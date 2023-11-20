"# SQL-project-on-Retail-Insights" 

Key Components:
1.	MySQL Database:
Product table- Contains detailed information like product_id, product_name, product_type, category and sub-category about various products.
Orders Table: Captures transactional data such as product_id, store_id, order_id, selling_price, customer_id, product_id
Stores Table: Stores relevant information about different stores like store_id, storetype_id, store_size, city_id, state, city.

2.	Data Analysis and Queries:
Leveraging SQL queries to calculate essential metrics such as the number of orders, Gross Merchandise Value (GMV), Revenue, Unique users, and New users.

3.	Integration with Google Sheets:
Developing an automated process to populate a Google Spreadsheet with real-time data updates from the MySQL database. 

Key Metrics to be filled in Google Spreadsheets:
Yday_Orders:	Number of orders placed on the previous day
Yday_GMV:	Gross Merchandise Value (GMV) for the previous day.
Yday_Revenue:	Total revenue generated from sales on the previous day (which is GMV excluding 18% GST)
Yday_Unique_Users:	Number of distinct users buying the product on the previous day 
Yday_New_Users:	Number of users who made their first purchase on the previous day
	
Similarly,
MTD_Orders:	Month to Date, cumulative order activity for the ongoing month till current date
LMTD_Orders:	Last Month to date orders (Orders from last month 1st date to current month, current date)
LM_Orders:	Last Month orders, cumulative order activity of last month

Methodology:
1.	Data Cleaning:
•	The initial step involved meticulous cleaning of the datasets which included the removal of extraneous spaces, normalization of date formats to adhere to MySQL standards, and other data quality enhancements.
2.	MySQL Database Import:
•	To facilitate efficient querying and analysis, the cleaned datasets were imported into MySQL. Recognizing the potential challenges posed by large datasets, the method of choice for data import was 'LOAD DATA INFILE.' It significantly improved the speed of data transfer into the MySQL.
3.	Query Execution:
•	A series of strategically designed queries were executed. These queries aimed to extract specific metrics and insights required for entering the values in the Google Spreadsheet.


Queries for Product category:
#Yday_Orders:
SELECT P.category, COUNT(order_id) AS Yday_orders FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY
GROUP BY P.category;

#Yday_GMV:
SELECT P.category, SUM(O.selling_price) AS Yday_GMV
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY 
GROUP BY P.category;

#Yday_Unique_Users:
SELECT P.category, COUNT(DISTINCT O.customer_id) AS Yday_Unique_Users FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY
GROUP BY P.category;

#Yday_New_Users:
SELECT R.category, COUNT(DISTINCT R.customer_id) AS Yday_New_Users
FROM (
    SELECT O.customer_id,
	RANK() OVER (PARTITION BY O.customer_id ORDER BY O.order_date) AS customer_order_rank, P.category
    FROM order_details_v1 AS O
    JOIN producthierarchy P ON O.product_id = P.product_id
    WHERE O.order_date = CURDATE() - INTERVAL 1 DAY
) AS R
WHERE customer_order_rank = 1
GROUP BY R.category;


#Category Level MTD Numbers:
#MTD_Orders:
SELECT P.category, COUNT(O.order_id) AS MTD_Orders
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE DATE(O.order_date) BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE()
GROUP BY P.category;

#MTD_GMV
SELECT P.category, SUM(O.selling_price) AS MTD_GMV
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE DATE(O.order_date) BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE()
GROUP BY P.category;

#MTD_Unique_Users
SELECT P.category, COUNT(DISTINCT O.customer_id) AS MTD_Unique_Users
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE DATE(O.order_date) BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE()
GROUP BY P.category;

#MTD_New_Users:
SELECT R.sub_category, COUNT(DISTINCT R.customer_id) AS MTD_New_Users
FROM (
    SELECT O.customer_id,
	RANK() OVER (PARTITION BY O.customer_id ORDER BY O.order_date) AS customer_order_rank, P.sub_category
    FROM order_details_v1 AS O
    JOIN producthierarchy P ON O.product_id = P.product_id
    WHERE DATE(O.order_date) BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE()
) AS R
WHERE customer_order_rank = 1
GROUP BY R.sub_category;


#Category Level LMTD Numbers:
#LMTD_Orders:
SELECT P.category, COUNT(o.order_id) AS LMTD_orders
FROM order_details_v1 O
JOIN producthierarchy P ON O.product_id = P.product_id
WHERE O.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01')
AND O.order_date <= CURDATE()
GROUP BY P.category;

#LMTD_GMV
SELECT P.category, SUM(O.selling_price) AS LMTD_GMV
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01')
AND o.order_date <= CURDATE()
GROUP BY p.category;

#LMTD_Unique_Users
SELECT P.category, COUNT(DISTINCT O.customer_id) AS LMTD_Unique_Users
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01')
AND o.order_date <= CURDATE()
GROUP BY p.category;

#LMTD_New_Users:
SELECT R.sub_category, COUNT(DISTINCT R.customer_id) AS LMTD_New_Users
FROM (
    SELECT O.customer_id,
	RANK() OVER (PARTITION BY O.customer_id ORDER BY O.order_date) AS customer_order_rank, P.sub_category
    FROM order_details_v1 AS O
    JOIN producthierarchy P ON O.product_id = P.product_id
    WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') AND o.order_date <= CURDATE()
) AS R
WHERE customer_order_rank = 1
GROUP BY R.sub_category;


