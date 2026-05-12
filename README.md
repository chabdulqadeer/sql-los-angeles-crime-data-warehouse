# Los Angeles Crime Data Warehouse (SQL Project)

## 📌 Project Overview

This project is a SQL-based Data Warehouse built using the Los Angeles Crime Dataset (2020–Present).  
The goal of this project is to design and implement a complete Medallion Architecture (Bronze, Silver, Gold) using only SQL Server.

The project focuses on:
- Data Warehousing
- ETL Design
- Data Cleaning
- Dimensional Modeling
- SQL Analytics
- Window Functions
- Crime Trend Analysis

---

# 🏗️ Architecture

The warehouse follows a Medallion Architecture:

```text
Source Dataset
       ↓
Bronze Layer (Raw Data)
       ↓
Silver Layer (Cleaned & Standardized Data)
       ↓
Gold Layer (Analytical & Reporting Layer)
```

---

# 📂 Layers Description

## 🥉 Bronze Layer
Stores raw crime data exactly as received from the source.

### Features
- No transformations
- Raw ingestion
- Append-only structure
- Source preservation

### Main Table
- `bronze.crime_raw`

---

## 🥈 Silver Layer
Contains cleaned and standardized data for analysis.

### Features
- Removed duplicates
- Standardized data types
- Cleaned text values
- Validated records
- Created derived columns

### Main Table
- `silver.crime_incident`

### Dimension Views
- `silver.dim_area`
- `silver.dim_weapon`
- `silver.dim_premise`
- `silver.dim_victim`

---

## 🥇 Gold Layer
Contains analytical queries, reporting views, and aggregated insights.

### Features
- Crime trend analysis
- Area-based analysis
- Victim analysis
- Weapon analysis
- Time-series analysis
- Window function analytics

### Example Analytical Views
- `gold.vw_monthly_crime_trend`
- `gold.vw_top_crime_areas`
- `gold.vw_weapon_analysis`
- `gold.vw_victim_analysis`

---

# 🛠️ Technologies Used

- SQL Server
- T-SQL
- SSMS (SQL Server Management Studio)

---

# 📊 Analysis Performed

## Crime Analysis
- Total crimes
- Crimes per year
- Crimes per month
- Top crime categories

## Area Analysis
- Most dangerous areas
- Crime hotspots
- Area-wise crime trends

## Victim Analysis
- Crimes by gender
- Crimes by age group
- Victim demographic analysis

## Weapon Analysis
- Most used weapons
- Weapon-related crime trends

## Time Analysis
- Peak crime hours
- Weekday vs weekend crimes
- Seasonal trends

## Advanced SQL Analytics
- Window functions
- Ranking analysis
- Running totals
- Moving averages
- Crime growth trends

---

# 🧠 SQL Concepts Used

- CTEs
- Joins
- CASE Statements
- Aggregate Functions
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()
- Views
- Data Cleaning Techniques

---

# 📁 Project Structure

```text
project/
│
├── bronze/
├── silver/
├── gold/
├── analytical_queries/
├── stored_procedures/
├── documentation/
└── README.md
```

---

# 📌 Dataset Source

Los Angeles Crime Dataset:

[LA Crime Dataset](https://data.lacity.org/Public-Safety/Crime-Data-from-2020-to-2024/2nrs-mtv8?utm_source=chatgpt.com)

---

# 🚀 Future Improvements

- Add automated ETL pipelines
- Implement stored procedures
- Add indexing optimization
- Create Power BI dashboards
- Implement Slowly Changing Dimensions (SCD)
- Add geospatial analysis

---

# 📖 Learning Outcomes

This project helped me understand:
- Data Warehouse Architecture
- Medallion Architecture
- ETL Processes
- Dimensional Modeling
- SQL Analytics
- Query Optimization
- Real-world Data Cleaning

---

# 👨‍💻 Author

Abdul Qadeer
