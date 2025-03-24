--3) Date Eploration
--identify ealriest and oldest dates 
--understand scope of the data and timespan		

--find the date of the first and last date
--now to get the difference between this date we use datediff
--how many years of sales availble
SELECT 
    MIN(order_date) AS MinOrderDate,
    MAX(order_date) AS MaxOrderDate,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS OrderRangeMonths,
	 DATEDIFF(year, MIN(order_date), MAX(order_date)) AS OrderRangeyears
FROM 
    gold.fact_sales;

--find the youngets and oldest customers
select max (birthdate) as youngest,
min (birthdate) as oldest,
DATEDIFF(year,MIN(birthdate),getdate()) as oldest_age--getdate() it is to get current date
from gold.dim_customers