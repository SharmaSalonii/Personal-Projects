USE ev;

select * from sales_by_makers_and_cat;
select * from ev_maker_by_place;
select * from charging_station;
select * from vehicles;

SELECT * FROM global_ev;
select * from charging;

select * from yearly_sales;

/* Details of ev in India*/
SELECT distinct
    *
FROM
    ev_maker_by_place
WHERE
    State IS NULL OR Place IS NULL
        OR Ev_Maker IS NULL;
   
SELECT distinct
    *
FROM
    operationalpc
WHERE
    State IS NULL OR Operational_PCS IS NULL;

SELECT distinct
    *
FROM
    Vehicles
WHERE
    Registration IS NULL OR Vehicle IS NULL;

    
drop table yearly_sales;

/* CREATING A NEW TABLE TO STORE YEAR WISE SALES */
CREATE TABLE yearly_sales AS
SELECT '2015' AS year, SUM(`2015`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2016' AS year, SUM(`2016`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2017' AS year, SUM(`2017`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2018' AS year, SUM(`2018`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2019' AS year, SUM(`2019`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2020' AS year, SUM(`2020`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2021' AS year, SUM(`2021`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2022' AS year, SUM(`2022`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2023' AS year, SUM(`2023`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat
UNION ALL
SELECT '2024' AS year, SUM(`2024`) AS total_sales,Maker,ï»¿Cat
FROM sales_by_makers_and_cat
group by Maker,ï»¿Cat;
    
select * from yearly_sales;

/*Calculate total sales by year*/
SELECT 
    year, SUM(total_sales)
FROM
    yearly_sales
GROUP BY year;


/*Total sales*/
select sum(total_sales) as total_sale
from yearly_sales;

/* Top 10 highest sold makers*/
SELECT 
    SUM(total_sales) AS sales, Maker
FROM
    yearly_sales
GROUP BY Maker
ORDER BY sales DESC
LIMIT 10;

/* Top 10 highest sold category*/
SELECT 
    SUM(total_sales) AS sales, ï»¿Cat
FROM
    yearly_sales
GROUP BY ï»¿Cat
ORDER BY sales DESC
LIMIT 10;

/*Total sales by Place */
SELECT 
    Place, total_sales
FROM
    yearly_sales AS y
        JOIN
    ev_maker_by_place AS m ON y.Maker = m.EV_Maker
GROUP BY total_sales , Place
ORDER BY total_sales DESC
LIMIT 10;

/*Calculate annual growth in EV sales to understand the market trend over the years*/
SELECT year, 
	(total_sales), 
       LAG((total_sales), 1) OVER (ORDER BY year) AS prev_year_sales,
       ((total_sales) - LAG((total_sales), 1) OVER (ORDER BY year)) * 100.0 / LAG((total_sales), 1) OVER (ORDER BY year) AS growth_percentage
FROM yearly_sales
GROUP BY year,total_sales
ORDER BY year;


/*Identify the top EV manufacturers by sales and market share*/
WITH totalsalesbymaker AS (SELECT maker, total_sales
FROM yearly_sales ),
TotalMarketSales AS (
    SELECT SUM(total_sales) AS market_sales
    FROM  totalsalesbymaker
)
SELECT
    maker,
    total_sales,
    ROUND((total_sales / market_sales) * 100, 2) AS market_share
FROM  totalsalesbymaker, TotalMarketSales
ORDER BY total_sales DESC
LIMIT 10;


/*Ev Global dataset*/
SELECT distinct
    *
FROM
    global_ev;
    
SELECT *
FROM global_ev
WHERE parameter IS NULL;

/*What are the total EV sales by region from 2010 to 2024?*/
SELECT 
    region, SUM(value) AS sales
FROM
    global_ev
GROUP BY region
ORDER BY sales DESC;

/*The sales distribution among different EV categories*/
SELECT 
    category, SUM(value) AS sales
FROM
    global_ev
GROUP BY category
ORDER BY sales DESC;

/*Which mode of transportation (e.g., personal, public) has contributed
 the most to EV sales in recent years?*/
 SELECT 
    SUM(value) AS sales, mode,year
FROM
    global_ev
WHERE 
    year BETWEEN 2010 AND 2024
GROUP BY mode , year
ORDER BY sales DESC;
 
/* Compare the sales performance of different EV powertrains
(e.g., BEV, PHEV) by region.*/
SELECT 
    region, powertrain, SUM(value) AS sales
FROM
    global_ev
GROUP BY region , powertrain
ORDER BY sales DESC;

/*What are the total EV sales globally each year?*/
SELECT year, 
       SUM(value) AS yearly_sales,
       LAG(SUM(value)) OVER (ORDER BY year) AS prev_year_sales,
       ((SUM(value) - LAG(SUM(value)) OVER (ORDER BY year)) * 100.0 /
        NULLIF(LAG(SUM(value)) OVER (ORDER BY year), 0)) AS growth_percentage
FROM global_ev
GROUP BY year
ORDER BY year;

/* What is the breakdown of EV sales units (e.g., in units, 
thousands, millions) across different years?*/

SELECT year, 
       unit, 
       SUM(value) AS total_sales
FROM global_ev
GROUP BY year, unit
ORDER BY year, total_sales DESC;

/* What are the average EV sales values (value) by mode in each region?*/
SELECT 
    region, mode, AVG(value) AS avg_sales_value
FROM
    global_ev
GROUP BY region , mode
ORDER BY region , mode;

/*Which mode has the highest sales value in each region over the last three years?*/
SELECT 
    region, mode, SUM(value) AS total_sales
FROM
    global_ev
WHERE
    year BETWEEN (SELECT 
            MAX(year) - 2
        FROM
            global_ev) AND (SELECT 
            MAX(year)
        FROM
            global_ev)
GROUP BY region , mode
ORDER BY region , total_sales DESC;

/*Compare the annual growth rates of EV sales and another parameter 
(e.g., emissions reductions) across regions.*/

SELECT year, 
       region, 
       parameter,
       SUM(value) AS total_value,
       LAG(SUM(value)) OVER (PARTITION BY region, parameter ORDER BY year) AS prev_year_value,
       ((SUM(value) - LAG(SUM(value)) OVER (PARTITION BY region, parameter ORDER BY year)) * 100.0 /
        NULLIF(LAG(SUM(value)) OVER (PARTITION BY region, parameter ORDER BY year), 0)) AS growth_percentage
FROM global_ev
GROUP BY year, region, parameter
ORDER BY year desc;

/*Total charging stations in india*/

select sum(Operational_PCS) as total_charging_station
from charging_station;

select * from charging_station;

/*Global Charging point*/
select * from charging;

SELECT *
FROM charging
WHERE parameter IS NULL;

/*Total charging stations*/
select count(*) as total_charging_globally
from charging;

/*Total charging station by region*/
SELECT 
    COUNT(*) AS total_charging_points, region
FROM
    charging
GROUP BY region
ORDER BY total_charging_points
DESC;

/*Which regions have seen the highest increase in charging
 points over the years?*/
SELECT
     count(*) AS yearly_charging_points,region,year,
	 LAG(COUNT(*)) OVER (PARTITION BY region ORDER BY year) AS prev_year_charging_points,
       ((COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY region ORDER BY year)) * 100.0 /
        NULLIF(LAG(COUNT(*)) OVER (PARTITION BY region ORDER BY year), 0)) AS growth_percentage
FROM charging 
GROUP BY region,year
ORDER BY yearly_charging_points DESC;

/* How do charging points vary by category (e.g., fast charging, standard charging)
 in each region?*/

SELECT 
    COUNT(*) AS total_charging_points, region
FROM
    charging
GROUP BY region
ORDER BY total_charging_points;

/* Analyze the distribution of charging points by mode (e.g., private, public) 
across regions.*/

SELECT 
    region, mode, COUNT(*) AS total_charging_points
FROM
    charging
GROUP BY region , mode
ORDER BY total_charging_points DESC;

/*What is the number of charging points available for 
different powertrains (e.g., BEV, PHEV) across regions?*/
SELECT region, 
       powertrain, 
       COUNT(*) AS total_charging_points
FROM charging
GROUP BY region, powertrain
ORDER BY total_charging_points DESC;

/*Total charging points public fast or slow*/
SELECT 
    COUNT(*) AS chargings, powertrain
FROM
    charging
GROUP BY powertrain
ORDER BY chargings;

