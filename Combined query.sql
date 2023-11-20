SELECT 
    category,
    COALESCE(SUM(CASE WHEN order_Date = DATE_ADD(CURDATE(), INTERVAL -1 DAY) THEN orders END), 0) AS yday_orders,
    COALESCE(SUM(CASE WHEN order_Date BETWEEN DATE_FORMAT(CURRENT_DATE() - INTERVAL 1 MONTH, '%Y-%m-01') AND DATE_ADD(DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY), INTERVAL -1 MONTH) THEN orders END), 0) AS lmtd_orders,
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

