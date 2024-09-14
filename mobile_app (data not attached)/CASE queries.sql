--Divide all customers into segments

SELECT 
    UserID, 
    AVG(Rub) as avg_rub,
    CASE  
        WHEN avg_rub < 5 THEN 'A'
        WHEN AVG(Rub) >= 5 AND AVG(Rub) < 10 THEN 'B'
        WHEN AVG(Rub) >= 10 AND AVG(Rub) < 20 THEN 'C'
        ELSE 'D'
    END AS Group
FROM checks
GROUP BY UserID
ORDER BY UserID ASC
LIMIT 10

--How many customers are in each segment, and how much revenue does each segment generate?


SELECT 
    COUNT(DISTINCT l.UserID) as count_users,
    SUM(l.Rub) as sum_rub,
    r.Group
FROM 
    checks AS l
JOIN
    (SELECT 
    UserID, 
    AVG(Rub) as avg_rub,
    CASE  
        WHEN avg_rub < 5 THEN 'A'
        WHEN AVG(Rub) >= 5 AND AVG(Rub) < 10 THEN 'B'
        WHEN AVG(Rub) >= 10 AND AVG(Rub) < 20 THEN 'C'
        ELSE 'D'
    END AS Group
    FROM checks
    GROUP BY UserID) AS r
ON l.UserID = r.UserID
GROUP BY r.Group
ORDER BY sum_rub DESC