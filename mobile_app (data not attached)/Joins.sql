SELECT *
FROM events AS l
LEFT JOIN devices AS r
    ON l.DeviceID = r.DeviceID
ORDER BY DeviceID DESC
LIMIT 1000;

--Let's check which users coming from which source made the highest number of purchases
SELECT 
    a.Source AS Source,
    COUNT(*) AS NumChecks
FROM installs AS a
JOIN devices AS b
    ON a.DeviceID = b.DeviceID 
JOIN checks AS c
    ON b.UserID = c.UserID
GROUP BY Source
ORDER BY NumChecks DESC;

--How many total unique users made purchases in our application
SELECT 
    COUNT(DISTINCT(c.UserID)) AS UniqUserID,
    a.Source AS Source
FROM installs AS a
JOIN devices AS b
    ON a.DeviceID = b.DeviceID 
JOIN checks AS c
    ON b.UserID = c.UserID
GROUP BY Source;

--Total revenue, as well as minimum, maximum, and average purchase amount
SELECT
    a.Source AS Source,
    SUM(c.Rub) AS Revenue,
    MIN(c.Rub) AS MinCheck,
    AVG(c.Rub) AS AvgCheck,
    MAX(c.Rub) AS MaxCheck
FROM installs AS a
JOIN devices AS b
    ON a.DeviceID = b.DeviceID 
JOIN checks AS c
    ON b.UserID = c.UserID
GROUP BY Source;

--Device identifiers of users who made at least one purchase in October 2019
SELECT 
    b.DeviceID AS DeviceID,
    toStartOfMonth(CAST(a.BuyDate AS Date)) AS BuyDate
FROM checks AS a
JOIN devices AS b
    ON a.UserID = b.UserID
WHERE BuyDate = '2019-10-01'
ORDER BY DeviceID ASC
LIMIT 1000;

--How many items on average do users from different platforms and different sources view ?
SELECT 
    AVG(a.events) AS AvgEvents,
    b.Platform AS Platform,
    b.Source AS Source
FROM events AS a
JOIN installs AS b
    ON a.DeviceID = b.DeviceID
GROUP BY Platform, Source
ORDER BY AvgEvents DESC;

--The number of unique DeviceIDs in installs for which there are views in the events table, with breakdown by platforms.
SELECT 
    COUNT(DISTINCT(b.DeviceID)) AS DeviceID,
    a.Platform AS Platform
FROM installs AS a
LEFT SEMI JOIN events AS b
    ON a.DeviceID = b.DeviceID
GROUP BY Platform;

--The conversion rate from install to view broken down by the platform of the install
SELECT 
    COUNT(DISTINCT(a.DeviceID)) AS DeviceID_a,
    COUNT(DISTINCT(b.DeviceID)) AS DeviceID_b,
    DeviceID_a/DeviceID_b AS Conversion,
    b.Platform AS Platform
FROM events AS a
RIGHT JOIN installs AS b
    ON a.DeviceID = b.DeviceID
GROUP BY Platform;

/* We need to select examples of DeviceIDs from the events table that do not exist in the installs table. 
This is to send them to the development team for correction, 
as there was an error in logging DeviceIDs in the events table, 
where part of the ID was recorded incorrectly, 
resulting in DeviceIDs appearing in the events table for which there are no installs */
SELECT 
    DISTINCT(a.DeviceID) AS DeviceID
FROM events AS a
LEFT ANTI JOIN installs AS b
    ON a.DeviceID = b.DeviceID
ORDER BY DeviceID DESC
LIMIT 10;
