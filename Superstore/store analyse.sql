create database superstores;
use superstores;
select * from superstore;

DESCRIBE superstore;
ALTER TABLE superstore
ADD COLUMN Order_Date_Converted DATE,
ADD COLUMN Ship_Date_Converted DATE;

UPDATE superstore
SET 
    Order_Date_Converted = STR_TO_DATE(Order_Date, '%d-%b-%y'),
    Ship_Date_Converted = STR_TO_DATE(Ship_Date, '%d-%b-%y');

SELECT Order_ID, Order_Date, Order_Date_Converted, Ship_Date, Ship_Date_Converted
FROM superstore
LIMIT 10;

ALTER TABLE superstore
ADD COLUMN Processing_Time INT;
UPDATE superstore
SET Processing_Time = TIMESTAMPDIFF(DAY, Order_Date_Converted, Ship_Date_Converted);

alter table superstore drop column order_date ;
alter table superstore drop column ship_date ;

ALTER TABLE superstore
CHANGE Ship_Date_Converted Ship_Date DATE;
ALTER TABLE superstore
CHANGE Order_Date_Converted Order_Date DATE;

/*Customer segemnets */
/*Q) Total customer buying in each state*/
select count(Customer_ID) as total_csutomer, state from superstore
group by state
order by count(Customer_ID) desc;

/*Q) Total customer buying in each city*/
select count(Customer_ID)as total_csutomer, city from superstore
group by city
order by count(Customer_ID) desc;

/*Q) Who are the top customers based on total sales and profit contribution?*/
select customer_name,sum(Profit) as total_profit,sum(sales) as total_sales
from superstore
group by customer_name
order by total_sales desc, total_profit desc
limit 20;

/*Q) Which customer segments (Consumer, Corporate, Home Office) generate the highest revenue and profit?*/
select segment, sum(Profit) as total_profit,sum(sales) as total_sales
from superstore
group by segment
order by total_sales desc, total_profit desc;

/*Q) What is the average order value for each customer segment?*/
select segment,avg(sales) as avg_order_value
from superstore
group by segment
order by avg_order_value desc ;

/*Q) Are there specific states where certain customer segments perform better?*/
SELECT
    State,
    Segment,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT(Customer_ID)) AS Customer_Count
FROM
    Superstore
GROUP BY
    State, Segment
ORDER BY
    Total_Sales DESC, Total_Profit DESC;

/*Q) How frequenselectly do customers from each segment purchase?*/
select count(distinct(customer_id)) as total_customer,
count(distinct(order_id)) as total_orders ,
COUNT(DISTINCT Order_ID) / COUNT(DISTINCT Customer_ID) AS Avg_Orders_Per_Customer,
segment
from superstore
group by segment
order by  Avg_Orders_Per_Customer desc ;

/*Product Performance*/
/*Q) Which products are the top-selling in terms of quantity and revenue?*/
select product_name ,count(quantity) as total_quantity_sold,sum(sales) as total_sales 
from superstore
group by product_name
order by total_quantity_sold desc,total_sales desc
limit 10;

/*Q) What are the least-performing categories?*/
select category,sum(sales) as total_sales
from superstore
group by  category
order by total_sales asc;

/*Q) How does product profitability vary across categories (e.g., Technology, Furniture, Office Supplies)?*/
select category,sum(sales) as total_sales,sum(profit) as total_profit,
(sum(profit)/sum(sales))*100 as profit_margin_percent
from superstore
group by category
order by profit_margin_percent desc;

/*Q) Are there specific sub-categories that perform better in particular regions or customer segments?*/
select sub_category,sum(sales) as total_sales,segment
from superstore
group by sub_category,segment
order by total_sales desc;

select sub_category,sum(sales) as total_sales,region
from superstore
group by sub_category,region
order by total_sales desc;

/*Q) What is the impact of discounts on sales performance for different products?*/
SELECT 
    Product_Name, 
    AVG(Discount) AS Average_Discount, 
    SUM(Profit) AS Total_Profit 
FROM superstore
GROUP BY Product_Name
ORDER BY Total_Profit ASC
LIMIT 10;

/*Sales and Revenue Trends*/
/*Q) How do monthly or yearly sales trends look for the company?*/
SELECT 
    YEAR(Order_Date) AS Year, 
    MONTHname(Order_Date) AS Month, 
    SUM(Sales) AS Total_Sales 
FROM superstore
GROUP BY YEAR(Order_Date), MONTHname(Order_Date)
ORDER BY Year, Month;

/*Q) Which regions contribute the most to total sales and revenue?*/
select sum(sales) as total_sales,region,SUM(Profit) AS Total_Profit from superstore
group by region
order by total_sales desc;

/*Q) Are there any seasonal patterns in sales, and if so, which months perform the best?*/
SELECT 
    monthname(Order_Date) AS Month, 
    SUM(Sales) AS Total_Sales 
FROM superstore
GROUP BY MONTHname(Order_Date)
ORDER BY Month;

/*Q) What is the percentage contribution of each region, state, or city to the overall revenue?*/
SELECT 
    Region,
    SUM(Sales) AS Total_Sales, 
    (SUM(Sales) / (SELECT SUM(Sales) FROM superstore) * 100) AS Percentage_Contribution 
FROM superstore
GROUP BY Region
ORDER BY Percentage_Contribution DESC;

