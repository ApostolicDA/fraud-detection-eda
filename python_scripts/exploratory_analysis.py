import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import chi2_contingency, pointbiserialr
import warnings
warnings.filterwarnings('ignore')

"""
========================================================================
FRAUD DETECTION - EXPLORATORY DATA ANALYSIS (EDA)
Senior-Level Statistical and Visual Analysis
========================================================================
Purpose: Comprehensive statistical analysis of fraud patterns
Author: ApostolicDA
Output: Statistical summaries, visualizations, and insights
========================================================================
"""

# Load cleaned data
df = pd.read_csv('cleaned_fraud_data.csv')

print("\n" + "="*70)
print("FRAUD DETECTION EDA - STATISTICAL ANALYSIS")
print("="*70)

# ======================== SECTION 1: DATA OVERVIEW ========================
print("\n[1] DATASET OVERVIEW")
print("-" * 70)
print(f"Dataset Shape: {df.shape}")
print(f"\nColumns: {df.columns.tolist()}")
print(f"\nData Types:\n{df.dtypes}")
print(f"\nMissing Values:\n{df.isnull().sum()}")

# ======================== SECTION 2: CLASS IMBALANCE ANALYSIS ========================
print("\n[2] CLASS IMBALANCE & FRAUD RATE ANALYSIS")
print("-" * 70)
fraud_distribution = df['fraud'].value_counts()
fraud_percentages = df['fraud'].value_counts(normalize=True) * 100

print(f"Fraud Distribution:")
for fraud_type in ['NO', 'YES']:
    count = fraud_distribution.get(fraud_type, 0)
    pct = fraud_percentages.get(fraud_type, 0)
    print(f"  {fraud_type}: {count:,} transactions ({pct:.2f}%)")

fraud_ratio = fraud_distribution.get('YES', 0) / fraud_distribution.get('NO', 0)
print(f"\nFraud Ratio (Fraud:Legitimate): 1:{fraud_ratio:.2f}")
print(f"Imbalance Level: {'SEVERE' if fraud_ratio < 0.15 else 'MODERATE' if fraud_ratio < 0.25 else 'BALANCED'}")

# ======================== SECTION 3: TRANSACTION AMOUNT ANALYSIS ========================
print("\n[3] TRANSACTION AMOUNT STATISTICAL ANALYSIS")
print("-" * 70)
for fraud_status in ['NO', 'YES']:
    fraud_data = df[df['fraud'] == fraud_status]['amount']
    print(f"\n{fraud_status} (Legitimate):" if fraud_status == 'NO' else f"\n{fraud_status} (Fraudulent):")
    print(f"  Count: {len(fraud_data):,}")
    print(f"  Mean: ${fraud_data.mean():.2f}")
    print(f"  Median: ${fraud_data.median():.2f}")
    print(f"  Std Dev: ${fraud_data.std():.2f}")
    print(f"  Min: ${fraud_data.min():.2f}")
    print(f"  Max: ${fraud_data.max():.2f}")
    print(f"  Q1: ${fraud_data.quantile(0.25):.2f}")
    print(f"  Q3: ${fraud_data.quantile(0.75):.2f}")
    print(f"  IQR: ${fraud_data.quantile(0.75) - fraud_data.quantile(0.25):.2f}")

# Fraud vs Legitimate comparison
fraud_mean = df[df['fraud'] == 'YES']['amount'].mean()
legit_mean = df[df['fraud'] == 'NO']['amount'].mean()
mean_ratio = fraud_mean / legit_mean
print(f"\nMean Value Ratio (Fraud:Legitimate): {mean_ratio:.2f}x")
print(f"Insight: Fraudulent transactions are {mean_ratio:.2f}x higher in value")

# ======================== SECTION 4: PAYMENT METHOD RISK MATRIX ========================
print("\n[4] PAYMENT METHOD RISK ANALYSIS")
print("-" * 70)
payment_method_analysis = df.groupby('payment_method').agg({
    'fraud': ['count', lambda x: (x == 'YES').sum(), lambda x: (x == 'YES').sum() / len(x) * 100],
    'amount': ['mean', 'sum']
}).round(2)

