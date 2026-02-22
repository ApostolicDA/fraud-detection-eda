# Fraud Risk Analysis & Detection

## Executive Summary

A financial services dataset containing 1,056 transactions was provided with suspected fraud activity. However, the data was inconsistent and not reliable enough for decision-making.

I validated and cleaned the dataset, identified key fraud risk patterns, quantified financial exposure, and built predictive models to support smarter fraud prevention strategies.

### Key Outcomes
- **Fraud Rate:** 10.61% (112 of 1,056 transactions)  
- **Total Fraud Exposure:** $38,990  
- **Fraud transactions were 9.7x higher in value** than legitimate transactions  
- **10% of users generated over 80% of fraud incidents**

This project demonstrates business-focused fraud analysis — from raw data to actionable risk intelligence.

---

## The Business Problem

The organization lacked visibility into:

- Which payment methods carried the highest fraud risk  
- Whether fraud was random or concentrated  
- Which product categories were being targeted  
- How fraud patterns changed over time  
- How to prioritize monitoring efforts  

Without structured analysis, fraud prevention would remain reactive instead of strategic.

---

## My Approach

### 1. Data Validation & Cleaning (Python)

Before analysis, I ensured the dataset was reliable by:

- Removing duplicate records  
- Handling missing values  
- Standardizing fraud labels  
- Validating numeric integrity (no negative transaction values)  
- Enforcing consistent data types  

Output: A clean, analysis-ready dataset.

---

### 2. Risk Analysis (SQL)

Using structured SQL analysis, I identified:

- **High-risk payment methods**  
  - Bank transfers had the highest fraud rate (12%)

- **Targeted product categories**  
  - Electronics showed the highest fraud concentration

- **User-level fraud concentration**  
  - A small group of users drove the majority of fraud

- **Time-based fraud patterns**  
  - Fraud activity peaked during specific hours

This shifted the discussion from “how many fraud cases?” to  
“where should we focus prevention efforts?”

---

### 3. Executive Dashboards (PowerBI)

Built interactive dashboards designed for business stakeholders:

- Fraud rate & total exposure KPIs  
- Payment method risk comparison  
- Category vulnerability breakdown  
- User-level risk concentration  
- Time-based fraud analysis  

---

## Dashboard Highlights

### Executive Summary Dashboard

- 1,056 total transactions  
- 112 fraudulent transactions  
- $38,990 total fraud exposure  
- Clear breakdown of fraud vs legitimate activity  
- Category-level fraud distribution  

![Executive Dashboard](./Screenshot%202026-01-04%20001812.png)

---

### Payment Method & Risk Analysis

- Fraud rate comparison by payment method  
- Bank transfers ranked highest risk  
- Volume vs fraud exposure visualization  
- Interactive filtering for deeper analysis  

![Payment Method Analysis](./Screenshot%202026-01-04%20001831.png)

---

### Temporal & Category Analysis

- Fraud patterns by hour and day  
- Category-level fraud heatmap  
- Electronics identified as most targeted category  
- Time-based trend visualization  

![Temporal Analysis](./Screenshot%202026-01-04%20001854.png)

---

## Predictive Modeling

Built and evaluated multiple fraud detection models.

Best performing model achieved:

- ~94% ROC-AUC  
- Strong recall to reduce costly missed fraud  

Model evaluation was framed around business trade-offs:

- Missed fraud ≈ $100 loss  
- False alarm ≈ $10 investigation cost  

This ensured optimization for financial impact — not just model accuracy.

---

## Key Business Insights

- Fraud is concentrated, not random  
- High-value transactions carry disproportionate risk  
- Bank transfers require enhanced monitoring  
- Electronics is the most vulnerable category  
- A small user segment drives most fraud exposure  
- Time-based monitoring can improve prevention efficiency  

---

## Project Structure


fraud-detection-eda/
├── python_scripts/
├── sql_queries/
├── powerbi_reports/
└── README.md


---

## Tools Used

- Python  
- SQL  
- PowerBI  
- Git  

---

## What This Project Demonstrates

- Strong data validation discipline  
- Business-first analytical thinking  
- Risk prioritization ability  
- Clear communication for non-technical stakeholders  
- End-to-end ownership from raw data to strategic recommendation  
