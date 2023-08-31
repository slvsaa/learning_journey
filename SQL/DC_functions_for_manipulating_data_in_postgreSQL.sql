--Functions for Manipulating Data in PostgreSQL
--use dc_sakila

-- 1. Overview of Common Data Types

--INFORMATION_SCHEMA that allows us to extract information about objects, including tables, in our database.
SELECT * 
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'public';

 SELECT * 
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'actor';
 
-- Get the column name and data type
SELECT
 	column_name, 
    data_type
-- From the system database information schema
FROM INFORMATION_SCHEMA.COLUMNS 
-- For the customer table
WHERE table_name = 'customer';

--Date dan Time
--INTERVAL
--INTERVAL data types provide you with a very useful tool for performing arithmetic on date and time data types. 

--let's say our rental policy requires a DVD to be returned within 3 days
SELECT
 	-- Select the rental and return dates
	rental_date,
	return_date,
 	-- Calculate the expected_return_date
	rental_date + INTERVAL '3 days' AS expected_return_date
FROM rental;

--ARRAY

--Select all films that have a special feature TRAILERS by filtering on the FIRST index of the special_features ARRAY.
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[1] = 'Trailers';

--Select all films that have DELETED SCENES in the SECOND index of the special_features ARRAY.
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[2] = 'Deleted Scenes';

--Match 'Trailers' in any index of the special_features ARRAY regardless of position.
SELECT
  title, 
  special_features 
FROM film 
-- Modify the query to use the ANY function 
WHERE 'Trailers'  = ANY (special_features);

/*
The contains operator @> operator is alternative syntax to the ANY function and matches 
data in an ARRAY using the following syntax.
 */

--Use the contains operator to match the text Deleted Scenes in the special_features column.
SELECT 
  title, 
  special_features 
FROM film 
WHERE special_features @> ARRAY['Deleted Scenes'];

-- 2. Working with DATE/TIME Functions and Operators
--Subtract the rental_date from the return_date to calculate the number of days_rented.
SELECT f.title, f.rental_duration,
    r.return_date - r.rental_date AS days_rented
FROM film AS f
     INNER JOIN inventory AS i ON f.film_id = i.film_id
     INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

--AGE()
--Now use the AGE() function to calculate the days_rented.
SELECT f.title, f.rental_duration,
	AGE(return_date, rental_date) AS days_rented
FROM film AS f
	INNER JOIN inventory AS i ON f.film_id = i.film_id
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

--INTERVAL
--to determine what film titles were currently out for rental with customers
SELECT
	f.title,
 	-- Convert the rental_duration to an interval
    INTERVAL '1' day * f.rental_duration,
 	-- Calculate the days rented as we did previously
    r.return_date - r.rental_date AS days_rented
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
-- Filter the query to exclude outstanding rentals
WHERE r.return_date IS NOT NULL
ORDER BY f.title;

--to calculate the actual expected return date of a specific rental
SELECT
    f.title,
	r.rental_date,
    f.rental_duration,
    -- Add the rental duration to the rental date
    INTERVAL '1' day * f.rental_duration + r.rental_date AS expected_return_date,
    r.return_date
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

-- NOW(), CURRENT_TIMESTAMP, CURRENT_DATE, CURRENT_TIME, CAST()
SELECT NOW(), CURRENT_TIMESTAMP, CURRENT_DATE, CURRENT_TIME;

--Select the current timestamp without timezone
SELECT CURRENT_TIMESTAMP::timestamp AS right_now;

--current timestamp without a timezone
SELECT CAST( NOW() AS timestamp );

SELECT 
    -- CAST the result of the NOW() function to a date
    CAST( NOW() AS date );
    
SELECT
	CURRENT_TIMESTAMP(0)::timestamp AS right_now,
    interval '5 days' + CURRENT_TIMESTAMP(0) AS five_days_from_now;
    
-- EXTRACT()
   
-- Count the total number of rentals by day of the week.
SELECT 
-- Extract day of week from rental_date
  EXTRACT(dow FROM rental_date) AS dayofweek, 
  COUNT(*) as rentals 
FROM rental 
GROUP BY 1;

