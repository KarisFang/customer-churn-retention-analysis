-- ============================================================
-- 04_risk_segmentation.sql
-- Purpose : Identify at-risk customers for retention campaigns
-- ============================================================

-- 1. Risk score: assign a simple 0–4 risk score per customer
--    based on known churn drivers (no Python, no ML — just logic).
--    Score 3–4 = High Risk  |  Score 2 = Medium  |  0–1 = Low
SELECT
    customer_id,
    contract_type,
    tenure_months,
    monthly_charges,
    internet_service,
    tech_support,
    online_security,
    -- Each flag adds 1 point to the risk score
    (
        CASE WHEN contract_type  = 'Month-to-month' THEN 1 ELSE 0 END +
        CASE WHEN tenure_months  < 12               THEN 1 ELSE 0 END +
        CASE WHEN monthly_charges > 70              THEN 1 ELSE 0 END +
        CASE WHEN tech_support   = 'No'             THEN 1 ELSE 0 END +
        CASE WHEN online_security= 'No'             THEN 1 ELSE 0 END
    )                                               AS risk_score,
    CASE
        WHEN (
            CASE WHEN contract_type  = 'Month-to-month' THEN 1 ELSE 0 END +
            CASE WHEN tenure_months  < 12               THEN 1 ELSE 0 END +
            CASE WHEN monthly_charges > 70              THEN 1 ELSE 0 END +
            CASE WHEN tech_support   = 'No'             THEN 1 ELSE 0 END +
            CASE WHEN online_security= 'No'             THEN 1 ELSE 0 END
        ) >= 3 THEN 'High'
        WHEN (
            CASE WHEN contract_type  = 'Month-to-month' THEN 1 ELSE 0 END +
            CASE WHEN tenure_months  < 12               THEN 1 ELSE 0 END +
            CASE WHEN monthly_charges > 70              THEN 1 ELSE 0 END +
            CASE WHEN tech_support   = 'No'             THEN 1 ELSE 0 END +
            CASE WHEN online_security= 'No'             THEN 1 ELSE 0 END
        ) = 2 THEN 'Medium'
        ELSE 'Low'
    END                                             AS risk_tier
FROM telecom_customers
WHERE churn = 'No'   -- focus only on customers we can still save
ORDER BY risk_score DESC, monthly_charges DESC;


-- 2. Summary: how many at-risk retained customers exist per tier?
SELECT
    CASE
        WHEN (
            CASE WHEN contract_type  = 'Month-to-month' THEN 1 ELSE 0 END +
            CASE WHEN tenure_months  < 12               THEN 1 ELSE 0 END +
            CASE WHEN monthly_charges > 70              THEN 1 ELSE 0 END +
            CASE WHEN tech_support   = 'No'             THEN 1 ELSE 0 END +
            CASE WHEN online_security= 'No'             THEN 1 ELSE 0 END
        ) >= 3 THEN 'High'
        WHEN (
            CASE WHEN contract_type  = 'Month-to-month' THEN 1 ELSE 0 END +
            CASE WHEN tenure_months  < 12               THEN 1 ELSE 0 END +
            CASE WHEN monthly_charges > 70              THEN 1 ELSE 0 END +
            CASE WHEN tech_support   = 'No'             THEN 1 ELSE 0 END +
            CASE WHEN online_security= 'No'             THEN 1 ELSE 0 END
        ) = 2 THEN 'Medium'
        ELSE 'Low'
    END                                             AS risk_tier,
    COUNT(*)                                        AS customers,
    ROUND(SUM(monthly_charges), 2)                  AS monthly_rev_at_stake
FROM telecom_customers
WHERE churn = 'No'
GROUP BY risk_tier
ORDER BY monthly_rev_at_stake DESC;


-- 3. Top 20 highest-value at-risk customers to prioritise outreach
--    (High risk tier, sorted by monthly charges desc)
SELECT
    customer_id,
    tenure_months,
    contract_type,
    monthly_charges,
    internet_service,
    payment_method
FROM telecom_customers
WHERE churn = 'No'
  AND contract_type   = 'Month-to-month'
  AND tenure_months   < 12
  AND monthly_charges > 70
ORDER BY monthly_charges DESC
LIMIT 20;
