-- ============================================================
-- 01_churn_overview.sql
-- Purpose : High-level churn KPIs for executive summary
-- Analyst : Beginner Product Analyst
-- ============================================================

-- 1. Overall churn rate
SELECT
    COUNT(*)                                              AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)       AS churned_customers,
    SUM(CASE WHEN churn = 'No'  THEN 1 ELSE 0 END)       AS retained_customers,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                     AS churn_rate_pct
FROM telecom_customers;


-- 2. Average tenure by churn status
--    Churned customers tend to leave much earlier — this confirms
--    that onboarding and early engagement are critical.
SELECT
    churn,
    ROUND(AVG(tenure_months), 1)    AS avg_tenure_months,
    ROUND(AVG(monthly_charges), 2)  AS avg_monthly_charges,
    ROUND(AVG(total_charges), 2)    AS avg_total_charges
FROM telecom_customers
GROUP BY churn;


-- 3. Monthly revenue at risk from churned customers
SELECT
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END), 2)  AS monthly_revenue_lost,
    ROUND(SUM(CASE WHEN churn = 'No'  THEN monthly_charges ELSE 0 END), 2)  AS monthly_revenue_retained,
    ROUND(SUM(monthly_charges), 2)                                           AS total_monthly_revenue
FROM telecom_customers;
