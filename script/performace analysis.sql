--performance analaysis
--its comparing ccurrent value to target value
--it helps measure success and compare performance

--analyse the yearly performance of product by comparing their sales to both the avg sales
--performance of the product and the previous years sales
with t1 as(
select 
year(s.order_date) as order_year,
p.product_name,
sum (s.sales_amount) as current_sales
from gold.fact_sales as s
join gold.dim_products as p
on s.product_key =p.product_key
where order_date is not null
group by year(s.order_date) ,p.product_name
	
)
select *,
avg (current_sales) over (partition by product_name  ) avg_sale,
current_sales -avg (current_sales) over (partition by product_name  ) as diff_avg,
case when current_sales -avg (current_sales) over (partition by product_name  ) > 0 then 'Above avg'
	when current_sales -avg (current_sales) over (partition by product_name  )< 0 then 'below avg'
	else 'Avg'
end avg_change,
lag (current_sales) over (partition by product_name order by order_year) as previous_yr,

current_sales -lag (current_sales) over (partition by product_name order by order_year) as py_avg,

case when current_sales -lag (current_sales) over (partition by product_name order by order_year) > 0 then 'increase'
	when current_sales -lag (current_sales) over (partition by product_name order by order_year)< 0 then 'decrease'
	else 'No change'
end py_change
from t1
order by product_name,order_year
