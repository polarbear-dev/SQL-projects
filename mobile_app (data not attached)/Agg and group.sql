--how many purchases are made per customer?
SELECT UserID, COUNT(BuyDate) as NumChecks
FROM default.checks
GROUP BY UserID
ORDER BY NumChecks DESC
LIMIT 10;

--The total amount of purchases
SELECT UserID, COUNT(BuyDate) as NumChecks, SUM(Rub) as Revenue
FROM default.checks
GROUP BY UserID
ORDER BY Revenue DESC
LIMIT 10;

--Dynamics of customer spending
SELECT 
    BuyDate, 
    MIN(Rub) as MinCheck, 
    MAX(Rub) as MaxCheck, 
    AVG(Rub) as AvgCheck
FROM default.checks
GROUP BY BuyDate
ORDER BY BuyDate DESC
LIMIT 10;

--Segment of users generating the highest revenue
SELECT UserID, SUM(Rub) as Revenue
FROM default.checks
GROUP BY UserID
HAVING Revenue > 10000
ORDER BY UserID DESC
LIMIT 10;