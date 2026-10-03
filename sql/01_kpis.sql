
-- (headline numbers)
/*SELECT COUNT(*) AS customers,
       ROUND(100 * SUM(Attrited) / COUNT(*), 2) AS attrition_pct,
       ROUND(AVG(Total_Trans_Amt), 0) AS avg_spend,
       ROUND(AVG(Total_Trans_Ct), 1) AS avg_txns,
       ROUND(SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct), 2) AS avg_ticket
FROM customers; */

-- Compare the card types
/* SELECT Card_Category,
       COUNT(*) AS customers,
       ROUND(AVG(Total_Trans_Amt), 0) AS avg_spend,
       ROUND(AVG(Total_Trans_Ct), 1) AS avg_txns,
       ROUND(SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct), 2) AS avg_ticket,
       ROUND(100 * SUM(Attrited) / COUNT(*), 1) AS attrition_pct
FROM customers
GROUP BY Card_Category
ORDER BY avg_spend DESC; */


-- KPIs by income category
 SELECT Income_Category,
       COUNT(*) AS customers,
       ROUND(AVG(Total_Trans_Amt), 0) AS avg_spend,
       ROUND(AVG(Total_Trans_Ct), 1) AS avg_txns,
       ROUND(SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct), 2) AS avg_ticket,
       ROUND(100 * SUM(Attrited) / COUNT(*), 1) AS attrition_pct
FROM customers
GROUP BY Income_Category
ORDER BY avg_spend DESC;

-- KPIs by age band
SELECT Age_Band,
       COUNT(*) AS customers,
       ROUND(AVG(Total_Trans_Amt), 0) AS avg_spend,
       ROUND(AVG(Total_Trans_Ct), 1) AS avg_txns,
       ROUND(SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct), 2) AS avg_ticket,
       ROUND(100 * SUM(Attrited) / COUNT(*), 1) AS attrition_pct
FROM customers
GROUP BY Age_Band
ORDER BY MIN(Customer_Age);


-- Share of total spend by card category
SELECT Card_Category,
       SUM(Total_Trans_Amt) AS total_spend,
       ROUND(100 * SUM(Total_Trans_Amt) / SUM(SUM(Total_Trans_Amt)) OVER (), 1) AS spend_share_pct
FROM customers
GROUP BY Card_Category
ORDER BY total_spend DESC;


-- Attrition rate by spend quartile (1 = lowest spenders, 4 = highest)
SELECT quartile,
       COUNT(*) AS customers,
       ROUND(100 * SUM(Attrited) / COUNT(*), 1) AS attrition_pct
FROM (
    SELECT Attrited,
           NTILE(4) OVER (ORDER BY Total_Trans_Amt) AS quartile
    FROM customers
) t
GROUP BY quartile
ORDER BY quartile;

-- Top 3 spenders per card category
SELECT *
FROM (
    SELECT CLIENTNUM, Card_Category, Total_Trans_Amt,
           RANK() OVER (PARTITION BY Card_Category ORDER BY Total_Trans_Amt DESC) AS rnk
    FROM customers
) t
WHERE rnk <= 3;


-- Decomposition: existing vs attrited customers
SELECT Attrition_Flag,
       COUNT(*) AS customers,
       ROUND(AVG(Total_Trans_Ct), 2) AS avg_txns,
       ROUND(SUM(Total_Trans_Amt) / SUM(Total_Trans_Ct), 2) AS avg_ticket,
       ROUND(AVG(Total_Trans_Amt), 0) AS avg_spend
FROM customers
GROUP BY Attrition_Flag;
