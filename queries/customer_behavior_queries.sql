-- Customer Behavior Queries
-- - These queries give insights into customer behaviors

-- Average spending per customer
SELECT
    CustomerID,
    AVG(UnitPrice * Quantity) AS AvgSpend
FROM ecommerce_datas
GROUP BY CustomerID;

-- Top customers by total purchase value
SELECT
    CustomerID,
    SUM(UnitPrice * Quantity) AS TotalPurchaseValue
FROM ecommerce_data
GROUP BY CustomerID
ORDER BY TotalPurchaseValue DESC;
