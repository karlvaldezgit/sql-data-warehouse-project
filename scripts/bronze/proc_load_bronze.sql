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
