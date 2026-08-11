-- Analyze the yearly performance of products by comparing their sales to both the average sales performance of the product and the pevious year's sales.

WITH yearly_product_sales AS (
SELECT
EXTRACT(YEAR FROM f.order_date) AS order_year,
p.product_name,
SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY 1,2
)
SELECT order_year, product_name, total_sales,
AVG(total_sales) OVER (PARTITION BY product_name):: int AS avg_sales,
(total_sales - AVG(total_sales) OVER (PARTITION BY product_name):: int) AS diff_avg,
CASE 
	WHEN (total_sales - AVG(total_sales) OVER (PARTITION BY product_name):: int) > 0 THEN 'Above Average'
	WHEN (total_sales - AVG(total_sales) OVER (PARTITION BY product_name):: int) < 0 THEN 'Below Average'
	ELSE 'Average'
END AS avg_change,
LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
(total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year)) AS diff_py,
CASE 
	WHEN (total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year)) > 0 THEN 'Increase'
	WHEN (total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year)) < 0 THEN 'Decrease'
	ELSE 'No Change'
END AS py_change
FROM yearly_product_sales
ORDER BY 2,1
