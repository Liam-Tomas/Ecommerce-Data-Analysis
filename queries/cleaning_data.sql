-- Some general queries for cleaning the ecommerce data set from Kaggle.com

-- Gets the customer with no ID listed. 
SELECT *
FROM ecommerce_data
WHERE CustomerID = 0;

SHOW TABLES;

-- Finds outliers where Monetary value is greater than 100,000
SELECT *
FROM RFM_Segmented
WHERE Monetary >= "100,000";
