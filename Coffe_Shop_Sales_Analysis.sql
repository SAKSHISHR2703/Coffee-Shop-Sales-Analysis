-- We are creating a database named coffee_shop for the coffee shop sales analysis.
DROP DATABASE IF EXISTS coffee_shop;
CREATE DATABASE coffee_shop_db;      -- Database created

USE coffee_shop_db;    -- Working on our database after importing the data

SELECT * FROM coffee_shop;  -- To check that my data is transportes successfully

SELECT COUNT(*) FROM coffee_shop;  -- Counting the number of Rows in our data

DESCRIBE coffee_shop;  -- Checking if there are any null values or incorrect datatype

-- THERE ARE NULL VALUES AND INCORRECT DATATYPES NOW WE ARE PERFORMING DATA CLEANING

-- 1. Updating the datatype of transaction_date column to DATE 
SELECT * 
FROM coffee_shop;
UPDATE coffee_shop
SET transaction_date = STR_TO_DATE(transaction_date,'%m/%d/%Y')
WHERE transaction_date IS NOT NULL;  -- There are null values so we are using where clause.

ALTER TABLE coffee_shop
MODIFY COLUMN 
transaction_date DATE;

DESCRIBE coffee_shop;

SET sql_safe_updates = 0;  -- TURNING OFF THE SAFE MODE SO THAT WE CAN PERFORM DATA CLEANING

-- 2. Updating the datatype of transaction_time column to TIME
SELECT * 
FROM coffee_shop;
UPDATE coffee_shop
SET transaction_time = STR_TO_DATE(transaction_time,'%H:%i:%s')
WHERE 
transaction_date IS NOT NULL; 

ALTER TABLE coffee_shop
MODIFY COLUMN 
transaction_time TIME;

DESCRIBE coffee_shop;

-- 3. Changing the transaction_id column to INTEGER as transaction_id

SELECT * FROM coffee_shop;

ALTER TABLE coffee_shop 
CHANGE COLUMN ï»¿transaction_id transaction_id INT;

DESCRIBE coffee_shop;

-- TOTAL SALES ANALYSIS

SELECT * FROM coffee_shop;

-- 1. Calculating Total Sales for each month

SELECT
CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1) ,'K') as Total_Sales
FROM coffee_shop
WHERE 
     MONTH(transaction_date) = 3; 
-- This is for the month March, we can change the number 3 to any month number like if we put 1 we'll get sales for JANUARY 

-- Calculating the difference in sales btw the selected month and previous month and month on month increase or decrease in sales

/* For finding the total sales difference what we are doing is Substacting the
   sum of Selected Month(SM) and sum of Previous Month(PM)....and dividing it by the sum of Previous Month
   and multiplying it with 100 to get the Percentage.
          SUM(SM) - SUM(PM)/ SUM(PM) * 100 
   So here we used some advanced windows function LAG() and OVER() */
   
   SELECT 
      MONTH(transaction_date) as Month, -- Number of Month
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1) ,'K') as Total_Sales, -- Total sales 
      SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty),1) -- Months sales difference
	  OVER(ORDER BY MONTH(transaction_date))/ LAG(SUM(unit_price * transaction_qty),1) -- Dividing by previous month
      OVER(ORDER BY MONTH(transaction_date)) * 100 as mom_increase_percentage -- Percentage
FROM 
     coffee_shop
WHERE 
      MONTH(transaction_date) IN (2,3) -- For months of February(PM) and March(SM)
GROUP BY 
	  MONTH(transaction_date)
ORDER BY 
      MONTH(transaction_date);
      
-- TOTAL ORDERS ANALYSIS

SELECT * FROM coffee_shop;

-- 1. Calculating the total number of orders for each month
SELECT 
COUNT(transaction_id) as Total_Orders
FROM 
    coffee_shop
WHERE 
    MONTH(transaction_date) = 3; -- For March

-- 2. Calculating the difference in orders and month on month increase or decrease in orders

