/* 
** Name: Husandeep kaur
** Assignment: Cheatsheet
** Date: 2024-01-13      
**/

-- -------------------------------------------------------------------
-- connecting with mysql.exe to MariaDB Services
-- typed the following: "mysql -u root -p" into the MariaDB interface

PS C:\Users\parve>mysql -u root -p
Enter password: ***********
Welcome to the MariaDB monitor. Commands end with ; or \g.
Your MariaDB connection id is 11
Server version: 11.4.0-MariaDB mariadb.org binary distribution 
...

MariaDB [(none)]>

--Bin directory path

C:\Program Files\MariaDB 11.4\bin>

--_Data path

D:\_data

--my.ini path

D:\_data\MariaDB 11.4\data\my.ini

-- RESTARTING SERVICES FOR MariaDB
-- Stopping services for mariaDB

C:\Windows\System32>net stop mariaDB
The MariaDB service is stopping..
The MariaDB service was stopped successfully.

-- starting servives for MariaDB

C:\Windows\System32>net start  mariaDB
The MariaDB service is starting..
The MariaDB service was started successfully.

-- -------------------------------------------------------------------
-- COMMENTS

-- single line comment (use always)

/*
multi-
line
comment

use to block out larger sections of code you don't want to run
*/
-- -------------------------------------------------------------------
-- SHOW and USE commands

-- list all database on the database Server
SHOW DATABASES;


SHOW SCHEMAS;

-- connecting to a DATABASE
USE database_name; -- syntax

USE information_schema;
-- Powershell
-- MariaDB [information_schema]>

-- determine database you are in
SELECT DATABASE ();

SHOW TABLES;

DESCRIBE COLLATIONS;

-- -------------------------------------------------------------------
-- listing all uft8mb4 collations, noting we will use
-- utf8mb4_unicode_ci
SELECT collation_name, character_set_name
FROM collations
WHERE character_set_name='utf8mb4'
ORDER BY collation_name;



-- -------------------------------------------------------------------
-- DROP/CREATE database SYNTAX
USE mysql;

DROP DATABASE IF EXISTS database_name;
CREATE DATABASE database_name
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';

USE database_name;

-- -------------------------------------------------------------------
-- DATA TYPES/SELECT/CONDITIONALS
ELECT collation_name, character_set_name -- COLUMNS
FROM collations -- TABLE
WHERE cha
Sracter_set_name='utf8mb4'
ORDER BY collation_name; -- BY DEFAULT ASC



ACTIVE bit NOT NULL DEFAULT 1 -- IF the value IS NOT NULL, it has something IN it, the DEFAULT value FOR it will be zero



-- BIT/boolean is actually a TINYINT(1) or
-- INT(1) only accepting 0 or 1 (FALSE or TRUE)
-- as values
SELECT FALSE AS b0, TRUE AS b1; -- we ARE gonna take this query AND USE it FOR subquery, so it IS TYPE pf a question

-- FALSE returns 0
-- TRUE returns 1
-- b0 and b1 are called labels
-- the results returned after executing this 
-- SQL query are a result set

-- using the temp result set as a subquery
-- in the FROM to do some conditionals in 
-- the SELECT
--
SELECT trs.b0, b1
     , b0=b1, b0<>b1, b0!=b1, b0=b0 -- this <> sign IS NOT equal TO sign
     , trs.b1=TRUE
FROM (SELECT FALSE AS b0, TRUE AS b1) trs; -- trs IS the label(temporary dataset)that we give TO ANY subquery, just the name OF query
-- subquery name could be anything, it could be tf or kfh or anything which we call alias


-- 1.1 -> NUMERIC(2,1) 2 stands for the size of numeric, or we can say the count of it like 1 comes 2 times
-- 2.22, -> NUMERIC(3,2) 2 represents the number of decimal places or we can say precession
-- 33.333 -> NUMERIC(5,3)
-- 444.444 -> NUMERIC(6,3)

-- returns for columns, w/ labels-values listed

SELECT 1 AS i1, 2 AS i2
     , 1.0 AS d1, 2.22 AS d2


-- numerics
SELECT i1, i2, d1, d2 -- returns: 1, 2, 1.0, 2.22
 , i1<i2    -- returns 1 as 1<2 is TRUE
 , i1<=d1   -- returns 1 as 1<=2 is TRUE
 , i1=d1    -- returns 1 as 1=1.0 is TRUE
 , i1!=d1   -- returns 1 as 1!=1.0 is FALSE
 , i2>i1    -- returns 1 as 2>1 is TRUE
 , d2>=i2   -- returns 1 as 2.22>=2 is TRUE
 , 1.5  BETWEEN i1 AND d2 -- 1<=1.5<=2.22 TRUE
 , 2.22 BETWEEN i1 AND d2 -- 1<=2.22<=2.22 TRUE
 , 3    BETWEEN i1 AND d2 -- 1<=3<=2.22 is FALSE
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs2;

