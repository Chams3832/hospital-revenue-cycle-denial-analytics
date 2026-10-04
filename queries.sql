-- ==============================================================================
-- PROJECT: Hospital Revenue Cycle & Medical Coding Denial Analytics
-- SCRIPT: Data Extraction & Advanced Analytical Engineering
-- TARGET: Databricks SQL / PostgreSQL / SQL Server
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- QUERY 1: Global Executive RCM Financial KPIs
-- Objective: Compute overall Denial Rate, Gross Billed, Revenue at Risk, and AR Days
-- ------------------------------------------------------------------------------
SELECT 
    COUNT(Claim_ID) AS Total_Claims_Submitted,
    SUM(Claim_Amount) AS Total_Gross_Revenue,
    SUM(CASE WHEN Claim_Status = 'Denied' THEN Claim_Amount ELSE 0 END) AS Revenue_At_Risk,
    ROUND(SUM(CASE WHEN Claim_Status = 'Denied' THEN 1.0 ELSE 0 END) / COUNT(Claim_ID) * 100, 2) AS Overall_Denial_Rate,
    ROUND(AVG(Days_In_AR), 1) AS Average_Days_In_AR
FROM hospital_claims;

-- ------------------------------------------------------------------------------
-- QUERY 2: Insurance Payer Financial Risk Assessment
-- Objective: Identify which payer presents the highest financial denial risk
-- ------------------------------------------------------------------------------
SELECT 
    Insurance_Provider,
    COUNT(Claim_ID) AS Claims_Count,
    SUM(Claim_Amount) AS Total_Billed,
    SUM(CASE WHEN Claim_Status = 'Denied' THEN Claim_Amount ELSE 0 END) AS Total_Denied_Amount,
    ROUND(SUM(CASE WHEN Claim_Status = 'Denied' THEN 1.0 ELSE 0 END) / COUNT(Claim_ID) * 100, 2) AS Payer_Denial_Rate
FROM hospital_claims
GROUP BY Insurance_Provider
ORDER BY Total_Denied_Amount DESC;

-- ------------------------------------------------------------------------------
-- QUERY 3: Top 5 Financial Leakage Drivers by ICD-10-CM Codes
-- Objective: Pinpoint medical coding specificity errors causing high claim rejections
-- ------------------------------------------------------------------------------
SELECT 
    ICD10_Code,
    ICD10_Description,
    COUNT(Claim_ID) AS Total_Denials,
    SUM(Claim_Amount) AS Total_Financial_Loss
FROM hospital_claims
WHERE Claim_Status = 'Denied'
GROUP BY ICD10_Code, ICD10_Description
ORDER BY Total_Financial_Loss DESC
LIMIT 5;

-- ------------------------------------------------------------------------------
-- QUERY 4: Advanced Window Function - Rank Denial Reasons Within Each Department
-- Objective: Isolate the top 2 absolute root-cause denial codes per clinical specialty
-- ------------------------------------------------------------------------------
WITH RankedDenials AS (
    SELECT 
        Department,
        Denial_Reason_Code,
        Denial_Reason_Description,
        SUM(Claim_Amount) AS Total_Loss,
        RANK() OVER(PARTITION BY Department ORDER BY SUM(Claim_Amount) DESC) AS Denial_Rank
    FROM hospital_claims
    WHERE Claim_Status = 'Denied'
    GROUP BY Department, Denial_Reason_Code, Denial_Reason_Description
)
SELECT * 
FROM RankedDenials 
WHERE Denial_Rank <= 2;

-- ------------------------------------------------------------------------------
-- QUERY 5: Correlation Matrix - Impact of Denials on Capital Liquidity (AR Days)
-- Objective: Quantify cash flow delays comparing Approved vs. Denied claim pipelines
-- ------------------------------------------------------------------------------
SELECT 
    Claim_Status,
    COUNT(Claim_ID) AS Total_Claims,
    ROUND(AVG(Days_In_AR), 1) AS Avg_Days_In_AR,
    MAX(Days_In_AR) AS Max_Days_In_AR
FROM hospital_claims
GROUP BY Claim_Status;



  