-- DATE_TRUNC()
-- truncate timestamp or interval data types to return a timestamp or interval at a specified precision

-- Truncate rental_date by year
SELECT DATE_TRUNC('year', rental_date) AS rental_year
FROM rental;

--count the total number of rentals by rental_day (TRUNCATE by day) and alias it as rentals.
SELECT 
  DATE_TRUNC('day', rental_date) AS rental_day,
  Count(*) AS rentals 
FROM rental
GROUP BY 1;

--extract a list of customers and their rental history over 90 days.
SELECT 
  c.first_name || ' ' || c.last_name AS customer_name,
  f.title,
  r.rental_date,
  -- Extract the day of week date part from the rental_date
  EXTRACT(dow FROM r.rental_date) AS dayofweek,
  AGE(r.return_date, r.rental_date) AS rental_days,
  -- Use DATE_TRUNC to get days from the AGE function
  CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > 
  -- Calculate number of d
    f.rental_duration * INTERVAL '1' day 
  THEN TRUE 
  ELSE FALSE END AS past_due 
FROM 
  film AS f 
  INNER JOIN inventory AS i 
  	ON f.film_id = i.film_id 
  INNER JOIN rental AS r 
  	ON i.inventory_id = r.inventory_id 
  INNER JOIN customer AS c 
  	ON c.customer_id = r.customer_id 
WHERE 
  -- Use an INTERVAL for the upper bound of the rental_date 
  r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';
  
-- 3. Parsing and Manipulating Text
-- CONCAT
 
--Concatenate the first_name and last_name columns separated by a single space followed by email surrounded by < and >.
SELECT first_name || ' ' || last_name || ' <' || email || '>' AS full_email 
FROM customer;

-- Use the CONCAT() function to do the same operation as the previous step.
SELECT CONCAT(first_name, ' ', last_name,  ' <', email, '>') AS full_email 
FROM customer;

-- UPPER, LOWER, INITCAP
SELECT 
  -- Concatenate the category name to coverted to uppercase
  -- to the film title converted to title case
  UPPER(c.name)  || ': ' || INITCAP(f.title) AS film_category, 
  -- Convert the description column to lowercase
  LOWER(f.description) AS description
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;
  	
-- REPLACE()
-- Replace whitespace in the film title with an underscore
SELECT 
  REPLACE(title, ' ', '_') AS title
FROM film; 

-- CHAR_LENGTH(), LENGTH()

-- Determine the length of the description column
SELECT 
  title,
  description,
  CHAR_LENGTH(description) AS desc_len,
  LENGTH(description) AS desc_len2
FROM film;

-- LEFT(), RIGHT()

-- Select the first 50 characters of description
SELECT 
  LEFT(description, 50) AS short_desc
FROM 
  film AS f; 

 
-- SUBSTRING(), POSITION()
 
-- Select only the street name from the address table
SELECT
	address,
	SUBSTRING(address FROM POSITION(' ' IN address)+1 FOR CHAR_LENGTH(address)) -- +1 TO EXCLUDE ' ' POSITION
FROM 
  address;

-- to break apart the email column from the customer table into three new derived fields.
SELECT
	email,
  -- Extract the characters to the left of the '@'
  LEFT(email, POSITION('@' IN email)-1) AS username,
  -- Extract the characters to the right of the '@'
  SUBSTRING(email, POSITION('@' IN email)+1, CHAR_LENGTH(email)) AS DOMAIN
FROM customer;

-- PADDING ; LPAD(), RPAD()
-- Default padding is space ' '

-- Concatenate the first_name and last_name 
SELECT 
	first_name || LPAD(last_name, LENGTH(last_name)+1) AS full_name
FROM customer; 

/*
Add a single space to the right or end of the first_name column.
Add the characters < to the right or end of last_name column.
Finally, add the characters > to the right or end of the email column.
 */ 
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) 
    || RPAD(last_name, LENGTH(last_name)+2, ' <') 
    || RPAD(email, LENGTH(email)+1, '>') AS full_email
FROM customer; 

-- TRIM()

