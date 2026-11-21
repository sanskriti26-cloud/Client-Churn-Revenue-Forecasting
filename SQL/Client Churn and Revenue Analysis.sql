-- ==================================================================================
-- 01. DATA OVERVIEW & QUALITY CHECK
-- ==================================================================================

-- Total Clients
SELECT COUNT(*) AS Total_Clients
FROM [Client_Master];

-- Total Transactions
SELECT COUNT(*) AS Total_Transactions
FROM [Service_Transactions];

-- Missing Revenue Records
SELECT
COUNT(*) AS Missing_Revenue,
ROUND(
COUNT(*)*100.0/COUNT(*) OVER(),2
) AS Percentage
FROM [Service_Transactions]
WHERE Revenue_Amount IS NULL;

-- Insight:
-- Approximately 12% of revenue records were missing and were
-- imputed using the median revenue value.

-- Missing Customer Satisfaction
SELECT COUNT(*) AS Missing_CSS
FROM [Client_Master]
WHERE Customer_Satisfaction_Score IS NULL;

-- Insight:
-- Customer satisfaction scores are complete, eliminating the
-- need for missing-value imputation for this variable.

-- Distinct Services
SELECT DISTINCT Event_Type
FROM [Service_Transactions];

-- Insight:
-- The dataset contains four distinct service categories.

-- ====================================================================================
-- 02. UNIVARIATE ANALYSIS
-- ====================================================================================

-- Churn Distribution
SELECT
Is_Churned,
COUNT(*) AS Clients,
ROUND(COUNT(*)*100.0/
SUM(COUNT(*)) OVER(),2) AS Percentage
FROM [Client_Master]
GROUP BY Is_Churned;

-- Insight:
-- 18% of clients have churned, while the remaining 82% are active.

-- Service Distribution
SELECT
    Service_Line,
    COUNT(*) AS Total_Transactions,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS Transaction_Percentage
FROM [Service_Transactions]
GROUP BY Service_Line
ORDER BY Total_Transactions DESC;

-- Insight:
-- Infrastructure Management accounted for the highest transaction
-- share (28.45%), while Security Services had the lowest (22.18%).

-- Revenue Statistics
SELECT
MIN(Revenue_Amount) AS Minimum_Revenue,
MAX(Revenue_Amount) AS Maximum_Revenue,
AVG(Revenue_Amount) AS Average_Revenue
FROM [Service_Transactions];

-- Insight:
-- Transaction revenue ranged from 20 to 14,770.36,
-- with an average of 1,777.51.

-- Customer Satisfaction Distribution
SELECT
Customer_Satisfaction_Score,
COUNT(*) AS Clients
FROM [Client_Master]
GROUP BY Customer_Satisfaction_Score
ORDER BY Customer_Satisfaction_Score;

-- Insight:
-- A satisfaction score of 4 was the most common, while a score
-- of 1 was the least common among clients.

-- ====================================================================================
-- 03. BIVARIATE ANALYSIS
-- ====================================================================================

-- Churn Vs Customer Satisfaction
SELECT
Is_Churned,
AVG(Customer_Satisfaction_Score) AS Avg_CSS
FROM [Client_Master]
GROUP BY Is_Churned;

-- Insight:
-- Churned clients had a substantially lower average satisfaction
-- score (1.63) than active clients (3.77), indicating a strong
-- association between customer dissatisfaction and churn.

-- Revenue by Service
SELECT
Service_Line,
SUM(Revenue_Amount) AS Total_Revenue
FROM [Service_Transactions]
GROUP BY Service_Line
ORDER BY Total_Revenue DESC;

-- Insight:
-- Infrastructure Management generated the highest total revenue,
-- followed by Cloud Migration, 24/7 IT Support, and Security Services.

-- Churn by Service Subscription
SELECT
Services_Subscribed,
COUNT(*) AS Clients,
SUM(CASE WHEN Is_Churned='TRUE' THEN 1 ELSE 0 END) AS Churned
FROM [Client_Master]
GROUP BY Services_Subscribed;

