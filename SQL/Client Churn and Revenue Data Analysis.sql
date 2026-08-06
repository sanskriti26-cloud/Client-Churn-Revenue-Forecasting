-- Exploratory Data Analysis (EDA)
-- Total Clients
SELECT COUNT(*) AS Total_Clients
FROM [Client_Master];

-- Insights:
-- There are 200 clients in total
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Total Transactions
SELECT COUNT(*) AS Total_Transactions
FROM [Service_Transactions];

-- Insights:
-- There are 50 thousand transactions in total which is enough for analysis
-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Missing Revenue Records
SELECT
COUNT(*) AS Missing_Revenue,
ROUND(
COUNT(*)*100.0/COUNT(*) OVER(),2
) AS Percentage
FROM [Service_Transactions]
WHERE Revenue_Amount IS NULL;

-- Insights:
-- 12% of revenue records were missing which were filled with median revenue of all revenue records
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Missing Customer Satisfaction
SELECT COUNT(*) AS Missing_CSS
FROM [Client_Master]
WHERE Customer_Satisfaction_Score IS NULL;

-- Insights:
-- No customer satisfaction score is missing which is good to predict client churn in future
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Distinct Services
SELECT DISTINCT Event_Type
FROM [Service_Transactions];

-- Insights:
-- Four services are being provided by the company
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Univariate Analysis
-- Churn Distribution
SELECT
Is_Churned,
COUNT(*) AS Clients,
ROUND(COUNT(*)*100.0/
SUM(COUNT(*)) OVER(),2) AS Percentage
FROM [Client_Master]
GROUP BY Is_Churned;

-- Insight:
-- 18% of clients have churned, whereas 82% remain active, indicating a relatively healthy customer retention rate.
-----------------------------------------------------------------------------------------------------------------------------------------------------------

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

-- Insights:
-- Infrastructure Management recorded the highest transaction share (28.45%), while Security Services had the lowest (22.18%), indicating relatively balanced service utilization.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Revenue Statistics
SELECT
MIN(Revenue_Amount) AS Minimum_Revenue,
MAX(Revenue_Amount) AS Maximum_Revenue,
AVG(Revenue_Amount) AS Average_Revenue
FROM [Service_Transactions];

-- Insights:
-- Revenue per transaction ranged from 20 to 14,770.36, with an average of 1,777.51, showing considerable variation in transaction values.
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Customer Satisfaction Distribution
SELECT
Customer_Satisfaction_Score,
COUNT(*) AS Clients
FROM [Client_Master]
GROUP BY Customer_Satisfaction_Score
ORDER BY Customer_Satisfaction_Score;

-- Insight:
-- Most clients have satisfaction scores of 4, while scores of 1 are the least common, indicating generally positive customer feedback.
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Monthy Revenue
SELECT
Month,
SUM(Revenue_Amount) AS Revenue
FROM [Service_Transactions]
GROUP BY Month
ORDER BY Month;

-- Insight:
-- Monthly revenue remains fairly consistent throughout the year with only moderate fluctuations and no significant seasonal decline.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Bivariate Analysis
-- Churn Vs Customer Satisfaction
SELECT
Is_Churned,
AVG(Customer_Satisfaction_Score) AS Avg_CSS
FROM [Client_Master]
GROUP BY Is_Churned;

-- Insight:
-- Churned clients have a significantly lower average satisfaction score (1.63) compared to active clients (3.77), highlighting customer satisfaction as a major churn driver.
----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Revenue by Service
SELECT
Service_Line,
SUM(Revenue_Amount) AS Total_Revenue
FROM [Service_Transactions]
GROUP BY Service_Line
ORDER BY Total_Revenue DESC;

-- Insight:
-- Infrastructure Management generated the highest total revenue, followed by Cloud Migration, 24/7 IT Support, and Security Services.
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Churn by Service Subscription
SELECT
Services_Subscribed,
COUNT(*) AS Clients,
SUM(CASE WHEN Is_Churned='TRUE' THEN 1 ELSE 0 END) AS Churned
FROM [Client_Master]
GROUP BY Services_Subscribed;

-- Insight:
-- Clients subscribed to multiple services exhibit varying churn levels, helping identify service combinations that may require targeted retention efforts.
--------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Average Revenue of Churned Vs Active Clients
SELECT
c.Is_Churned,
AVG(s.Revenue_Amount) AS Avg_Revenue
FROM [Client_Master] c
JOIN [Service_Transactions] s
ON c.Client_ID = s.Client_ID
GROUP BY c.Is_Churned;

-- Insight:
-- The average revenue generated by churned and active clients is almost identical, suggesting revenue alone is not a strong indicator of churn.
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Revenue by Quarter
SELECT
Quarter,
SUM(Revenue_Amount) AS Revenue
FROM [Service_Transactions]
GROUP BY Quarter
ORDER BY Quarter;

-- Insight:
-- Q3 generated the highest revenue, while Q2 generated the lowest, indicating seasonal fluctuations in business performance.
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Multivariate Analysis
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
-- Active clients contribute substantially higher revenue across all service lines, while churned clients account for only a small share of total revenue.
------------------------------------------------------------------------------------------------------------------------------------------------------------

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
-- Infrastructure Management remained the top revenue-generating service across all quarters, while the remaining services showed relatively stable quarterly performance.
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Customer Satisfaction Vs Revenue and Churn
SELECT
c.Is_Churned,
AVG(c.Customer_Satisfaction_Score) AS Avg_CSS,
SUM(s.Revenue_Amount) AS Total_Revenue
FROM [Client_Master] c
JOIN [Service_Transactions] s
ON c.Client_ID=s.Client_ID
GROUP BY c.Is_Churned;

-- Insight:
-- Active clients have a higher average satisfaction score (3.78) and contribute significantly more revenue than churned clients (1.71), reinforcing the strong relationship between customer satisfaction, retention, and revenue.
----------------------------------------------------------------------------------------------------------------------------------------------------------

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
-- Infrastructure Management consistently generated the highest yearly revenue, followed by Cloud Migration, indicating strong long-term demand for these services.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Question-Specific Queries
-- Top Clients Likey to Churn
SELECT
Client_ID,
Client_Name,
Customer_Satisfaction_Score
FROM [Client_Master]
WHERE Is_Churned='FALSE'
AND Customer_Satisfaction_Score < 3
ORDER BY Customer_Satisfaction_Score;

-- Insight:
-- Clients with satisfaction scores of 1 or 2 are identified as the highest churn-risk customers and should be prioritized for retention initiatives.
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top Factors Driving Churn
SELECT
Churn_Reason,
COUNT(*) AS Total_Clients
FROM [Client_Master]
WHERE Is_Churned='TRUE'
GROUP BY Churn_Reason
ORDER BY Total_Clients DESC;

-- Insight:
-- Switched provider is the leading reason for churn, followed by price/cost and poor support quality, suggesting improvements in pricing strategy and service quality could reduce customer attrition.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

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
Year,
Month;

-- Insight:
-- Monthly revenue data provides a consistent historical baseline for forecasting future revenue trends and business performance.
--------------------------------------------------------------------------------------------------------------------------------------------------