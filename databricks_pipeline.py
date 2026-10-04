# ==============================================================================
# DATABRICKS PIPELINE: AWS S3 Ingestion & Delta Table Processing
# STACK: PySpark, AWS S3, Databricks Delta Lake
# ==============================================================================

from pyspark.sql.functions import col, to_date, when

# 1. AWS S3 Storage Configurations (Simulated Production Environment)
aws_bucket_name = "nyc-healthcare-revenue-data"
source_s3_path = f"s3a://{aws_bucket_name}/landing/healthcare_claims_dataset.csv"
target_delta_path = "/mnt/delta/hospital_claims"

# 2. Extract: Read raw billing logs from AWS S3 Landing Zone
df_raw = spark.read.format("csv") \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .load(source_s3_path)

# 3. Transform: Standardize, clean, and enrich healthcare data types
df_cleaned = df_raw \
    .withColumn("Claim_Date", to_date(col("Claim_Date"), "yyyy-MM-dd")) \
    .withColumn("Claim_Amount", col("Claim_Amount").cast("double")) \
    .withColumn("Paid_Amount", col("Paid_Amount").cast("double")) \
    .withColumn("Days_In_AR", col("Days_In_AR").cast("integer")) \
    .withColumn("Is_High_Value_Denial", 
                when((col("Claim_Status") == "Denied") & (col("Claim_Amount") > 5000), True)
                .otherwise(False))

# 4. Load: Write transformed data into Delta Lake for accelerated SQL querying
df_cleaned.write.format("delta") \
    .mode("overwrite") \
    .save(target_delta_path)

print("ETL Pipeline executed successfully: Data ingested from AWS S3 and saved into Delta Lake Table.")
