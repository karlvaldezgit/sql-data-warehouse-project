/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/



-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

DROP VIEW IF EXISTS gold.dim_customers;
CREATE VIEW gold.dim_customers AS 
SELECT
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
cxi.cst_id AS customer_id,
cxi.cst_key AS customer_number,
cxi.cst_firstname AS first_name,
cxi.cst_lastname AS last_name,
loc.cntry AS country,
cxi.cst_marital_status AS marital_status,
CASE
	WHEN cxi.cst_gndr != 'n/a' THEN cxi.cst_gndr
	ELSE COALESCE(cxa.gen, 'n/a')
END AS gender,
cxa.bdate AS birthdate,
cxi.cst_create_date AS create_date
FROM silver.crm_cust_info AS cxi
LEFT JOIN silver.erp_cust_az12 AS cxa
ON cxi.cst_key = cxa.cid
LEFT JOIN silver.erp_loc_a101 AS loc
ON cxi.cst_key = loc.cid;


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

DROP VIEW IF EXISTS gold.dim_products;
CREATE VIEW gold.dim_products AS
SELECT
ROW_NUMBER() OVER (ORDER BY prd_start_dt, cpi.prd_key) AS product_key,
cpi.prd_id AS product_id,
cpi.prd_key AS product_number,
cpi.prd_nm AS product_name,
cpi.cat_id AS category_id,
epc.cat AS category,
epc.subcat AS subcategory,
epc.maintenance,
cpi.prd_cost AS product_cost,
cpi.prd_line AS product_line,
cpi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cpi
LEFT JOIN silver.erp_px_cat_g1v2 AS epc
ON cat_id = id
WHERE prd_end_dt IS NULL;


-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================

DROP VIEW IF EXISTS gold.fact_sales;
CREATE VIEW gold.fact_sales AS
SELECT
ssd.sls_ord_num AS order_number,
gdp.product_key,
gdc.customer_key,
ssd.sls_order_dt AS order_date,
ssd.sls_ship_dt AS shipping_date,
ssd.sls_due_dt AS due_date,
ssd.sls_sales AS sales_amount,
ssd.sls_quantity AS quantity,
ssd.sls_price AS price
FROM silver.crm_sales_details AS ssd
LEFT JOIN gold.dim_products AS gdp
ON sls_prd_key = product_number
LEFT JOIN gold.dim_customers AS gdc
ON sls_cust_id = gdc.customer_id;
