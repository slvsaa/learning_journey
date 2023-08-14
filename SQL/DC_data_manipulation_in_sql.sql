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
	ROUND(AVG(m.home_team_goal + m.away_team_goal),2) AS avg_goals,
    -- Subtract the overall average from the league average
	ROUND(AVG(m.home_team_goal + m.away_team_goal) -
		(SELECT AVG(home_team_goal + away_team_goal)
		 FROM matches 
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN matches AS m
ON l.country_id = m.country_id
WHERE season = '2013/2014'
GROUP BY l.name;

-- Complicated SUBQUERIES 
SELECT 
	-- Select the stage and average goals from s
	stage,
    ROUND(avg_goals,2) AS avg_goal,
    -- Select the overall average for 2012/2013
    (SELECT AVG(home_team_goal + away_team_goal) FROM matches WHERE season = '2012/2013') AS overall_avg
FROM 
	-- Select the stage and average goals in 2012/2013 from match
	(SELECT
		 stage,
         AVG(home_team_goal + away_team_goal) AS avg_goals
	 FROM matches
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_team_goal  + away_team_goal) 
                    FROM matches WHERE season = '2012/2013');
                    
-- CORRELATED SUBQUERIES 
-- takes a lot more computing power and time than a simple subquery
                   
-- to examine matches with scores that are extreme outliers for each country -- above 3 times the average score!
SELECT 
	-- Select country ID, date, home, and away goals from match
	main.country_id,
    main.date,
    main.home_team_goal, 
    main.away_team_goal
FROM matches AS main
WHERE 
	-- Filter the main query by the subquery
	(home_team_goal + away_team_goal) > 
        (SELECT AVG((sub.home_team_goal + sub.away_team_goal) * 3)
         FROM matches AS sub
         -- Join the main query to the subquery in WHERE
         WHERE main.country_id = sub.country_id);
         
-- NESTED SUBQUERIES
        
-- to examine the highest total number of goals in each season, overall, and during July across all seasons.
SELECT
	-- Select the season and max goals scored in a match
	season,
    max(home_team_goal + away_team_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT max(home_team_goal + away_team_goal) FROM matches) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT max(home_team_goal  + away_team_goal) 
    FROM matches
    WHERE id IN (
          SELECT id FROM matches WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM matches
GROUP BY season;

-- What's the average number of matches per season where a team scored 5 or more goals? How does this differ by country?
SELECT
	c.name AS country,
    -- Calculate the average matches per season
	AVG(outer_s.matches) AS avg_seasonal_high_scores
FROM country AS c
-- Left join outer_s to country
LEFT JOIN (
  SELECT country_id, season,
         COUNT(id) AS matches
  FROM (
    SELECT country_id, season, id
	FROM matches
	WHERE home_team_goal >= 5 OR away_team_goal >= 5) AS inner_s
  -- Close parentheses and alias the subquery
  GROUP BY country_id, season) AS outer_s
ON c.id = outer_s.country_id
GROUP BY country;

-- COMMON TABLE EXPRESSIONS (CTE)

-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM matches
    WHERE (home_team_goal + away_team_goal) >= 10)
-- end CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

-- CTE
WITH match_list AS (
    SELECT 
  		l.name AS league, 
     	m.date, 
  		m.home_team_goal, 
  		m.away_team_goal,
      (m.home_team_goal + m.away_team_goal) AS total_goals
    FROM matches AS m
    LEFT JOIN league as l ON m.country_id = l.id)
-- end CTE
SELECT league, date, home_team_goal, away_team_goal
FROM match_list
WHERE total_goals >= 8;

-- CTE with nested
WITH match_list AS (
    SELECT 
  		country_id,
  		(home_team_goal + away_team_goal) AS goals
    FROM matches
    WHERE id IN (
       SELECT id
       FROM matches
       WHERE season = '2013/2014' AND EXTRACT(MONTH FROM date) = 03))
-- end CTE
SELECT 
	name,
	AVG(goals)
FROM league AS l
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;


-- DIFFERENT USE FOR MANIPULATION DATA
-- Get team names with Subquery
SELECT
	m.date,
    -- Get the home and away team names
    hometeam,
    awayteam,
    m.home_team_goal,
    m.away_team_goal
FROM matches AS m
-- Join the HOME subquery to the match table
LEFT JOIN (
	SELECT matches.id, team.team_long_name AS hometeam
	FROM matches
	LEFT JOIN team
	ON matches.home_team_api_id = team.team_api_id) AS home
ON home.id = m.id
-- Join the AWAY subquery to the match table
LEFT JOIN (
	SELECT matches.id, team.team_long_name AS awayteam
	FROM matches
	LEFT JOIN team
	ON matches.away_team_api_id = team.team_api_id) AS away
ON away.id = m.id;

-- Get team names with correlated subqueries
SELECT
    m.date,
    -- hometeam
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.home_team_api_id) AS hometeam,
    -- awayteam
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.away_team_api_id) AS awayteam,
    -- Select home and away goals
     home_team_goal,
     away_team_goal
FROM matches AS m;

-- Get team names with CTEs
WITH home AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS hometeam, m.home_team_goal
  FROM matches AS m
  LEFT JOIN team AS t 
  ON m.home_team_api_id = t.team_api_id),
