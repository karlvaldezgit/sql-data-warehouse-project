-- Find the yearly or monthly sales.
SELECT 
EXTRACT (YEAR FROM order_date) AS order_year,
EXTRACT (MONTH FROM order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1,2
ORDER BY 1,2;

-- OR

SELECT 
DATE_TRUNC('month', order_date)::DATE AS order_year,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1
