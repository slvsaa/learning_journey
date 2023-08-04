-- Intermediate SQL
USE dc_films;
-- COUNT
-- COUNT(field_name) >> count the number of records with value in a FIELD, NULL NOT include
-- COUNT(*) >> count records in TABLE, NULL include
SELECT COUNT(gross) AS count_gross, count(*) AS count_records
FROM films;

-- DISTINCT 
-- remove duplicates to return only unique values
SELECT DISTINCT country
FROM films;

-- COUNT and DISTINCT 
-- Count unique VALUES 
SELECT count(DISTINCT country) unique_country
FROM films;

-- WHERE 
-- One Criteria
SELECT film_id, imdb_score
FROM reviews
WHERE imdb_score > 7.0;

SELECT Count(*) as films_over_100K_votes
from reviews
where num_votes >= 100000;

select Count(*) as count_spanish
from films
where language = 'Spanish';

-- Multiple Criteria 
-- AND, OR, BETWEEN 
select title, release_year
from films
where language = 'German' and release_year < 2000;

select *
from films
where release_year > 2000 
    and release_year < 2010 
    and language = 'German';
   
SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
	and (language = 'English' or language = 'Spanish');

SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
	AND (language = 'English' OR language = 'Spanish')
	and gross > 2000000;

Select title, release_year
from films
where release_year BETWEEN 1990 and 2000;

SELECT title, release_year
FROM films
WHERE (release_year BETWEEN 1990 AND 2000)
-- Narrow down your query to films with budgets > $100 million
	and budget > 100000000;

SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
	AND budget > 100000000
-- Amend the query to include Spanish or French-language films
	AND (language = 'Spanish' OR language = 'French');

-- FILTERING TEXT
-- LIKE, NOT LIKE, IN

-- % >> match zero, one, or many CHARACTERS 
SELECT name
FROM people
WHERE name LIKE 'B%'; -- whose names begin with 'B'.

-- _ >> match a single CHARACTERS 
SELECT name
FROM people
-- Select the names that have r as the SECOND letter
WHERE name LIKE '_r%';

SELECT name
FROM people
-- Select names that don't start with A
WHERE name NOT LIKE 'A%';

SELECT  title, release_year
FROM  films
WHERE  release_year IN (1990, 2000)
    AND duration > 120;
   
SELECT title, language
FROM films
WHERE language in ('English', 'Spanish', 'French');

-- NULL 
SELECT title AS no_budget_info
FROM films
WHERE budget IS NULL;

SELECT count(language) AS count_language_known
FROM films; -- NULL NOT include 

-- AGGREGATE FUNCTION
-- AVG, SUM, COUNT, MIN, MAX 
-- COUNT, MIN, MAX can use in non-numerical values
-- Operations Vertically
SELECT sum(duration) AS total_duration
FROM films;

SELECT avg(duration) AS average_duration
FROM films;

SELECT max(release_year) AS latest_year
FROM films;

SELECT sum(gross) AS total_gross
FROM films
WHERE release_year >= 2000;

-- Round
-- Round a number to a specified decimal, ROUND(number_want_to_round, how_many_decimal_you_want)
SELECT round(avg(num_votes),1) AS avg_num_votes
FROM reviews;

-- Negative ROUND 
-- Calculate the average budget rounded to the thousands
SELECT round(avg(budget),0) AS avg_budget_thousands
FROM films;

SELECT round(avg(budget),-3) AS avg_budget_thousands
FROM films;

-- Arithmetic
-- + - / *
-- Operations Horizontally
SELECT (4 / 3);
SELECT (4.0 / 3.0);

SELECT title, duration/60.0 as duration_hours
FROM films;

SELECT count(deathdate) * 100 / count(*) AS percentage_dead
FROM people; -- missing VALUES NOT identified AS null

SELECT title, round((duration / 60.0),2) AS duration_hours
FROM films;

-- SELECT name, deathdate 
-- FROM people p 
-- WHERE deathdate <> ''; 

-- ORDER BY
-- Default ASC, from small to big
-- DESC, from big to small 
SELECT name
FROM people
ORDER BY name;

SELECT certification, release_year, title
FROM films
ORDER BY certification, release_year DESC ; -- certification ASC, release_year DESC 

-- GROUP BY 
SELECT release_year, count(*) AS film_count
FROM films
GROUP BY release_year;

SELECT release_year, country, max(budget) AS max_budget
FROM films
GROUP BY release_year, country
ORDER BY release_year, country;

-- HAVING 
-- Filtering for GROUP VALUES
SELECT country, count(DISTINCT certification) AS certification_count
FROM films
-- Group by country
GROUP BY country
-- Filter results to countries with more than 10 different certifications
HAVING count(DISTINCT certification) > 10;

SELECT country, round(avg(budget),2) AS average_budget
FROM films
GROUP BY country
HAVING round(avg(budget),2) > 1000000000
ORDER BY round(avg(budget),2) DESC ;

SELECT release_year, count(title)
FROM films
WHERE release_year > 1990 -- USE WHERE because NOT filtering GROUP values 
GROUP BY release_year;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross 
FROM films 
WHERE release_year > 1990 -- filtering non group
GROUP BY release_year 
HAVING AVG(budget) > 60000000; -- filtering group

-- EXECUTE ORDER
-- FROM, GROUP BY, WHERE, SELECT, ORDER BY, LIMIT
-- FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT