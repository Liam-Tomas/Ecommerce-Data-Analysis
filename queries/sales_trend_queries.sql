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
CREATE VIEW DailySalesView AS
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
CREATE VIEW OutOfStock AS
SELECT
    ed.StockCode,
    ed.Description,
    COUNT(*) AS OutOfStockCount
FROM ecommerce_data AS ed
WHERE ed.Quantity <= 0
GROUP BY ed.StockCode, ed.Description
HAVING OutOfStockCount >= 10
ORDER BY OutOfStockCount DESC;



-- Monthly / Seasonal Sales Data:
DROP TABLE SeasonalSales;
CREATE TABLE IF NOT EXISTS SeasonalSales (
    Year INT,
    Month INT,
    MonthlySales DECIMAL(12, 2)
);

INSERT INTO SeasonalSales (Year, Month, MonthlySales)
SELECT
    YEAR(ecom.InvoiceDate) AS Year,
    MONTH(ecom.InvoiceDate) AS Month,
    SUM(rfm.TotalPurchaseValue) AS MonthlySales
FROM
    ecommerce_data ecom
JOIN
    RFM_Aggregated rfm
ON
    ecom.CustomerID = rfm.CustomerID
WHERE
    ecom.CustomerID <> 0 -- Exclude rows where CustomerID is 0
GROUP BY
    Year, Month
ORDER BY
    Year, Month;

-- Monthly Sales calculation : 
SELECT
    YEAR(ecom.InvoiceDate) AS Year,
    MONTH(ecom.InvoiceDate) AS Month,
    SUM(rfm.TotalPurchaseValue) AS MonthlySales
FROM
    ecommerce_data ecom
JOIN
    RFM_Aggregated rfm
ON
    ecom.CustomerID = rfm.CustomerID
GROUP BY
    Year, Month
ORDER BY
    Year, Month;
    
SELECT * FROM SeasonalSales;

-- Top Selling Products Table Creation 
CREATE TABLE TopSellingProducts (
    StockCode VARCHAR(255),
    Description VARCHAR(255),
    TotalQuantitySold INT
);
INSERT INTO TopSellingProducts (StockCode, Description, TotalQuantitySold)
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS TotalQuantitySold
FROM
    ecommerce_data
GROUP BY
    StockCode, Description
ORDER BY
    TotalQuantitySold DESC
LIMIT 10; -- Change the limit to display more or fewer products

SELECT * FROM TopSellingProducts;

-- Create a table for Sales Growth Data
CREATE TABLE IF NOT EXISTS SalesGrowthData (
    Year INT,
    Month INT,
    MonthlySales DECIMAL(12, 2),
    PreviousMonthSales DECIMAL(12, 2),
    SalesGrowthRate DECIMAL(12, 2)
);

-- Insert the results of the SQL query into the table and round the SalesGrowthRate
INSERT INTO SalesGrowthData (Year, Month, MonthlySales, PreviousMonthSales, SalesGrowthRate)
SELECT
    Year,
    Month,
    MonthlySales,
    LAG(MonthlySales) OVER (ORDER BY Year, Month) AS PreviousMonthSales,
    ROUND((MonthlySales - LAG(MonthlySales) OVER (ORDER BY Year, Month)) / LAG(MonthlySales) OVER (ORDER BY Year, Month), 2) AS SalesGrowthRate
FROM
    SeasonalSales
ORDER BY
    Year, Month;
    
SELECT * FROM SalesGrowthData;

