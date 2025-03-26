CREATE DATABASE Google_shopping;
USE Google_shopping;

select * from  serpapi_results LIMIT 10 ;

#SEARCHING NULL VALUES
SELECT 
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN Source IS NULL THEN 1 ELSE 0 END) AS source_nulls,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
    SUM(CASE WHEN extracted_price IS NULL THEN 1 ELSE 0 END) AS extracted_price_nulls,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_nulls,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN snippet IS NULL THEN 1 ELSE 0 END) AS snippet_nulls,
    SUM(CASE WHEN reviews IS NULL THEN 1 ELSE 0 END) AS reviews_nulls,
    SUM(CASE WHEN old_price IS NULL THEN 1 ELSE 0 END) AS old_price_nulls,
    SUM(CASE WHEN extracted_old_price IS NULL THEN 1 ELSE 0 END) AS extracted_old_price_nulls,
    SUM(CASE WHEN tag IS NULL THEN 1 ELSE 0 END) AS tag_nulls
FROM serpapi_results;

#Replace $ sign
SET SQL_SAFE_UPDATES = 0;
UPDATE serpapi_results 
SET price = REPLACE(price, "$", "");
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE serpapi_results
DROP column extracted_price,
drop column extracted_old_price;

ALTER TABLE serpapi_results
drop column discount_rate;

ALTER TABLE serpapi_results
drop column tag;
ALTER TABLE serpapi_results
drop column snippet;

select * from serpapi_results;

#EDA (Exploratory Data Analysis)
#1.  Calculate Discounts
SELECT title, price, old_price, 
    ROUND((old_price - price) / old_price * 100, 2) AS discount_percentage
FROM serpapi_results
WHERE old_price > price;

# Total Products per Category
select category, count(*) AS total_products
FROM serpapi_results
Group by category
order by total_products desc;

#Best Rated Products (Rating ≥ 4.5)
select title,rating
from serpapi_results
where rating >= 4.5;

# Category-wise Revenue Estimation
select category,sum(price) as total_revenue
from serpapi_results
group by category
order by total_revenue desc;

# Products with Most Reviews
select title,reviews 
from serpapi_results
order by reviews  desc
limit 10 ; 

#Most Expensive and Cheapest Products
select title,price
from serpapi_results AS most_expensive
order by price desc
limit 1;

select title, price 
from serpapi_results AS cheapest
order by price asc
limit 1;


#What are the most common sources (sellers) of products across categories?
SELECT source, category, COUNT(*) AS product_count
FROM serpapi_results
GROUP BY source, category
ORDER BY product_count DESC;

#How many unique sellers exist in the dataset?
select distinct(source)
from serpapi_results;

select * from serpapi_results;

#What is the average price of products in each category?
select avg(price) as average_price, category
from serpapi_results
group by category;

#Which category has the highest and lowest average product price?
SELECT category, 
       AVG(price) AS avg_price
FROM serpapi_results
WHERE price > 0
GROUP BY category
ORDER BY avg_price DESC;

UPDATE serpapi_results
SET price = REPLACE(REPLACE(price, ',', ''), '$', '');
UPDATE serpapi_results
SET old_price = REPLACE(REPLACE(old_price, ',', ''), '$', '');

ALTER TABLE serpapi_results 
MODIFY COLUMN price FLOAT;
ALTER TABLE serpapi_results 
MODIFY COLUMN old_price FLOAT;

ALTER TABLE serpapi_results DROP COLUMN discount;
ALTER TABLE serpapi_results ADD COLUMN discount DECIMAL(10,2);
SET SQL_SAFE_UPDATES = 0;
UPDATE serpapi_results 
SET discount = 
    CASE 
        WHEN old_price > 0 THEN ((old_price -price) / old_price) * 100
        ELSE 0
    END;
SET SQL_SAFE_UPDATES = 1;

select discount from serpapi_results ;

#Which seller offers the highest average discounts across all products?
select source,avg(discount) as avg_discount
from serpapi_results  
group by source
order by avg_discount desc
limit 5;

#What is the overall average rating across all products?
SELECT AVG(rating) AS overall_avg_rating
FROM serpapi_results;

#Which category has the highest-rated products on average?
select category,avg(rating) as avg_rating
from serpapi_results
group by category
order by avg_rating desc
limit 1;

#Which category has the lowest average rating?
select category,avg(rating) as avg_rating
from serpapi_results
group by category
order by avg_rating asc
limit 1;

#What percentage of products have ratings but zero reviews?
select title,rating,reviews
from serpapi_results
where reviews=0 AND rating>0;

#Which products have extremely high reviews but low ratings (potential fake reviews)?
SELECT title, source, category, rating, reviews
FROM serpapi_results
WHERE reviews > (SELECT AVG(reviews) * 2 FROM serpapi_results) -- Extremely high reviews
AND rating < (SELECT AVG(rating) * 0.5 FROM serpapi_results)  -- Very low ratings
ORDER BY reviews DESC;

#What are the top 5 most reviewed products across all categories?
select category,reviews
from serpapi_results
order by reviews desc
limit 5;

#Which sellers have the highest-rated products on average?
select source,avg(rating) as avg_rate
from serpapi_results
group by source
order by avg_rate desc
limit 1;

#Are expensive products generally rated higher than cheaper products?
SELECT title, source, category, price, rating
FROM serpapi_results
WHERE price IS NOT NULL AND rating IS NOT NULL
ORDER BY price DESC
LIMIT 10;

SELECT title, source, category, price, rating
FROM serpapi_results
WHERE price IS NOT NULL AND rating IS NOT NULL
ORDER BY price ASC
LIMIT 10;
#There is a positive relationship between price and rating.
#Higher-priced products tend to have higher ratings.
#Cheaper products often have 0 ratings, possibly because they are low-quality or less reviewed.

#Which categories have the most price fluctuations (difference between extracted price and old price)?
select category,max(abs(price-old_price)) as price_fluctuation
from serpapi_results
WHERE old_price > 0 
group by category
order by price_fluctuation desc
limit 10;
