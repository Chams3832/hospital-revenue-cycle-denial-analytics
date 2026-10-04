-- ==============================================================================
-- PROJECT: Hospital Revenue Cycle & Medical Coding Denial Analytics
-- SCRIPT: Data Extraction & Key Performance Indicators (KPIs)
-- AUTHOR: [Votre Nom]
-- TARGET: Databricks / PostgreSQL / SQL Server
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- REQUÊTE 1: Calcul des indicateurs clés (KPIs) globaux du réseau hospitalier
-- Objectif: Extraire le Taux de Refus global, le Revenu Bloqué et les Jours AR moyens
-- ------------------------------------------------------------------------------
SELECT 
    COUNT(Claim_ID) AS Total_Claims_Submitted,
    SUM(Claim_Amount) AS Total_Gross_Revenue,
    SUM(CASE WHEN Claim_Status = 'Denied' THEN Claim_Amount ELSE 0 END) AS Revenue_At_Risk,
    ROUND(SUM(CASE WHEN Claim_Status = 'Denied' THEN 1.0 ELSE 0 END) / COUNT(Claim_ID) * 100, 2) AS Overall_Denial_Rate,
    ROUND(AVG(Days_In_AR), 1) AS Average_Days_In_AR
FROM hospital_claims;


-- ------------------------------------------------------------------------------
-- REQUÊTE 2: Analyse de performance par organisme payeur (Assurances)
-- Objectif: Identifier quel assureur présente le plus haut taux de rejet financier
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
-- REQUÊTE 3: Top 5 des codes de diagnostic (CIM-10-CM) causant le plus de pertes
-- Objectif: Repérer les erreurs de codage ou les manques de spécificité clinique
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
-- REQUÊTE 4: Analyse croisée des motifs de refus (Denial Reasons) par département
-- Objectif: Déterminer où cibler les formations d'audit de codage en interne
-- ------------------------------------------------------------------------------
SELECT 
    Department,
    Denial_Reason_Code,
    Denial_Reason_Description,
    COUNT(Claim_ID) AS Incident_Count,
    SUM(Claim_Amount) AS Estimated_Leakage
FROM hospital_claims
WHERE Claim_Status = 'Denied'
GROUP BY Department, Denial_Reason_Code, Denial_Reason_Description
ORDER BY Estimated_Leakage DESC;
