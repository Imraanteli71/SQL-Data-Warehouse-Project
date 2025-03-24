--5)Magnitude analysis

--we will compare MEASURES WITH DIMENSIONS 

--explanation what is  cardinality(unique value) -- low cardinality is like gender,country,category and high cardinality is product,address,customer etc
-- find the customers by countries
select country, count(customer_key) as total_customer from gold.dim_customers
group by country
order by 2 desc

-- find the customers by gender
select gender, count(customer_key) as total_customer from gold.dim_customers
group by gender


-- find the total products by category 
select category ,count(product_key) as total_products
from gold.dim_products
group by category
order by 2 desc

--what is the avg cost in each category
select category ,avg(cost) as avg_cost
from gold.dim_products
group by category
order by 2 desc

--what is the total revenue	genrated for the each category?
select p.category, sum(s.sales_amount) as revenue
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by p.category
order by 2 desc


--find total revenue is genrated by each customer 
SELECT 
    s.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS total_revenue
FROM 
    gold.fact_sales s
JOIN 
    gold.dim_customers c ON s.customer_key = c.customer_key
GROUP BY 
    s.customer_key,
    c.first_name,
    c.last_name
ORDER BY 
    total_revenue DESC;  -- Ordering by total_revenue in descending order



--what is the distribution of sold items across countries
SELECT 
	country,
	sum (s.quantity) as total_sold_items  
FROM 
    gold.fact_sales s
JOIN 
    gold.dim_customers c ON s.customer_key = c.customer_key
GROUP BY 
    country
ORDER BY 
    total_sold_items DESC;