payment_method_analysis.columns = ['Total_Transactions', 'Fraud_Count', 'Fraud_Rate_%', 'Avg_Amount', 'Total_Amount']
payment_method_analysis = payment_method_analysis.sort_values('Fraud_Rate_%', ascending=False)

print("\nPayment Method Risk Profile:")
print(payment_method_analysis.to_string())

# ======================== SECTION 5: PRODUCT CATEGORY ANALYSIS ========================
print("\n[5] PRODUCT CATEGORY FRAUD ANALYSIS")
print("-" * 70)
category_analysis = df.groupby('category').agg({
    'fraud': ['count', lambda x: (x == 'YES').sum(), lambda x: (x == 'YES').sum() / len(x) * 100],
    'amount': ['mean', 'sum']
}).round(2)

category_analysis.columns = ['Total_Transactions', 'Fraud_Count', 'Fraud_Rate_%', 'Avg_Amount', 'Total_Fraud_Amount']
category_analysis = category_analysis.sort_values('Fraud_Count', ascending=False)

print("\nCategory Fraud Risk Profile:")
print(category_analysis.to_string())

# ======================== SECTION 6: USER CONCENTRATION ANALYSIS ========================
print("\n[6] USER CONCENTRATION & RISK PROFILING")
print("-" * 70)
user_fraud = df[df['fraud'] == 'YES'].groupby('user_id').size()
user_fraud_sorted = user_fraud.sort_values(ascending=False)

print(f"\nTotal Unique Users: {df['user_id'].nunique():,}")
print(f"Users with Fraud: {len(user_fraud_sorted):,}")
print(f"\nTop 10 Fraudulent Users (by incident count):")
for idx, (user, count) in enumerate(user_fraud_sorted.head(10).items(), 1):
    fraud_transactions = df[(df['user_id'] == user) & (df['fraud'] == 'YES')]
    fraud_amount = fraud_transactions['amount'].sum()
    user_total = df[df['user_id'] == user].shape[0]
    fraud_rate = count / user_total * 100
    print(f"  {idx}. User {user}: {count} frauds (${fraud_amount:.2f}), {fraud_rate:.1f}% fraud rate out of {user_total} transactions")

print(f"\nFraud Concentration:")
top_10_fraud_pct = (user_fraud_sorted.head(10).sum() / user_fraud_sorted.sum() * 100)
print(f"  Top 10 users account for {top_10_fraud_pct:.1f}% of all fraud incidents")