SELECT 
    State,
    SUM(Sales) AS Total_Sales, 
    (SUM(Sales) / (SELECT SUM(Sales) FROM superstore) * 100) AS Percentage_Contribution 
FROM superstore
GROUP BY state
ORDER BY Percentage_Contribution DESC;

/*Shipping and Operational Efficiency/*
/*Q) What is the average delivery time across different shipping modes (e.g., Standard Class, Second Class)?*/
select avg(order_date-ship_date) as avg_delivery_time,ship_mode
from superstore
group by ship_mode;

/*Q) Which regions or cities experience the longest delivery delays?*/
select avg(order_date-ship_date) as avg_delivery_time,region
from superstore
group by region;

select avg(order_date-ship_date) as avg_delivery_time,city
from superstore
group by city;

/*Q) Are there shipping modes that are more cost-effective or profitable than others?*/
SELECT 
    Ship_Mode, 
    SUM(Sales) AS Total_Sales, 
    SUM(Profit) AS Total_Profit 
FROM superstore
GROUP BY Ship_Mode
ORDER BY Total_Profit DESC;

/*Q) How often do orders get delayed, and what factors contribute to these delays?*/
/*LET STANDARD DELIVERY TIME for same day- 0days; first class 3 day;second class-5 days,standard class 10days*/
Alter table superstore 
add column delivery_status text;

update superstore
set delivery_status= CASE 
when ship_mode="Same Day" and processing_time >0 THEN "Late Delivery"
when ship_mode="first class" and processing_time >3 THEN "Late Delivery"
when ship_mode="second class" and processing_time >5 THEN "Late Delivery"
when ship_mode="Standard class" and processing_time >10 THEN "Late Delivery"
else "ON TIME"
END;

SELECT Ship_Mode, Delivery_Status, COUNT(*) AS Orders
FROM superstore
GROUP BY Ship_Mode, Delivery_Status;

/*Marketing and Discount Analysis*/
Alter table superstore add column discount_level varchar(20);
update superstore
set discount_level = CASE 
    WHEN Discount > 0 AND Discount <= 0.1 THEN 'Low (0-10%)'
    WHEN Discount > 0.1 AND Discount <= 0.3 THEN 'Medium (10-30%)'
    WHEN Discount > 0.3 THEN 'High (>30%)'
    else "No discount"
  END ;
  
/*Q) How do different levels of discounts affect sales and profit margins?*/
SELECT 
  Discount_Level,
  COUNT(*) AS Total_Orders,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY Discount_Level
ORDER BY Discount_Level;

/*Q) Are higher discounts leading to increased customer retention or loyalty?*/
select
discount_level,
count(customer_id) as total_customer ,discount_level
from superstore
group by discount_level;

/* Q) What is the ROI for applying discounts in different product categories or regions?*/
SELECT 
  Category,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SUM(Sales * Discount), 2) AS Total_Discount_Given,
  ROUND(
    CASE 
      WHEN SUM(Sales * Discount) = 0 THEN NULL
      ELSE (SUM(Profit) - SUM(Sales * Discount)) / SUM(Sales * Discount) * 100
    END, 2
  ) AS ROI_Percent
FROM superstore
WHERE Discount > 0
GROUP BY Category;

/*Financial Segment Insights*/
/*Q) What is the overall profit margin, and how does it vary across categories and sub-categories?*/
select category,sub_category,
round((sum(profit)/sum(sales))*100,2) as profit_margin 
from superstore
group by category,sub_category;

/*Q) Are there products or categories with consistently negative profit margins?*/
select category,
round((sum(profit)/sum(sales))*100,2) as profit_margin 
from superstore
group by category
having profit_margin <0;

select product_name,
round((sum(profit)/sum(sales))*100,2) as profit_margin 
from superstore
group by product_name
having profit_margin <0
order by profit_margin asc; 

/*Q) What is the impact of discounting on overall profitability?*/
SELECT 
  CASE 
    WHEN Discount = 0 THEN 'No Discount'
    ELSE 'Discounted'
  END AS Discount_Flag,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin
FROM superstore
GROUP BY Discount_Flag;
/*The profit margin is negative (-2.86%), meaning you're losing money on discounted sales.*/

 /*Regional Analysis*/
 /* Q) Which regions have the highest and lowest sales and profits?*/
SELECT 
  Region,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SUM(Profit)/NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin
FROM superstore
GROUP BY Region
ORDER BY Total_Profit DESC;
/*Interpretation:
Top regions by profit = high performers → invest more.
Low or negative profit regions = need pricing/logistics review.*/

 /*Q) Are there specific states or cities where the company should focus more effort (e.g., marketing or logistics)?*/
SELECT 
  State,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM superstore
GROUP BY State
ORDER BY Total_Profit ASC;

/*Lowest profit states at the bottom → identify logistics or demand issues.
High sales but low profit = potential pricing/discount problem.
Low sales and low customers = needs more marketing effort.*/

/* Q) How does customer demand vary by region, and how does this impact inventory management?*/
SELECT 
  Region,
  COUNT(DISTINCT Order_ID) AS Total_Orders,
  COUNT(DISTINCT Product_ID) AS Products_Ordered,
  SUM(Quantity) AS Total_Quantity,
  ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY Region
ORDER BY Total_Orders DESC;

/*Regions with high orders & product variety need robust inventory.
Low product/quantity but many orders → smaller, frequent shipments (consider logistics optimization).*/

