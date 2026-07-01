## 🖥️ Live Dashboard

> **[→ View Interactive Dashboard](https://karisfang.github.io/customer-churn-retention-analysis/dashboard/index.html)**
> Built with Chart.js · Pure SQL analysis · No BI tool required

---

# 📊 Customer Churn & Retention Analysis — Telecom

> A beginner-level product analytics project using **pure SQL** to analyse churn drivers, segment customers by risk, and surface data-driven retention recommendations for a fictional telecom business.

---

## 🗂️ Project Structure

```
customer-churn-retention-analysis/
├── data/
│   └── telecom_customers.csv          # 200-row synthetic telecom dataset
├── sql/
│   ├── 01_churn_overview.sql          # High-level KPIs
│   ├── 02_churn_by_segment.sql        # Churn breakdown by contract, tenure, etc.
│   ├── 03_revenue_impact.sql          # Revenue at risk & LTV estimates
│   ├── 04_risk_segmentation.sql       # Rule-based risk scoring (no ML)
│   └── 05_retention_strategy.sql      # Actionable retention queries
└── README.md
```

---

## 🧰 Tools Used

| Tool | Purpose |
|------|---------|
| SQL (SQLite / DuckDB compatible) | All analysis — no Python, no BI tool required |
| CSV | Raw dataset |

> ✅ Every query is written at a **beginner SQL level**: `SELECT`, `CASE WHEN`, `GROUP BY`, `ORDER BY`, `LIMIT`. No window functions, CTEs, or stored procedures.

---

## 📋 Dataset Overview

`data/telecom_customers.csv` — 200 synthetic customer records.

| Column | Description |
|--------|-------------|
| `customer_id` | Unique ID (C0001–C0200) |
| `gender` | Male / Female |
| `senior_citizen` | 1 = Senior, 0 = Non-senior |
| `tenure_months` | Months as a customer (1–72) |
| `contract_type` | Month-to-month / One year / Two year |
| `monthly_charges` | Monthly bill in USD |
| `total_charges` | Cumulative spend in USD |
| `internet_service` | DSL / Fiber optic / No |
| `tech_support` | Yes / No / No internet service |
| `online_security` | Yes / No / No internet service |
| `payment_method` | Electronic check / Mailed check / Bank transfer / Credit card |
| `churn` | **Yes** = churned, **No** = retained |

---

## 📈 Key Findings

### 1. Overall Churn Rate

| Metric | Value |
|--------|-------|
| Total customers | 200 |
| Churned customers | 73 |
| **Churn rate** | **36.5%** |
| Monthly revenue lost to churn | $5,288.45 |

---

### 2. Churn by Contract Type

Month-to-month customers churn at **2.4× the rate** of annual contract customers.

| Contract Type | Customers | Churned | Churn Rate |
|--------------|-----------|---------|-----------|
| Month-to-month | 109 | 52 | **47.7%** |
| Two year | 41 | 11 | 26.8% |
| One year | 50 | 10 | 20.0% |

💡 **Insight:** Locking customers into annual contracts is the single strongest lever to reduce churn.

---

### 3. Churn by Tenure Bucket

Customers in their **first year** are at the highest risk of leaving.

| Tenure | Customers | Churned | Churn Rate |
|--------|-----------|---------|-----------|
| 0–5 months | 9 | 4 | 44.4% |
| 6–11 months | 23 | 14 | **60.9%** |
| 12–23 months | 27 | 9 | 33.3% |
| 24–47 months | 68 | 23 | 33.8% |
| 48+ months | 73 | 23 | 31.5% |

💡 **Insight:** The 6–11 month window is the most critical. A proactive check-in or loyalty offer at Month 6 could significantly cut churn.

---

### 4. Churn by Internet Service

| Internet Service | Customers | Churned | Churn Rate |
|----------------|-----------|---------|-----------|
| Fiber optic | 60 | 28 | **46.7%** |
| DSL | 66 | 24 | 36.4% |
| No internet | 74 | 21 | 28.4% |

💡 **Insight:** Fiber optic customers pay more but churn faster — a service quality or pricing perception issue worth investigating.

---

### 5. Risk Tier Segmentation (Rule-Based, No ML)

Each retained customer is scored 0–5 based on known churn drivers:
- On a month-to-month contract (+1)
- Tenure under 12 months (+1)
- Monthly charges above $70 (+1)
- No tech support (+1)
- No online security (+1)

| Risk Tier | Retained Customers | Monthly Revenue at Stake |
|-----------|-------------------|------------------------|
| High (score ≥ 3) | 21 | $1,696 |
| Medium (score = 2) | 40 | $2,876 |
| Low (score ≤ 1) | 66 | $3,701 |

💡 **Insight:** 61 customers (47% of retained base) are Medium or High risk. Prioritise outreach to High-risk customers first — they represent meaningful revenue and are most likely to churn next.

---

## 🎯 Retention Recommendations

| Action | Target Segment | Expected Impact |
|--------|---------------|----------------|
| **Contract upgrade offer** | Month-to-month customers with 12+ months tenure | Reduce churn rate from ~48% to ~20% |
| **Month-6 check-in campaign** | Customers with 4–8 months tenure | Address the 6–11 month churn spike (60.9%) |
| **Free tech support trial** | Fiber optic customers without tech support | Reduce Fiber churn from 46.7% |
| **Auto-pay incentive** | Electronic check users | Lower billing friction; auto-pay correlates with lower churn |
| **Senior customer support programme** | Senior citizens | Address higher churn propensity in this segment |

---

## 🚀 How to Run

The SQL files are compatible with any SQL engine. Quickest way locally:

```bash
# Install DuckDB CLI (Mac/Linux)
pip install duckdb

# Run a query directly against the CSV (no DB setup needed)
duckdb -c "
CREATE TABLE telecom_customers AS SELECT * FROM read_csv_auto('data/telecom_customers.csv');
$(cat sql/01_churn_overview.sql)
"
```

Or load the CSV into **DB Browser for SQLite** and run each `.sql` file in sequence.

---

## 📝 Skills Demonstrated

- Writing clean, readable SQL with inline comments
- Translating business questions into SQL queries
- Segmenting customers using `CASE WHEN` logic
- Calculating churn rates, revenue impact, and LTV without Python
- Building a rule-based risk model using only SQL arithmetic
- Communicating findings with product-ready recommendations

---

*Dataset is synthetic and generated for portfolio purposes only.*
