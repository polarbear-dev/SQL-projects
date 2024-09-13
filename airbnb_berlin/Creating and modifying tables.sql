CREATE TABLE test.reviews (
    listing_id UInt32,
    id UInt32,
    created_at DateTime('Europe/Moscow'),
    reviewer_id UInt32,
    reviewer_name String,
    comments String,
    ORDER BY (listing_id, id)
) ENGINE = MergeTree

--The created_at field will only record the date, without the time, so the data type needs to be changed
ALTER TABLE test.reviews 
MODIFY COLUMN created_at Date

--Some rows with comments are empty. Let’s delete the empty rows
ALTER TABLE test.reviews 
DELETE WHERE comments=''

--Adding new column
ALTER TABLE test.reviews 
ADD COLUMN price Float32 AFTER comments

--Changing new column
ALTER TABLE test.reviews 
UPDATE price=price*2 
WHERE created_at>'2019-01-01'