-- = is equal to
-- < is less than, <= is less than equal to
-- > is greater than, >= is greater than equal to
-- != and <> are not equal to

       
-- value BETWEEN begin_value AND end_value
-- compares whether the value is within and/or 
-- equals the begin and end values:
-- with i1=1 and d2=2.22
-- 1.5 BETWEEN 1 AND 2.22 is TRUE basically it is
-- the same as 1<=1.5 AND 1.5<=2.22
-- 
SELECT i1, d2  -- 1.5
  , 1.5 BETWEEN i1 AND d2
  , i1<=1.5 AND 1.5<=d2   -- same as the between
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs3;


-- column IN(value1, value2 ... , valueN) will
-- return 1 (TRUE) is the column value is 
-- matching a value in the list:
-- 
SELECT i1 IN (1,2,3,4)         -- TRUE  1
     , i2 IN (5,6,7,8)         -- FALSE 0
     , d1 IN (1,2,3,4)         -- TRUE  1
     , d2 IN (i1,i2,d1)        -- FALSE 0
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs4;

       

-- also, we can do some mathematics with numbers
-- 
--     add     subtract times   divide  modulus
SELECT i1+i2,  i1-i2,   i1*i2,  i1/i2,  i1%i2
     , d1+d2,  d1-d2,   d1*d2,  d1/d2,  d1%d2
     , i1+d1,  i1-d1,   i1*d1,  i1/d1,  i1%d1
FROM (SELECT 1 AS i1, 2 AS i2
           , 1.0 AS d1, 2.22 AS d2) trs5;


-- -------------------------------------------------------------------
-- Strings (CHAR, VARCHAR, TEXT)

-- CHAR - counts even the empty spaces and id mostly 10 characters, mostlr refers to simple strings without any variable   'hello     '
    -- constant width
-- VARCHAR-variables with thousand different first names or addresses like with evreything that has a variable thats why its called VARCHAR
-- TEXT - only meant for paragraphs, all the body of the content
       
CHAR = 'ROH OHO' CONSTANT WIDTH
VARCHAR = CHANGE WIDTH STRING DATA
TEXT = ONLY MEANT FOR PARAGRAPHS


-- simple strings, begins/ends with space, noting
-- data is usually trimmed and not stored this way
SELECT ' Hi '  AS s1
     , ' Bye ' AS s2;


SELECT s1, s2            -- returns:
  , TRIM(s1), TRIM(s2)   -- 'Hi' 'Bye'
  , LTRIM(s1), LTRIM(s2) -- 'Hi ' 'Bye '
  , RTRIM(s1), RTRIM(s2) -- ' Hi' ' Bye'
  , CONCAT(s1,'and',s2)  -- ' Hi and Bye ' -- SAME AS WHAT WE DID IN PYTHON (concatenation method)
  , LENGTH(TRIM(s1)), LENGTH('HĬ') -- LENGTH in bytes -- That little cap ON hi represents it AS the international CHARACTER so its value will be 3
  , CHAR_LENGTH(TRIM(s1)), CHAR_LENGTH('HĬ') -- visual LENGTH
FROM (SELECT ' Hi '  AS s1
           , ' Bye ' AS s2) tsr6;



SELECT s1, s2               -- returns:
    , CONCAT(s1,' ',s2) -- 'Hi and Bye'
FROM (SELECT 'Husan'  AS s1
           , 'kalsi' AS s2) tsr7;



-- string comparisons and 'H' or 'i' patterns
       
SELECT s1, s2       -- returns:
  , s1=s2, s1<>s2   -- 0 (FALSE) | 1 (TRUE)
  , s1='Hi'         -- 1
  , s1<>'Bye'       -- 1 
  , s1 LIKE 'H%'    -- 1, % is 0 to many chars
  , s1 LIKE 'H_'    -- 1, _ means must have 1
  , 'H' LIKE 'H%'   -- 1
  , 'Hi' LIKE 'H%'  -- 1
  , ' Hi' LIKE 'H%' -- 0 if pattern ' H%' then 1
  , 'H' LIKE 'H_'   -- 0, means any 1 char after
  , s1 LIKE 'H__'   -- 0, means any 2 chars after
  , s1 LIKE '_i'    -- 1, means any 1 char before
  , s1 LIKE '__i'   -- 0, means any 2 chars bef.
  , s1 LIKE '%i'    -- 1, 0 to many chars bef.
  , s1 LIKE '%%i'   -- 1, but pointless, NEVER DO
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr8;


-- string comparisons and patterns

SELECT s1, s2       -- returns:
  , s2='Bye'        -- 1
  , s2!='Hi'        -- 1 
  , s2 LIKE 'B%'    -- 1, % is 0 to many chars
  , s2 LIKE 'B_'    -- 0, _ must have 1 only
  , 'B' LIKE 'B%'   -- 1
  , 'Bye' LIKE 'B%' -- 1
  , ' Bye' LIKE 'B%'-- 0 if pattern ' B%' rtns: 1
  , 'B' LIKE 'B_'   -- 0, means any 1 char after
  , s2 LIKE 'B__'   -- 1, means any 2 chars after
  , s2 LIKE '_e'    -- 0, means any 1 char before
  , s2 LIKE '__e'   -- 1, means any 2 chars bef.
  , s2 LIKE 'B_e'   -- 1, means 1 char in middle
  , s2 LIKE 'B%e'   -- 1, 0 to many chars mid
  , s2 LIKE '_y_'   -- 1, 1 char beg end, y mid
  , s2 LIKE '%y%'   -- 1, chars beg end, y mid
  , 'y' LIKE '%y%'  -- 1, 0 chars beg end, y mid
  , 'y' LIKE '_y_'  -- 0, 1 char beg end, y mid
  , s2 LIKE '%%e'   -- 1, but pointless, NEVER DO
  , s2 LIKE 'B%%'   -- 1, but pointless, NEVER DO
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr9;




