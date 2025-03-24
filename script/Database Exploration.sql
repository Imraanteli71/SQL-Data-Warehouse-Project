-- here we will do EDA -Exploratery DAta Analysis
--there are total 6 steps in which we will do this 
--1)Database exploration,2)Dimension Exploration 3) Date Exploration 4) Measures Exploration
--5) Magnitude 6) Ranking 

--1) Database Exploration
-- it is to see the basic structure of Db

--Explore ALl objects in the schemas

 SELECT * FROM INFORMATION_SCHEMA.TABLES

 --EXPLORE ALL COLUMNS IN THE DB
 SELECT * FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'dim_customers'