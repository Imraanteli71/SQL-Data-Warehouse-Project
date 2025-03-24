--2)cumulative Anlysis

--aggergating data progressively over time
--we mostly used window function here

--calculate the total sales per month 
--and the running total of sales over time

select order_date,total_sales,
sum (total_sales) over (order by order_date) as running_total,
avg (avg_sales_amount) over (order by order_date) as avg_running_total
from 
(
select datetrunc(month,order_date) order_date,
sum(sales_amount) as total_sales,
avg(sales_amount) as avg_sales_amount
from gold.fact_sales
where order_date is not null
group by datetrunc(month,order_date)
) t1