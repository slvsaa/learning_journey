-- PostgreSQL Summary Stats and Window Functions
-- use dc_summary

--1. Introduction to window functions

-- NUMBERING ROWS (ROW_NUMBER())
--allows you to easily fetch the n-th row
--always assigns UNIQUE numbers, even if two rows' values are the SAME
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
-- LAG (column, n) returns column's value at the row n rows before the current row

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
-- LEAD (column, n) 
--returns column's value at the row n rows after the current row

--For each year, fetch the current gold medalist and the gold medalist 3 competitions ahead of the current row
WITH Discus_Medalists AS (
  SELECT DISTINCT
    Years,
    Athlete
  FROM summer 
  WHERE Medal = 'Gold'
    AND Events = 'Discus Throw'
    AND Gender = 'Women'
    AND Years >= 2000)
--end cte
SELECT
  -- For each year, fetch the current and future medalists
  years,
  Athlete,
  LEAD(Athlete,3) OVER (ORDER BY years ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Years ASC;

--FIRST_VALUE(column)
--returns the first value in the table or partition

--Return all athletes and the first athlete ordered by alphabetical order
WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM summer
  WHERE Medal = 'Gold'
    AND Gender = 'Men')
--end cte
SELECT
  -- Fetch all athletes and the first athlete alphabetically
  Athlete,
  FIRST_VALUE(Athlete) OVER (
    ORDER BY Athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;

--LAST_VALUE (column) 
--returns the last value in the table or partition

--Fetch the last city in which the Olympic games were held.
WITH Hosts AS (
  SELECT DISTINCT Years, City
    FROM summer)
--end cte
SELECT
  years ,
  City,
  -- Get the last city in which the Olympic games were held
  LAST_VALUE (city)  OVER (
   ORDER BY years ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Years ASC;

--RANK ()
--assigns the same number to rows with identical values, skipping over the NEXT numbers in such cases
-- ex: ROW_NUMBER 1 2 3 4 5 ; RANK 1 2 2 4 5

/* 
Rank each athlete by the number of medals they've earned 
-- the higher the count, the higher the rank -- 
with identical numbers in case of identical values.
*/
WITH Athlete_Medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM summer s 
  GROUP BY Athlete)
--end cte
SELECT
  Athlete,
  Medals,
  -- Rank athletes by the medals they've won
  RANK() OVER (ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Medals DESC;

--DENSE_RANK()
--also assigns the same number to rows with identical values, but doesn't skip over the next numbers
-- ex: ROW_NUMBER 1 2 3 4 5 ; RANK 1 2 2 4 5 ; DENSE_RANK 1 2 2 3 4

/*
Rank each country's athletes by the count of medals they've earned 
-- the higher the count, the higher the rank -- without skipping numbers in case of identical values.
 */
WITH Athlete_Medals AS (
  SELECT
    Country, Athlete, COUNT(*) AS Medals
  FROM summer
  WHERE
    Country IN ('JPN', 'KOR')
    AND Years >= 2000
  GROUP BY Country, Athlete
  HAVING COUNT(*) > 1)
--end cte
SELECT
  Country,
  -- Rank athletes in each country by the medals they've won
  Athlete,
  DENSE_RANK() OVER (PARTITION BY country
                ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Country ASC, RANK_N ASC;

--PAGING: Splitting data into (approximately) equal chunks
--NTILE (n)
--splits the data into n approximately equal pages

--Split the distinct events into exactly 111 groups, ordered by event in alphabetical order.
WITH Events AS (
  SELECT DISTINCT Events
  FROM summer)
--END cte
SELECT
  --- Split up the distinct events into 111 unique groups
  Events,
  NTILE(111) OVER (ORDER BY Events ASC) AS Page
FROM Events
ORDER BY Events ASC;

--Split the athletes into top, middle, and bottom thirds based on their count of medals.
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM summer s 
  GROUP BY Athlete
  HAVING COUNT(*) > 1)
--end cte
SELECT
  Athlete,
  Medals,
  -- Split athletes into thirds by their earned medals
  NTILE(3) OVER(ORDER BY Medals DESC) AS Third
FROM Athlete_Medals
ORDER BY Medals DESC, Athlete ASC;

--Return the average of each third.
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM summer
  GROUP BY Athlete
  HAVING COUNT(*) > 1),
Thirds AS (
  SELECT
    Athlete,
    Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
  FROM Athlete_Medals)
-- end cte
SELECT
  -- Get the average medals earned in each third
  Third,
  AVG(medals) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;

--3. Aggregate window functions and frames