-- IN and NOT IN comma delimited list
SELECT s1, s2         -- returns:
  , s1 IN('Hi','Bye')      -- 1
  , s2 IN('Hi','Bye')      -- 1 
  , s1 NOT IN('Hi','Bye')  -- 0
  , s2 NOT IN('Hi','Bye')  -- 0 
  , 'Hello' IN('Hi','Bye') -- 0
  , 'Hello' IN(s1,s2)      -- 0
  , 'Hi'    IN(s1,s2)      -- 1
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr10;




-- NULL checks, null does not mean empty string ''
SELECT s1, s2, s3        -- returns:
  , s1=s3                -- NULL
  , s2<>s3               -- NULL
  , s1=IFNULL(s3,'')     -- 0 - workaround
  , s2<>IFNULL(s3,'')    -- 1 - workaround
  , s3 IS NULL           -- 1
  , s1 IS NOT NULL       -- 1
  , NULL IN (s1,s2,s3)   -- NULL
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2
           , NULL AS s3) tsr11;

       

       
-- AND operator, both conditionals must be TRUE
SELECT s1, s2             -- returns:
  , s1='Hi'  AND s2='Bye' -- 1 TRUE+TRUE=TRUE
  , s1='Hi'  AND s2='Hi'  -- 0 TRUE+FALSE=FALSE
  , s1='Bye' AND s2='Bye' -- 0 FALSE+TRUE=FALSE
  , s1='Bye' AND s2='Hi'  -- 0 FALSE+FALSE=FALSE
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr12;

       
       
        
-- OR operator, either conditional must be TRUE
-- 
SELECT s1, s2             -- returns:
  , s1='Hi'  OR s2='Bye' -- 1 TRUE or TRUE=TRUE
  , s1='Hi'  OR s2='Hi'  -- 1 TRUE or FALSE=TRUE
  , s1='Bye' OR s2='Bye' -- 1 FALSE or TRUE=TRUE
  , s1='Bye' OR s2='Hi'  -- 0 FALSE or FALSE=FALSE
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr13;

       
       
       
-- row will display
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr14
WHERE s1='Hi';

-- row will display
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr15
WHERE s1='Hi' AND s2='Bye';

-- row will not display
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr16
WHERE s2='Hi' OR s1='Bye';

-- row will display 
SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr17
WHERE s1 IN ('Hi','Bye') AND s2 LIKE 'B%';


SELECT s1, s2             
FROM (SELECT 'Hi'  AS s1
           , 'Bye' AS s2) tsr18
WHERE (s1='Hi' OR s1='Bye') AND s2 LIKE 'B%';

       
 YYYY-MM-DD  -- 10 CHARACTERS  
'2024-01-22'  
   
 HH:MM:SS  -- 8 CHARACTERS
'09:09:09'       
       
       
 YYYY-MM-DD HH:MM:SS   -- 19 CHARACTERS AND THESE ARE ALPHABETIC 
'2024-01-22 09:09:09'  
       
       
-- 01 JAN 2020 TO 31 DEC 2021      
SELECT d1, d2
    , d1<=d2                               -- 1             
    , d1=d2                                -- 0           
    , d1>d2                                -- 0
    , d1='2020-01-01 00:00:00'             -- 1
    , d2='2020-01-01 00:00:00'             -- 0
    , d1 BETWEEN '2019-01-01 00:00:00'
             AND '2022-01-01 00:00:00'     -- 1
    , d1 NOT BETWEEN '2019-01-01 00:00:00'
                 AND '2022-01-01 00:00:00' -- 0
FROM (SELECT '2020-01-01 00:00:00' AS d1
           , '2021-12-31 23:59:59' AS d2) tsr20;

       
SELECT NOW(); -- THIS FUNCTION WILL GIVE US THE PRESENT TIMING
-- 2024-01-26 02:35:18

-- NOW function with date numeric functions
SELECT d1
    , QUARTER(d1)     -- Date Quarter           
    , YEAR(d1)        -- Date Year0           
    , MONTH(d1)       -- Date Month
    , DAY(d1)         -- Date Day 
    , HOUR(d1)        -- Date Hour 
    , MINUTE(d1)      -- Date Minute 
    , SECOND(d1)      -- Date Second 
    , WEEKDAY(d1)     -- 0 Mon thru 7 Sun
FROM (SELECT NOW() AS d1) tsr21;



