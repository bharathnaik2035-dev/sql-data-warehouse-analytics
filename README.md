# SQL Data Warehouse Analytics & Exploratory Data Analysis (EDA)

## 📌 Project Overview
This project builds a modern Data Warehouse architecture from scratch using **SQL Server** and performs extensive **Exploratory Data Analysis (EDA)** to uncover critical business insights. It simulates a real-world data engineering workflow—from defining database schemas and staging raw CSV data to executing complex analytical queries.

---

## 🛠️ Tech Stack & Tools
* **Database Management System:** Microsoft SQL Server (SSMS)
* **Language:** T-SQL (Transact-SQL)
* **Key Concepts:** Star Schema Design, Data Warehousing, Bulk Data Loading, Executive KPIs, Magnitude Analysis, and Ranking Analysis.

---

## 🏗️ Architecture & Database Structure
The project follows a structured star schema analytics layer containing:
* **`gold.dim_customers`**: Stores cleaned customer demographic information (Country, Gender, Marital Status, Age).
* **`gold.dim_products`**: Contains product catalog data categorized by product line, category, and subcategory.
* **`gold.fact_sales`**: Stores transaction-level metrics, linking sales orders to customers and products with corresponding quantities and sales amounts.

---

## 🔍 Key Insights & Analysis Performed
The core script (`scripts/00_init_database.sql`) handles the end-to-end pipeline:
1. **Database & Schema Setup:** Automated creation/reset of the data warehouse and relational table constraints.
2. **Data Ingestion:** Using `BULK INSERT` to load raw CSV data straight into database tables.
3. **Data Exploration & Auditing:** Auditing table structures, unique customer regions, and product taxonomies.
4. **Key Performance Indicators (KPIs):** Measuring total revenue, total items sold, average selling prices, total orders, and active customer counts using an executive summary query (`UNION ALL`).
5. **Magnitude Analysis:** Breaking down customer distribution and revenue contributions across regions and categories.
6. **Ranking Analysis:** Identifying top-performing products generating the highest revenue as well as bottom-performing items using Window Functions (`ROW_NUMBER()`).

---

## 📁 Repository Structure
```text
sql-data-warehouse-analytics/
├── scripts/
│   └── 00_init_database.sql   # Complete database setup, bulk insert, and EDA queries
├── gold.dim_customers.csv     # Customer dimension dataset
├── gold.dim_products.csv      # Product dimension dataset
├── gold.fact_sales.csv        # Sales fact transaction dataset
└── README.md                  # Project documentation
