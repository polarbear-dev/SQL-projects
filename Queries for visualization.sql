--In which countries are there the highest number of unique users
SELECT 
COUNT(DISTINCT CustomerID) AS user_number, Country
FROM 
default.retail
GROUP BY
Country

--Let’s look at the monthly dynamics of the number of active users in the UK, Australia, and the Netherlands
SELECT 
COUNT(DISTINCT CustomerID) AS user_number, Country, toStartOfMonth(InvoiceDate) AS month
FROM 
default.retail
WHERE 
Country IN ('United Kingdom', 'Australia', 'Netherlands')
GROUP BY
Country, month
ORDER BY
month

--The monthly dynamics of the number of active users for all countries except the UK
SELECT 
COUNT(DISTINCT CustomerID) AS user_number, Country, toStartOfMonth(InvoiceDate) AS month
FROM 
default.retail
WHERE 
Country !='United Kingdom' 
GROUP BY
Country, month
ORDER BY
month

--Calculate the average order value (AOV) in each country
SELECT
    Country, 
    AVG(TotalPrice) AS avg_price
FROM
    (SELECT 
        InvoiceNo, 
        SUM(Quantity*UnitPrice) as TotalPrice,
        Country
    FROM retail
    WHERE Quantity >= 0
    GROUP BY 
        InvoiceNo,
        Country
    )
GROUP BY Country
ORDER BY avg_price DESC

--How the average order value changed in different countries by month?
SELECT
    Country, 
    AVG(TotalPrice) AS avg_price,
    date_month
FROM
    (SELECT 
        InvoiceNo, 
        SUM(Quantity*UnitPrice) as TotalPrice,
        Country,
        toStartOfMonth(InvoiceDate) AS date_month
    FROM retail
    WHERE Quantity >= 0
    GROUP BY 
        InvoiceNo,
        Country,
        date_month
    )
WHERE Country IN ('United Kingdom', 'Germany', 'France', 'Spain', 'Netherlands', 'Belgium', 'Switzerland', 'Portugal', 'Australia', 'USA')
GROUP BY 
    Country,
    date_month

--How many items do users usually add to their cart?
SELECT 
AVG(sum_quantity) as avg_q,
Country
FROM
  (SELECT 
   SUM(Quantity) as sum_quantity,
   InvoiceNo,
   Country
   FROM
   retail
   GROUP BY
   InvoiceNo, Country
   )
GROUP BY
Country

--Group the data by users in the Netherlands and see who bought the most items
SELECT
CustomerID,
SUM(Quantity) as sum_q
FROM
retail
WHERE
Country = 'Netherlands'
GROUP BY
CustomerID
ORDER BY
sum_q DESC