-- away CTE
away AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS awayteam, m.away_team_goal
  FROM matches AS m
  LEFT JOIN team AS t 
  ON m.away_team_api_id = t.team_api_id)
-- Select date, home_goal, and away_goal
SELECT 
	home.date,
    home.hometeam,
    away.awayteam,
    home.home_team_goal,
    away.away_team_goal
-- Join away and home on the id column
FROM home
INNER JOIN away
ON home.id = away.id;

-- WINDOWS FUNCTION
-- OVER
-- to pass an aggregate function down a data set, similar to subqueries in SELECT
SELECT 
	m.id, 
    c.name AS country, 
    m.season,
	m.home_team_goal,
	m.away_team_goal,
    -- Use a window to include the aggregate average in each row
	AVG(m.home_team_goal + m.away_team_goal) OVER() AS overall_avg
FROM matches AS m
LEFT JOIN country AS c ON m.country_id = c.id;

-- RANK
-- ASC
SELECT 
	l.name AS league,
    AVG(m.home_team_goal + m.away_team_goal) AS avg_goals,
    -- Rank each league according to the average goals
    RANK() OVER(ORDER BY AVG(m.home_team_goal + m.away_team_goal)) AS league_rank
FROM league AS l
LEFT JOIN matches AS m 
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;

-- DESC
SELECT 
	l.name AS league,
    AVG(m.home_team_goal + m.away_team_goal) AS avg_goals,
    -- Rank leagues in descending order by average goals
    RANK() OVER(ORDER BY AVG(m.home_team_goal + m.away_team_goal) DESC) AS league_rank
FROM league AS l
LEFT JOIN matches AS m 
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;

-- PARTITION BY
-- allows you to calculate separate "windows" based on columns you want to divide your results
SELECT
	date,
	season,
	home_team_goal,
	away_team_goal,
	CASE WHEN home_team_api_id = 9991 THEN 'home' 
		 ELSE 'away' END AS warsaw_location,
    -- Calculate the average goals scored partitioned by season
    AVG(home_team_goal) OVER(PARTITION BY season) AS season_homeavg,
    AVG(away_team_goal) OVER(PARTITION BY season) AS season_awayavg
FROM matches
WHERE 
	home_team_api_id = 9991 
    OR away_team_api_id = 9991
ORDER BY (home_team_goal + away_team_goal) DESC;

SELECT 
	date,
	season,
	home_team_goal,
	away_team_goal,
	CASE WHEN home_team_api_id = 9991 THEN 'home' 
         ELSE 'away' END AS warsaw_location,
	-- Calculate average goals partitioned by season and month
    AVG(home_team_goal) OVER(PARTITION BY season, 
         	EXTRACT(MONTH FROM date)) AS season_mo_home,
    AVG(away_team_goal) OVER(PARTITION BY season, 
            EXTRACT(MONTH FROM date)) AS season_mo_away
FROM matches
WHERE 
	home_team_api_id = 9991 
    OR away_team_api_id = 9991
ORDER BY (home_team_goal + away_team_goal) DESC;

-- SLIDING WINDOWS 
-- to create running calculations between any two points in a window using functions such as PRECEDING, FOLLOWING, and CURRENT ROW

/*
ROWS or RANGE- specifying rows or range.
PRECEDING – get rows before the current one.
FOLLOWING – get rows after the current one.
UNBOUNDED – when used with PRECEDING or FOLLOWING, it returns all before or after.
CURRENT ROW
*/
SELECT 
	date,
	home_team_goal,
	away_team_goal,
    -- Create a running total and running average of home goals
    SUM(home_team_goal) OVER(ORDER BY date 
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    AVG(home_team_goal) OVER(ORDER BY date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM matches
WHERE 
	home_team_api_id = 9991 
	AND season = '2011/2012';
	
SELECT 
     date,
    home_team_goal,
	away_team_goal,
    -- Create a running total and running average of home goals
    -- sorting the data set in reverse order and calculating a backward running total from 
	-- the CURRENT ROW to the end of the data set (earliest record).
    SUM(home_team_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_total,
    AVG(away_team_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_avg
FROM matches
WHERE 
	away_team_api_id = 9991
    AND season = '2011/2012';
    
   
-- BRING IT ALL TOGETHER

-- to generate a list of matches in which KAA Gent was defeated during the 2014/2015 English Premier League season.
-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_team_goal > m.away_team_goal THEN 'KG Win'
		   WHEN m.home_team_goal < m.away_team_goal THEN 'KG Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM matches AS m
  LEFT JOIN team AS t ON m.home_team_api_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_team_goal > m.away_team_goal THEN 'KG Loss'
		   WHEN m.home_team_goal < m.away_team_goal THEN 'KG Win' 
  		   ELSE 'Tie' END AS outcome
  FROM matches AS m
  LEFT JOIN team AS t ON m.away_team_api_id = t.team_api_id)
-- Select columns and and rank the matches by goal difference
SELECT DISTINCT
    date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_team_goal,
    m.away_team_goal,
    RANK() OVER(ORDER BY ABS(home_team_goal - away_team_goal) DESC) as match_rank
-- Join the CTEs onto the match table
FROM matches AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND ((home.team_long_name = 'KAA Gent' AND home.outcome = 'KG Loss')
      OR (away.team_long_name = 'KAA Gent' AND away.outcome = 'KG Loss'));