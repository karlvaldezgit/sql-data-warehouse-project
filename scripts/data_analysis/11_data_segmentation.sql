-- Segment products into cost ranges and count how many products fall into each segment
WITH product_segments AS (
SELECT
product_key,
product_name,
product_cost,
CASE
	WHEN product_cost < 100 THEN 'Below 100'
	WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'Above 1000'
END AS cost_range
FROM gold.dim_products
)

SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range;

/* Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than 5,000.
	- Regular: Customers with at least 12 months of history but spending 5,000 or less.
	- New: Customers with a life span less than 12 months.
And find the total number of customers by each group.
*/
WITH customer_spending AS (
SELECT 
customer_key,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
(MAX(order_date) - MIN(order_date))/30 AS lifespan,
SUM(sales_amount) AS total_spending
FROM gold.fact_sales
GROUP BY customer_key
)

SELECT 
customer_tier, 
COUNT(*)
FROM 
	(SELECT
	customer_key,
	total_spending,
	lifespan,
	CASE 
		WHEN lifespan >= 12 AND total_spending >= 5000 THEN 'VIP'
		WHEN lifespan >=12  AND total_spending < 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_tier
	FROM customer_spending)
GROUP BY customer_tier;
