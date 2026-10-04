# Hospital Revenue Cycle & Medical Coding Denial Analytics

## 🎯 Project Overview
This repository contains an end-to-end data analytics project focused on the US healthcare financial ecosystem (**Revenue Cycle Management - RCM**). The objective is to analyze medical billing claims data from a simulated New York City hospital network to identify root causes of insurance claim denials, evaluate financial leakage, and optimize coding accuracy.

By cross-referencing **ICD-10-CM diagnostic codes**, **CPT procedure codes**, and standard industry denial reason codes (e.g., HIPAA Claim Status Codes), this project bridges the gap between raw data analytics and medical coding workflows.

## 🛠️ Data Pipeline Architecture (Cloud & Big Data Stack)
The project simulates a modern enterprise data architecture to handle production-grade healthcare transactions:
1. *Extraction & Saisie (Excel):* Raw clinical billing logs are exported from EHR/EMR systems into Excel format (.xlsx/.csv).
2. *Data Lake Landing Zone (AWS S3):* Files are securely uploaded to an AWS S3 bucket acting as the landing layer.
3. *Data Engineering & ETL (Databricks):* A Databricks cluster utilizing PySpark cleans, types data fields (dates, currencies), and loads them into a high-performance Delta Lake table.
4. *Data Warehousing & Analytics (Advanced SQL):* In-depth claim denial trends are extracted using advanced analytical SQL queries (Window Functions, CTEs).
5. *Business Intelligence (Power BI / Tableau):* Direct connection to the data layer to deliver an interactive Revenue Cycle executive dashboard.

## 📊 Key Performance Indicators (KPIs) Tracked
1. *Denial Rate (%)*: Total claims denied vs. total claims submitted (Industry Benchmark Target: < 5%).
2. *Total Revenue at Risk (\$)*: Gross dollar amount tied up in denied or rejected claims.
3. *Clean Claim Rate (CCR)*: The % of claims that pass through the clearinghouse and are paid on the first submission.
4. *Days in Accounts Receivable (AR Days)*: Average number of days it takes to secure payment post-encounter.

## 🗄️ Database Schema
The core dataset (healthcare_claims_dataset.csv) contains the following transactional variables:
- Claim_ID / Patient_ID / Claim_Date
- Department: Clinical specialty (e.g., Cardiology, Orthopedics)
- Insurance_Provider: Payers (Medicare, Medicaid, BCBS, Aetna, UnitedHealthcare)
- ICD10_Code & CPT_Code: Clinical documentation metrics
- Claim_Status: Approved vs. Denied
- Denial_Reason_Code: Standard industry claim remarks (CO-16, CO-50, etc.)

## 🚀 Project Roadmap (Target Completion: End of Year)
- [x] Project scope definition & KPI alignment
- [x] Synthetic RCM dataset generation & structuring
- [x] Cloud ETL ingestion architecture setup (databricks_pipeline.py)
- [x] Advanced SQL analytics scripts implementation (queries.sql)
- [x] Business Intelligence modeling & DAX logic definition (powerbi_measures.dax)
- [ ] Final UI dashboard publish & portfolio screenshot attachment