# ======================== SECTION 7: TEMPORAL PATTERNS ========================
print("\n[7] TEMPORAL PATTERN ANALYSIS")
print("-" * 70)
hour_analysis = df.copy()
hour_analysis['hour'] = hour_analysis['time'].apply(lambda x: int(x // 3600) % 24)

hourly_fraud = hour_analysis.groupby('hour').agg({
    'fraud': ['count', lambda x: (x == 'YES').sum(), lambda x: (x == 'YES').sum() / len(x) * 100 if len(x) > 0 else 0]
}).round(2)

hourly_fraud.columns = ['Total_Transactions', 'Fraud_Count', 'Fraud_Rate_%']
print("\nHourly Fraud Pattern (Top 5 High-Risk Hours):")
print(hourly_fraud.sort_values('Fraud_Rate_%', ascending=False).head(5).to_string())

peak_hour = hourly_fraud['Fraud_Count'].idxmax()
print(f"\nPeak Fraud Hour: {peak_hour}:00 (UTC) with {hourly_fraud.loc[peak_hour, 'Fraud_Count']:.0f} incidents")

# ======================== SECTION 8: DEVICE ANALYSIS ========================
print("\n[8] DEVICE FINGERPRINTING & RISK ASSESSMENT")
print("-" * 70)
device_analysis = df.groupby('device_id').agg({
    'fraud': ['count', lambda x: (x == 'YES').sum(), lambda x: (x == 'YES').sum() / len(x) * 100],
    'amount': 'mean',
    'user_id': 'nunique'
}).round(2)

device_analysis.columns = ['Total_Transactions', 'Fraud_Count', 'Fraud_Rate_%', 'Avg_Amount', 'Unique_Users']
device_analysis = device_analysis[device_analysis['Fraud_Count'] > 0].sort_values('Fraud_Count', ascending=False)

print(f"\nTotal Devices: {df['device_id'].nunique():,}")
print(f"Devices with Fraud: {len(device_analysis):,}")
print("\nTop 10 Suspicious Devices:")
print(device_analysis.head(10).to_string())

# ======================== SECTION 9: CORRELATION & STATISTICAL TESTS ========================
print("\n[9] STATISTICAL CORRELATION ANALYSIS")
print("-" * 70)

# Convert fraud to numeric for correlation
df_numeric = df.copy()
df_numeric['fraud_numeric'] = (df_numeric['fraud'] == 'YES').astype(int)

# Correlation with fraud
correlations = {}
for col in ['amount', 'device_id', 'time']:
    corr, p_value = pointbiserialr(df_numeric['fraud_numeric'], df_numeric[col])
    correlations[col] = {'correlation': corr, 'p_value': p_value}

print("\nPoint-Biserial Correlations with Fraud:")
for col, stats in correlations.items():
    print(f"  {col}: r={stats['correlation']:.4f}, p-value={stats['p_value']:.6f} {'***' if stats['p_value'] < 0.001 else '**' if stats['p_value'] < 0.01 else '*' if stats['p_value'] < 0.05 else 'ns'}")

print("\n*** p < 0.001 (highly significant)")
print("** p < 0.01 (very significant)")
print("* p < 0.05 (significant)")
print("ns = not significant")

# ======================== SECTION 10: KEY FINDINGS & RECOMMENDATIONS ========================
print("\n[10] SENIOR-LEVEL INSIGHTS & RECOMMENDATIONS")
print("-" * 70)

findings = [
    f"\n1. CLASS IMBALANCE: {fraud_percentages.get('YES', 0):.2f}% fraud rate indicates severe imbalance",
    f"   → Recommendation: Use stratified sampling and weighted models",
    
    f"\n2. FRAUD VALUE PATTERN: Fraudulent transactions average ${fraud_mean:.2f} vs ${legit_mean:.2f} for legitimate",
    f"   → Insight: {mean_ratio:.2f}x value uplift suggests intentional high-value targeting",
    f"   → Recommendation: Implement amount-based thresholds and transaction monitoring",
    
    f"\n3. PAYMENT METHOD RISK: {payment_method_analysis.index[0]} shows {payment_method_analysis['Fraud_Rate_%'].iloc[0]:.2f}% fraud rate",
    f"   → Recommendation: Enhanced security for high-risk payment methods",
    
    f"\n4. USER CONCENTRATION: Top 10 users account for {top_10_fraud_pct:.1f}% of fraud",
    f"   → Insight: Highly concentrated fraud suggests organized crime or compromised accounts",
    f"   → Recommendation: Implement user-level risk scoring and account restrictions",
    
    f"\n5. TEMPORAL PATTERNS: Peak fraud at {peak_hour}:00 UTC",
    f"   → Recommendation: Increase monitoring during peak hours",
    
    f"\n6. CATEGORY TARGETING: {category_analysis.index[0]} most targeted category",
    f"   → Recommendation: Category-specific fraud prevention and inventory security",
]

for finding in findings:
    print(finding)

print("\n" + "="*70)
print("EDA ANALYSIS COMPLETE")
print("="*70)
print("\nNext Steps:")
print("  1. Feed these insights into feature engineering for ML models")
print("  2. Implement thresholds based on transaction amount and time patterns")
print("  3. Create user and device risk scoring algorithms")
print("  4. Develop real-time monitoring dashboard for peak fraud hours")
print("  5. Consider ensemble methods for imbalanced classification")
print("\n")
