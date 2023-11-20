#Yday_Orders:
SELECT P.category, COUNT(order_id) FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY
GROUP BY P.category;

SELECT P.sub_category, COUNT(order_id) FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY
GROUP BY P.sub_category;

#Yday_GMV:
SELECT P.category, SUM(O.selling_price) AS Yday_GMV
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY 
GROUP BY P.category;

SELECT P.sub_category, SUM(O.selling_price) AS Yday_GMV
FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY 
GROUP BY P.sub_category;

#Yday_Unique_Users:
SELECT P.category, COUNT(DISTINCT O.customer_id) AS Yday_Unique_Users FROM order_details_v1 AS O
JOIN producthierarchy AS P ON O.product_id = P.product_id
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY
GROUP BY P.category;

SELECT P.sub_category, COUNT(DISTINCT O.customer_id) AS Yday_Unique_Users
FROM order_details_v1 AS O
WHERE O.order_date= CURDATE() - INTERVAL 1 DAY
GROUP BY P.sub_category;

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
SELECT R.category, COUNT(DISTINCT R.customer_id) AS MTD_New_Users
FROM (
    SELECT O.customer_id,
	RANK() OVER (PARTITION BY O.customer_id ORDER BY O.order_date) AS customer_order_rank, P.category
    FROM order_details_v1 AS O
    JOIN producthierarchy P ON O.product_id = P.product_id
    WHERE DATE(O.order_date) BETWEEN DATE_FORMAT(CURDATE(), "%Y-%m-01") AND CURDATE()
) AS R
WHERE customer_order_rank = 1
GROUP BY R.category;


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
SELECT R.category, COUNT(DISTINCT R.customer_id) AS LMTD_New_Users
FROM (
    SELECT O.customer_id,
	RANK() OVER (PARTITION BY O.customer_id ORDER BY O.order_date) AS customer_order_rank, P.category
    FROM order_details_v1 AS O
    JOIN producthierarchy P ON O.product_id = P.product_id
    WHERE o.order_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') AND o.order_date <= CURDATE()
) AS R
WHERE customer_order_rank = 1
GROUP BY R.category;


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






