--Data Segmentation
--here we will use measures by measures and then will combine them and convert them itno new category
--for this we normally use case when statements

--segment products into cost ranges and count how many products fall into each segment
with product_segments as(
select 
p.product_key ,
product_name,
cost,
case when cost < 100 then 'below 100'
	when cost between 100 and 500 then '100-500'
	when cost between 500 and 1000 then '500-1000'
	else 'above 1000'
end cost_range 
from gold.fact_sales s
join gold.dim_products p
on s.product_key =p.product_key
)
select cost_range,
count(product_key) as total_products
from product_segments
group by cost_range
order by 2



--group customers into 3 segments based on their spending behaviour 
--VIP - at least spend 12 months history and spending more than 5000
--regular -at least spend 12 months history and spending less than 5000
--new - lifespan less than 12 month and find the total number of customers
-- Define customer segments based on spending and lifespan
WITH customer_segment AS (
    SELECT
        c.customer_key,
        MIN(s.order_date) AS first_order,
        MAX(s.order_date) AS last_order,
        SUM(s.sales_amount) AS total_spending,
        DATEDIFF(month, MIN(s.order_date), MAX(s.order_date)) AS lifespan
    FROM
        gold.fact_sales s
    JOIN
        gold.dim_customers c ON c.customer_key = s.customer_key
    GROUP BY
        c.customer_key
)

-- Categorize and count customers
SELECT
    category,
    COUNT(customer_key) AS total_customers
FROM
    (
        SELECT
            customer_key,
            total_spending,
            lifespan,
            CASE 
                WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
                WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
                ELSE 'New'
            END AS category
        FROM
            customer_segment
    ) AS categorized_customers
GROUP BY
    category

ORDER BY 
	total_customers desc