-- NOW and common string format functions (
-- https://www.w3schools.com/sql/func_mysql_date_format.asp              
SELECT d1
    , MONTHNAME(d1)   -- Date Month
    , DAYNAME(d1)     -- Date Day 
    , DATE_FORMAT(d1,'%a, %D of %b %Y %l:%i %p')
                      -- Date String
FROM (SELECT NOW() AS d1) tsr22;
       
       
-- '%a, %D of %b %Y %l:%i %p'      
-- Fri, 26th of Jan 2024 2:41 AM
       

-- -------------------------------------------------------------------
-- DROP/CREATE TABLE syntax
DROP TABLE IF EXISTS table_name;
CREATE TABLE IF NOT EXISTS table_name (
    colPK     INTtype        AUTO_INCREMENT 
  , col2      DATAtype(size) NULL DEFAULT value
  ...
  , colN      DATAtype(size) 
  , colFKs    INTtype        NOT NULL
  , USERMOD   INTTYPE        NOT NULL DEFAULT 2 -- logged IN USER p_id
  , datemod   DATETIME       NOT NULL DEFAULT NOW()
  , useract   INTtype        NOT NULL DEFAULT 2 -- logged in user p_id    
  , dateact   DATETIME       NOT NULL DEFAULT NOW()
  , active    BIT            NOT NULL DEFAULT 1 -- 0 hide
  
  , CONSTRAINT table_name___PK PRIMARY KEY(colPK)
  , CONSTRAINT table_name___UK UNIQUE(col2,...colN)

);


-- MANUFACUTRES -- what IS FOREIGN KEY - its just a primayr KEY IN another TABLE so IF we ARE USING these PRIMARY KEYS IN another TABLE,
-- 1 sony       -- THEN FOR that TABLE, these would be FOREIGN keys
-- 2 LG



-- ITEMS
-- 1 55" TV  sony  10.99 -- or we can write 1 in place of sony and 2 in place of LG 
-- 2 60" TV  sony  20.99 -- its just a way TO narrow down our TABLE TO capture less storage
-- 3 90" TV  LG    30.99 

-- An older option, was to create a COMPOSITE key, which allowed for multiple columns to be combined as a PRIMARY KEY for the TABLE
-- PRIMARY KEY SHOULD ALWAYS BE NARROWED DOWN

-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT      TABLE syntax
DROP TABLE IF EXISTS table_name;
CREATE TABLE IF NOT EXISTS table_name (
	  colPK      INTtype        AUTO_INCREMENT 
	, col2       VARCHAR(191)   NULL DEFAULT value 'STRING'
	, col2       CHAR(191)      NULL DEFAULT value 'CONSTANT' 
	, col2       TINYINT        NOT NULL 
	, col2       MEDIUMINT      NOT NULL	
	...
	, colN       CHAR(191)      NULL DEFAULT value 'constant'
	, colFKs     INTtype        NOT NULL
	, USERMOD    INTTYPE        NOT NULL DEFAULT 2 -- logged IN USER p_id
	, datemod    DATETIME       NOT NULL DEFAULT NOW()
	, useract    INTtype        NOT NULL DEFAULT 2 -- logged in user p_id    
	, dateact    DATETIME       NOT NULL DEFAULT NOW()
	, active     BIT            NOT NULL DEFAULT 1 -- 0 hide

	, CONSTRAINT table_name___PK PRIMARY KEY(colPK)
	, CONSTRAINT table_name___UK UNIQUE(col2,...colN)

	);

-- TRUNCATE SYNTAX	
TRUNCATE TABLE table_name;
                       , colN,colFKs)
VALUES					   (val2 ....
					   , valN,colFKs);
					   
-- SELECT syntax
SELECT t1.colPK, t1.column2
       , t1.colFK
	   , t2.colPK, t2.column2
	   , t1.colFK2
	   , t3.colPK, t3.column2
FROM   table_name t1        
       JOIN table_name2 t2 ON t1.colFK1=t2.colPK
	   JOIN table_name3 t3 ON t1.colFK2=t3.colPK
	   
WHERE    filter_condition AND|OR second_condition
ORDER BY column2 DESC, ...
LIMIT    rowoffset#, rowsperpage#(rpp);

-- -------------------------------------------------------------------

-- VARCHAR IS MEANT FOR VARIABLES
-- CHAR IS MEANT FOR CONSTANTS OR STRINGS LIKE FIRST AND LAST NAME
-- insert syntax
INSERT INTO table_name (column2 ... ,
                        columnN, columnFKs)
VALUES                 (value2 ... , 
                        valueN, valueFKs);


MANUFACUTRES -- what IS FOREIGN KEY - its just a primayr KEY IN 
another TABLE so IF we ARE USING these PRIMARY KEYS IN another TABLE,
1 sony       -- THEN FOR that TABLE, these would be FOREIGN keys
2 LG



ITEMS
1 55" TV  sony  10.99 -- or we can write 1 in place of sony 
 and 2 in place of LG 
2 60" TV  sony  20.99 -- its just a way TO narrow down our 
TABLE TO capture less storage
3 90" TV  LG    30.99 
"
-- An older option, was to create a COMPOSITE key, which allowed for 
-- multiple columns to be combined as a PRIMARY KEY for the TABLE
-- PRIMARY KEY SHOULD ALWAYS BE NARROWED DOWN

-- -------------------------------------------------------------------
-- DROP/CREATE TABLE syntax
DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
    p_id       MEDIUMINT     UNSIGNED AUTO_INCREMENT 
  , full_name  VARCHAR(100)  DEFAULT value
  , CONSTRAINT people___PK             PRIMARY KEY(p_id)
  , CONSTRAINT people___UK__full_name  UNIQUE(full_name ASC)
);



