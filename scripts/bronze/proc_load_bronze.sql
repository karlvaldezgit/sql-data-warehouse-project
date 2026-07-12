/* 
===========================================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===========================================================================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Manually load data from csv files to bronze tables.
===========================================================================================================
*/


--Deleting all table rows if exists before importing. Do this with all other files.
TRUNCATE TABLE bronze.crm_cust_info;

CSV files were imported using pgAdmin:
1. Right-click the table
2. Select Import/Export Data
3. Choose the CSV file
4. Set Format = CSV
5. Set Header = Yes
6. Click Import

-- If encounters importing errors. Alter columns to text.
ALTER TABLE bronze.crm_sales_details
ALTER COLUMN sls_order_dt TYPE TEXT,
ALTER COLUMN sls_ship_dt TYPE TEXT,
ALTER COLUMN sls_due_dt TYPE TEXT;
