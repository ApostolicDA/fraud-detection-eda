# Fraud Detection EDA - End-to-End Data Analysis Project

## Project Overview
This is a comprehensive end-to-end data analysis project focused on credit card fraud detection. The project demonstrates the complete workflow from data cleaning through exploratory data analysis (EDA) to visualization of fraud patterns using Python, SQL, and PowerBI.

## Dataset
- **Source**: Synthetic credit card fraud dataset
- **Original File**: `messy_synthetic_fraud.csv`
- **Total Transactions**: 1,056
- **Fraud Cases**: 112 (10.61%)
- **Fraud Amount**: $38,990

## Project Structure

```
fraud-detection-eda/
├── python_scripts/
│   └── data_cleaning.py          # Data cleaning and validation script
├── sql_queries/
│   └── fraud_eda.sql             # SQL exploratory data analysis queries
├── powerbi_reports/              # PowerBI visualization files
└── README.md                      # This file
```

## Technology Stack
- **Python 3.x**: Data cleaning and preprocessing using pandas
- **SQL**: Exploratory data analysis and aggregation queries
- **PowerBI**: Interactive dashboards and fraud visualization
- **Git**: Version control and collaboration

## Data Processing Workflow

### 1. Data Cleaning (Python)
The `python_scripts/data_cleaning.py` script performs:
- Loading of raw fraud dataset
- Converting fraud binary values (0/1) to categorical (NO/YES)
- Duplicate record removal
- Handling missing values (rows with >3 missing values removed)
- Data validation:
  - Checking for negative values in amount column
  - Checking for negative values in device_id column
  - Data type conversions
- Generating cleaned dataset output

**Key Statistics**:
- Duplicates found and removed
- Missing values handled by threshold
- Data integrity validated

### 2. Exploratory Data Analysis (SQL)
The `sql_queries/fraud_eda.sql` script contains 12 comprehensive queries:

1. **Transaction Count**: Total fraud vs. legitimate transactions
2. **Payment Method Analysis**: Average amounts by payment method
3. **Fraud by Amount**: Average transaction amount for fraudulent vs. legitimate
4. **Payment Method Risk**: Fraud distribution across payment methods
5. **Risky Methods**: Payment methods with highest fraud incidents
6. **Safe Methods**: Payment methods with legitimate transaction volume
7. **Fraud by Category**: Product categories most targeted by fraud
8. **Suspicious Users**: Identification of users with most fraud incidents
9. **Hourly Risk Factor**: Fraud distribution by hour of day
10. **Hourly Category Risk**: Fraud by category and time of day
11. **Daily Risk Factor**: Fraud distribution across days
12. **Daily Category Risk**: Category-wise fraud trends over time

### 3. Visualization (PowerBI)
The PowerBI reports include interactive dashboards with:
- **Key Metrics**: Total transactions, fraud count, fraud rate, fraud amount
- **Payment Method Analysis**: Fraud rate and transaction volume by payment method
- **Category Analysis**: Fraud distribution across product categories
- **Temporal Analysis**: Fraud patterns by hour and day
- **User Risk Analysis**: Identification of high-risk users
- **Interactive Filters**: Dynamic filtering by date, category, and payment method

## Key Findings

### Fraud Statistics
- **Overall Fraud Rate**: 10.61% (112 out of 1,056 transactions)
- **Total Fraud Amount**: $38,990
- **Average Fraud Transaction**: $347.78
- **Average Legitimate Transaction**: $35.72

### High-Risk Payment Methods
1. **Bank Transfers**: 30 fraudulent transactions (12% fraud rate)
2. **PayPal**: 29 fraudulent transactions (11% fraud rate)  
3. **Cryptocurrency**: 26 fraudulent transactions (10% fraud rate)
4. **Credit Card**: 26 fraudulent transactions (10% fraud rate)

### High-Risk Categories
- **Electronics**: Most targeted category for fraud
- **Sports**: High fraud count
- **Home & Garden**: Significant fraud incidents
- **Food & Beverages**: Moderate fraud risk

## How to Use This Project

### Prerequisites
- Python 3.x with pandas library
- MySQL or compatible SQL database
- PowerBI Desktop (for viewing/editing reports)
- Git for version control

### Running the Data Cleaning Script
```bash
python python_scripts/data_cleaning.py
```
This will:
- Load the raw fraud dataset
- Apply data cleaning transformations
- Validate data integrity
- Output `cleaned_fraud_data.csv`

### Executing SQL Queries
1. Connect to your database with the cleaned fraud data
2. Run queries from `sql_queries/fraud_eda.sql`
3. Review the results for insights

### Viewing PowerBI Reports
1. Open the PowerBI files in PowerBI Desktop
2. Connect to your data source
3. Interact with the dashboards using filters and slicers
4. Export reports as needed

## Database Setup

Ensure your database has the following structure:
```sql
CREATE TABLE credit.cleaned_fraud (
    user_id INT,
    amount INT,
    fraud VARCHAR(10),
    payment_method VARCHAR(50),
    category VARCHAR(50),
    device_id INT,
    time INT
);
```

## Results and Insights

### Data Quality Improvements
- Removed duplicate entries for data integrity
- Handled missing values appropriately
- Standardized fraud values to categorical format
- Validated numeric fields for negative values

### Fraud Pattern Discoveries
1. **Payment Method Risk**: Bank transfers show higher fraud susceptibility
2. **Category Vulnerability**: Electronics and sports categories are most targeted
3. **Temporal Patterns**: Fraud incidents vary by time of day and day of week
4. **User Concentration**: A small number of users account for majority of fraud
5. **Amount Patterns**: Fraudulent transactions are significantly higher in value

## Future Enhancements
- Machine learning models for fraud prediction
- Real-time fraud detection system
- Anomaly detection algorithms
- Customer segmentation analysis
- Risk scoring model

## Files in This Repository

| File | Description |
|------|-------------|
| `python_scripts/data_cleaning.py` | Python script for data cleaning and validation |
| `sql_queries/fraud_eda.sql` | SQL queries for comprehensive EDA |
| `powerbi_reports/fraud_analysis.pbix` | Main PowerBI dashboard |
| `powerbi_reports/fraud_by_category.pbix` | Category-specific fraud analysis |
| `README.md` | This documentation file |

## Author
**ApostolicDA** - Data Analyst & Data Engineer

## License
This project is provided as-is for educational and analytical purposes.

## Contact & Support
For questions or suggestions regarding this project, please open an issue on GitHub.

---

**Last Updated**: January 2026
**Project Status**: Active
