-- ============================================================
-- 03_revenue_impact.sql
-- Purpose : Quantify the financial impact of churn
-- ============================================================

-- 1. Revenue lost vs retained, split by contract type
--    Useful to prioritise which customer segments to protect first.
SELECT
    contract_type,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END), 2)  AS monthly_rev_lost,
    ROUND(SUM(CASE WHEN churn = 'No'  THEN monthly_charges ELSE 0 END), 2)  AS monthly_rev_retained
FROM telecom_customers
GROUP BY contract_type
ORDER BY monthly_rev_lost DESC;


-- 2. Average monthly charge: churned vs retained, by internet service
--    Higher-paying fiber customers churning = bigger revenue impact per head.
SELECT
    internet_service,
    churn,
    COUNT(*)                                 AS customers,
    ROUND(AVG(monthly_charges), 2)           AS avg_monthly_charge,
    ROUND(SUM(monthly_charges), 2)           AS total_monthly_revenue
FROM telecom_customers
GROUP BY internet_service, churn
ORDER BY internet_service, churn;


-- 3. Simple lifetime value estimate (monthly charge × average tenure)
--    LTV proxy = avg monthly charge × avg tenure months
SELECT
    churn,
    ROUND(AVG(monthly_charges), 2)                        AS avg_monthly_charge,
    ROUND(AVG(tenure_months), 1)                          AS avg_tenure_months,
    ROUND(AVG(monthly_charges) * AVG(tenure_months), 2)   AS estimated_ltv
FROM telecom_customers
GROUP BY churn;


-- 4. Monthly revenue at risk: customers with Month-to-month contracts NOT yet churned
--    These are your next most vulnerable customers — act on them proactively.
SELECT
    COUNT(*)                            AS at_risk_customers,
    ROUND(SUM(monthly_charges), 2)      AS monthly_revenue_at_risk
FROM telecom_customers
WHERE contract_type = 'Month-to-month'
  AND churn = 'No';
