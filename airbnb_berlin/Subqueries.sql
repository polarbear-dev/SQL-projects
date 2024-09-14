SELECT
    id,
    toFloat64OrNull(review_scores_rating) AS rsr ,
    reviews_per_month
FROM
    listings
WHERE
    rsr > (SELECT 
				AVG(toFloat64OrNull(review_scores_rating)) 
           FROM listings)
	AND reviews_per_month < 3
ORDER BY reviews_per_month DESC,
         rsr DESC
LIMIT 100

-- Let's find the room that is the farthest from the center but still closer than the average distance of all other rooms
SELECT
    geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)) as distance,
    id,
    host_id
FROM listings
WHERE
        distance < (SELECT
                        AVG(geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)))
                    FROM listings
                    WHERE 
                    room_type = 'Private room')
    AND
        room_type = 'Private room'
ORDER BY distance DESC
LIMIT 1000

-- Let's imagine we are planning to rent accommodation in Berlin for 7 days using more sophisticated filters than those offered on the website.
SELECT
    geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)) as distance,
    id,
    host_id,
    toFloat64OrNull(replaceRegexpAll(price, '[$,]', '')) as price,
    toFloat64OrNull(review_scores_rating) as rsr
    FROM listings
WHERE
        distance < (SELECT
                        AVG(geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)))
                    FROM listings
                    )
    AND
        price < 100
    AND
        multiSearchAnyCaseInsensitive(amenities, ['wifi'])
    AND
        toDateOrNull(last_review) > '2018-09-01'
ORDER BY rsr DESC
LIMIT 1000

/* 
Let's find in the calendar_summary table those available listings (where available='t') 
that have a number of reviews from unique users in the reviews table above the average 
*/
WITH
    (SELECT
        AVG(reviewers)
    FROM
        (SELECT 
            listing_id,
            COUNT(DISTINCT reviewer_id) as reviewers
        FROM
            reviews
        GROUP BY listing_id)) as avg_reviewers

SELECT
    listing_id,
    COUNT(DISTINCT reviewer_id) as reviewer_amount
FROM
    reviews as r
JOIN
    (SELECT 
        DISTINCT listing_id
    FROM
        calendar_summary
    WHERE available='t') as cs
ON r.listing_id = cs.listing_id
GROUP BY listing_id
HAVING reviewer_amount > avg_reviewers
ORDER BY listing_id ASC
LIMIT 100

/*
<<<<<<< HEAD
In the context of choosing a place to stay, we assume that we are only interested in two parameters: 
the presence of a kitchen (kitchen) and a flexible cancellation policy (flexible), with the former being the priority
*/

=======
Let’s assume that when choosing accommodation, we are only interested in two parameters: 
the presence of a kitchen and a flexible cancellation policy, with the former being the priority
*/
>>>>>>> 57f572b4f6a8cb6e97522e53757975b5a7067eb3
SELECT 
    host_id, 
    CASE  
        WHEN multiSearchAnyCaseInsensitive(amenities, ['kitchen']) AND multiSearchAnyCaseInsensitive(cancellation_policy, ['flexible']) THEN 'good'
        WHEN multiSearchAnyCaseInsensitive(amenities, ['kitchen']) THEN 'ok'
        ELSE 'not ok'
    END AS Group
FROM listings
ORDER BY Group ASC
<<<<<<< HEAD
LIMIT 5
=======
LIMIT 5
>>>>>>> 57f572b4f6a8cb6e97522e53757975b5a7067eb3
