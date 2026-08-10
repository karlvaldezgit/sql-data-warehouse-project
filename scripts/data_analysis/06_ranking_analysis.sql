-- Which 5 products generate the highest revenue?
SELECT
f.product_key,
p.product_name,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY 1,2
ORDER BY total_sales DESC
LIMIT 5;


-- What are the 5 worst-performing products in terms of sales?
SELECT
f.product_key,
p.product_name,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY 1,2
ORDER BY total_sales
LIMIT 5;


-- Ranking the products.
SELECT
f.product_key,
p.product_name,
SUM(sales_amount) AS total_sales,
ROW_NUMBER () OVER (ORDER BY SUM(sales_amount) DESC) AS rank_products
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY 1,2;
