/*=============================================================================
  FRAUD DETECTION EDA - COMPREHENSIVE SQL ANALYSIS
  Purpose: Senior-level exploratory data analysis for fraud pattern detection
  Author: ApostolicDA
  Last Updated: January 2026
  Business Context: Credit card fraud detection and risk assessment
=============================================================================*/

-- ============================================================================
-- QUERY 1: FRAUD OVERVIEW - Transaction Volume Analysis
-- ============================================================================
-- Business Question: What is the overall fraud rate and volume in our system?
-- Use Case: Executive dashboard KPI, risk assessment, financial impact
-- Expected Insight: Understand scale of fraud problem and legitimate transaction volume

SELECT 
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS total_fraud_cases,
    SUM(CASE WHEN fraud = 'NO' THEN 1 ELSE 0 END) AS total_legitimate_transactions,
    ROUND(100.0 * SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate_percent,
    COUNT(*) AS total_transactions
FROM credit.cleaned_fraud;

-- ============================================================================
-- QUERY 2: PAYMENT METHOD RISK ANALYSIS - Average Transaction Amount
-- ============================================================================
-- Business Question: Which payment methods have highest average transaction values?
-- Use Case: Risk stratification, fraud prevention strategy by payment type
-- Expected Insight: Identify high-value payment methods for enhanced monitoring

SELECT 
    payment_method,
    ROUND(AVG(amount), 2) AS avg_transaction_amount,
    COUNT(*) AS transaction_count,
    ROUND(AVG(CASE WHEN fraud = 'YES' THEN amount ELSE NULL END), 2) AS avg_fraud_amount
FROM credit.cleaned_fraud
GROUP BY payment_method
ORDER BY avg_transaction_amount DESC;

-- ============================================================================
-- QUERY 3: FRAUD SEVERITY ANALYSIS - Transaction Amount Comparison
-- ============================================================================
-- Business Question: Do fraudulent transactions have different values than legitimate ones?
-- Use Case: Transaction threshold policies, anomaly detection thresholds
-- Expected Insight: Identify fraudster behavior patterns (do they target high/low values?)

SELECT 
    fraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(MIN(amount), 2) AS min_amount,
    ROUND(MAX(amount), 2) AS max_amount,
    ROUND(SUM(amount), 2) AS total_amount
FROM credit.cleaned_fraud
GROUP BY fraud;

-- ============================================================================
-- QUERY 4: PAYMENT METHOD DISTRIBUTION - Fraud by Payment Type
-- ============================================================================
-- Business Question: Which payment methods are most vulnerable to fraud?
-- Use Case: Payment method security assessment, fraud prevention prioritization
-- Expected Insight: Identify which payment channels need enhanced security

SELECT 
    payment_method,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_count,
    SUM(CASE WHEN fraud = 'NO' THEN 1 ELSE 0 END) AS legitimate_count,
    ROUND(100.0 * SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate_percent,
    COUNT(*) AS total_transactions
FROM credit.cleaned_fraud
GROUP BY payment_method
ORDER BY fraud_rate_percent DESC;

-- ============================================================================
-- QUERY 5: HIGH-RISK PAYMENT METHODS - Prioritize Fraud Prevention
-- ============================================================================
-- Business Question: Which payment methods have highest fraud incidents (absolute numbers)?
-- Use Case: Resource allocation for fraud prevention, system hardening prioritization
-- Expected Insight: Where to focus fraud prevention efforts for maximum impact

SELECT 
    payment_method,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_incidents,
    ROUND(SUM(CASE WHEN fraud = 'YES' THEN amount ELSE 0 END), 2) AS total_fraud_amount,
    ROUND(AVG(CASE WHEN fraud = 'YES' THEN amount ELSE NULL END), 2) AS avg_fraud_amount
FROM credit.cleaned_fraud
WHERE fraud = 'YES'
GROUP BY payment_method
ORDER BY fraud_incidents DESC;

-- ============================================================================
-- QUERY 6: LOW-RISK PAYMENT METHODS - Secure Channels Assessment
-- ============================================================================
-- Business Question: Which payment methods show strongest security (highest legitimate volume)?
-- Use Case: Customer confidence, marketing safe payment options, fraud prevention benchmarking
-- Expected Insight: Best-performing payment methods by volume and security

SELECT 
    payment_method,
    SUM(CASE WHEN fraud = 'NO' THEN 1 ELSE 0 END) AS legitimate_transactions,
    ROUND(SUM(CASE WHEN fraud = 'NO' THEN amount ELSE 0 END), 2) AS total_legitimate_amount,
    ROUND(AVG(CASE WHEN fraud = 'NO' THEN amount ELSE NULL END), 2) AS avg_legitimate_amount
FROM credit.cleaned_fraud
WHERE fraud = 'NO'
GROUP BY payment_method
ORDER BY legitimate_transactions DESC;

-- ============================================================================
-- QUERY 7: PRODUCT CATEGORY FRAUD RISK - What's Being Targeted?
-- ============================================================================
-- Business Question: Which product categories are most targeted by fraudsters?
-- Use Case: Inventory security, merchant risk assessment, category-specific monitoring
-- Expected Insight: Identify high-value or high-demand categories as fraud targets

SELECT 
    category,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_incidents,
    COUNT(*) AS total_transactions,
    ROUND(100.0 * SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate_percent,
    ROUND(SUM(CASE WHEN fraud = 'YES' THEN amount ELSE 0 END), 2) AS fraud_amount_lost
FROM credit.cleaned_fraud
GROUP BY category
ORDER BY fraud_incidents DESC;

-- ============================================================================
-- QUERY 8: USER RISK PROFILING - Identify Suspicious User Accounts
-- ============================================================================
-- Business Question: Which user accounts show highest fraud concentration?
-- Use Case: User account monitoring, KYC (Know Your Customer) verification, account restrictions
-- Expected Insight: Identify compromised or fraudulent user accounts for investigation

SELECT 
    user_id,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_incidents,
    SUM(CASE WHEN fraud = 'NO' THEN 1 ELSE 0 END) AS legitimate_transactions,
    ROUND(100.0 * SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate_percent,
    ROUND(SUM(CASE WHEN fraud = 'YES' THEN amount ELSE 0 END), 2) AS fraud_amount_by_user,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM credit.cleaned_fraud
GROUP BY user_id
HAVING SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) > 0
ORDER BY fraud_incidents DESC
LIMIT 20;

-- ============================================================================
-- QUERY 9: TEMPORAL FRAUD PATTERNS - Hourly Risk Analysis
-- ============================================================================
-- Business Question: At which times of day do fraud incidents spike?
-- Use Case: Real-time monitoring schedule, alert threshold timing, staffing optimization
-- Expected Insight: Identify peak fraud hours for enhanced detection and response

SELECT 
    FLOOR(time / 3600) AS hour_of_day,
    category,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_count,
    COUNT(*) AS total_transactions,
    ROUND(100.0 * SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate_percent
FROM credit.cleaned_fraud
WHERE fraud = 'YES'
GROUP BY FLOOR(time / 3600), category
ORDER BY hour_of_day ASC, fraud_count DESC;

-- ============================================================================
-- QUERY 10: DAILY FRAUD TRENDS - Cumulative Analysis Over Time
-- ============================================================================
-- Business Question: How do fraud patterns vary across different days?
-- Use Case: Trend analysis, seasonal patterns, anomaly detection baseline
-- Expected Insight: Identify if fraud follows specific daily or weekly patterns

SELECT 
    FLOOR(time / 86400) AS day_number,
    category,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_incidents,
    COUNT(*) AS total_transactions,
    ROUND(SUM(CASE WHEN fraud = 'YES' THEN amount ELSE 0 END), 2) AS fraud_amount,
    ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM credit.cleaned_fraud
GROUP BY FLOOR(time / 86400), category
ORDER BY fraud_incidents DESC
LIMIT 30;

-- ============================================================================
-- QUERY 11: CATEGORY-DEVICE FRAUD ANALYSIS - Device Risk Segmentation
-- ============================================================================
-- Business Question: Are certain devices more prone to fraud in specific categories?
-- Use Case: Device fingerprinting, cross-device fraud rings, anomaly detection
-- Expected Insight: Identify suspicious device-category combinations

SELECT 
    device_id,
    category,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_count,
    COUNT(*) AS total_transactions,
    ROUND(100.0 * SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate_percent,
    ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM credit.cleaned_fraud
GROUP BY device_id, category
HAVING SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) >= 2
ORDER BY fraud_rate_percent DESC;

-- ============================================================================
-- QUERY 12: COMPREHENSIVE FRAUD IMPACT REPORT - Business ROI Metrics
-- ============================================================================
-- Business Question: What is the total financial impact of fraud and prevention priority?
-- Use Case: Board reporting, budget justification for fraud prevention, financial planning
-- Expected Insight: Quantify fraud impact for executive decision-making

SELECT 
    'FRAUD METRICS' AS metric_type,
    SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN fraud = 'YES' THEN amount ELSE 0 END), 2) AS total_fraud_amount,
    ROUND(AVG(CASE WHEN fraud = 'YES' THEN amount ELSE NULL END), 2) AS avg_fraud_value,
    ROUND(100.0 * SUM(CASE WHEN fraud = 'YES' THEN amount ELSE 0 END) / SUM(amount), 2) AS fraud_percent_of_volume
FROM credit.cleaned_fraud;
