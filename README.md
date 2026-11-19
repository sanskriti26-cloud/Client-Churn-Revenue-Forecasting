# Client Churn Risk Analysis & Revenue Forecasting for Managed IT Services

## Project Overview
This project analyzes enterprise client churn and forecasts future revenue for a managed IT services company using **Microsoft Excek**, **Microsoft SQL Server** and **Microsoft Power BI**.

The objective is to identify clients at risk of churn, determine the key factors driving customer attrition, forecast revenue for the next 12 months, and provide data-driven recommendations to improve customer retention and business performance.

---

## Business Problem
The company provides the following managed IT services:
- Infrastructure Management
- Cloud Migration
- Security Services
- 24/7 IT Support

Management aims to:
- Identify clients likely to churn within the next three months.
- Determine the key factors contributing to customer churn.
- Forecast revenue for the next twelve months.
- Recommend strategies to reduce customer churn by at least 5%.

---

## Tools & Technologies

- Microsoft Excel
- Microsoft SQL Server
- Microsoft Power BI

---

## Dataset

The project utilizes two datasets:

### clients
The factors in this dataset are:
- Client ID
- Client Name
- Services Subscribed
- Churn Status
- Churn Date
- Churn Reason
- Customer Satisfaction Score
- Contract Start Date

### billing_events
The factors in this dataset are:
- Event ID
- Client ID
- Year
- Month
- Quarter
- Service Line
- Event Type
- Revenue Amount

---

## Data Preparation

The following preprocessing steps were performed using Microsoft Excel:
- Imported raw datasets.
- Validated data types.
- Checked for duplicate records.
- Handled missing values.
- Cleaned and standardized the data.

## Data Analysis using SQL Server
Data analysis was performed on both the tables, "clients" and "billing_events". This included:
- Understanding the dataset
- Finding factors most strongly associated with client attrition.
- Finding clients most likely to churn in next 3 months.
- Revenue trend analysis
- Forecasting next 12 months' revenue based on past trend of revenue.

---

## Dashboard Features

The interactive Power BI dashboard includes:
- Total Revenue KPI
- Total Clients KPI
- Client Churn Rate
- Average Customer Satisfaction
- Monthly Revenue Trend
- Customer Satisfaction Distribution
- Most Subscribed Services
- Churn Reason Analysis
- Interactive Year, Quarter and Month Filters

---

## Key Insights
- Total Enterprise Clients: **200**
- Total Revenue: **88.88 Million**
- Client Churn Rate: **18%**
- Average Customer Satisfaction: **3.39 / 5**
- Revenue exhibits an overall declining trend during the analysis period.
- Switching to competitors is the leading cause of customer churn.
- Cloud Migration and Infrastructure Management are the most frequently subscribed services.

---

## Recommendations

- Strengthen customer retention initiatives.
- Improve customer satisfaction through enhanced service quality.
- Review pricing strategies to remain competitive.
- Promote high-demand services through cross-selling opportunities.

---

## Repository Structure
'''
text
client-churn-revenue-forecasting/
│
├── Raw Dataset/
│   └── Client Churn and Revenue Forecasting.zip
│
├── Cleaned Dataset/
│   ├── Client_Master_Cleaned.csv
│   └── Service_Transactions_Cleaned.csv
│
├── SQL/
│   └── Client Churn and Revenue Data Analysis.sql
│
├── Power BI/
│   └── Client Churn and Revenue Performance Dashboard.pbix
│
├── Report/
│   └── Client Churn Prediction and Revenue Forecasting Report.pdf
│
└── README.md
'''

This project is intended for educational and portfolio purposes
