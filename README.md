# hospital-revenue-cycle-denial-analytics
# Hospital Revenue Cycle & Medical Coding Denial Analytics

## 🎯 Project Overview
This repository contains an end-to-end data analytics project focused on the US healthcare financial ecosystem (**Revenue Cycle Management - RCM**). The objective is to analyze medical billing claims data from a simulated New York City hospital network to identify root causes of insurance claim denials, evaluate financial leakage, and optimize coding accuracy.

By cross-referencing **ICD-10-CM diagnostic codes**, **CPT procedure codes**, and standard industry denial reason codes (e.g., HIPAA Claim Status Codes), this project bridges the gap between raw data analytics and medical coding logic.

## 🛠️ Tech Stack & Architecture
- **Data Engineering & Manipulation:** SQL (PostgreSQL) / Databricks
- **Business Intelligence & Visualization:** Power BI / Tableau
- **Core Analytics:** Advanced Excel (Pivot Tables, Power Query)

## 📊 Key Performance Indicators (KPIs) Tracked
1. **Denial Rate (%)**: Total claims denied vs. total claims submitted (Industry Benchmark Target: < 5%).
2. **Total Revenue at Risk (\$)**: Gross dollar amount tied up in denied or rejected claims.
3. **Clean Claim Rate (CCR)**: The % of claims that pass through the clearinghouse and are paid on the first submission.
4. **Days in Accounts Receivable (AR Days)**: Average number of days it takes to secure payment post-encounter.

## 🗄️ Database Schema & Source Data
The primary dataset (`healthcare_claims_dataset.csv`) consists of 1,000 transaction records containing:
- `Claim_ID` / `Patient_ID` / `Claim_Date`
- `Department`: Clinical specialty (e.g., Cardiology, Orthopedics)
- `Insurance_Provider`: Payers (Medicare, Medicaid, BCBS, Aetna, UnitedHealthcare)
- `ICD10_Code` & `CPT_Code`: Clinical documentation metrics
- `Claim_Status`: Approved vs. Denied
- `Denial_Reason_Code`: Standard industry claim remarks (CO-16, CO-50, etc.)

## 📈 SQL Analysis Portfolio

### 1. Overall Payer Denial Rate Analytics
```sql
SELECT 
    insurance_provider,
    COUNT(*) as total_claims,
    SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END) as denied_claims,
    ROUND(SUM(CASE WHEN claim_status = 'Denied' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) as denial_rate
FROM hospital_claims
GROUP BY insurance_provider
ORDER BY denial_rate DESC;
```

### 2. Financial Leakage by ICD-10-CM Coding Mistakes
```sql
SELECT 
    icd10_code,
    icd10_description,
    COUNT(*) as denial_frequency,
    SUM(claim_amount) as total_financial_loss
FROM hospital_claims
WHERE claim_status = 'Denied'
GROUP BY icd10_code, icd10_description
ORDER BY total_financial_loss DESC
LIMIT 5;
```

## 🎨 Dashboard Design Mockup (Power BI)
The interactive dashboard is organized into 3 strategic pillars:
1. **Executive Summary:** High-level cards tracking *Total Revenue At Risk*, *Average AR Days*, and *Payer Mix Distribution*.
2. **Denial Root-Cause Deep Dive:** A bar chart segmenting top denial codes (e.g., *CO-16: Lack of Specificity*) mapped directly against the responsible clinical departments.
3. **Actionable Remediation Matrix:** A drill-down table allowing medical coding supervisors to identify which specific ICD-10/CPT combinations require clinical documentation improvement (CDI).

## 🚀 Progress Roadmap (Target Completion: End of Year)
- [x] Define metrics and project scope
- [x] Generate/Structure synthetic RCM dataset
- [ ] Write complete SQL analytical scripts (`queries.sql`)
- [ ] Design and publish Power BI / Tableau Dashboard
- [ ] Write final business impact summary report