#Category Level LM Numbers:
#LM_Orders:
SELECT p.category, COUNT(o.order_id) AS LM_Orders
FROM order_details_v1 o
JOIN producthierarchy p ON o.product_id = p.product_id
WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01')
GROUP BY p.category;

#LM_GMV:
SELECT P.category, SUM(O.selling_price) AS LM_GMV
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01')
GROUP BY p.category;

#LM_Unique_Users:
SELECT P.category, COUNT(DISTINCT O.customer_id) AS LM_Unique_Users
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01')
GROUP BY p.category;

#LM_New_Users:
SELECT R.category, COUNT(DISTINCT R.customer_id) AS MTD_New_Users
FROM (
    SELECT O.customer_id,
	RANK() OVER (PARTITION BY O.customer_id ORDER BY O.order_date) AS customer_order_rank, P.category
    FROM order_details_v1 AS O
    JOIN producthierarchy P ON O.product_id = P.product_id
    WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01')
) AS R
WHERE customer_order_rank = 1
GROUP BY R.category;

Similar Queries were written for Product sub_category

We can combine all these queries into single query using Case Statements. 

Combined Query for Product Category:
SELECT 
    category,
    COALESCE(SUM(CASE WHEN order_Date = DATE_ADD(CURDATE(), INTERVAL -1 DAY) THEN orders END), 0) AS      yday_orders,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURRENT_DATE() - INTERVAL 1 MONTH, '%Y-%m-01') AND    DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY), INTERVAL -1 MONTH) THEN orders END), 0) AS lmtd_orders,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE() THEN orders END), 0) AS mtd_orders,
    COALESCE(SUM(CASE WHEN order_Date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') THEN orders END), 0) AS lm_orders,
    COALESCE(SUM(CASE WHEN order_Date = DATE_ADD(CURDATE(), INTERVAL -1 DAY) THEN gmv END), 0) AS yday_gmv,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURRENT_DATE() - INTERVAL 1 MONTH, '%Y-%m-01') AND DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY), INTERVAL -1 MONTH) THEN gmv END), 0) AS lmtd_gmv,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE() THEN gmv END), 0) AS mtd_gmv,
    COALESCE(SUM(CASE WHEN order_Date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') THEN gmv END), 0) AS lm_gmv,
    COALESCE(SUM(CASE WHEN order_Date = DATE_ADD(CURDATE(), INTERVAL -1 DAY) THEN revenue END), 0) AS yday_revenue,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURRENT_DATE() - INTERVAL 1 MONTH, '%Y-%m-01') AND DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY), INTERVAL -1 MONTH) THEN revenue END), 0) AS lmtd_revenue,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE() THEN revenue END), 0) AS mtd_revenue,
    COALESCE(SUM(CASE WHEN order_Date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') THEN revenue END), 0) AS lm_revenue,
    COALESCE(SUM(CASE WHEN order_Date = DATE_ADD(CURDATE(), INTERVAL -1 DAY) THEN customers END), 0) AS yday_unique_users,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURRENT_DATE() - INTERVAL 1 MONTH, '%Y-%m-01') AND DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY), INTERVAL -1 MONTH) THEN customers END), 0) AS lmtd_unique_users,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE() THEN customers END), 0) AS mtd_unique_users,
    COALESCE(SUM(CASE WHEN order_Date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') THEN customers END), 0) AS lm_unique_users,
    COALESCE(SUM(CASE WHEN order_Date = DATE_ADD(CURDATE(), INTERVAL -1 DAY) AND customer_order_rank = 1 THEN 1 END), 0) AS yday_new_users,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURRENT_DATE() - INTERVAL 1 MONTH, '%Y-%m-01') AND DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY), INTERVAL -1 MONTH) AND customer_order_rank = 1 THEN 1 END), 0) AS lmtd_new_users,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE() AND customer_order_rank = 1 THEN 1 END), 0) AS mtd_new_users,
    COALESCE(SUM(CASE WHEN order_Date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') AND customer_order_rank = 1 THEN 1 END), 0) AS lm_new_users
FROM (
    SELECT 
        y.category,
        x.order_date,
        COUNT(DISTINCT order_id) AS orders,
        COUNT(DISTINCT customer_id) AS customers,
        SUM(selling_price) AS gmv,
        ROUND(SUM(selling_price) / 1.18, 0) AS revenue,
        RANK() OVER (PARTITION BY x.customer_id ORDER BY x.order_date) AS customer_order_rank
    FROM order_details_v1 x
    LEFT JOIN producthierarchy y ON x.product_id = y.product_id
    WHERE x.order_date >= DATE_ADD(CURDATE(), INTERVAL -365 DAY)
    GROUP BY 1, 2, x.customer_id
) x
GROUP BY 1;

![category](https://github.com/Suchi0506/SQL-project-on-Retail-Insights/assets/140787972/6c5f227f-cbfd-4c4a-a759-b33118f6d088)

Similar Queries were written for Product sub_category

