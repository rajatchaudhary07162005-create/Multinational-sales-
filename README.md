# Multinational-sales-
## Overview / Purpose
-This project simulates a real-world business intelligence task: a retail company operates in five countries (Canada, China, India, Nigeria, UK, US — six tables total), and each region maintains its own sales records independently. The goal is to bring these fragmented datasets together into a single source of truth, clean up data quality issues, engineer the metrics the business actually cares about (revenue, profit), and answer concrete operational questions — which products sell best, which reps perform best, which stores are most profitable, and how performance varies across a specific time window.
-This mirrors a common real analytics workflow: raw multi-source data → unified table → cleaning → enrichment → reporting, which is essentially a lightweight ETL (Extract, Transform, Load) process done entirely in SQL.
-Dataset Structure
- Each country table shares a common schema with 15 columns, covering three categories of information:

- Transaction details: Transaction ID (primary key), Date, Country, Payment Method
Product details: Product ID, Product Name, Category, Price Per Unit, Cost Price, Discount Applied, Quantity Purchased
Context/segmentation: Customer Age Group, Customer Gender, Store Location, Sales Representative

-This is a fairly rich schema — it supports analysis across at least four dimensions: time, geography, product, and people (reps/customers).
Methodology (phase by phase)
-1. Exploration
Initial SELECT * queries on each country table to understand the raw data before touching it.
-2. Schema standardization
Some tables already existed (Canada, China) with mismatched types (e.g., Date as something other than text), so they're altered to match. New tables (India, Nigeria, US, UK) are created from scratch with explicit types and a primary key constraint on Transaction ID — this enforces uniqueness at the database level rather than relying purely on post-hoc checks.
-3. Consolidation
All six tables are combined into one sales_data table via CREATE TABLE ... AS SELECT ... UNION ALL .... Using UNION ALL (not UNION) is the correct choice here since it preserves duplicates rather than silently deduping rows that might just happen to look similar — important when you don't yet know whether duplicates are a real problem to investigate or not.
-4. Type correction
Date is converted from text to a proper date type using to_date(..., 'MM/DD/YYYY'), which is necessary because dates stored as text can't be reliably filtered, sorted, or used in range queries (as seen in the later BETWEEN filters).
-5. Data quality auditing
A targeted WHERE clause checks for NULLs across all the numeric/categorical fields that matter for the financial calculations (Country, Price, Quantity, Cost, Discount). This is a good practice — checking nulls before doing calculations on those columns, since a single null would silently break a profit calculation.
-6. Manual data correction & imputation
Two specific bad records are fixed:

-A transaction with a clearly wrong quantity is hard-coded to 3
-A transaction missing a price is imputed using the dataset's average price

This shows judgment — recognizing that not every data issue warrants the same fix (hard correction vs. statistical imputation).
-7. Duplicate detection
A GROUP BY ... HAVING COUNT(*) > 1 query confirms whether the primary key constraint actually held after the union (a good sanity check, since UNION ALL across separately-created tables can sometimes introduce duplicate IDs if source systems weren't coordinated).
-8. Feature engineering
Two derived business metrics are added as new columns rather than computed on the fly every time:

Total Amount — actual revenue per transaction after discount
Profit — revenue minus cost

Storing these as columns (rather than recalculating in every query) trades a bit of redundancy for query simplicity and performance in downstream reporting.
-9. Business reporting
Five analytical queries answer specific business questions:

Revenue/profit by country — geographic performance ranking
Top 5 products by units sold (within a date window) — demand analysis
Top 5 sales reps by revenue (within a date window) — performance management
Top 5 store locations by sales/profit (within a date window) — location performance
Summary statistics (min/max/avg/total for sales and profit) — a high-level KPI snapshot

