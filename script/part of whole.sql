-- part of whole-proportional analysis
--here mostly asnwer related of getting percentage answers 
--which categories contribute the most to overall sales?

with category_sales as (
select p.category ,
sum (s.sales_amount) as total_sales
from gold.fact_sales s
join gold.dim_products p
on p.product_key = s.product_key
group by p.category 
)
select *,
sum (total_sales) over () overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / sum(total_sales) over ()) * 100, 2), '%') AS percl
from category_sales
order by percl desc