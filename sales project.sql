select * from sales_canada;
alter table sales_canada
alter column "Date" type text;

select * from sales_china;

CREATE TABLE sales_india
(
    "Transaction ID" text,
    "Date" text,
    "Country" text,
    "Product ID" text,
    "Product Name" text,
    "Category" text,
    "Price Per Unit" numeric,
    "Quantity Purchased" integer,
    "Cost Price" numeric,
    "Discount Applied" numeric,
    "Payment Method" text,
    "Customer Age Group" text,
    "Customer Gender" text,
    "Store Location" text,
    "Sales Representative" text,
    PRIMARY KEY ("Transaction ID")
);

select * from sales_india;

CREATE TABLE sales_nigeria
(
    "Transaction ID" text,
    "Date" text,
    "Country" text,
    "Product ID" text,
    "Product Name" text,
    "Category" text,
    "Price Per Unit" numeric,
    "Quantity Purchased" integer,
    "Cost Price" numeric,
    "Discount Applied" numeric,
    "Payment Method" text,
    "Customer Age Group" text,
    "Customer Gender" text,
    "Store Location" text,
    "Sales Representative" text,
    PRIMARY KEY ("Transaction ID")
);

CREATE TABLE sales_us
(
    "Transaction ID" text,
    "Date" text,
    "Country" text,
    "Product ID" text,
    "Product Name" text,
    "Category" text,
    "Price Per Unit" numeric,
    "Quantity Purchased" integer,
    "Cost Price" numeric,
    "Discount Applied" numeric,
    "Payment Method" text,
    "Customer Age Group" text,
    "Customer Gender" text,
    "Store Location" text,
    "Sales Representative" text,
    PRIMARY KEY ("Transaction ID")
);

CREATE TABLE sales_uk
(
    "Transaction ID" text,
    "Date" text,
    "Country" text,
    "Product ID" text,
    "Product Name" text,
    "Category" text,
    "Price Per Unit" numeric,
    "Quantity Purchased" integer,
    "Cost Price" numeric,
    "Discount Applied" numeric,
    "Payment Method" text,
    "Customer Age Group" text,
    "Customer Gender" text,
    "Store Location" text,
    "Sales Representative" text,
    PRIMARY KEY ("Transaction ID")
);

select * from sales_canada;
select * from sales_china;
select * from sales_india;
select * from sales_nigeria;
select * from sales_uk;
select * from sales_us;


CREATE TABLE sales_data as
select * from sales_canada
UNION ALL
SELECT * FROM sales_china
Union all
SELECT * FROM sales_india
Union all
SELECT * FROM sales_nigeria
Union all
SELECT * FROM sales_uk
Union all
SELECT * FROM sales_us

select * from sales_data

alter table sales_data 
alter column "Date" type date 
using to_date("Date", 'MM/DD/YYYY');


select * 
from sales_data
where
    "Country" is null
	or "Price Per Unit" is null
	or "Quantity Purchased" is null
	or "Cost Price" is null
	or "Discount Applied" is null;


update sales_data
set "Quantity Purchased" = 3
where "Transaction ID" = '00a30472-89a0-4688-9d33-67ea8ccf7aea'


update sales_data
set "Price Per Unit" = (
    SELECT AVG("Price Per Unit") from sales_data
	where "Price Per Unit" is not null )
	where "Transaction ID" ='001898f7-b696-4356-91dc-8f2b73d09c63'

select "Transaction ID", Count(*)
from sales_data
group by "Transaction ID"
having count(*)>1;


Alter table sales_data add
column"Total Amount" Numeric(10,2);

update sales_data
set "Total Amount"=("Price Per Unit" * "Quantity Purchased") - "Discount Applied";

select * from sales_data;

alter table sales_data add
column "Profit" Numeric(10,2);

update sales_data
set "Profit"="Total Amount" - ("Cost Price" + "Quantity Purchased");


SELECT 
    "Country", 
    SUM("Total Amount") AS "Total Revenue",
    SUM("Profit") AS "Total Profit"
FROM sales_data
GROUP BY "Country"
ORDER BY "Total Revenue" DESC;

SELECT 
    "Product Name", 
    SUM("Quantity Purchased") AS "Total Units Sold"
FROM sales_data
WHERE "Date" BETWEEN '2025-02-10' AND '2025-02-14'
GROUP BY "Product Name"
ORDER BY "Total Units Sold" DESC
LIMIT 5;

SELECT 
    "Sales Representative", 
    SUM("Total Amount") AS "Total Sales"
FROM sales_data
WHERE "Date" BETWEEN '2025-02-10' AND '2025-02-14'
GROUP BY "Sales Representative"
ORDER BY "Total Sales" DESC
LIMIT 5;

SELECT 
    "Store Location", 
    SUM("Total Amount") AS "Total Sales",
    SUM("Profit") AS "Total Profit"
FROM sales_data
WHERE "Date" BETWEEN '2025-02-10' AND '2025-02-14'
GROUP BY "Store Location"
ORDER BY "Total Sales" DESC
limit 5;

SELECT
  MIN("Total Amount") AS "Min Sales Value",
    MAX("Total Amount") AS "Max Sales Value",
    AVG("Total Amount") AS "Avg Sales Value",
    SUM("Total Amount") AS "Total Sales Value",
    MIN("Profit") AS "Min Profit",
    MAX("Profit") AS "Max Profit",
    AVG("Profit") AS "Avg Profit",
    SUM("Profit") AS "Total Profit"
FROM sales_data
WHERE "Date" BETWEEN '2025-02-10' AND '2025-02-14';



