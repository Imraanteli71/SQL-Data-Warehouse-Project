-- now here we will do ADVANCE ANALYTICS 
--1) change over time 2)cumulative analysis 3)performance analysis 4)part to whole perportional
--5)data segmentation 6)reporting

1)--change over time 
--it is when we compare measure with date column to find analyse the trends over time

--analyse sales performce over time 

select 
year (order_date) as year_order_date,
month (order_date) as monthly_order_date,
sum (sales_amount) as sales_amount,
count (distinct customer_key) as total_customer,
sum (quantity) as total_qty
from gold.fact_sales
where year (order_date) is not null
group by year (order_date) ,month (order_date)
order by year (order_date),month (order_date)

--we can use the datetrunc function to formate the date specifically
select 
datetrunc (month,order_date) as monthly_order_date,

sum (sales_amount) as sales_amount,
count (distinct customer_key) as total_customer,
sum (quantity) as total_qty
from gold.fact_sales
where year (order_date) is not null
group by datetrunc (month,order_date)
order by datetrunc (month,order_date)

select 
datetrunc (year,order_date) as monthly_order_date,

sum (sales_amount) as sales_amount,
count (distinct customer_key) as total_customer,
sum (quantity) as total_qty
from gold.fact_sales
where year (order_date) is not null
group by datetrunc (year,order_date)
order by datetrunc (year,order_date)