/*
Let's look at avocado sales in two cities (New York, Los Angeles) 
and find out how many organic avocados were sold in total by the end of each week (cumulative sales), 
starting from the beginning of the observation period (04/01/15)
/*

SELECT 
    region,
    date,
    total_volume,
    SUM(total_volume) OVER w AS volume
FROM
    avocado
WHERE 
    region IN ('NewYork', 'LosAngeles')
    AND 
    type = 'organic'
WINDOW w AS 
    (
    PARTITION BY region
    ORDER BY date ASC
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )
ORDER BY 
    region DESC,
    date ASC

-- add a breakdown for each year
SELECT
   region, 
   date, 
   total_volume,
   SUM(total_volume) OVER w as Volume
FROM 
   avocado
WHERE 
   region IN ('NewYork', 'LosAngeles') 
   AND 
   type = 'organic'
WINDOW w AS
    (
    PARTITION BY region, EXTRACT(YEAR from date)
    ORDER BY date 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )
ORDER BY
   region DESC,
   date

-- Let's see when the sales volumes of conventional avocados sharply declined compared to the previous week
SELECT
    date, 
    total_volume,
    region,
    total_volume - LAG(total_volume, 1) OVER () AS week_diff
FROM avocado
WHERE 
    region = 'TotalUS' 
    AND 
    type = 'conventional'
ORDER BY date

--Let's take a closer look at avocado sales volumes in New York in 2018
SELECT
    date, 
    total_volume,
    region,
    type,
    total_volume - lag(total_volume, 1) OVER (PARTITION BY type) AS week_diff
FROM avocado
WHERE 
    region = 'NewYork'
    AND
    year = 2018
ORDER by date

--Let's calculate the moving average of avocado prices (average_price) in New York, with a breakdown by avocado type
SELECT
    date, 
    average_price,
    region,
    type,
    AVG(average_price) OVER w AS rolling_price
FROM avocado
WHERE 
    region = 'NewYork'
WINDOW w AS
    (
    PARTITION BY type
    ORDER BY date ASC
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )
ORDER BY
    type,
    date


