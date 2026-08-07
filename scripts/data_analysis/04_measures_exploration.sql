-- Find the total sales.
SELECT 
SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold.
SELECT 
SUM(quantity) AS total_items_sold
FROM gold.fact_sales;

-- Find the average selling price.
SELECT 
AVG(price) AS avg_price
FROM gold.fact_sales;

-- Find the total number of orders.
SELECT 
COUNT(DISTINCT order_number)AS total_orders
FROM gold.fact_sales;

-- Find the total number of products.
SELECT
COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products;

-- Find the total number of custmeors.
SELECT
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;

-- Find the total number of customer that has placed an order.
SELECT
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales;

-- Generate a report that shows all key metrics of the business.
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity Sold' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name, ROUND(AVG(price),0) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Num Orders' AS measure_name, COUNT(DISTINCT(order_number)) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Num Products' AS measure_name, COUNT(DISTINCT(product_name)) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Num Customers' AS measure_name, COUNT(DISTINCT(customer_key)) AS measure_value FROM gold.dim_customers;