/* For finding the total order difference what we are doing is Substacting the
   count of Selected Month(SM) and count of Previous Month(PM)....and dividing it by the count of Previous Month
   and multiplying it with 100 to get the Percentage.
          COUNT(SM) - COUNT(PM)/ COUNT(PM) * 100 
 */
   SELECT 
      MONTH(transaction_date) as Month, -- Number of Month
      ROUND(COUNT(transaction_id)) as Total_Orders, -- Total Orders
      COUNT(transaction_id) - LAG(COUNT(transaction_id),1) -- Months Order difference
      OVER(ORDER BY MONTH(transaction_date))/ LAG(COUNT(transaction_id),1) -- Dividing by previous month
      OVER(ORDER BY MONTH(transaction_date)) * 100 as mom_increase_percentage -- Percentage
FROM 
    coffee_shop
WHERE 
      MONTH(transaction_date) IN (2,3) -- For months of February(PM) and March(SM)
GROUP BY 
	  MONTH(transaction_date)
ORDER BY 
      MONTH(transaction_date);

-- TOTAL QUANTITY SOLD ANALYSIS

SELECT * FROM coffee_shop;

-- 1. Calculating Total Sales for each month

SELECT 
      CONCAT(ROUND(SUM(transaction_qty)/1000,1), 'K') as Total_Sales
FROM 
     coffee_shop
WHERE 
     MONTH(transaction_date) = 3; 

-- 2. Calculating the difference in total quantity sold and month on month increase or decrease in total quantity sold

/* For finding the total quantity sold difference what we are doing is Substacting the
   sum of Selected Month(SM) and sum of Previous Month(PM)....and dividing it by the count of Previous Month
   and multiplying it with 100 to get the Percentage.
          SUM(SM) - SUM(PM)/ SUM(PM) * 100 
 */


 SELECT
       MONTH(transaction_date) as Month,
       ROUND(SUM(transaction_qty)) as Total_quantity_sold,
       SUM(transaction_qty) - LAG(SUM(transaction_qty),1)
       OVER(ORDER BY MONTH(transaction_date))/ LAG(SUM(transaction_qty),1) 
       OVER(ORDER BY MONTH(transaction_date)) * 100 as mom_percentage_increase
FROM 
     coffee_shop
WHERE
     MONTH(transaction_date) IN (2,3)
GROUP BY 
     MONTH(transaction_date)
ORDER BY 
	 MONTH(transaction_date);
     
-- SUMMARIZED MATIX OF SALES,ORDER AND QUANTITY
     
SELECT * FROM coffee_shop;


SELECT                  -- we have used the concat and round to round off the values upto 1 decimal point and get in a manner like 5.6K
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1) ,'K') as Total_Sales,
      CONCAT(ROUND(SUM(transaction_qty)/1000,1),'K') as Total_quantity_sold,
      CONCAT(ROUND(COUNT(transaction_id)/1000,1),'K') as Total_Orders
FROM 
      coffee_shop
WHERE 
      transaction_date = '2023-05-18';

-- SALES ANALYSIS BY WEEKENDS AND WEEKDAYS

-- Weekends- Sun,Sat
-- Weekdays- Mon to Fri


SELECT    -- Sun = 1,Mon=2....Sat=7  that's why we have mentioned 1,7 because it's weekend Sun and Sat
      CASE 
           WHEN DAYOFWEEK(transaction_date) IN (1,7) 
           THEN 'Weekends'
           ELSE 'Weekdays' END AS day_type,
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1) ,'K') as Total_Sales
FROM 
     coffee_shop
WHERE 
     MONTH(transaction_date) = 3  -- March month
GROUP BY 
      day_type;

-- SALES ANALYSIS BY STORE LOCATION

SELECT * FROM coffee_shop;

SELECT 
      store_location,
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2) ,'K') as Total_Sales
FROM 
     coffee_shop
WHERE 
     MONTH(transaction_date) = 3 -- March month
GROUP BY 
       store_location
ORDER BY 
       Total_Sales DESC;

-- DAILY SALES ANALYSIS WITH AVERAGE LINE

