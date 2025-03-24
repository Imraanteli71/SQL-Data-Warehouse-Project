--2)Dimension Exploration
--this are to explore unique category to look for such as country, category ,product 
--for this we will use DISTINCT function to check the granuality 

--explore the country from the customer came from 

select distinct country
from gold.dim_customers

--explore all the categories 
select distinct category
from gold.dim_products