-- SALES TREND QUERIES:
-- - These queries give insight into common sales trends

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

-- Total sales by month
SELECT
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    SUM(UnitPrice * Quantity) AS TotalSales
FROM ecommerce_data
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year, Month;

-- Average spend per customer
SELECT
    CustomerID,
    AVG(UnitPrice * Quantity) AS AvgSpend
FROM ecommerce_data
GROUP BY CustomerID;

-- Top customers by total purchase value
SELECT
    CustomerID,
    SUM(UnitPrice * Quantity) AS TotalPurchaseValue
FROM ecommerce_data
GROUP BY CustomerID
ORDER BY TotalPurchaseValue DESC;


-- Products frequently out of stock
SELECT
    StockCode,
    COUNT(*) AS OutOfStockCount
FROM ecommerce_data
WHERE Quantity <= 0
GROUP BY StockCode
ORDER BY OutOfStockCount DESC;


