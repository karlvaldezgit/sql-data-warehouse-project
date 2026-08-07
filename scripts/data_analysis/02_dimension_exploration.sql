-- Explore all countries our customers comes from.
SELECT DISTINCT(country)
FROM gold.dim_customers;

-- Explore all categories 'The Major Divisions'
SELECT DISTINCT(category), subcategory
FROM gold.dim_products
ORDER BY category;
