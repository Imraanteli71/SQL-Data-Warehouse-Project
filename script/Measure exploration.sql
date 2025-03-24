--4) Measures exploration

--we will use sum,count,avg etc aggreate functions

--its basically spoting a light on big numbers 

--find the total sales
select sum (sales_amount) as total_sales from gold.fact_sales

--find how many items are sold
select sum (quantity) as total_sold_items from gold.fact_sales


--find the avg  selling price
select avg (price) as total_sales from gold.fact_sales

-- find the total number of orders
select count (distinct order_number) as total_orders from gold.fact_sales


--find the total number of products 
select count(product_key) as total_products from gold.dim_products


--find the total number of customers
select count(customer_key) as total_customer from gold.dim_customers


--find the total number of customers that has placed orders
select count(distinct customer_key) as total_customer from gold.fact_sales

--now we will build a report that shows all the metrics of the business

select 'Total Sales' as measure_name ,sum (sales_amount) as measure_value  from gold.fact_sales
union all 
select  'Total_items' as measure_name , sum (quantity) as measure_value  from gold.fact_sales
union all	
select 'Avg Price' as measure_name, avg (price) as measure_value from gold.fact_sales
union all
select  'total_orders' as measure_name, count (distinct order_number) as measure_value from gold.fact_sales
union all
select  'total_products' as measure_name, count(product_key) as measure_value from gold.dim_products
union all
select  'total_customers' as measure_name, count(customer_key) as measure_value  from gold.dim_customers
union all
select  'total_active_customers' as measure_name, count(distinct customer_key) as measure_value  from gold.fact_sales
