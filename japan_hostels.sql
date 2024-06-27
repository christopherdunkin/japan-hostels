-- Inspect all of the data:
SELECT *
FROM hostels;

-- In the following few statements we clean the data:
-- First set 'Rating' ratings to the more appropriate 'Not good':
UPDATE hostels
SET rating_band = 'Not good'
WHERE rating_band = 'Rating';

-- Next, for consistency, set 'Very Good' to 'Very good':
UPDATE hostels
SET rating_band = 'Very good'
WHERE rating_band = 'Very Good';

/*Currently, the distance_from_city_centre column is populated with strings of the 
form distance followed by 'km from the city centre'. Here we trip 'km from the city centre' off the end of each such string:*/
UPDATE hostels
SET distance_from_city_centre = REPLACE(distance_from_city_centre, 'km from city centre', '');

-- Convert the data type in the distance_from_city_centre column to double:
ALTER TABLE hostels
MODIFY COLUMN distance_from_city_centre double;

-- Remove records with outlier prices from table:
DELETE FROM hostels
WHERE price_from > 20000;

-- Remove records with outlier latitude from table:
DELETE FROM hostels
WHERE latitude < 20
    OR latitude > 36;

-- Now the data is cleaned and we are ready to create the desired views for visualisation.
-- Let's start with price_from by city:
CREATE VIEW city_price AS
SELECT id, city, price_from
FROM hostels;

-- distance_from_city_centre against price_from, classified by city:
CREATE VIEW distance AS
SELECT city, distance_from_city_centre, price_from
FROM hostels;

-- Retrieve data on rating variables against price_from, classified by city, excluding records with null values:
CREATE VIEW city_rating AS
SELECT city, summary_score, atmosphere, cleanliness, facilities, location_rating, security_rating, staff, value_for_money, price_from
FROM hostels
WHERE summary_score IS NOT NULL
    AND atmosphere IS NOT NULL
    AND cleanliness IS NOT NULL
    AND facilities IS NOT NULL
    AND location_rating IS NOT NULL
    AND security_rating IS NOT NULL
    AND staff IS NOT NULL
    AND value_for_money IS NOT NULL;

-- Retrieve data for map:
CREATE VIEW map AS
SELECT city, longitude, latitude, rating_band
FROM hostels
WHERE longitude IS NOT NULL
    AND latitude IS NOT NULL
    AND rating_band IS NOT NULL;