DESCRIBE people;

DELETE FROM people;

TRUNCATE people TABLE; -- deletes the DATA but keeps the SCHEMA structure

-- replace Instructor Name and Your Name with 
-- respective values

INSERT INTO people (full_name) VALUES ('Brad Vincelette');
INSERT INTO people (full_name) VALUES ('Husandeep Kaur');
INSERT INTO people (full_name) VALUES ('Gurnoor Kalsi');

-- -------------------------------------------------------------------
-- ALTER SYNTAX
ALTER TABLE table_name
   ADD COLUMN  column3   datatype(size) nullable
  ,ADD COLUMN  column4   datatype(size) nullable
.....
,  ADD COLUMN  columnN   datatype(size) nullable;

ALTER TABLE  table_name
   MODIFY COLUMN columnN  datatype(size) nullable;
   
 
ALTER TABLE  table_name
   DROP COLUMN columnN;

-- can be done all together:
ALTER TABLE table_name
   ADD COLUMN column3    datatype(size) nullable
   MODIFY COLUMN columnN datatype(size) nullable;
   DROP COLUMN  columnN;
   
-- -------------------------------------------------------------------

-- SELECT FROM syntax
SELECT   DISTINCT column1, column2 ... , columnN 
FROM     table_name 
WHERE    filter_condition AND|OR second_condition
ORDER BY column2 DESC, ...
LIMIT    rowoffset#, rowsperpage#(rpp);


-- LIMIT 2; displays beginning 2 rows
-- LIMIT  0,10; displays beginning 10 rows 
-- LIMIT 10,10; displays beginning at row 10, 10 rows = 10 to 19 rows
-- LIMIT 20,10; displays beginning at row 20, 10 rows

