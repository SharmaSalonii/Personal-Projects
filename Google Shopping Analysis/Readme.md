                          Google Shopping Analysis

### 📌 Overview
This project automates the process of extracting Google Shopping data using SerpApi with Python, transforming it into structured data, cleaning
and analyzing it using SQL, and visualizing insights with Power BI. The primary goal is to understand product pricing, discount trends, customer
ratings, and reviews across various shopping platforms.

### 🔍 Key Features:
Automated Data Extraction: Uses SerpApi to fetch real-time product details from Google Shopping.
Data Transformation & Cleaning: Handles missing values, formats price and discount data, and structures it for SQL.
Exploratory Data Analysis (EDA): Identifies trends in pricing, discounts, ratings, and review counts.
SQL Integration: Stores and queries processed data for better analytics.
Power BI Dashboarding: Provides interactive visualizations and drill-through reports for deep insights.

### 🔧 Tools & Technologies
Python: Web scraping, data processing, and automation.
SerpApi: Extracting structured product data from Google Shopping.
SQL: Storing, querying, and analyzing data.
Power BI: Creating interactive reports and dashboards.

### 🔍 SQL Analysis
The database Google_shopping was created with a table serpapi_results.
The script performs null value analysis for key columns (title, source, price, rating, reviews, old_price).
$ signs are removed from price values to standardize numerical analysis.

### 🐍 Python Automation
Data is fetched from SerpAPI using categories like electronics, fashion, gaming, home appliances, automobile, sports, books, toys.
The script cleans prices (removes $, handles missing values) and stores them in MySQL.
Scheduled automation updates the dataset every 12 hours.

## 📊 Insights & Findings:
#### Discounts vs Pricing
Higher discounts ≠ lowest prices: Some high-discounted products still have higher old prices, meaning the actual benefit might not be as large as advertised.
Certain categories (e.g., electronics & fashion) have frequent discounts, while others (e.g., books, home appliances) remain relatively stable.

#### Customer Reviews & Ratings
Products with moderate pricing tend to get the most reviews. Extremely high or low-priced products don’t receive as many.
Higher ratings correlate with lower reviews in some cases—this suggests that niche, high-rated products may not be widely popular.

#### Platform Comparison
Some shopping sources consistently have higher-rated products—this could indicate better quality control or customer satisfaction.
Review count varies by platform: Some platforms see more user engagement, while others have fewer but more detailed reviews.

#### Trends in Discounts
Seasonal patterns in discount rates: Categories like fashion & electronics show major discounts during sales events, while categories like books & home appliances have stable pricing.
Discounts on certain sources are more frequent, making them better for bargain shoppers.
