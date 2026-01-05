-- Fraud Detection EDA SQL Queries
-- Total fraud vs regular transactions
SELECT SUM(CASE WHEN fraud = 'YES' THEN 1 ELSE 0 END) AS total_fraud, SUM(CASE WHEN fraud = 'NO' THEN 1 ELSE 0 END) AS total_regular_transactions FROM credit.cleaned_fraud;

-- Average transaction amount by payment method
SELECT ROUND(AVG(amount), 2) AS avg_amount, payment_method FROM credit.cleaned_fraud GROUP BY payment_method ORDER BY avg_amount DESC;

-- Average amount by fraud status
SELECT AVG(amount) AS avg_amount, fraud FROM credit.cleaned_fraud GROUP BY fraud;

-- Total fraud transactions by payment method
SELECT SUM(CASE WHEN payment_method = 'paypal' THEN 1 ELSE 0 END) AS paypal, SUM(CASE WHEN payment_method = 'crypto' THEN 1 ELSE 0 END) AS crypto, SUM(CASE WHEN payment_method = 'bank' THEN 1 ELSE 0 END) AS bank FROM credit.cleaned_fraud WHERE fraud = 'YES';

-- Risky payment methods
SELECT COUNT(payment_method) AS total_defrauded, payment_method FROM credit.cleaned_fraud WHERE fraud = 'YES' GROUP BY payment_method ORDER BY total_defrauded DESC;

-- Safest payment methods
SELECT COUNT(payment_method) AS total_used, payment_method FROM credit.cleaned_fraud WHERE fraud = 'NO' GROUP BY payment_method ORDER BY total_used DESC;

-- Most targeted categories
SELECT COUNT(category) AS fraud_count, category FROM credit.cleaned_fraud WHERE fraud = 'YES' GROUP BY category ORDER BY fraud_count DESC;

-- Suspicious users
SELECT COUNT(user_id) AS fraud_transactions, user_id FROM credit.cleaned_fraud WHERE fraud = 'YES' GROUP BY user_id ORDER BY fraud_transactions DESC;

-- Fraud risk by hour
SELECT FLOOR(time / 3600) AS hourly, category, COUNT(*) AS fraud_count FROM credit.cleaned_fraud WHERE fraud = 'YES' GROUP BY hourly, category ORDER BY hourly ASC, fraud_count DESC;

-- Fraud by day and category
SELECT FLOOR(time / 86400) AS daily, category, COUNT(CASE WHEN fraud = 'YES' THEN 1 END) AS total_fraud FROM credit.cleaned_fraud GROUP BY daily, category ORDER BY total_fraud DESC;
