                           Bike Store Relational Database
 Overview:
This repository contains the SQL scripts and queries for a Bike Store relational database. The database is designed to manage
information about customers, orders, products, categories, brands, stores, and staff.It supports various analytical queries to 
gain insights into sales trends, customer satisfaction, product performance, and more.

-->Dataset Collection : https://www.kaggle.com/datasets/dillonmyrick/bike-store-sample-database

:Database Schema:
->The database schema includes the following tables:

:-Customers
customer_id: Primary Key
firstname
lastname
phone
email
street
city
state
zipcode

:-Orders
order_id: Primary Key
customer_id: Foreign Key
order_status
order_date
required_date
shipped_date
store_id: Foreign Key
staff_id: Foreign Key

:-Staffs
staff_id: Primary Key    
first_name
last_name
email
phone
active
store_id: Foreign Key
manager_id: Foreign Key (self-referencing)

:-Stores
store_id: Primary Key
store_name
phone
email
street
city
state
zipcode

:-Order Items
order_id: Primary Key, Foreign Key
item_id: Primary Key
product_id: Foreign Key
quantity
list_price
discount

:-Categories
category_id: Primary Key
category_name

:-Products
product_id: Primary Key
product_name
brand_id: Foreign Key
category_id: Foreign Key
model_year
list_price

:-Stocks
store_id: Primary Key, Foreign Key
product_id: Primary Key, Foreign Key
quantity

:-Brands
brand_id: Primary Key
brand_name
