/*
==============================
Product Report
==============================
Purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product names, category, subcategory and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
	- total orders
	- total sales
	- total quantity sold
	- total customers (unique)
	- lifespan (in months)
4. Calculates valuable KPIs:
	- recency (months since last sale)
	- average order revenue (AOR)
	- average monthly revenue
==============================
*/

CREATE VIEW gold.report_products AS
WITH base_query AS(
/* --------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products.
-----------------------------------------------------------------------*/
SELECT
f.order_number,
f.order_date,
f.product_key,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_name,
p.category,
p.subcategory,
p.product_cost
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL ----- only consider valid dates
),
/*
------------------------------------------------------------
Product Aggregations: Summarizes key metrics at product level.
------------------------------------------------------------
*/
product_aggregations AS(
SELECT
product_key,
product_name,
category,
subcategory, 
product_cost,
(MAX(order_date) - MIN(order_date))/30 AS lifespan,
MAX(order_date) AS last_sale_date,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_sold,
SUM(sales_amount)/SUM(quantity) AS avg_selling_price
FROM base_query
GROUP BY 
product_key,
product_name,
category,
subcategory,
product_cost
)
/*
------------------------------------------------------------
Final Query: Combines all product results into one output.
------------------------------------------------------------
*/
SELECT 
product_key,
product_name,
category,
subcategory,
product_cost,
last_sale_date,
EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date))*12 AS recency,
CASE 
	WHEN total_sales > 50000 THEN 'High-Performers'
	WHEN total_sales >= 10000 THEN 'Mid-Range'
	ELSE 'Low-Performers'
END AS product_tier,
lifespan,
total_orders,
total_sold,
total_customers,
avg_selling_price,
CASE
	WHEN total_orders = 0 THEN total_sales
	ELSE total_sales / total_orders
END AS avg_order_revenue, ----- Average Order Revenue (AOR)
CASE
	WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan ------ Average Monthly Revenue
END AS avg_monthly_revenue
FROM product_aggregations;
