/*
=============================================================
Create Database, Schemas, and Perform Exploratory Data Analysis
=============================================================
Script Purpose:
    This script sets up the 'DataWarehouseAnalytics' database, creates 
    the 'gold' schema, defines dimension and fact tables, bulk loads 
    CSV data, and runs comprehensive Exploratory Data Analysis (EDA) 
    including magnitude, ranking, and business metric calculations.
=============================================================
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schema
CREATE SCHEMA gold;
GO

-- =============================================================
-- Create Tables
-- =============================================================

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int,
	product_id int,
	product_number nvarchar(50),
	product_name nvarchar(50),
	category_id nvarchar(50),
	category nvarchar(50),
	subcategory nvarchar(50),
	maintenance nvarchar(50),
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

-- =============================================================
-- Load Data via Bulk Insert
-- NOTE: Update the file paths below to match your local machine directory.
-- =============================================================

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\bhara\Downloads\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\bhara\Downloads\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\bhara\Downloads\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO


-- =============================================================
-- Database Exploration
-- =============================================================

-- Explore All Tables in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore All Columns in the dim_customers table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


-- =============================================================
-- Dimension Exploration
-- =============================================================

-- Explore all unique countries our customers come from
SELECT DISTINCT country 
FROM gold.dim_customers
ORDER BY country;

-- Explore all product categories, subcategories, and products
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1, 2, 3;


-- =============================================================
-- Date Exploration
-- =============================================================

-- Find the date of the first and last order 
SELECT MIN(order_date) AS first_order_date,
       MAX(order_date) AS last_order_date
FROM gold.fact_sales;

-- How many years of sales are available 
SELECT DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find youngest and oldest customer age calculations
SELECT MIN(birthdate) AS oldest_birthday,
       DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age, 
       MAX(birthdate) AS youngest_birthday,
	   DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;


-- =============================================================
-- Measure Exploration (Key Performance Indicators)
-- =============================================================

-- Find the Total Sales
SELECT SUM(sales_amount) AS Total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS average_selling_price
FROM gold.fact_sales;

-- Find the Total number of Orders
SELECT COUNT(DISTINCT order_number) AS Total_orders
FROM gold.fact_sales;

-- Find the total number of products
SELECT COUNT(product_number) AS Total_products
FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT(customer_id) AS Total_customers
FROM gold.dim_customers;

-- Find the total number of customers that have placed an order 
SELECT COUNT(DISTINCT customer_key) AS Total_customers_with_orders
FROM gold.fact_sales;

-- Generate a Executive Report showing all key business metrics
SELECT 'Total_sales' AS measure_name, CAST(SUM(sales_amount) AS FLOAT) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'total_quantity', CAST(SUM(quantity) AS FLOAT) FROM gold.fact_sales
UNION ALL
SELECT 'average_selling_price', CAST(AVG(price) AS FLOAT) FROM gold.fact_sales
UNION ALL
SELECT 'Total_orders', CAST(COUNT(DISTINCT order_number) AS FLOAT) FROM gold.fact_sales
UNION ALL
SELECT 'Total_products', CAST(COUNT(product_number) AS FLOAT) FROM gold.dim_products
UNION ALL
SELECT 'Total_customers', CAST(COUNT(customer_id) AS FLOAT) FROM gold.dim_customers
UNION ALL
SELECT 'Active_customers', CAST(COUNT(DISTINCT customer_key) AS FLOAT) FROM gold.fact_sales;


-- =============================================================
-- Magnitude Analysis
-- =============================================================

-- Find total customers by country
SELECT country, COUNT(DISTINCT customer_id) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Find total customers by gender
SELECT gender, COUNT(DISTINCT customer_id) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Find total products by category
SELECT category, COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- What is the average cost in each category
SELECT category, AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- What is total revenue generated for each category
SELECT p.category,
       SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Find the total revenue generated by each customer
SELECT c.customer_key,
       c.first_name,
	   c.last_name,
       SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key,
         c.first_name,
		 c.last_name
ORDER BY total_revenue DESC;

-- What is the distribution of sold items across countries 
SELECT c.country,
       SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;


-- =============================================================
-- Ranking Analysis
-- =============================================================

-- Which 5 products generate the highest revenue
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- What are the 5 worst-performing products in terms of sales
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;
