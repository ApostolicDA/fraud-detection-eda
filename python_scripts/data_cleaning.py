import pandas as pd

# Load the messy fraud dataset
df = pd.read_csv(r"C:\Users\gadis\Downloads\messy_synthetic_fraud.csv")

# Replace fraud values: convert 0/1 to NO/YES
df['fraud'] = df['fraud'].replace({0: 'NO', 1: 'YES'})

# Check for duplicates
print(f"Duplicates before cleaning: {df.duplicated().sum()}")

# Remove duplicate rows
df = df.drop_duplicates()

print(f"Duplicates after cleaning: {df.duplicated().sum()}")

# Check for null values
print(f"\nNull values by column:\n{df.isnull().sum()}")

# Drop rows where there are more than 3 missing values
# (keep rows with at most 3 missing values from 7 columns total)
df = df.dropna(thresh=len(df.columns) - 3)

# Data validation: Check for negative values in amount column
negative_amounts = df[df['amount'] < 0]
if len(negative_amounts) > 0:
    print(f"\nWarning: Found {len(negative_amounts)} rows with negative amounts")
    print(negative_amounts)

# Data validation: Check for negative values in device_id
negative_devices = df[df['device_id'] < 0]
if len(negative_devices) > 0:
    print(f"\nWarning: Found {len(negative_devices)} rows with negative device IDs")

# Display first few rows
print(f"\nCleaned dataset shape: {df.shape}")
print(f"\nFirst few rows:")
print(df.head())

# Display time column info
print(f"\nTime column statistics:")
print(df['time'].describe())

# Save cleaned data
df.to_csv('cleaned_fraud_data.csv', index=False)
print("\nCleaned data saved as 'cleaned_fraud_data.csv'")
