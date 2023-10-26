-- Exploratory Queries:
-- - These queries allow for basic exploration of the dataset 
    
-- Get the first 10 rows of the dataset to see the structure:
SELECT * FROM ecommerce_data LIMIT 10;

-- Fetches the invoice numbers and corresponding stock codes 
-- for 1st 10 entries in the dataset
SELECT InvoiceNo, StockCode FROM ecommerce_data LIMIT 10;

-- Count the number of distinct invoices
SELECT COUNT(DISTINCT InvoiceNo) AS unique_invoices FROM ecommerce_data;

-- 2.3. Get the total number of products (by StockCode) and their total quantity:
SELECT StockCode, SUM(Quantity) as total_quantity FROM ecommerce_data GROUP BY StockCode ORDER BY total_quantity DESC;

-- Identify the top 5 countries with the most orders:
SELECT Country, COUNT(DISTINCT InvoiceNo) as order_count FROM ecommerce_data GROUP BY Country ORDER BY order_count DESC LIMIT 5;

-- Check for missing data
SELECT 
  SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) AS missing_invoiceno,
  SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS missing_stockcode,
  SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS missing_description,
  SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
  SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS missing_invoicedate,
  SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS missing_unitprice,
  SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS missing_customerid,
  SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS missing_country
FROM ecommerce_data;