SELECT 
  CONCAT(UPPER(c.name), ': ', f.title) AS film_category, 
  -- Truncate the description remove trailing whitespace
  TRIM(LEFT(description, 50)) AS film_desc
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

-- truncate text fields like the film table's description column without cutting off a word.
SELECT 
  UPPER(c.name) || ': ' || f.title AS film_category, 
  -- Truncate the description without cutting off a word
  LEFT(
  	description, 50 - POSITION(' ' IN REVERSE(LEFT(description, 50))) -- Subtract the position of the first whitespace character
  ),
--  FOR UNDERSTANDING HOW ITS WORK
  REVERSE(LEFT(description, 50)), POSITION(' ' IN REVERSE(LEFT(description, 50)))
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;
  	
SELECT REVERSE(LEFT(description, 50)), POSITION(' ' IN REVERSE(LEFT(description, 50)))
FROM film f ;

-- 4. Full-text Search and PostgresSQL Extensions
-- Full text search provides a means for performing natural language queries of text data in your database.

-- TSVECTOR, TSQUERY
-- searches for text case-insensitively

-- Select the film description as a tsvector
SELECT to_tsvector(description)
FROM film;

-- Perform a full-text search on the title column for the word elf
SELECT title, description
FROM film
-- Convert the title to a tsvector and match it against the tsquery 
WHERE to_tsvector(title) @@ to_tsquery('elf');

-- USER-DEFINED DATA TYPES

/*ENUM or enumerated data types 
are great options to use in your database when you have a column 
where you want to store a fixed list of values that rarely change
*/
-- Create an enumerated data type, compass_position
CREATE TYPE compass_position AS ENUM (
  	-- Use the four cardinal directions
  	'North', 
  	'South',
  	'East', 
  	'West'
);
-- Confirm the new data type is in the pg_type system table
SELECT typname, typcategory
FROM pg_type
WHERE typname='compass_position'; -- typcategory E is mean ENUM

-- Getting info about user-defined data types
-- Select the column name, data type and udt name columns
SELECT column_name, data_type, udt_name
FROM INFORMATION_SCHEMA.COLUMNS 
-- Filter by the rating column in the film table
WHERE table_name ='film' AND column_name='rating';

SELECT *
FROM pg_type 
WHERE typname='mpaa_rating' -- mpaa_rating IS user-defined data TYPES IN Sakila DATABASE

-- USER-DEFINED FUNCTIONS
-- EXAMPLE SYNTAX FOR BUILD FUNCTION IN SQL
/*
CREATE FUNCTION squared(i integer) RETURNS integer AS $$
BEGIN
RETURN i * i;
END;
$$ LANGUAGE plpgsql
*/

-- determine which film title is currently held by which customer using the inventory_held_by_customer() function
SELECT 
	f.title, 
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
	-- inventory_held_by_customer() IS FUNCTION THAT ALREADY IN SAKILA DATABASE
    inventory_held_by_customer(i.inventory_id) as held_by_cust 
FROM film as f 
	INNER JOIN inventory AS i ON f.film_id=i.film_id 
WHERE
	-- Only include results where the held_by_cust is not null
    inventory_held_by_customer(i.inventory_id) IS NOT NULL
    
    
-- EXTENSION

-- check extension on postgresSQL
-- Select all rows extensions
SELECT * 
FROM pg_extension;

-- Enable the pg_trgm and fuzzystrmatch extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

-- use extension 
-- Calculate the similarity between the title and description
SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(title, description)
FROM film;
  
-- the levenshtein distance represents the number of edits required to convert one string to another string being compared.
-- Calculate the levenshtein distance for the film title with the string JET NEIGHBOR.
SELECT  
  title, 
  description, 
  -- Calculate the levenshtein distance
  levenshtein(title, 'JET NEIGHBOR') AS distance
FROM film
ORDER BY 3;

-- calculates the similarity of the description with the phrase 'Astounding Drama'.
SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(description, 'Astounding Drama')
FROM film 
WHERE 
  to_tsvector(description) @@ to_tsquery('Astounding & Drama') -- SEARCH for descriptions containing 'Astounding & Drama'
ORDER BY similarity(description, 'Astounding Drama') DESC;