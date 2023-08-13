-- PostgreSQL Summary Stats and Window Functions
-- use dc_summary

--1. Introduction to window functions

-- NUMBERING ROWS (ROW_NUMBER())
--allows you to easily fetch the n-th row
SELECT
  years,
  -- Assign numbers to each year
  ROW_NUMBER() OVER() AS Row_N
FROM (
  SELECT DISTINCT years
  FROM summer s
  ORDER BY years ASC
) AS Years
ORDER BY years ASC;

-- ORDER BY inside Windows Function 
-- make an order based on values in Windows Function 
SELECT
  years ,
  -- Assign the lowest numbers to the most recent years
  ROW_NUMBER() OVER (ORDER BY years  DESC) AS Row_N
FROM (
  SELECT DISTINCT years 
  FROM summer s 
) AS Years
ORDER BY YEARS;

-- CTE
WITH Athlete_Medals AS (
  SELECT
    -- Count the number of medals each athlete has earned
    Athlete,
    COUNT(*) AS Medals
  FROM summer s 
  GROUP BY Athlete)
-- END CTE
SELECT
  -- Number each athlete by how many medals they've earned
  athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;

-- LAG 
-- get previous values in column A in to column B

-- CTE
WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    years,
    Country AS champion
  FROM summer
  WHERE
    Discipline = 'Weightlifting' AND
    events = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')
-- end cte
SELECT
  years, Champion,
  -- Fetch the previous year's champion
  LAG(Champion,1) OVER
    (ORDER BY years ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY years ASC;

--PARTITION BY 
--splits the table into partitions based on a column's unique values

--CTE
WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, years, Country
  FROM summer
  WHERE
    years  >= 2000 AND
    Events = 'Javelin Throw' AND
    Medal = 'Gold')
--end CTE
SELECT
  Gender, years ,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(Country,1) OVER (PARTITION BY gender
            ORDER BY years ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Years ASC;

--CTE
WITH Athletics_Gold AS (
  SELECT DISTINCT
    Gender, Years, Events, Country
  FROM summer
  WHERE
    Years >= 2000 AND
    Discipline = 'Athletics' AND
    Events IN ('100M', '10000M') AND
    Medal = 'Gold')
--end cte
SELECT
  Gender, Years, Events,
  Country AS Champion,
  -- Fetch the previous year's champion by gender and event
  LAG(Country,1) OVER (PARTITION BY gender, events
            ORDER BY Years ASC) AS Last_Champion
FROM Athletics_Gold
ORDER BY Events ASC, Gender ASC, Years ASC;

-- 2. Fetching, ranking, and paging
