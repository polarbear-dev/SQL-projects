--Which month and year saw the highest number of new hosts registered?
SELECT 
    toStartOfMonth((toDateOrNull(host_since))) AS host_since,
    COUNT(DISTINCT host_id) as count_host
FROM listings
GROUP BY host_since
ORDER BY count_host DESC;

--The average response rate among hosts (f) and superhosts (t)
SELECT 
    host_is_superhost,
    AVG(toInt32OrNull(replaceAll(host_response_rate, '%', ''))) AS AvgResp
FROM (
    SELECT 
        DISTINCT host_id,
        host_is_superhost,
        host_response_rate
    FROM 
        listings) AS sub -- In the subquery, we select unique row values based on the columns of interest
GROUP BY host_is_superhost;

--The average price per night among hosts
SELECT 
    host_id,
    groupArray(id),
    AVG(toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))) as AvgPricePerHost
FROM listings
GROUP BY host_id
ORDER BY AvgPricePerHost DESC, host_id DESC
LIMIT 1000;

--The difference between the maximum and minimum set price for each host
SELECT 
    host_id,
    MAX(toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))) as max_price,
    MIN(toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))) as min_price,
    max_price - min_price as diff
FROM listings
GROUP BY host_id
ORDER BY diff DESC
LIMIT 1000;

--The average nightly price by type of accommodation
SELECT
    room_type,
    AVG(toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))) as avg_price
FROM listings
GROUP BY room_type;

--Which of the presented rooms is located closest to the city center?
SELECT
    id,
    room_type,
    geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)) as distance
FROM listings
WHERE room_type = 'Private room'
LIMIT 100;