-- 1. Average sales revenue

SELECT
      CONCAT(ROUND(AVG(Total_Sales)/1000,2),'K') as Avg_Sales
FROM
	(SELECT 
           SUM(unit_price * transaction_qty) as Total_Sales
     FROM 
         coffee_shop
     WHERE 
          MONTH(transaction_date) = 3
     GROUP BY 
          transaction_date
) as Inner_query;

-- 2. Daily sales revenue

SELECT 
      DAY(transaction_date) as Day_of_month,
      SUM(unit_price * transaction_qty) as Total_Sales
FROM 
     coffee_shop
WHERE 
    MONTH(transaction_date) = 3
GROUP BY 
       Day_of_month
ORDER BY 
       Day_of_month ASC;

-- 3. Daily Sales analysis with average line
 
SELECT 
Day_of_month,  -- CASE is used to get the above or below avg sales per day
CASE 
     WHEN Total_Sales > Avg_Sales 
     THEN 'Above average'
     WHEN Total_Sales < Avg_Sales 
     THEN 'Below average'
     ELSE 'Average'
END AS sales_status, Total_Sales
FROM 
    (SELECT 
           DAY(transaction_date) as Day_of_month,
           SUM(unit_price * transaction_qty) as Total_Sales,
           AVG(SUM(unit_price * transaction_qty)) OVER() AS Avg_Sales
     FROM 
		 coffee_shop
     WHERE 
         MONTH(transaction_date) = 3 -- March month
     GROUP BY 
          DAY(transaction_date)) AS Sales_data
      ORDER BY 
            Day_of_month;

-- SALES ANALYSIS WITH PRODUCT CATEGORY

SELECT * FROM coffee_shop;

SELECT 
      product_category,
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2) ,'K') as Total_Sales
FROM 
     coffee_shop
WHERE 
     MONTH(transaction_date) = 3 -- March month
GROUP BY 
     product_category
ORDER BY 
      Total_Sales DESC;

-- TOP 10 PRODUCTS BY SALES

SELECT 
      product_type,
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2) ,'K') as Total_Sales
FROM 
	coffee_shop
WHERE 
     MONTH(transaction_date) = 3 AND product_category = 'Coffee'  -- March month
GROUP BY 
     product_type
ORDER BY 
      Total_Sales DESC LIMIT 10;

-- SALES ANALYSIS BY DAYS AND HOURS

SELECT * FROM coffee_shop;

SELECT 
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2) ,'K') as Total_Sales,
      SUM(transaction_qty) AS Total_quantity_sold,
      COUNT(*)
FROM 
      coffee_shop
WHERE 
      MONTH(transaction_date) = 3
      AND DAYOFWEEK(transaction_date) = 2
      AND HOUR(transaction_time) = 8;

-- 1. To get sales for all hours of the month March

SELECT 
      HOUR(transaction_time),
      CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2) ,'K') as Total_Sales
FROM 
      coffee_shop
WHERE 
      MONTH(transaction_date) = 3
GROUP BY 
      HOUR(transaction_time)
ORDER BY 
      HOUR(transaction_time);

-- 2. To get the sales from Mon to Sun of the month March

SELECT
      CASE 
          WHEN DAYOFWEEK(transaction_date) = 2 
          THEN 'Monday'
          WHEN DAYOFWEEK(transaction_date) = 3 
          THEN 'Tuesday'
          WHEN DAYOFWEEK(transaction_date) = 4 
          THEN 'Wednesday'
          WHEN DAYOFWEEK(transaction_date) = 5 
          THEN 'Thursday'
          WHEN DAYOFWEEK(transaction_date) = 6 
          THEN 'Friday'
          WHEN DAYOFWEEK(transaction_date) = 7 
          THEN 'Saturday'
       ELSE 'Sunday'
       END AS Day_of_week,
     CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2) ,'K') as Total_Sales
FROM 
     coffee_shop
WHERE 
     MONTH(transaction_date) = 3
GROUP BY 
      Day_of_week;




















































     
       







