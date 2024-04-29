/*A manager comes to you with a problem: 
over the past month, they've noticed a decline in revenue in certain regions and want to identify the possible cause of this decline. 
To start, you can group the revenue data by countries and find the top 5 countries by revenue, 
as it will be most interesting to focus on the data from these countries.*/

SELECT 
    Country, 
    SUM(Quantity*UnitPrice) AS Revenue
FROM default.retail
GROUP BY Country
ORDER BY Revenue DESC;

--The average quantity of purchased items and the average price of items in purchases made in a specific country.

SELECT 
    Country, 
    AVG(Quantity) AS AvgQuantity, 
    AVG(UnitPrice) AS AvgPrice
FROM default.retail
WHERE Description != 'Manual'
GROUP BY Country
ORDER BY AvgPrice DESC;

--The dynamics of total revenue by month.

SELECT 
    toStartOfMonth(InvoiceDate) AS month_date, 
    SUM(Quantity*UnitPrice) AS Revenue
FROM default.retail
WHERE Description != 'Manual'
GROUP BY month_date
ORDER BY Revenue DESC;

/*The revenue dynamics from customers who, on average, purchase the most expensive items. 
We will use the average price of purchased items (UnitPrice) as the target metric, and look at the data for March 2011.*/

SELECT
    CustomerID,
    AVG(UnitPrice) AS AvgPrice
FROM default.retail
WHERE
        Description != 'Manual'
    AND
        toStartOfMonth(InvoiceDate) = '2011-03-01'
GROUP BY CustomerID
ORDER BY AvgPrice DESC
LIMIT 1000;

--How has the average, minimum and maximum quantity of goods purchased in the country with the highest revenue changed over the past months?

SELECT 
    AVG(Quantity) AS AvgQuantity,
    MIN(Quantity) AS MinQuantity,
    MAX(Quantity) AS MaxQuantity,
    toStartOfMonth(InvoiceDate) AS month_date,
    Country
FROM default.retail
WHERE
        Description != 'Manual'
    AND
        Country = 'United Kingdom'
    AND
        Quantity > 0    
GROUP BY Country, month_date
ORDER BY month_date;