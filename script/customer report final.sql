/*Customer Report
===================================================
Purpose:
- This report consolidates key customer metrics and behaviors

Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last order)
   - average order value
   - average monthly spend
===================================================
*/

--1) base query to retrive customers details
create view gold.report_customer as  -- after all hte below steps this is going to be last step to setup this as view for further analysis or report building
with base_query as(

SELECT
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
	CONCAT (c.first_name,' ' ,c.last_name) as customer_name,
    c.birthdate,
	datediff(year,birthdate,getdate()) age
FROM
    gold.fact_sales f
LEFT JOIN
    gold.dim_customers c ON c.customer_key = f.customer_key
WHERE order_date is not null
)
--2) customer aggregation ; summerize key metrics at the customer level
,customer_aggregation as
(
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM
    base_query
GROUP BY
    customer_key,
    customer_number,
    customer_name,
    age
)
--3)
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    -- Age group segmentation
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    -- Customer segment based on spending and lifespan
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    -- Recency calculation (assumes GETDATE() is your current date function)
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    -- Average Order Value (AOV)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,
    -- Average Monthly Spend
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend
FROM
    customer_aggregation
