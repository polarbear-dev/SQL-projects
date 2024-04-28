SELECT *
FROM default.checks
LIMIT 10;

--top 10 payments by amount
SELECT *
FROM default.checks
ORDER BY 
    Rub DESC
LIMIT 10;

SELECT
    Rub AS revenue,
    BuyDate,
    UserID
FROM default.checks
ORDER BY 
    UserID ASC
LIMIT 15;

--Check the data for which period is available in the table
SELECT
    MIN(BuyDate) AS MinDate,
    MAX(BuyDate) AS MaxDate
FROM default.checks;

/*We have a task to select several groups of users based on different criteria to send them personalized messages about promotions. 
For example, we want to offer a discount on the next purchase to the first 10 users who registered on the website 
(the earlier the user registered, the smaller their UserID).*/
SELECT DISTINCT UserID
FROM default.checks
ORDER BY
    UserID ASC
LIMIT 10;

/*We want to create a new promotion for International Women's Day, and for this, 
we are interested in the largest purchases made on this day last year.*/
SELECT *
FROM default.checks
WHERE
    BuyDate = '2019-03-08'
ORDER BY
    Rub DESC
LIMIT 10;

/*We assume that users who made large purchases on September 1st last year are parents of schoolchildren, 
and next year we can prepare a promotion for them on a group of products.*/
SELECT DISTINCT UserID
FROM default.checks
WHERE 
        BuyDate ='2019-09-01'
    AND
        Rub > 2000
ORDER BY 
    UserID DESC;