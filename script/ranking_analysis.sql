--6)Ranking
--rank using diension by measure 

--we will use top , rank,dense_rank, row_number

--which are 5 products	generate highest revenue?

select top 5
p.product_name, sum(s.sales_amount) as revenue
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by p.product_name
order by 2 desc

--like this we can solve all these using window funcion 

select * from ( --used subquery here to get only top 5  after performing the below query
select
p.product_name, sum(s.sales_amount) as revenue,
row_number() over (order by sum(s.sales_amount )desc) as rank_products
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by p.product_name )t
where rank_products <=5

---what are the 5 worst performing products in terms of sales?

select top 5
p.product_name, sum(s.sales_amount) as revenue
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by p.product_name
order by 2 


--like this check top 5 best sub category 

select top 5
p.subcategory, sum(s.sales_amount) as revenue
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by p.subcategory
order by 2 desc


--check bottom 5 best sub category 

select top 5
p.subcategory, sum(s.sales_amount) as revenue
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by p.subcategory
order by 2 



--find the top10 customers who have genrated the highest revenue
with t1  as
(
SELECT 
    s.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS total_revenue,
	dense_rank () over (order by  SUM(s.sales_amount)desc) as rank_customer
FROM 
    gold.fact_sales s
JOIN 
    gold.dim_customers c ON s.customer_key = c.customer_key
GROUP BY 
    s.customer_key,
    c.first_name,
    c.last_name
--ORDER BY 
  --  total_revenue DESC -- u cant use order by withing cte u have to use it in outer cte
) 

select *
from t1
where rank_customer <=10

-- 3 customers with fewest orders placed

SELECT  top 3 
    s.customer_key,
    c.first_name,
    c.last_name,
    count (distinct order_number) AS total_order_number
	--dense_rank () over (order by count(distinct order_number)) as rank_customer
FROM 
    gold.fact_sales s
JOIN 
    gold.dim_customers c ON s.customer_key = c.customer_key
GROUP BY 
    s.customer_key,
    c.first_name,
    c.last_name
ORDER BY 
  total_order_number 
