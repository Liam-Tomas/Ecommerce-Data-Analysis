
-- Calculate RFM values for each customer:
--  RFM analysis involves:
-- - Recency (R): How recently a customer made a purchase. Calculated this as the number of days since their last purchase.
-- - Frequency (F): How often a customer makes a purchase. Calculated as the total number of purchases.
-- - Monetary (M): How much money a customer spends. Calculated as the total purchase value.
-- - Segmentation:
-- - Once we have the RFM values, customers are segmented into different categories based on these values. 
-- - - I am using three segments for simplicity: "Low," "Medium," and "High."

-- Step 1: Calculate RFM Values and Store in MySQL Database
-- Data Preprocessing: Aggregates the data to create a single table for each customer, summarizing their total purchase value, transaction count, and recency.
-- It calculates the following metrics for each customer:
-- - LastPurchaseDate: The date of their most recent purchase.
-- - TransactionCount: The total number of unique transactions made by the customer.
-- - TotalPurchaseValue: The total purchase value (monetary value) of all their transactions.
-- This aggregated data serves as the basis for further RFM (Recency, Frequency, Monetary) analysis and customer segmentation.
-- Used for calculating quartiles in the Python script @ RFM_calculation.py

CREATE TABLE RFM_Aggregated AS
SELECT
    CustomerID,
    MAX(InvoiceDate) AS LastPurchaseDate,
    COUNT(DISTINCT InvoiceNo) AS TransactionCount,
    SUM(UnitPrice * Quantity) AS TotalPurchaseValue
FROM ecommerce_data
GROUP BY CustomerID;

-- Display the Aggregated table for testing purposes
SELECT * FROM RFM_Aggregated LIMIT 10;

-- Create a table to store segmented customer data.
-- This table is populated by the Pandas Python script @ RFM_calculation.py. 
-- -- The python script script calculates the RFM, segments it, and inserts the data into this table when run.
CREATE TABLE RFM_Segmented (
    CustomerID INT PRIMARY KEY,
    Recency INT,
    Frequency INT,
    Monetary DECIMAL(10, 2),
    RecencySegment VARCHAR(20), 
    FrequencySegment VARCHAR(20), 
    MonetarySegment VARCHAR(20)
);

-- Display the table for testing purposes
SELECT * FROM RFM_Segmented LIMIT 30;