-- for paging, to calculate the row offset: 
    (page#  x  rpp#) - rpp# = ro#
    ie: Page 4 with 10 rows:  (4 x 10)-10=30
    for LIMIT 30,10

SELECT   p_id, full_name 
FROM     people 
WHERE    1=1  -- returns 0 rows, contains no data yet
ORDER BY full_name --  DESC Describes the descending ORDER OF names AND ASC is for vice versa
LIMIT    10,10;

1*10 -10 = 0
2*10 -10 = 10

USE information_schema;
SELECT * 
FROM COLUMNS 
WHERE table_schema='hk_0398817_boxstore' AND table_name='people'; -- OR 
we can WRITE ORDER BY table_schema, table_name IN place OF this line

                           
LOAD DATA 
INFILE 'C:\\_data\\_imports\\hk_0398817_boxstore_people_10000.csv' 
INTO TABLE people 
LINES TERMINATED BY '\r\n'
(full_name);


SELECT p_id, full_name, CHAR_LENGTH(full_name)
FROM people; 

-- BULK LOAD insert 10000 people records
-- copy name from record 3 out, paste in between 2 pipes
--  123456789012345
-- |Octavio Bridges|

SELECT p_id, full_name 
FROM people 
WHERE 1=1;  -- returns 0 rows, contains no data yet

-- SELECT p_id, full_name 
-- FROM people 
-- WHERE p_id =2;
|Husandeep Kaur|  

-- SELECT p_id, full_name 
-- FROM people 
-- WHERE full_name LIKE '% vicelette' 
|Brad Vincelette|

SELECT p_id, full_name 
FROM people 
WHERE NOT(full_name LIKE '__%__%'
  OR      full_name LIKE '__%__%');

-- ALTER TABLE_NAME is for changing the structure of the TABLE
-- UPDATE table_name is for changing the values in the table or we can say the data


SELECT p_id, full_name
   -- , INSTR(full_name, ' ')      AS space_loc
   -- , 1                          AS first_name_beg
   -- , INSTR(full_name, ' ')-1    AS first_name_end
   -- , INSTR(full_name, ' ')+1    AS last_name_beg
   -- , CHAR_LENGTH(full_name)     AS last_name_end
   
   , TRIM(MID(full_name,1,INSTR(full_name, ' ')-1 )) AS first_name
   -- ,  CHAR_LENGTH(full_name)-( INSTR(full_name, ' ')+1) +1 as last_name_len
   , TRIM(MID(
         full_name
        ,INSTR(full_name, ' ')+1 
        ,CHAR_LENGTH(full_name)-INSTR(full_name, ' ')  
       )) AS last_name
FROM people
WHERE p_id>2

-- reset for rerun
UPDATE people
SET    first_name=NULL
     , last_name =NULL
WHERE  p_id IN (1,2);


-- value updates for p_id 1 and 2
UPDATE people
SET    first_name='Brad'
     , last_name ='Vincelette'
WHERE  p_id=1;


UPDATE people
SET    first_name='Husandeep'
     , last_name ='Kaur'
WHERE  p_id=2;

SELECT * FROM people WHERE p_id<=2;

-- 
UPDATE people
SET    first_name=TRIM(MID(full_name,1,INSTR(full_name, ' ')-1 ))
     , last_name = TRIM(MID(
                        full_name
                       ,INSTR(full_name, ' ')+1 
                       ,CHAR_LENGTH(full_name)-INSTR(full_name, ' ')  
                   ))
WHERE  p_id>2;


SELECT CHAR_LENGTH(fn)-CHAR_LENGTH(REPLACE(fn,' ',''))
FROM (SELECT 'Blake Van Morrison' AS fn) trs

SELECT  p_id, full_name, first_name, last_name 
FROM    people 
WHERE NOT(first_name IS NULL OR last_name IS NULL);

SELECT   first_name, last_name 
FROM     people
WHERE    first_name='Brad'
ORDER BY last_name; -- example WITH ORDERING LAST name

-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT  TABLE syntax
-- JOIN/ON syntax
DROP TABLE IF EXISTS table_name;
CREATE TABLE IF NOT EXISTS table_name (
	  colPK      INTtype       AUTO_INCREMENT 
	, col2       VARCHAR(191)  NULL DEFAULT value 'STRING'
	, col2       CHAR(191)     NULL DEFAULT value 'CONSTANT' 
	, col2       TINYINT       NOT NULL 
	, col2       MEDIUMINT     NOT NULL	
	...
	, colN      CHAR(191)      NULL DEFAULT value 'constant'
	, colFKs    INTtype        NOT NULL
	, USERMOD   INTTYPE        NOT NULL DEFAULT 2 -- logged IN USER p_id
	, datemod   DATETIME       NOT NULL DEFAULT NOW()
	, useract   INTtype        NOT NULL DEFAULT 2 -- logged in user p_id    
	, dateact   DATETIME       NOT NULL DEFAULT NOW()
	, active    BIT            NOT NULL DEFAULT 1 -- 0 hide

	, CONSTRAINT table_name___PK PRIMARY KEY(colPK)
	, CONSTRAINT table_name___UK UNIQUE(col2,...colN)

	);
	
-- TRUNCATE syntax
TRUNCATE TABLE table_name;

-- INSERT syntax
INSERT INTO table_name  (col2 ...
                       , colN,colFKs)
VALUES					   (val2 ....
					   , valN,colFKs);

-- SELECT syntax
SELECT t1.colPK, t1.column2
       , t1.colFK
	   , t2.colPK, t2.column2
	   , t1.colFK2
	   , t3.colPK, t3.column2
FROM   table_name t1        
       JOIN table_name2 t2 ON t1.colFK1=t2.colPK
	   JOIN table_name3 t3 ON t1.colFK2=t3.colPK
	   
WHERE    filter_condition AND|OR second_condition
ORDER BY column2 DESC, ...
LIMIT    rowoffset#, rowsperpage#(rpp);

-- -------------------------------------------------------------------
-- UPDATE table_name

UPDATE table_name
SET   varchar1 ='value1'
     , datetime1 = 'YYYY-MM-DD HH:MM:SS'
	 , ....
	 , medintN =1
WHERE 1=0;
-- -------------------------------------------------------------------

-- 0        1         2					ruler tens
-- 012345678901234567890					ruler ones
-- 'FirstName LastName'
--  1       ^?^      ^
--          |^|= space position (SP)
--          ? ?      ? = LENGTH - SP
--       SP-1 SP+1            

-- -------------------------------------------------------------------

-- -------------------------------------------------------------------

-- UPPER Case Function: returns BRAD in all capital letters
SELECT first_name, UPPER(first_name)
FROM   people
WHERE  p_id = 1;

-- Brad
-- BRAD
--  brad

SELECT first_name
     ,  UPPER(first_name) AS first_name_upper
FROM   people p
WHERE  p_id = 1;

SELECT UPPER(first_name) AS first_name
FROM   people
WHERE  p_id = 1;

SELECT p_id, first_name, last_name
FROM   people
WHERE  UPPER(first_name) = 'ZACK';

-- LOWER Case function, returns: red river
SELECT LOWER('ReD RiVeR');   -- returned |red river|

SELECT p_id, first_name, last_name
FROM   people
WHERE  LOWER(first_name) = 'stephen';

-- LOWER Case function in WHERE clause
SELECT p_id, first_name, last_name
     , LOWER(first_name)
     , LOWER(first_name) = 'stephen'
FROM   people
WHERE  LOWER(first_name) = 'stephen';

-- -------------------------------------------------------------------
-- SUBSTR Function
-- 3 parameters: string to parse data from
--               starting position #
--               length of string you want returned
-- syntax:
SUBSTR('value'
      , character_position_to_start
      , number_of_characters_to_return)

-- Ruler 123456789 
SELECT  'Red River';

-- Ruler       123456789

SELECT SUBSTR('Red River', 1, 4);  -- returned |Red |

SELECT UPPER('stephen') AS first_name; -- returned |STEPHEN|

SELECT SUBSTR('Red River', 5, 5); -- returned |River|

SELECT SUBSTR('Red River', 2, 2); -- returned |ed|

SELECT SUBSTR('Red River', 5);  -- returned |River|

SELECT SUBSTR('Red River College Polytechnic', 5); -- returned: |River College Polytechnic|

SELECT SUBSTR('Hello World!', 7, 5)  -- returned |World|

SELECT SUBSTR('Info Tech', 3, 4) -- returned |fo T|

SELECT last_name
     , SUBSTR(last_name,1,2) AS last_name_abbr
FROM people;

SELECT last_name
     , SUBSTR(last_name,1,2) AS last_name_abbr
FROM people
ORDER BY last_name;

-- INSTR function, 2 parameters: string you are looking within
--                               string portion you ARE looking for
INSTR (
     'string to search in'
   , 'string portion you are searching for'
)

-- RULER      123456789012345678901234567890
SELECT INSTR('Red River','v'); -- returned: 7

SELECT INSTR('Red River','e'); -- returned: 2

SELECT SUBSTR(
           'https://rrc.ca/courses/dsml/'
         , INSTR('https://rrc.ca/courses/dsml/','//')+8
       ) AS webpath
;
-- |/courses/dsml/|

SELECT SUBSTR('https://rrc.ca/courses/dsml/', 15)
     , INSTR('https://rrc.ca/courses/dsml/','//')
     , SUBSTR('https://rrc.ca/courses/dsml/', 15)
FROM (SELECT 'rrc.ca' AS domain_name) trs;

SELECT first_name, last_name
FROM   people
WHERE  INSTR(last_name,'J') = 1;

SELECT first_name, last_name, UPPER(LEFT(last_name,1))
FROM   people
WHERE  UPPER(LEFT(last_name,1))='J';

-- CHAR_LENGTH
SELECT CHAR_LENGTH('Red River'); -- returned: 9

SELECT p_id, first_name, last_name
     , CHAR_LENGTH(first_name)
FROM   people
WHERE  CHAR_LENGTH(first_name) > 8;

SELECT first_name, last_name
FROM   people
WHERE  CHAR_LENGTH(first_name) + CHAR_LENGTH(last_name) < 15;

-- LPAD syntax
LPAD('value', 
     maximum_character_result,
     padding_character)

-- RPAD syntax
RPAD('value', 
     maximum_character_result,
     padding_character)

SELECT LPAD('Red', 6, '*'); -- returned |**Red|

SELECT RPAD('Red', 10, ''); -- returned |Red__|

SELECT LPAD('River', 7, '-'); -- returned |--River|

SELECT RPAD('College', 7, '%'); -- returned |College|

SELECT LPAD('Rules', 3, '&'); -- returned |Rul|

-- TRIM
SELECT TRIM('  My Value  '); -- returned |My Value|

-- LTRIM
SELECT LTRIM('  my value  '); -- returned |my value  |

-- RTRIM
SELECT RTRIM('  my value  '); -- returned |  my value|

-- CONCAT function
SELECT CONCAT('my',' ','value'); -- returned |my value|

SELECT CONCAT(first_name,' ',last_name) AS full_name
FROM people;

-- REPLACE function
SELECT 
REPLACE('replace the space with underscore',' ','_'); -- returned |replace_the_space_with_underscore|

-- CONCAT and REPLACE function
SELECT CONCAT('/'
             , REPLACE(
                 'replace the space with hyphen'
                ,' '
                ,'-'
               )
             , '/')
; -- returned |/replace-the-space-with-hyphen/|

UPDATE wp_posts
SET post_content = REPLACE(post_content,'  ',' ');

SELECT CONCAT(
            REPLACE(first_name,'Stephen','Blue')
                  , ' '
                  , last_name
       ) AS new_name
FROM people
WHERE first_name = 'Stephen';

--             12345678901234567
SELECT SUBSTR('Red River College', 5); -- returned |River College|

SELECT SUBSTR(
        'Red River College'
        , INSTR('Red River College',' ')+1
);

-- ROUND function
SELECT ROUND(123.2, 0); -- returned 123

SELECT ROUND(25.8); -- returned 26

SELECT ROUND(25.7); -- returned 26

SELECT ROUND(7.56, 1); -- returned 7.6

SELECT ROUND(7.53, 1); -- returned 7.5

SELECT ROUND(1456.56, -2); -- returned 1500

SELECT ROUND(1446.56, -2); -- returned 1400

-- TRUNCATE function

SELECT TRUNCATE(25.8, 0); -- returned 25

SELECT TRUNCATE(25.8, -1); -- returned 20

SELECT TRUNCATE(25.3, 0); -- returned 25

SELECT TRUNCATE(7.56, 1); -- returned 7.5

SELECT TRUNCATE(7.56, 1); -- returned 7.5

SELECT TRUNCATE(1446.56, -2); -- returned 1400

SELECT TRUNCATE(1446.56, -2); -- returned 1400

-- MOD
SELECT MOD(7, 3); -- returned 1

SELECT MOD(24, 2); -- returned 0


SELECT MOD (1,2)
UNION ALL
SELECT MOD (2,2)
UNION ALL
SELECT MOD (3,2)
UNION ALL
SELECT MOD (4,2)
UNION ALL
SELECT MOD (5,2);

-- ABS 
SELECT ABS(3); -- returned 3

SELECT ABS(-3); -- returned 3

-- IFNULL
SELECT IFNULL(addr_delivery,'Knock please!') 
FROM   people;

-- -------------------------------------------------------------------
-- Aggregates

SELECT * FROM people_employee;

-- sum of all employees: 28600.00 1 row 1 column a cell
SELECT SUM(pe_salary) AS pe_salary_tot
FROM   people_employee pe;

 9900.00
 3300.00
 2200.00
 2200.00
 2200.00
 2200.00
 2200.00
 2200.00
 2200.00
28600.00
3177.777778
3177.78

SELECT SUM(pe_salary)  
     , ROUND(AVG(pe_salary), 2)
     , MIN(pe_salary)  
     , MAX(pe_salary)
     , COUNT(pe_salary)
     , COUNT(DISTINCT pe_salary)
     , GROUP_CONCAT(pe_salary)
     , GROUP_CONCAT(DISTINCT pe_salary)
FROM   people_employee;

-- SUM(): 28600.00
SELECT SUM(pe_salary) AS pe_salary_tot
FROM   people_employee;

-- MIN(): 2200.00
SELECT MIN(pe_salary) AS pe_salary_min 
FROM   people_employee;

-- MAX(): 9900.00
SELECT MAX(pe_salary) AS pe_salary_max 
FROM   people_employee;

-- AVG(): 3177.777778
SELECT AVG(pe_salary) AS pe_salary_avg
FROM   people_employee;

-- COUNT(): 7
SELECT COUNT(p_id_mgr) AS emp_mgr_count
FROM   people_employee;

-- COUNT(*): 9
SELECT COUNT(*) AS emp_cnt
FROM   people_employee;

SELECT COUNT(p_id) AS emp_mgr_count
FROM   people_employee;

-- 1926 OR 10002
SELECT COUNT(DISTINCT first_name) AS first_name_cnt_unique
FROM   people;

SELECT pe.pe_id
     , pe.p_id    , e.p_id, e.first_name, e.last_name 
     , pe.p_id_mgr, m.p_id, m.first_name, m.last_name
     , pe.pe_hired, pe.pe_salary
FROM   people_employee pe 
       RIGHT JOIN people e ON pe.p_id=e.p_id
       LEFT JOIN  people m ON pe.p_id_mgr=m.p_id 
WHERE  e.active=1 OR m.active=1;

SELECT pe.pe_id, pe.p_id_mgr, pe.pe_salary
FROM   people_employee pe;

SELECT COUNT(*)                    AS people_count
     , COUNT(pe.pe_id)             AS employee_count
     , COUNT(pe.p_id_mgr)          AS emp_with_mgr_count 
     , COUNT(DISTINCT pe.p_id_mgr) AS p_id_mgr_count_dist
     , COUNT(pe.pe_salary)         AS emp_with_pe_salary_count
     , SUM(CASE
           WHEN pe.pe_id IS NULL
           THEN 1 ELSE 0 END)      AS cust_cnt
FROM   people_employee pe 
       RIGHT JOIN people e ON pe.p_id=e.p_id
       LEFT JOIN  people m ON pe.p_id_mgr=m.p_id 
WHERE  e.active=1 OR m.active=1;
10002   9   7   2   9   9993

-- 1926 rows
SELECT   first_name, COUNT(p_id)
FROM     people
GROUP BY first_name
ORDER BY COUNT(p_id) DESC, first_name;

SELECT   first_name, COUNT(p_id) AS first_name_cnt
FROM     people
WHERE    active=1
GROUP BY first_name
HAVING   COUNT(p_id)>=15
ORDER BY first_name_cnt DESC, first_name;

SELECT gco.co_id, gco.co_name
     , COUNT(gtc.tc_id) AS towncity_cnt
FROM   geo_towncity gtc
       JOIN geo_region grg  ON gtc.rg_id=grg.rg_id 
       JOIN geo_country gco ON grg.co_id=gco.co_id
WHERE gtc.active=1 AND grg.active=1 AND gco.active=1
GROUP BY gco.co_id, gco.co_name 
ORDER BY towncity_cnt DESC, gco.co_name;

SELECT gco.co_id, gco.co_name
     , COUNT(gtc.tc_id) AS towncity_cnt
FROM   geo_towncity gtc
       JOIN geo_region grg  ON gtc.rg_id=grg.rg_id 
       JOIN geo_country gco ON grg.co_id=gco.co_id
WHERE gtc.active=1 AND grg.active=1 AND gco.active=1
GROUP BY gco.co_id, gco.co_name
HAVING   COUNT(gtc.tc_id)>1
ORDER BY towncity_cnt DESC, gco.co_name;

-- GROUP_CONCAT
-- returned: Redmond, Round Rock, Los Altos, Santa Clara
SELECT gco.co_id, gco.co_name
     , COUNT(gtc.tc_id) AS towncity_cnt
     , REPLACE(
           GROUP_CONCAT(gtc.tc_name)
          , ',', ', '
       ) AS country_towncities
FROM   geo_towncity gtc
       JOIN geo_region grg  ON gtc.rg_id=grg.rg_id 
       JOIN geo_country gco ON grg.co_id=gco.co_id
WHERE gtc.active=1 AND grg.active=1 AND gco.active=1
GROUP BY gco.co_id, gco.co_name
HAVING   COUNT(gtc.tc_id)>1
ORDER BY towncity_cnt DESC, gco.co_name;












