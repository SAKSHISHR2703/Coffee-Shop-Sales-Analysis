# ☕ Coffee Shop Sales Analysis — SQL Project

![SQL](https://img.shields.io/badge/SQL-MySQL-blue?style=flat-square&logo=mysql)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)
![Records](https://img.shields.io/badge/Records-149%2C000%2B-orange?style=flat-square)

> An end-to-end SQL analysis of 149,000+ coffee shop transactions across 3 store locations — uncovering sales trends, peak hours, top products, and month-over-month performance.

---

## 📌 Project Overview

This project performs a full sales analysis for a multi-location coffee shop chain using MySQL. Starting from raw transactional data, I handled data cleaning, type conversion, and built a comprehensive suite of KPI queries to support business decision-making.

---

## 🎯 Business Questions Answered

- What are the **total sales, orders, and quantity sold** for each month?
- How does performance **compare month-over-month** (MoM)?
- Which **store locations** drive the most revenue?
- What are the **peak hours and days** for customer traffic?
- Which **product categories and types** generate the highest sales?
- How do **weekday vs. weekend** sales compare?

---

## 🗂️ Dataset

| Detail | Info |
|--------|------|
| Total Records | 149,000+ transactions |
| Locations | 3 store branches |
| Time Period | Multiple months (2023) |
| Key Columns | `transaction_id`, `transaction_date`, `transaction_time`, `transaction_qty`, `unit_price`, `product_category`, `product_type`, `store_location` |

---

## 🛠️ Tools & Skills Used

- **MySQL** — Data cleaning, querying, aggregation
- **Window Functions** — `LAG()`, `OVER()` for MoM comparisons
- **Date & Time Functions** — `MONTH()`, `DAYOFWEEK()`, `HOUR()`, `STR_TO_DATE()`
- **Subqueries & CTEs** — For average benchmarking and nested aggregations
- **CASE statements** — For conditional categorization (weekday/weekend, above/below avg)

---

## 🧹 Data Cleaning Steps

The raw dataset required the following fixes before analysis:

1. Converted `transaction_date` from string → `DATE` using `STR_TO_DATE()`
2. Converted `transaction_time` from string → `TIME`
3. Renamed malformed `transaction_id` column (contained BOM characters)
4. Handled NULL values using conditional `WHERE` clauses during updates

---

## 📊 Key Analyses

### 1. 📈 Total Sales / Orders / Quantity — Monthly KPIs
Calculates core KPIs for any selected month with formatted output (e.g., `76.1K`).

### 2. 🔁 Month-on-Month (MoM) Growth
Uses `LAG()` window function to compare current vs. previous month — outputs both absolute difference and percentage change.

### 3. 🏪 Sales by Store Location
Ranks the 3 store locations by revenue for a selected month.

### 4. 📅 Weekday vs. Weekend Sales
Segments revenue using `DAYOFWEEK()` to identify if weekends or weekdays drive more sales.

### 5. ⏰ Sales by Hour & Day of Week
Identifies the **peak hour (8 AM)** and best-performing days using time-based aggregation.

### 6. 🛍️ Product Category & Top 10 Products
Ranks all 9+ product categories and drills into top products within a category (e.g., Coffee).

### 7. 📉 Daily Sales vs. Average Benchmark
Tags each day as **Above Average**, **Below Average**, or **Average** using `AVG()` as a window function.

---

## 💡 Key Findings

- 🕗 **Peak sales hour: 8 AM** — morning rush drives the highest daily revenue
- 📦 **Coffee** is the top-performing product category by revenue
- 📍 Store location performance varies — one branch consistently outperforms others
- 📆 **Weekdays** generate higher overall sales volume than weekends

---

## 📁 File Structure

```
coffee-sales-analysis/
│___ Coffee_Sales_Analysis.sql  # Full SQL script (cleaning + all analyses)
├── Coffee_Sales_Analysis.csv      #  Sample Dataset
└── Project Overview   # Full project description
|__ README.md       # Project documentation
```

---

## 🚀 How to Run

1. Import your CSV data into MySQL as a table named `coffee_shop`
2. Run the full script: `Coffee_Sales_Analysis.sql`
3. Change the `MONTH()` filter value to explore different months:
   ```sql
   WHERE MONTH(transaction_date) = 3  -- Change 3 to any month (1–12)
   ```

---

## 🙋‍♀️ About Me

**Sakshi Sharma** 
Data Analyst with a knack for finding the story hiding in messy datasets.
I work with SQL, Python, and Power BI to build dashboards that actually help people make decisions.
Currently leveling up through real-world projects in sales, customer analytics & food delivery ops. 

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/sakshi2703)

---

*If you found this project helpful, please ⭐ star the repository!*
