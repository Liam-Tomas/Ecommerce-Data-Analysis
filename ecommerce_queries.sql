CREATE DATABASE ecommerce;

CREATE TABLE ecommerce_data (
    InvoiceNo VARCHAR(10),
    StockCode VARCHAR(10),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(7, 2),
    CustomerID INT,
    Country VARCHAR(50)
);

-- Convert to latin1 or utf8mb4 for compatibility if necessary:
ALTER TABLE ecommerce_data CONVERT TO CHARACTER SET utf8mb4;

-- Load data from csv file into MySQL
LOAD DATA LOCAL INFILE '/Users/LiamA/OSU_CS/projects-mern/data_analysis_ecommerce/ecommerce_data.csv'
INTO TABLE ecommerce_data
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ! Exploratory Queries !:
    
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

-- SALES TREND QUERIES:

-- Total sales by month/year
SELECT 
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    SUM(UnitPrice * Quantity) AS TotalSales
FROM ecommerce_data
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year, Month;

-- Identify days with sales 2 standard deviations above the mean (days with abnormally high sales)
WITH DailySales AS (
    SELECT 
        DATE(InvoiceDate) AS Date,
        SUM(UnitPrice * Quantity) AS TotalSales
    FROM ecommerce_data
    GROUP BY DATE(InvoiceDate)
)
SELECT Date, TotalSales
FROM DailySales
WHERE TotalSales > (SELECT AVG(TotalSales) + 2 * STD(TotalSales) FROM DailySales);

-- Unusual purchase behavior:
-- Example: customers buying more than 1000 units of a product in one purchase.)
SELECT CustomerID, StockCode, InvoiceDate, Quantity
FROM ecommerce_data
WHERE Quantity > 1000;
