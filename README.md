# sql-data-warehouse-analytics
SQL Server Data Warehouse Analytics and Exploratory Data Analysis project.
# SQL Data Warehouse Analytics & Exploratory Data Analysis (EDA)

## 📌 Project Overview
This project builds a modern Data Warehouse architecture from scratch using **SQL Server** and performs extensive **Exploratory Data Analysis (EDA)** to uncover critical business insights. It simulates a real-world data engineering workflow—from defining database schemas and staging data to executing complex analytical queries.

---

## 🛠️ Tech Stack & Tools
* **Database Management System:** Microsoft SQL Server (SSMS)
* **Language:** T-SQL (Transact-SQL)
* **Key Concepts:** Star Schema Design, Data Warehousing, Bulk Data Loading, KPIs, Magnitude Analysis, Ranking Analysis.

---

## 🏗️ Architecture & Database Structure
The project follows a structured schema approach representing a modern analytics layer:
* **`gold.dim_customers`**: Stores cleaned customer demographic information (Country, Gender, Marital Status, Age).
* **`gold.dim_products`**: Contains product catalog data categorized by product line, category, and subcategory.
* **`gold.fact_sales`**: Stores transaction-level metrics, linking sales orders to customers and products with corresponding quantities and sales amounts.

---

## 🔍 Key Insights & Analysis Performed
The EDA script (`scripts/00_init_database.sql`) covers the following key modules:
1. **Database & Schema Setup:** Automated creation/reset of the data warehouse and relational table constraints.
2. **Data Exploration:** Auditing table structures, unique customer regions, and product taxonomies.
3. **Date Range Analysis:** Tracking business lifetime performance (first order, last order, and total operating years).
4. **Key Performance Indicators (KPIs):** Measuring total revenue, total items sold, average selling prices, total orders, and active customer counts using an executive summary query (`UNION ALL`).
5. **Magnitude Analysis:** Breaking down customer distribution, revenue contribution by product category, and regional performance.
6. **Ranking Analysis:** Identifying top-performing products generating the highest revenue as well as bottom-performing items using Window Functions and sorting techniques.

---

## 📁 Repository Structure
```text
sql-data-warehouse-analytics/
├── scripts/
│   └── 00_init_database.sql   # Complete setup, bulk load, and EDA script
└── README.md                  # Project documentation
