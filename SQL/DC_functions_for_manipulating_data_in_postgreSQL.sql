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