-- Insight:
-- Churned client counts vary across service subscription
-- combinations, highlighting segments for further retention analysis

-- Average Revenue of Churned Vs Active Clients
SELECT
c.Is_Churned,
AVG(s.Revenue_Amount) AS Avg_Revenue
FROM [Client_Master] c
JOIN [Service_Transactions] s
ON c.Client_ID = s.Client_ID
GROUP BY c.Is_Churned;

-- Insight:
-- Average transaction revenue is similar between churned and
-- active clients, suggesting limited differentiation in
-- transaction values between the two groups.

-- Revenue by Quarter
SELECT
Quarter,
SUM(Revenue_Amount) AS Revenue
FROM [Service_Transactions]
GROUP BY Quarter
ORDER BY Quarter;

-- Insight:
-- Q3 recorded the highest total revenue, while Q2 recorded
-- the lowest, highlighting differences in quarterly revenue performance.

-- ======================================================================================
-- 04. MULTIVARIATE ANALYSIS
-- ======================================================================================

-- Service-wise Client Count and Revenue by Churn Status
SELECT
s.Service_Line,
c.Is_Churned,
COUNT(DISTINCT c.Client_ID) AS Clients,
SUM(s.Revenue_Amount) AS Revenue
FROM [Client_Master] c
JOIN [Service_Transactions] s
ON c.Client_ID=s.Client_ID
GROUP BY
s.Service_Line,
c.Is_Churned
ORDER BY Revenue DESC;

-- Insight:
-- Active clients account for a substantially higher share of
-- total revenue across service lines than churned clients.

-- Quarter-wise Revenue by Service
SELECT
Quarter,
Service_Line,
SUM(Revenue_Amount) AS Revenue
FROM [Service_Transactions]
GROUP BY
Quarter,
Service_Line
ORDER BY Quarter, Revenue DESC;

-- Insight:
-- Infrastructure Management generated the highest revenue across
-- all quarters, while the remaining services showed relatively
-- stable quarterly revenue patterns.

-- Revenue Trend by Year and Service
SELECT
Year,
Service_Line,
SUM(Revenue_Amount) AS Revenue
FROM [Service_Transactions]
GROUP BY
Year,
Service_Line
ORDER BY Year, Service_Line;

-- Insight:
-- Infrastructure Management consistently generated the highest
-- annual revenue, followed by Cloud Migration, highlighting
-- their contribution to overall business revenue.

-- ====================================================================================
-- 05. BUSINESS QUESTIONS & INVESTIGATION
-- ====================================================================================

-- Clients at Risk of Churning
SELECT
Client_ID,
Client_Name,
Customer_Satisfaction_Score
FROM [Client_Master]
WHERE Is_Churned='FALSE'
AND Customer_Satisfaction_Score < 3
ORDER BY Customer_Satisfaction_Score;

-- Insight:
-- Active clients with satisfaction scores below 3 are identified
-- as potential churn-risk segments and may warrant proactive
-- retention efforts.

-- Reported Churn Reasons
SELECT
Churn_Reason,
COUNT(*) AS Total_Clients
FROM [Client_Master]
WHERE Is_Churned='TRUE'
GROUP BY Churn_Reason
ORDER BY Total_Clients DESC;

-- Insight:
-- Switched provider is the leading reason for churn, followed by price/cost and poor support quality, suggesting improvements in pricing strategy and service quality could reduce customer attrition

-- Revenue Forecast Base (Monthly Revenue)
SELECT
Year,
Month,
SUM(Revenue_Amount) AS Monthly_Revenue
FROM [Service_Transactions]
GROUP BY
Year,
Month
ORDER BY
Year;

-- Insight:
-- Monthly revenue is aggregated across four years of historical
-- data, providing a chronological view of revenue performance
-- for trend analysis and forecasting.