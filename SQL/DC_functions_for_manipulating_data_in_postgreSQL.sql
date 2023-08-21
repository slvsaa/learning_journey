--Functions for Manipulating Data in PostgreSQL

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