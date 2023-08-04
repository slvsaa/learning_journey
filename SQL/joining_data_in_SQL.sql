-- Joining Data in SQL
USE dc_countries;

-- INNER JOIN
-- Have MATCHING VALUES in BOTH table
SELECT c.code AS country_code, country_name, year, inflation_rate
FROM countries AS c
INNER JOIN economies as e
ON c.code = e.code;

SELECT c.country_name  AS country, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
using (code); -- Kegunaan sama seperti ON, namun hanya bisa digunakan jika nama kolom sama 

SELECT 
	c1.name AS city, 
    code, 
    c2.country_name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;

-- Multiple JOIN 
SELECT c.country_name, p.year, p.fertility_rate, e.year, e.unemployment_rate
FROM countries AS c -- TABLE 1
INNER JOIN populations AS p -- TABLE 2
ON c.code = p.country_code
INNER Join economies AS e -- TABLE 3
ON p.country_code = e.code;

-- More than one condition to join table
SELECT country_name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code -- CONDITION 1
	and (p.year = e.year); -- CONDITION 2
	
-- LEFT JOIN or LEFT OUTER JOIN
-- Return ALL RECORDS in the LEFT table, and those records in the RIGHT that MATCH on the left table
SELECT 
	c1.name AS city, 
    code, 
    c2.country_name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
LEFT JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;

SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
GROUP BY region
ORDER BY avg_gdp DESC 
LIMIT 10;
	
-- RIGHT JOIN or RIGHT OUTER JOIN
-- Return ALL RECORDS in the RIGHT table, and those records in the LEFT that MATCH on the left table
SELECT 
	c.country_name AS country, 
	l.name AS language, 
	percent
FROM languages l
RIGHT JOIN countries c
USING(code)
ORDER BY language;

-- FULL JOIN or FULL OUTER JOIN 
-- combination Left and Right join
-- In MySQL FULL JOIN can't be use, so do LEFT > UNION > RIGHT to FULL JOIN

-- actual syntax
-- SELECT country_name AS country, code, region, basic_unit
-- FROM countries
-- FULL JOIN currencies
-- USING (code)
-- WHERE region = 'North America' OR region IS NULL
-- ORDER BY region;

-- MySQL syntax 
SELECT country_name AS country, code, region, basic_unit
FROM countries 
LEFT JOIN currencies 
USING (code)
WHERE region = 'North America' OR region IS NULL
ORDER BY region

UNION

SELECT country_name AS country, code, region, basic_unit
FROM countries
RIGHT JOIN currencies 
USING (code)
WHERE region = 'North America' OR region IS NULL
ORDER BY region;

-- CROSS JOIN 
-- Creates all possible COMBINATIONS of two tables
SELECT 
	c.country_name AS country,
	l.name AS language
FROM countries AS c        
CROSS JOIN languages AS l 
WHERE c.code in ('PAK','IND')
	AND l.code in ('PAK','IND');
	
-- SELF JOIN 
SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
-- Join populations as p1 to itself, alias as p2, on country code
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = 2010
-- Filter such that p1.year is always five years before p2.year
    AND p1.year = (p2.year - 5);
    
-- Set Operations
-- stack fields, not merging tables left to right
-- Must have same number of fields/column for each table
-- Columns must have same field type
   
-- UNION 
-- takes two tables as input, and returns ALL RECORDS from both tables
-- Ignore identical records/duplicates
SELECT *
FROM economies2015
UNION
SELECT *
FROM economies2019
ORDER BY code, year;

SELECT code, year
FROM economies
UNION
SELECT country_code, year
FROM populations
ORDER BY code, year;
   
-- UNION ALL 
-- takes two tables and returns all records from both tables, including duplicates
SELECT code, year
FROM economies
UNION ALL
SELECT country_code, year
FROM populations
ORDER BY code, year;

-- INTERSECT
-- Return the same records from both table, duplicate not included
-- the number of fields and the data type must be same
SELECT name
FROM cities
INTERSECT 
SELECT country_name
FROM countries;

-- EXCEPT
-- Only return records from the left table that are not present in right table
SELECT name
FROM cities
EXCEPT 
SELECT country_name
FROM countries
ORDER BY name;

-- Subqueries
-- Semi JOIN 
SELECT DISTINCT name
FROM languages
WHERE code IN
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;

-- Anti join 
SELECT code, country_name
FROM countries
WHERE continent = 'Oceania' AND code NOT IN (
										SELECT code
										FROM currencies);

-- Subquery in WHERE 
SELECT *
FROM populations
-- Filter for only those populations where life expectancy is 1.15 times higher than average
WHERE life_expectancy > 1.15 * (
	-- search average life_expetancy in 2015	
	SELECT AVG(life_expectancy)
	FROM populations
	WHERE year = 2015) 
AND year = 2015;

SELECT name, country_code, urbanarea_pop
FROM cities
-- Filter using a subquery on the countries table
WHERE name IN (
    SELECT capital
    FROM countries)
ORDER BY urbanarea_pop DESC;

-- Subquery in SELECT 
SELECT c.country_name AS country,
-- Subquery that provides the count of cities   
  (SELECT count(*)
   FROM cities
   WHERE country_code = code) AS cities_num
FROM countries c
ORDER BY cities_num DESC, country
LIMIT 9;

-- Subquery in FROM 
SELECT local_name, lang_num
FROM countries,
  (SELECT code, COUNT(*) AS lang_num
  FROM languages
  GROUP BY code) AS sub
-- Where codes match
WHERE countries.code = sub.code
ORDER BY lang_num DESC;

SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code
    FROM countries
    WHERE gov_form LIKE '%Republic%' OR gov_form LIKE '%Monarchy%' 
  )
ORDER BY inflation_rate;

-- Select fields from cities
SELECT name, country_code, city_proper_pop, metroarea_pop, (city_proper_pop/metroarea_pop)*100 as city_perc
FROM cities
-- Use subquery to filter city name
WHERE name IN (
    SELECT capital
    FROM countries
    WHERE continent = 'Europe' OR continent LIKE '%America'
)
-- Add filter condition such that metroarea_pop does not have null values
    AND metroarea_pop IS NOT NULL
-- Sort and limit the result
ORDER BY city_perc DESC
LIMIT 10;

