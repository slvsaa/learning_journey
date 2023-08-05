-- Data Manipulation in SQL
USE dc_soccer;

-- CASE
SELECT 
	CASE 
		WHEN home_team_api_id = 9991 THEN 'KAA Gent'
        WHEN home_team_api_id = 1773 THEN 'Oud-Heverlee Leuven'
        ELSE 'Other' 
    END AS home_team,
	COUNT(id) AS total_matches
FROM matches
-- Group by the CASE statement alias
GROUP BY 1;

SELECT 
	date,
	team_long_name AS opponent,
	-- Identify home wins, losses, or ties
	CASE
		WHEN home_team_goal > away_team_goal THEN 'KAA Gent win!'
        WHEN home_team_goal < away_team_goal THEN 'KAA Gent loss :(' 
        ELSE 'Tie' 
    END AS outcome
FROM matches m
LEFT JOIN team t 
ON m.away_team_api_id = t.team_api_id
WHERE home_team_api_id = 9991; -- AS home team

SELECT 
	date,
	home_team_api_id,
	team_long_name AS opponent,
	-- Identify home wins, losses, or ties
	CASE
		WHEN home_team_goal < away_team_goal THEN 'KAA Gent win!'
        WHEN home_team_goal > away_team_goal THEN 'KAA Gent loss :(' 
        ELSE 'Tie' 
    END AS outcome
FROM matches m
LEFT JOIN team t 
ON m.home_team_api_id = t.team_api_id
WHERE away_team_api_id = 9991; -- AS away team

SELECT 
	date,
	CASE WHEN home_team_api_id = 9991 THEN 'KAA Gent' 
         ELSE 'Oud-Heverlee Leuven' END as home,
	CASE WHEN away_team_api_id = 9991 THEN 'KAA Gent'
         ELSE 'Oud-Heverlee Leuven' END as away,
	-- Identify all possible match outcomes
	CASE WHEN home_team_goal > away_team_goal AND home_team_api_id = 9991 THEN 'KAA Gent win!'
        WHEN home_team_goal > away_team_goal AND home_team_api_id = 1773 THEN 'Oud-Heverlee Leuven win!'
        WHEN home_team_goal < away_team_goal AND away_team_goal = 9991 THEN 'KAA Gent win!'
        WHEN home_team_goal < away_team_goal AND away_team_goal = 1773 THEN 'Oud-Heverlee Leuven win!'
        ELSE 'Tie!' END AS outcome
FROM matches
WHERE (away_team_api_id = 9991 OR home_team_api_id = 9991)
      AND (away_team_api_id = 1773 OR home_team_api_id = 1773);
      
SELECT 
	season,
	date,
    -- Identify when KAA Gent won a match
	CASE 
		WHEN home_team_api_id = 9991 AND home_team_goal > away_team_goal THEN 'KAA Gent Win'
		WHEN away_team_api_id = 9991 AND away_team_goal > home_team_goal THEN 'KAA Gent Win' 
	END AS outcome
FROM matches; -- there is a null value

-- Select the season, date, home_goal, and away_goal columns
SELECT 
	season,
    date,
	home_team_goal,
	away_team_api_id
FROM matches
WHERE 
-- Exclude games not won by Bologna
	CASE 
		WHEN home_team_api_id = 9991 AND home_team_goal > away_team_goal THEN 'KAA Gent Win'
		WHEN away_team_api_id = 9991 AND away_team_goal > home_team_goal THEN 'KAA Gent Win' 
	END IS NOT NULL; -- TO IGNORE NULL VALUES (same as WHERE column_a IS NOT NULL)
	
-- CASE in WHEN with AGGREGATE
SELECT 
	c.name AS country,
    -- Count games from the 2012/2013 season
	COUNT(CASE WHEN m.season = '2012/2013' 
        	THEN m.id ELSE NULL END) AS matches_2012_2013
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY c.name;

SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	COUNT(CASE WHEN m.season = '2012/2013' THEN m.id END) AS matches_2012_2013,
	COUNT(CASE WHEN m.season = '2013/2014' THEN m.id END) AS matches_2013_2014,
	COUNT(CASE WHEN m.season = '2014/2015' THEN m.id END) AS matches_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY C.name;

SELECT 
	c.name AS country,
    -- Sum the total records in each season where the home team won
	SUM(CASE WHEN m.season = '2012/2013' AND m.home_team_goal > m.away_team_goal 
        THEN 1 ELSE 0 END) AS matches_2012_2013,
 	SUM(CASE WHEN m.season = '2013/2014' AND m.home_team_goal > m.away_team_goal 
        THEN 1 ELSE 0 END) AS matches_2013_2014,
	SUM(CASE WHEN m.season = '2014/2015' AND m.home_team_goal > m.away_team_goal 
        THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY c.name;


-- Identify tie matches
SELECT 
	c.name AS country,
	ROUND(AVG(CASE WHEN m.season='2013/2014' AND m.home_team_goal = m.away_team_goal  THEN 1 -- 1 FOR CONDITION is MET
			 WHEN m.season='2013/2014' AND m.home_team_goal != m.away_team_goal  THEN 0 -- 0 FOR CONDITION is NOT MET
			 END),2) AS pct_ties_2013_2014,
	ROUND(AVG(CASE WHEN m.season='2014/2015' AND m.home_team_goal = m.away_team_goal  THEN 1
			 WHEN m.season='2014/2015' AND m.home_team_goal != m.away_team_goal  THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

-- SUBQUERIES
-- can be un any part of a query: SELECT, FROM, WHERE, GROUP BY 
SELECT 
    date,
	home_team_goal,
	away_team_goal 
FROM  matches
-- Filter for matches where total goals exceeds 3x the average
WHERE (home_team_goal + away_team_goal) > 
       (SELECT 3 * AVG(home_team_goal + away_team_goal)
        FROM matches); 

-- to generate a list of teams that never played a game in their home city.
SELECT 
	team_long_name,
	team_short_name
FROM team 
-- Exclude all values from the subquery
WHERE team_api_id NOT IN
     (SELECT DISTINCT home_team_api_id FROM matches m);

    
-- creating a list of teams that scored 7 or more goals in a home match
SELECT
	team_long_name,
	team_short_name
FROM team
WHERE team_api_id IN
	  (SELECT home_team_api_id
       FROM matches
       WHERE home_team_goal >= 7);
       
-- SUBQUERY in FROM
-- to generate a subquery using the match table, and then join that subquery to the country table to calculate information about 
-- matches with 9 or more goals in total!
SELECT
    name AS country_name,
    COUNT(sub.id) AS matches
FROM country AS c
-- Inner join the subquery onto country
-- Select the country id and match id columns
INNER JOIN (SELECT country_id, id
           FROM matches m 
           -- Filter the subquery by matches with 9+ goals
           WHERE (home_team_goal + away_team_goal) >= 9) AS sub
ON c.id = sub.country_id
GROUP BY country_name;  


SELECT
    country,
    date,
    home_team_goal,
    away_team_goal
FROM 
	(SELECT c.name AS country, 
     	    m.date, 
     		m.home_team_goal, 
     		m.away_team_goal,
           (home_team_goal + m.away_team_goal) AS total_goals
    FROM matches AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subq
WHERE total_goals >= 9;

-- SUBQUERY in SELECT 
-- calculates the average number of goals per match in each country's league.
SELECT 
	l.name AS league,
    ROUND(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals,
    -- Select & round the average total goals for the SEASON
    (SELECT ROUND(AVG(home_team_goal + away_team_goal), 2) 
     FROM matches
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN matches AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY l.name;


-- add a column that directly compares these values by subtracting the overall average from the subquery
SELECT
	name AS league,
	ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Subtract the overall average from the league average
	ROUND(AVG(m.home_goal + m.away_goal) -
		(SELECT AVG(home_goal + away_goal)
		 FROM match 
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
WHERE season = '2013/2014'
GROUP BY l.name;

