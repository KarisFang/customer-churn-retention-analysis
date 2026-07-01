-- ============================================================
-- 05_retention_strategy.sql
-- Purpose : Data-driven retention levers and opportunity sizing
-- ============================================================

-- 1. Contract upgrade opportunity
--    How many Month-to-month customers have stayed 12+ months?
--    These "loyal month-to-month" customers are the easiest win
--    for an upgrade offer — they've proven value but lack lock-in.
SELECT
    COUNT(*)                            AS upgrade_candidates,
    ROUND(SUM(monthly_charges), 2)      AS monthly_rev_opportunity
FROM telecom_customers
WHERE contract_type   = 'Month-to-month'
  AND tenure_months   >= 12
  AND churn           = 'No';


-- 2. Tech support upsell opportunity
--    Customers without tech support who are on Fiber optic
--    churn more. Offering a free trial of tech support could reduce churn.
SELECT
    internet_service,
    tech_support,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)                   AS churned,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                 AS churn_rate_pct
FROM telecom_customers
WHERE internet_service != 'No'
GROUP BY internet_service, tech_support
ORDER BY internet_service, churn_rate_pct DESC;


-- 3. Payment method conversion opportunity
--    Auto-pay customers (bank transfer / credit card) churn less.
--    Nudging electronic-check users to auto-pay may reduce churn.
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


-- 4. Senior citizen churn rate
--    Do senior customers churn more? If so, a dedicated support
--    programme could improve satisfaction and reduce churn.
SELECT
    CASE WHEN senior_citizen = 1 THEN 'Senior' ELSE 'Non-Senior' END AS segment,
    COUNT(*)                                                           AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)                    AS churned,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                                  AS churn_rate_pct
FROM telecom_customers
GROUP BY senior_citizen;


-- 5. Combined retention priority matrix
--    Rank retained customers by estimated save-value:
--    those on high charges with low tenure and no annual contract.
SELECT
    customer_id,
    tenure_months,
    contract_type,
    monthly_charges,
    internet_service,
    tech_support,
    online_security,
    CASE
        WHEN tenure_months < 6   THEN 'Critical – first 6 months'
        WHEN tenure_months < 12  THEN 'At risk – approaching 1 year'
        ELSE                          'Stable but on monthly contract'
    END AS retention_priority
FROM telecom_customers
WHERE churn         = 'No'
  AND contract_type = 'Month-to-month'
ORDER BY monthly_charges DESC, tenure_months ASC
LIMIT 30;
