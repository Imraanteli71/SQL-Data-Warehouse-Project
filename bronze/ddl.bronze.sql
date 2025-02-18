/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

--DDL(data definition language) Function- Bronze layer

--step 1 to load the schema or build a table based on their columns
IF OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL
DROP TABLE bronze.crm_cust_info
create  table bronze.crm_cust_info (
	cst_id INT,
	cst_key INT,
	cst_firstname NVARCHAR(50), 
	cst_lastname NVARCHAR(50),	
	cst_marital_status	NVARCHAR(50),
	cst_gndr	NVARCHAR(50),
	cst_create_date DATE 
)
ALTER table bronze.crm_cust_info 
ALTER COLUMN cst_key NVARCHAR(50)

IF OBJECT_ID ('bronze.crm_prd_info','U') IS NOT NULL
DROP TABLE bronze.crm_prd_info

create table bronze.crm_prd_info (
	prd_id INT,
	prd_key INT,
	prd_nm NVARCHAR (50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE

)
ALTER table bronze.crm_prd_info 
ALTER COLUMN prd_key NVARCHAR(50)

IF OBJECT_ID ('bronze.crm_sales_details','U') IS NOT NULL
DROP TABLE bronze.crm_sales_details

create table bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
)

IF OBJECT_ID ('bronze.erp_cust_az12','U') IS NOT NULL
DROP TABLE bronze.erp_cust_az12
create table bronze.erp_cust_az12 (
	CID NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(20)
)

IF OBJECT_ID ('bronze.erp_loc_a101','U') IS NOT NULL
DROP TABLE bronze.erp_loc_a101
create table bronze.erp_loc_a101 (
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
)

IF OBJECT_ID ('bronze.erp_px_cat_g1v2','U') IS NOT NULL
DROP TABLE bronze.erp_px_cat_g1v2
create table bronze.erp_px_cat_g1v2 (
	ID NVARCHAR (50),
	CAT NVARCHAR(50),
	SUBCAT 	NVARCHAR(50),
	MAINTENANCE NVARCHAR(10)
)


--step 2 here when table or schema is done now we have to load using the below bulk inster method 
--Bulk insert if data to the tables

--step 3 its store procedure this comes after finishing the below bulk insert in the table 
--we have to refresh this script so for that we will use stored procedure 

--step 4 we used try and catch for error handling
--step 5 used start time and end timer to check the duration of loading and now we have calculated the whole bunch duration 

create or alter procedure bronze.load_bronze as  
begin ---this is where it starts the STORE PROCEDURE PROCESS
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime,@batch_end_time datetime
	begin try --its used for checking for an error or error handling  in the code
		print '=============================================='
		print 'Loading the Bronze layer'
		print '=============================================='

		print '----------------------------------------------'
		print 'Loading CRM Tables '
		print '----------------------------------------------'

		set @batch_start_time= GETDATE() -----batch strat and end is to check duration of whole insert opertation
		set @start_time =GETDATE(); 
		print '>>Truncating table :bronze.crm_cust_info '
		truncate table bronze.crm_cust_info --its for avoiding duplication of tables 

		print '>>Inserting table :bronze.crm_cust_info '
		BULK INSERT bronze.crm_cust_info
		from 'C:\Users\imraa\Desktop\interview prep\NEw Project BARAA\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			firstrow =2,--this is to determine the values of the column start frrom 2nd row as 1st row is header
			fieldterminator =',', --this is to tell sql the delimiter or separator used in csv
			tablock --this will lock the tabe while loading its optional to use though
		)
		set @end_time = getdate();
		print '>> load duration ' +cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds'
		print '---------------'
		set @start_time =GETDATE(); 
		print '>>Truncating table :bronze.crm_prd_info '
		truncate table bronze.crm_prd_info --its for avoiding duplication of tables 

		print '>>Inserting table :bronze.crm_prd_info '
		BULK INSERT bronze.crm_prd_info
		from 'C:\Users\imraa\Desktop\interview prep\NEw Project BARAA\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			firstrow =2,
			fieldterminator =',',
			tablock
		)

		set @end_time = getdate();
		print '>> load duration ' +cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds'
		print '---------------'

		set @start_time =GETDATE(); 
		print '>>Truncating table :bronze.crm_sales_details '
		truncate table bronze.crm_sales_details --its for avoiding duplication of tables 

		print '>>Inserting table :bronze.crm_sales_details '
		BULK INSERT bronze.crm_sales_details
		from 'C:\Users\imraa\Desktop\interview prep\NEw Project BARAA\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			firstrow =2,
			fieldterminator =',',
			tablock
		)

		set @end_time = getdate();
		print '>> load duration ' +cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds'
		print '----------------------------------------------'
		print 'Loading ERP Tables '
		print '----------------------------------------------'
		set @start_time = getdate()
		print '>>Truncating table :bronze.erp_cust_az12 '
		truncate table  bronze.erp_cust_az12;

		print '>>inserting table :bronze.erp_cust_az12 '
		BULK INSERT bronze.erp_cust_az12
		from 'C:\Users\imraa\Desktop\interview prep\NEw Project BARAA\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with
		(
			firstrow =2,
			fieldterminator =',',
			tablock
		)
		set @end_time = getdate();
		print '>> load duration ' +cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds'

		set @start_time =GETDATE(); 
		print '>>Truncating table :bronze.erp_loc_a101 '
		truncate table bronze.erp_loc_a101

		print '>>Inseritng table :bronze.erp_loc_a101 '
		BULK INSERT bronze.erp_loc_a101
		from 'C:\Users\imraa\Desktop\interview prep\NEw Project BARAA\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with 
		(
			firstrow = 2,
			fieldterminator =',',
			tablock
		)
		set @end_time = getdate();
		print '>> load duration ' +cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds'

		set @start_time =GETDATE(); 
		print '>>Truncating table :bronze.erp_px_cat_g1v2 '
		truncate table bronze.erp_px_cat_g1v2

		print '>>Inserting table :bronze.erp_px_cat_g1v2 '
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\imraa\Desktop\interview prep\NEw Project BARAA\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		with 
		(
			firstrow =2 ,
			fieldterminator =',',
			tablock

		)
		set @end_time = getdate();
		print '>> load duration ' +cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds'
		print '----------------'
		set @batch_end_time =GETDATE()
		print '>>total duration'+cast(datediff (second,@batch_start_time,@batch_end_time) as nvarchar) + ' seconds' 

		end try 
	begin catch --sql runs try block and if its fail it runs catch block to handle the error
		print '==========================================='
		print 'Error Occured during loading bronze layer '
		print 'error message' + error_message ();
		print 'error message' + cast(error_number() as nvarchar);
		print 'error message' + cast(error_state() as nvarchar);
		print '==========================================='


	end catch 


end --this is where the store procedure ends its operation 

 exec bronze.load_bronze
