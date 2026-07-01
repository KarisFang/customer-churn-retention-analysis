-- ============================================================
-- 02_churn_by_segment.sql
-- Purpose : Break down churn rate by key customer dimensions
-- ============================================================

-- 1. Churn rate by contract type
--    Insight: Month-to-month customers churn at a much higher rate.
--    Action : Incentivise upgrades to annual/biennial contracts.
SELECT
    contract_type,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)                   AS churned,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM telecom_customers
GROUP BY contract_type
ORDER BY churn_rate_pct DESC;


-- 2. Churn rate by tenure bucket
--    Insight: New customers (< 12 months) are at highest risk.
--    Action : Design a 90-day onboarding journey to build stickiness.
SELECT
    CASE
        WHEN tenure_months <  6  THEN '0–5 months'
        WHEN tenure_months < 12  THEN '6–11 months'
        WHEN tenure_months < 24  THEN '12–23 months'
        WHEN tenure_months < 48  THEN '24–47 months'
        ELSE                          '48+ months'
    END                                                               AS tenure_bucket,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)                   AS churned,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM telecom_customers
GROUP BY tenure_bucket
ORDER BY MIN(tenure_months);


-- 3. Churn rate by internet service type
--    Insight: Fiber optic customers churn more — potential service quality issue.
SELECT
    internet_service,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)                   AS churned,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM telecom_customers
GROUP BY internet_service
ORDER BY churn_rate_pct DESC;


-- 4. Churn rate by payment method
--    Insight: Electronic check users churn more — may signal billing friction.
SELECT
    payment_method,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)                   AS churned,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM telecom_customers
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;
