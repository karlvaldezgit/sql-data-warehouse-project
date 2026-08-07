-- Explore the boundaries of our dates.
SELECT 
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) AS order_range_years
FROM gold.fact_sales;

-- OR

SELECT 
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
(MAX(order_date) - MIN(order_date)) / 365 AS order_range_years
FROM gold.fact_sales;

-- Check for months

SELECT 
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
(MAX(order_date) - MIN(order_date)) / 30 AS order_range_month
FROM gold.fact_sales;


-- Find the youngest and oldest customer.
SELECT 
MIN(birthdate) AS oldest_customer,
((CURRENT_DATE - MIN(birthdate))/365) AS oldest_customer_age,
MAX(birthdate) AS youngest_customer,
((CURRENT_DATE - MAX(birthdate))/365) AS youngest_customer_age,
((MAX(birthdate) - MIN(birthdate)) / 365) AS customer_range
FROM gold.dim_customers;
