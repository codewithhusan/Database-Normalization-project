/* 
** Name: Husandeep kaur
** Assignment: COMPETENCY C,D
** Date: 2024-01-13
** Version1: 2024-01-13
**  		 Creating the boxstore database
**          - use mysql database to exit boxstore database prior to:
**          - DROP/CREATE/USE boxstore database block added
**
** Version2: 2024-01-25
**           Creating the people table
**           - DROP/CREATE/TRUNCATE/INSERT/SELECT block added
**           - Loading 10000 names csv file into the code
**           - and counting the characters
**           - updating the first 2 records by separating 
**           - first and last names
**
** Version3: 2024-02-09
**           Creating four tables
**           - geo_address_type 
**           - geo_country
**           - geo_region
**           - geo_towncity
**           Creating JOINS within these tables
**           - region to country , towncity to region to country
**           - One large JOIN query contaning all the tables including 
**           - the people table
**           - Query that forms the front of an envelope
**           ALTER PEOPLE TABLE
**           - updating people table with different columns 
**           - for the first two records 
*/


-- ------------------------------------------------------------------
-- DROP/CREATE/USE database BLOCK
USE mysql;
 
-- DROP DATABASE IF EXISTS hk_0398817_boxstore;
DROP DATABASE IF EXISTS hk_0398817_boxstore;
CREATE DATABASE IF NOT EXISTS hk_0398817_boxstore
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';
 
USE hk_0398817_boxstore;

-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_address_type table
DROP   TABLE IF     EXISTS       geo_address_type;
CREATE TABLE IF NOT EXISTS       geo_address_type (
      addr_type_id TINYINT       UNSIGNED AUTO_INCREMENT
    , addr_type    VARCHAR(15)   NOT NULL
    , active       BIT           NOT NULL DEFAULT 1
    , CONSTRAINT   gat_PK        PRIMARY KEY(addr_type_id)
    , CONSTRAINT   gat_UK        UNIQUE (addr_type ASC)
);

TRUNCATE TABLE geo_address_type;
INSERT   INTO  geo_address_type (addr_type)
VALUES                          ('Apartment')
                               ,('Building')
                               ,('Condominium')
                               ,('Head Office')
                               ,('House')
                               ,('Other')
                               ,('Townhouse')
                               ,('Warehouse')                       
;

SELECT gat.addr_type_id, gat.addr_type
     , gat.active
FROM   geo_address_type gat
WHERE  gat.active=1;


-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_country table

DROP   TABLE IF     EXISTS geo_country;
CREATE TABLE IF NOT EXISTS geo_country (
      co_id      TINYINT        UNSIGNED AUTO_INCREMENT
    , co_name    VARCHAR(75)    NOT NULL
    , co_abbr    CHAR(2)        NOT NULL
    , active     BIT            NOT NULL DEFAULT 1
    , CONSTRAINT gco_PK         PRIMARY KEY(co_id)
    , CONSTRAINT gco_UK_name    UNIQUE (co_name ASC)
    , CONSTRAINT gco_UK_abbr    UNIQUE (co_abbr ASC)
);

TRUNCATE TABLE geo_country;
INSERT   INTO  geo_country (co_name, co_abbr)
VALUES                     ('Canada','CA')
                         , ('Japan','JP')
                         , ('South Korea','KR')
                         , ('United States of America','US')
;
            
SELECT gco.co_id, gco.co_name, gco.co_abbr
     , gco.active
FROM   geo_country gco
WHERE  gco.active=1;


-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_region table
DROP   TABLE   IF   EXISTS geo_region;
CREATE TABLE IF NOT EXISTS geo_region (
          rg_id      SMALLINT       UNSIGNED AUTO_INCREMENT
        , rg_name    VARCHAR(50)    NOT NULL
        , rg_abbr    CHAR(2)
        , co_id      TINYINT        NOT NULL
        , active     BIT            NOT NULL DEFAULT 1
        , CONSTRAINT grg_PK         PRIMARY KEY(rg_id)
        , CONSTRAINT grg_UK         UNIQUE (co_id ASC, rg_name ASC)
);

TRUNCATE TABLE geo_region;
INSERT   INTO  geo_region (rg_name, rg_abbr, co_id)
VALUES                       ('Manitoba', 'MB', 1)
                           , ('Tokyo', '', 2)
                           , ('Osaka', '', 2)
                           , ('Gyeonggi', '', 3)
                           , ('California', '', 4)
                           , ('Texas', '', 4)
                           , ('Washington', '', 4)
;
            
SELECT grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id
      ,grg.active
FROM   geo_region grg
WHERE  grg.active=1;

-- JOIN region to country(exclude active)
SELECT grg.rg_id, grg.rg_name, grg.co_id    -- region
     , gco.co_id, gco.co_name, gco.co_abbr  -- country
FROM   geo_region grg
       JOIN geo_country gco ON grg.co_id=gco.co_id
;


-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT geo_towncity table
DROP   TABLE   IF   EXISTS geo_towncity;
CREATE TABLE IF NOT EXISTS geo_towncity (
          tc_id      MEDIUMINT        UNSIGNED AUTO_INCREMENT
        , tc_name    VARCHAR(60)      NOT NULL
        , rg_id      SMALLINT         NOT NULL
        , active     BIT              NOT NULL DEFAULT 1
        , CONSTRAINT gtc_PK           PRIMARY KEY(tc_id)
        , CONSTRAINT gtc_UK   
              UNIQUE (rg_id ASC, tc_name ASC)
);
  
TRUNCATE TABLE   geo_towncity;
INSERT   INTO    geo_towncity (tc_name, rg_id)
VALUES                        ('Winnipeg', 1)
                            , ('Chiyoda', 2)
                            , ('Minato', 2)
                            , ('Kadoma', 3)
                            , ('Seoul', 4)
                            , ('Suwon', 4)
                            , ('Los Altos', 5)
                            , ('Santa Clara', 5)
                            , ('Round Rock', 6)
                            , ('Redmond', 7)
;         
SELECT gtc.tc_id, gtc.tc_name, gtc.rg_id
     , gtc.active
FROM   geo_towncity gtc
WHERE  gtc.active=1;


-- JOIN towncity to region to country

SELECT gtc.tc_id, gtc.tc_name, gtc.rg_id               -- towncity col
      ,grg.rg_id, grg.rg_name, grg.rg_abbr, grg.co_id  -- region col
      ,gco.co_id , gco.co_name, gco.co_abbr            -- country col
FROM   geo_towncity gtc                                -- towncity col
       JOIN geo_region grg  ON gtc.rg_id=grg.rg_id     -- region col
       JOIN geo_country gco ON grg.co_id=gco.co_id     -- country col
;

       
-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT people TABLE block
DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
    p_id         MEDIUMINT               AUTO_INCREMENT 
  , full_name    VARCHAR(100) 
  , CONSTRAINT   people___PK             PRIMARY KEY(p_id)
--  , CONSTRAINT people___UK__full_name  UNIQUE(full_name ASC)
);


TRUNCATE TABLE people;

-- BULK INSERT Instructor name and your name with  respective values
INSERT INTO people (full_name) VALUES ('Brad Vincelette') 
                                    , ('Husandeep Kaur')
;
                           
-- BULK LOAD INSERT 10000 people  -- useract = 1                    
LOAD DATA 
INFILE 'C:\\_data\\_imports\\hk_0398817_boxstore_people_10000.csv' 
INTO TABLE people 
LINES TERMINATED BY '\r\n'
(full_name);

-- verufy your table query works
SELECT p_id, full_name 
FROM people 
WHERE 1=1;
-- ORDER BY full_name;

-- -------------------------------------------------------------------
--  ALTER/UPDATE people table

ALTER TABLE people 
    ADD COLUMN  first_name    VARCHAR(35) NOT NULL
  , ADD COLUMN  last_name     VARCHAR(35) 
  , ADD COLUMN  email_addr    VARCHAR(50)
  , ADD COLUMN  password      CHAR(32)     
  , ADD COLUMN  phone_pri     CHAR(12)      -- NOT NULL later switch
  , ADD COLUMN  phone_sec     CHAR(12)
  , ADD COLUMN  phone_fax     CHAR(12)
  , ADD COLUMN  addr_prefix   VARCHAR(25)
  , ADD COLUMN  addr          VARCHAR(60)
  , ADD COLUMN  addr_code     VARCHAR(15)
  , ADD COLUMN  addr_info     VARCHAR(191)
  , ADD COLUMN  addr_delivery VARCHAR(191)
  , ADD COLUMN  addr_type_id  TINYINT       -- FK geo_address_type
  , ADD COLUMN  tc_id         SMALLINT      -- FK geo_towncity
  , ADD COLUMN  employee      BIT         DEFAULT 0
  , ADD COLUMN  usermod       MEDIUMINT   NOT NULL DEFAULT 2
  , ADD COLUMN  datemod       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
  , ADD COLUMN  useract       MEDIUMINT   NOT NULL DEFAULT 1
  , ADD COLUMN  dateact       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
  , ADD COLUMN  active        BIT         NOT NULL DEFAULT 1
;
  
SELECT p_id, full_name, first_name, last_name 
FROM   people p
WHERE  1=1;

-- value updates for p_id 1 and 2  -- usermod = 2

UPDATE people
SET    first_name='Brad'
     , last_name ='Vincelette'
WHERE  p_id=1;


UPDATE people
SET    first_name='Husandeep'
     , last_name ='Kaur'
WHERE  p_id=2;


-- SELECT * from people WHERE p_id IN (1,2);

-- updating 10000 records -- usermod/act = 2
-- Parsing first and last names from full_name
  
UPDATE people
SET    first_name= TRIM(MID(full_name,1,INSTR(full_name, ' ')-1 ))
     , last_name = TRIM(MID(
                        full_name
                       ,INSTR(full_name, ' ')+1 
                       ,CHAR_LENGTH(full_name)-INSTR(full_name, ' ')  
                   ))
WHERE  p_id>=3;

SELECT p_id, full_name, first_name, last_name 
FROM   people 
WHERE  1=1;

-- dropping full_name after first and last have been loaded
ALTER TABLE people   DROP COLUMN full_name;


-- updating 2 records: myself and instructor's
UPDATE people  
SET    email_addr    = 'brad.vincelette@boxstore.com'
     , password      = MD5('pepper-MINT_1921!')
     , phone_pri     = '204-456-6785'
     , phone_sec     = '204-235-3002'
     , phone_fax     = '204-768-2005'
     , addr_prefix   = NULL
     , addr          = '356 Ellice Ave'
     , addr_code     = 'R2L 1N5'
     , addr_info     = 'BRAD VINCELETTE\n'
                       'PO BOX 356 ELLICE AVE\n' 
                       'REDMOND, WASHINGTON, US R2L 1N5\n'
     , addr_delivery = 'check with conceirge on main level'
     , addr_type_id  = 5
     , tc_id         = 10
     , usermod       = 2
     , datemod       = NOW() 
WHERE p_id =1;


UPDATE people
SET    email_addr    ='husandeep.kaur@boxstore.com'
     , password      = MD5('hot_chocolate:2114!')
     , phone_pri     = '204-987-7653'
     , phone_sec     = '204-467-0087'
     , phone_fax     = '204-097-0064'
     , addr_prefix   = '105'
     , addr          = '46 Leahcrest Crescent'
     , addr_code     = 'R3P 2B5'
     , addr_info     = NULL
     , addr_delivery = 'knock on outside door'
     , addr_type_id  = 1
     , tc_id         = 1
     , usermod       = 2
     , datemod       = NOW()     
WHERE p_id=2;


-- ------------------------------------------------------------------
-- people meta loaded

-- populate people records WHERE p_id BETWEEN 3 AND 10002
DROP TABLE IF EXISTS z__street;
CREATE TABLE IF NOT EXISTS z__street (
    street_name VARCHAR(25) NOT NULL
);
INSERT INTO z__street VALUES('First Ave');
INSERT INTO z__street VALUES('Second Ave');
INSERT INTO z__street VALUES('Third Ave');
INSERT INTO z__street VALUES('Fourth Ave');
INSERT INTO z__street VALUES('Fifth Ave');
INSERT INTO z__street VALUES('Sixth Ave');
INSERT INTO z__street VALUES('Seventh Ave');
INSERT INTO z__street VALUES('Eighth Ave');
INSERT INTO z__street VALUES('Ninth Ave');
INSERT INTO z__street VALUES('Cedar Blvd');
INSERT INTO z__street VALUES('Elk Blvd');
INSERT INTO z__street VALUES('Hill Blvd');
INSERT INTO z__street VALUES('Lake St');
INSERT INTO z__street VALUES('Main Blvd');
INSERT INTO z__street VALUES('Maple St');
INSERT INTO z__street VALUES('Park Blvd');
INSERT INTO z__street VALUES('Pine St');
INSERT INTO z__street VALUES('Oak Blvd');
INSERT INTO z__street VALUES('View Blvd');
INSERT INTO z__street VALUES('Washington Blvd');

-- people meta load VIEW -----
DROP VIEW IF EXISTS z__people__meta_load;

CREATE VIEW IF NOT EXISTS z__people__meta_load AS (

    SELECT p.p_id
        -- , p.first_name, p.last_name
        , CONCAT(LOWER(LEFT(p.first_name,1)),LOWER(p.last_name),'@'
        , CASE WHEN RAND() < 0.25 THEN 'google.com'
               WHEN RAND() < 0.50 THEN 'outlook.com'
               WHEN RAND() < 0.75 THEN 'live.com'
               ELSE 'rocketmail.com' END) AS email_addr
        , MD5(RAND()) AS password
        , CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_pri
        , CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_sec
        , CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_fax

, NULL AS addr_prefix
        , MIN(
            CONCAT(
                 CASE WHEN RAND() < 0.25 THEN CONVERT(RAND()*100,INT)
                      WHEN RAND() < 0.50 THEN CONVERT(RAND()*1000,INT)
                      WHEN RAND() < 0.75 THEN CONVERT(RAND()*10000,INT)
                                         ELSE CONVERT(RAND()*10,INT) END+10
                 ,' ',zs.street_name)
          ) AS addr
        , CONCAT(
            SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
                , SUBSTR('0123456789', rand()*10+1, 1)
                , SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
                , ' '
                , SUBSTR('0123456789', rand()*10+1, 1)
                , SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
                , SUBSTR('0123456789', rand()*10+1, 1) 
          ) AS addr_code
        , NULL AS addr_info
        , NULL AS addr_delivery
        , CASE WHEN RAND() < 0.50 THEN 1 ELSE 2 END AS addr_type_id
        , 1 AS tc_id
        , 2 AS usermod
        , NOW() AS datemod
    FROM people p, z__street zs
    GROUP BY p.p_id
);
SELECT * FROM z__people__meta_load;


-- people TABLE UPDATE 10000 people records  ------------------------
UPDATE people p 
       JOIN z__people__meta_load dt ON p.p_id = dt.p_id
SET p.email_addr = dt.email_addr
  , p.password = dt.password
  , p.phone_pri = dt.phone_pri
  , p.phone_sec = dt.phone_sec
  , p.phone_fax = dt.phone_fax
  , p.addr_prefix = dt.addr_prefix
  , p.addr = dt.addr
  , p.addr_code = dt.addr_code
  , p.addr_info = dt.addr_info
  , p.addr_delivery = dt.addr_delivery
  , p.addr_type_id = dt.addr_type_id
  , p.tc_id = dt.tc_id
  , p.usermod = dt.usermod  
  , p.datemod = dt.datemod
WHERE p.p_id>=3;


-- update addr_prefix: suite number, room number, floor number
UPDATE people
SET addr_prefix=CASE WHEN RAND() < 0.33 THEN CONVERT(RAND()*100,INT)
                      WHEN RAND() < 0.67 THEN CONVERT(RAND()*1000,INT)
                                         ELSE CONVERT(RAND()*10,INT) END+10
WHERE addr_type_id IN (1,2,3) AND p_id>=3;

DROP VIEW IF EXISTS z__people__meta_load;
DROP TABLE IF EXISTS z__street;

-- end populate people 3 to 10002
-- -------------------------------------------------------------------


UPDATE people SET employee=1 WHERE p_id BETWEEN 3 AND 10;
-- -------------------------------------------------------------------
-- final working people table query (with columns no SELECT * allowed)

SELECT  p.p_id, p.first_name, p.last_name,p.email_addr, p.password
      , p.phone_pri, p.phone_sec, p.phone_fax
      , p.addr_prefix, p.addr, p.addr_code, p.addr_info
      , p.addr_delivery
      , p.addr_type_id
      , p.tc_id 
      , p.employee
FROM    people p 
WHERE   p.active=1;


-- -------------------------------------------------------------------
-- JOIN query containing all the tables
SELECT  p.p_id, p.first_name, p.last_name, p.email_addr, p.password
      , p.phone_pri, p.phone_sec, p.phone_fax
      , p.addr_prefix, p.addr, p.addr_code, p.addr_info
      , p.addr_delivery
      , p.addr_type_id
      , gat.addr_type_id, gat.addr_type
      , p.tc_id 
      , gtc.tc_id, gtc.tc_name
      , gtc.rg_id
      , grg.rg_id, grg.rg_name, grg.rg_abbr
      , grg.co_id
      , gco.co_id, gco.co_name, gco.co_abbr
FROM    people p
        JOIN geo_address_type gat ON p.addr_type_id=gat.addr_type_id
        JOIN geo_towncity     gtc ON p.tc_id=gtc.tc_id
        JOIN geo_region       grg ON gtc.rg_id=grg.rg_id
        JOIN geo_country      gco ON grg.co_id=gco.co_Id
WHERE   p.active=1;


-- -------------------------------------------------------------------
-- Envelope Query

SELECT p.first_name, p.last_name, p.addr_prefix, p.addr, p.addr_code
     , p.addr_info, p.addr_delivery
     , gat.addr_type
     , gtc.tc_name
     , grg.rg_abbr
     , gco.co_abbr
FROM   people p
       JOIN geo_address_type gat ON p.addr_type_id=gat.addr_type_id
       JOIN geo_towncity     gtc ON p.tc_id=gtc.tc_id
       JOIN geo_region       grg ON gtc.rg_id=grg.rg_id
       JOIN geo_country      gco ON grg.co_id=gco.co_Id
WHERE  p.active=1;

-- -------------------------------------------------------------------
-- Table: people_employee --------------------------------------------
DROP TABLE IF EXISTS people_employee;
CREATE TABLE IF NOT EXISTS people_employee ( 
      pe_id           SMALLINT  UNSIGNED AUTO_INCREMENT 
    , p_id            MEDIUMINT UNSIGNED NOT NULL -- FK
    , p_id_mgr        MEDIUMINT UNSIGNED -- FK
    , pe_employee_id  CHAR(10)
    , pe_hired        DATETIME 
    , pe_salary       DECIMAL(7,2) 
    , usermod         MEDIUMINT NOT NULL DEFAULT 2 
    , datemod         DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP 
    , active          BIT       NOT NULL DEFAULT 1 
    , PRIMARY KEY(pe_id)
);

TRUNCATE TABLE people_employee;
INSERT   INTO  people_employee 
       (p_id, p_id_mgr, pe_employee_id, pe_hired, pe_salary)            
VALUES (1, NULL, 'A11000010', '2022-02-15', 9900.00)
      ,(2, 1,    'B21000011', '2024-01-02', 3300.00)
      ,(3, 2,    'B21000020', '2024-03-17', 2200.00)
      ,(4, 2,    'B21000032', '2024-03-17', 2200.00)
      ,(5, 2,    'B21000042', '2024-03-17', 2200.00)
      ,(6, 2,    'B21000052', '2024-03-17', 2200.00)
      ,(7, 2,    'B21000062', '2024-03-17', 2200.00)
      ,(8, 2,    'B21000072', '2024-03-17', 2200.00)
      ,(9, 2,    'B21000082', '2024-03-17', 2200.00)
;

SELECT pe.p_id_mgr, pe.pe_id, pe.p_id, pe.pe_employee_id
     , pe.pe_hired, pe.pe_salary
     , pe.usermod, pe.datemod, pe.active
FROM   people_employee pe;


-- employee join and manager
SELECT pe.pe_id
     , pe.p_id, e.p_id, e.first_name, e.last_name 
     , pe.p_id_mgr, m.p_id, m.first_name, m.last_name
     , pe.pe_hired, pe.pe_salary
FROM   people_employee pe 
       JOIN      people e ON pe.p_id=e.p_id
       LEFT JOIN people m ON pe.p_id_mgr=m.p_id
WHERE  e.active=1 OR m.active=1;


-- -------------------------------------------------------------------
-- DROP/CREATE/TRUNCATE/INSERT/SELECT manufacturer TABLE block
DROP   TABLE   IF     EXISTS   manufacturer ;
CREATE TABLE   IF NOT EXISTS   manufacturer(
    man_id         MEDIUMINT           AUTO_INCREMENT 
  , p_id_man       MEDIUMINT  UNSIGNED -- AUTO_INCREMENT
  , man_name       VARCHAR(50) 
  , email_addr     VARCHAR (50)
  , password       CHAR(32)
  , phone_pri      CHAR(12)
  , phone_sec      CHAR(12)
  , phone_fax      CHAR(12)
  , addr_prefix    VARCHAR(25)
  , addr           VARCHAR(60)
  , addr_code      VARCHAR(15)
  , addr_info      VARCHAR(191)
  , addr_delivery  VARCHAR (191)
  , addr_type_id   TINYINT   UNSIGNED -- AUTO_INCREMENT
  , tc_id          SMALLINT  UNSIGNED -- AUTO_INCREMENT
  , usermod        INT       -- NOT NULL DEFAULT = 0
  , datemod        DATETIME  -- NOT NULL
  , useract        INT       -- NOT NULL DEFAULT = 1
  , dateact        DATETIME  -- NOT NULL 
  , active         BIT       -- NOT NULL DEFAULT = 1
  , CONSTRAINT   man___PK             PRIMARY KEY(man_id)
  , CONSTRAINT   man___UK__man_name   UNIQUE(man_name ASC)
);


TRUNCATE TABLE manufacturer ;


INSERT INTO manufacturer (man_name, p_id_man
                        , phone_pri, phone_sec, phone_fax
                        , addr_prefix, addr, addr_code, addr_info
                        , addr_type_id, tc_id)
VALUES         ( 'Boxstore Inc.', 1
               , '222-222-2222', '333-333-3333', '444-444-4444'
               , 'Floor 1', '3 Road Runner Way', 'ROH HOH', NULL
               , 3, 1);
INSERT INTO manufacturer 
     (man_id, p_id_man, man_name, addr, addr_info, addr_type_id, tc_id)
       
VALUES (2,101,'Apple Inc.','260-17 1st St','PO Box 2601',3,7)
     , (3,202,'Samsung Electronics','221-6 2nd St','PO Box 24',3,5)
     , (4,303,'Dell Technologies','90-62 3rd St','PO Box 2517',3,9)
     , (5,404,'Hitachi','88-42 4th St','PO Box 2654',3,2)
     , (6,505,'Sony','80-92 5th St','PO Box 4017',3,3)
     , (7,606,'Panasonic','74-73 6th St' ,'PO Box 4958',3,4)
     , (8,707,'Intel','71-9 7th St','PO Box 2934',3,8)
     , (9,808,'LG Electronics','54-39 8th St','PO Box 9824',3,6)
     , (10,909,'Microsoft','100-10 Ninth St','PO Box: 98245',3,10)
;                   
                         

SELECT p_id_man, man_id, man_name, phone_pri, phone_sec, phone_fax
     , addr_prefix, addr, addr_info, addr_type_id, tc_id
FROM manufacturer m
WHERE 1=1;


-- -------------------------------------------------------------------
-- Create a VIEW called manufacturer_people_reps

CREATE OR REPLACE VIEW manufacturer_people_reps AS
    SELECT man.man_id, man.p_id_man, man.man_name
         , man.password, man.phone_pri, man.phone_sec, man.phone_fax
         , man.addr_prefix, man.addr, man.addr_code, man.addr_info
         , man.addr_delivery, man.addr_type_id, man.tc_id
         , p.first_name, p.last_name, p.email_addr
         , gat.addr_type_id AS addr_type_id_gat, gat.addr_type
         , gtc.tc_id AS tc_id_gtc, gtc.tc_name
         , gtc.rg_id
         , grg.rg_id AS rg_id_grg, grg.rg_name, grg.rg_abbr
         , grg.co_id
         , gco.co_id AS co_id_gco, gco.co_name, gco.co_abbr
FROM     manufacturer man
         JOIN people           p   ON man.p_id_man=p.p_id
         JOIN geo_address_type gat ON man.addr_type_id=gat.addr_type_id
         JOIN geo_towncity     gtc ON man.tc_id=gtc.tc_id
         JOIN geo_region       grg ON gtc.rg_id=grg.rg_id
         JOIN geo_country      gco ON grg.co_id=gco.co_Id

ORDER BY
    gco.co_name,
    grg.rg_name,
    gtc.tc_name,
    man.man_name;

SELECT mp.man_name, mp.first_name, mp.last_name, mp.addr, mp.addr_info
     , mp.tc_name, mp.rg_name, mp.co_name
     , mp.phone_pri, mp.phone_sec, mp.phone_fax
FROM manufacturer_people_reps mp;

-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Table: item_type (it) - PLACE TABLES/DATA after Manufacturer- 
-- Task 2.1.A

DROP TABLE IF EXISTS item_type;
CREATE TABLE IF NOT EXISTS item_type (
      it_id        TINYINT UNSIGNED AUTO_INCREMENT 
    , it_desc      VARCHAR(50) NOT NULL
    , active       BIT NOT NULL DEFAULT 1
    , CONSTRAINT item_type_PK PRIMARY KEY (it_id)
    , CONSTRAINT item_type_UK UNIQUE      (it_desc)
);

TRUNCATE TABLE item_type;
INSERT INTO item_type (it_id, it_desc)
VALUES                (1,'4KTV - 55" & Down')
                    , (2,'4KTV - 60" - 69"')
                    , (3,'8KTV - 70" & Up')
                    , (4,'Blenders')
                    , (5,'Coffee & Tea')
                    , (6,'Dryers')
                    , (7,'Smartphones')
                    , (8,'Tablets')
                    , (9,'Washers')
;

SELECT it.it_id, it.it_desc
FROM   item_type it
WHERE  it.active=1;

-- -------------------------------------------------------------------
-- Table: item (i)- Task 2.1.B
DROP TABLE IF EXISTS item;
CREATE TABLE IF NOT EXISTS item (
      item_id       INT UNSIGNED AUTO_INCREMENT 
    , man_id        SMALLINT UNSIGNED NOT NULL            -- FK
    , item_name     VARCHAR(45) NOT NULL
    , item_modelno  VARCHAR(20)
    , item_barcode  CHAR(12)
    , it_id         TINYINT UNSIGNED NOT NULL            -- FK
    , item_price    NUMERIC(7,2)            -- current_price
    , usermod       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , datemod       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , useract       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , dateact       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active        BIT NOT NULL DEFAULT 1
    , CONSTRAINT item_PK PRIMARY KEY (item_id)
    , CONSTRAINT item_UK_man_item_model UNIQUE (man_id ASC, item_name ASC, item_modelno)
);

TRUNCATE TABLE item;
INSERT INTO item 
       (item_id, man_id, item_name, item_modelno, item_barcode, it_id, item_price)
VALUES (1, 2,  'Actually a Flipper', '4DAI0200002260', '000000002260', 7, 264.74)
     , (2, 2,  'Actually a Flipper 2', '7BOC0200002293', '000000002293', 7, 207.79)
     , (3, 2,  'Mini Tablet', '4DAI0200002123', '000000002123', 8, 424.58)
     , (4, 2,  'Tiny Tablet', '4DAI0200002136', '000000002136', 8, 374.63)
     , (5, 1,  'Barista Express', '1GQD0200001006', '000000001006', 5, 100.00)
     , (6, 1,  'Barista Express II', '1GQD0200001012', '000000001012', 5, 133.17)
     , (7, 1,  'Super Tablet', '1GQD0200008335', '000000008335', 8, 1435.00)
     , (8, 1,  'Super Tablet 1TB', '3ADA0100008360', '000000008360', 8, 2000.00)
     , (9, 4,  '20 ounce Blender', '3SKY0111164009', '000011164009', 4, 69.53)
     , (10, 4, '40 ounce Blender ', '3SKY0142542001', '000042542001', 4, 89.41)
     , (11, 4, '65" HDTV', '3FPT0100051281', '000000051281', 2, 6665.33)
     , (12, 4, '60" HDTV', '3DET0100051281', '000000051287', 2, 6065.33)
     , (13, 4, 'Mini Tablet', '3OCE0108211010', '000008211010', 8, 499.50)
     , (14, 4, 'Really Smartphone', '3TEC0350864001', '000050864001', 7, 1090.91)
     , (15, 5, '20 ounce Blender', '4MAR0120815001', '000020815001', 4, 54.35)
     , (16, 5, 'Actually a Flipper', '4HEL0140184001', '000040184001', 7, 226.07)
     , (17, 5, 'Barista Express', '4HEL0140182001', '000040182001', 5, 172.63)
     , (18, 5, 'Dryer', '7HYU0200008359', '000000008359', 6, 710.00)
     , (19, 5, 'Mini Tablet', '4HEL0105850009', '000005850009', 8, 448.25)
     , (20, 5, 'Really Smartphone', '7HAN0200013563', '000000013563', 7, 1170.00)
     , (21, 5, 'Super Tablet', '7HYU0200041406', '000000041406', 8, 1500.00)
     , (22, 8, '20 ounce Blender', '2SUR1108413009', '000008413009', 4, 50.75)
     , (23, 8, 'Barista Express', '2SUR1103820009', '000003820009', 5, 104.50)
     , (24, 8, 'Really Smartphone', '2SUR1101100321', '000001100321', 7, 1272.00)
     , (25, 8, 'Super Tablet', '2SUR1100008294', '000000008294', 8, 1414.11)
     , (26, 9, 'Mini Tablet', '2SUR1100002136', '000000002136', 8, 374.63)
     , (27, 9, 'Not-as Smartphone', '2SUR1100002124', '000000002124', 7, 358.74)
     , (28, 9, 'Really Smartphone', '2SUR1100041398', '000000041398', 7, 1200.00)
     , (29, 9, 'Super Tablet', '2SUR1100008335', '000000008335', 8, 1435.00)
     , (30, 9, 'Super Tablet X', '2SUR1100011577', '000000011577', 8, 1842.00)
     , (31, 10,'55" HDTV', '2BRE1000066014', '000000056014', 1, 2605.00)
     , (32, 10,'50" HDTV', '2BRE1000056014', '000000066001', 1, 2100.00)
     , (33, 10,'Not-as Smartphone', '2BRE1200002124', '000000002124', 7, 358.74)
     , (34, 10,'Really Smartphone', '2BRE0100008427', '000000008427', 7, 1010.00)
     , (35, 10,'Really Smartphone X', '2BRE0600013628', '000000013628', 7, 1350.00)
     , (36, 10,'Super Tablet', '2SUR1100041491', '000000041491', 8, 1991.00)
     , (37, 7, 'Barista Express', '7SPP0105618009', '000005618009', 5, 199.80)
     , (38, 7, 'Not-as Smartphone', '7SPP0120983041', '000020983041', 7, 332.97)
     , (39, 7, 'Super Tablet', '7SPP0100041406', '000000041406', 8, 1500.00)
     , (40, 3, 'Barista Express', '3BRI0300001012', '000000001012', 5, 133.17)
     , (41, 3, 'Mini Tablet', '3BRI0400002136', '000000002136', 8, 374.63)
     , (42, 3, 'Really Smartphone', '7DAE0400012490', '000000012490', 7, 1250.00)
     , (43, 3, 'Super Tablet', '7DAE0400008335', '000000008335', 8, 1435.00)
     , (44, 3, 'Washer', '3BRI3505804084', '000005804084', 9, 504.69)
     , (45, 3, 'Washer X', '3BRI3505805085', '000005805085', 9, 553.95)
     , (46, 6, '50" HDTV', '6PRI0299999203', '000099999203', 1, 2100.00)
     , (47, 6, '75" HDTV', '6PRI0299999197', '000099999197', 3, 20013.33)
     , (48, 6, 'Super Tablet', '7SMS0100041406', '000000008355', 8, 1500.00)
;

SELECT i.item_id, i.item_name, i.item_modelno, i.item_barcode
     , i.item_price
     , i.man_id, i.it_id
     , i.usermod, i.datemod, i.useract, i.dateact, i.active
FROM   item i
WHERE  i.active=1;

-- Creating a join from item table to manufacturer and
--  then item_type tables
SELECT i.item_id, i.item_name, i.item_modelno, i.item_barcode
     , i.item_price
     , i.man_id
     , man.man_id, man.man_name
     , i.it_id
     , it.it_id, it.it_desc
FROM   item i
       JOIN manufacturer man ON i.man_id=man.man_id
       JOIN item_type it ON i.it_id=it.it_id;

-- -------------------------------------------------------------------
-- Table: item_inventory - Task 2.1.C
DROP   TABLE IF     EXISTS item_inventory;
CREATE TABLE IF NOT EXISTS item_inventory (
      ii_id       BIGINT AUTO_INCREMENT
    , item_id     INT                       -- FK
    , ii_serialno CHAR(6)
    , oi_id       BIGINT NULL
    , usermod     MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , datemod     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , useract     MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , dateact     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active      BIT NOT NULL DEFAULT 1

    , CONSTRAINT ii_PK PRIMARY KEY (ii_id)
);
      
TRUNCATE TABLE item_inventory;
INSERT INTO item_inventory (ii_id, item_id, ii_serialno, oi_id)
VALUES (1,5,'1GQD04',1)
     , (2,15,'G36954',2)
     , (3,15,'G36955',2)
     , (4,32,'2BRE12',4)
     , (5,32,'2BRE13',4)
     , (6,6,'1GQD10',6)
     , (7,6,'1GQD11',7)
     , (8,21,'G36976',8)
     , (9,21,'G36977',8)
     , (10,37,'7SPP01',10)
     , (11,37,'7SPP02',10)
     , (12,38,'7SPP05',12)
     , (13,38,'7SPP06',12)
     , (14,38,'7SPP07',12)
     , (15,38,'7SPP08',12)
     , (16,34,'2BRE20',16)
     , (17,34,'2BRE21',17)
     , (18,44,'3BRI13',18)
     , (19,44,'3BRI14',18)
     , (20,34,'2BRE22',20)
     , (21,34,'2BRE23',20)
     , (22,22,'2SUR11',22)
     , (23,22,'2SUR12',22)
     , (24,23,'2SUR13',24)
     , (25,23,'2SUR14',24)
     , (26,23,'2SUR15',24)
     , (27,23,'2SUR16',24)
     , (28,23,'2SUR17',24)
     , (29,23,'2SUR18',24)
     , (30,23,'2SUR19',24)
     , (31,23,'2SUR20',24)
     , (32,23,'2SUR21',24)
     , (33,23,'2SUR22',24)
     , (34,23,'2SUR23',24)
     , (35,23,'2SUR24',24)
     , (36,23,'2SUR25',24)
     , (37,23,'2SUR26',24)
     , (38,28,'ESUR29',38)
     , (39,24,'2SUR31',39)
     , (40,9,'3SKY01',40)
     , (41,9,'3SKY02',40)
     , (42,10,'3SKY03',42)
     , (43,10,'3SKY04',42)
     , (44,7,'1GQD12',44)
     , (45,7,'1GQD13',44)
     , (46,42,'3BRI09',46)
     , (47,42,'3BRI10',46)
     , (48,14,'3SKY13',48)
     , (49,18,'G36964',49)
     , (50,20,'G36975',50)
     , (51,45,'3BRI15',51)
     , (52,48,'4SOD15',52)
     , (53,16,'G36958',53)
     , (54,16,'G36959',53)
     , (55,16,'G36960',53)
     , (56,17,'G36961',56)
     , (57,19,'G36972',57)
     , (58,19,'G36973',57)
     , (59,30,'ESUR33',59)
     , (60,30,'ESUR34',59)
     , (61,36,'2BRE34',61)
     , (62,36,'2BRE35',61)
     , (63,31,'2BRE10',63)
     , (64,31,'2BRE11',63)
     , (65,35,'2BRE24',65)
     , (66,35,'2BRE25',66)
     , (67,29,'ESUR31',67)
     , (68,29,'ESUR32',67)
     , (69,33,'2BRE18',69)
     , (70,33,'2BRE19',69)
     , (71,8,'1GQD14',71)
     , (72,8,'1GQD15',71)
     , (73,8,'1GQD16',71)
     , (74,8,'1GQD17',71)
     , (75,11,'3SKY05',75)
     , (76,11,'3SKY07',75)
     , (77,12,'3SKY09',75)
     , (78,26,'ESUR13',78)
     , (79,26,'ESUR14',78)
     , (80,26,'ESUR17',78)
     , (81,26,'ESUR18',78)
     , (82,26,'ESUR21',78)
     , (83,26,'ESUR22',78)
     , (84,13,'3SKYX1',84)
     , (85,13,'3SKY11',84)
     , (86,13,'3SKY12',84)
     , (87,26,'ESUR15',87)
     , (88,26,'ESUR16',87)
     , (89,26,'ESUR19',87)
     , (90,28,'ESUR27',90)
     , (91,28,'ESUR28',90)
     , (92,43,'3BRI11',92)
     , (93,43,'3BRI12',93)
     , (94,27,'ESUR25',94)
     , (95,27,'ESUR26',94)
     , (96,18,'G36966',96)
     , (97,18,'G36967',97)
     , (98,48,'4SOD17',98)
     , (99,48,'4SOD18',98)
     , (100,18,'G36968',100)
     , (101,39,'7SPP09',101)
     , (102,39,'7SPP10',101)
     , (103,25,'2SUR36',103)
     , (104,40,'3BRI03',104)
     , (105,35,'2BRE27',105)
     , (106,46,'4SOD03',106)
     , (107,46,'4SOD04',106)
     , (108,47,'4SOD05',108)
     , (109,47,'4SOD06',108)
     , (110,47,'4SOD07',108)
     , (111,47,'4SOD08',108)
     , (112,1,'4DAI02',112)
     , (113,1,'4DAI03',112)
     , (114,41,'3BRI05',114)
     , (115,4,'4DAI10',115)
     , (116,3,'4DAI08',116)
     , (117,2,'4DAI04',117)
     , (118,2,'4DAI05',117)
     , (119,2,'4DAI06',117)
     , (120,2,'4DAI07',117)
;

SELECT ii.ii_id, ii.item_id, ii.ii_serialno, ii.oi_id
     , ii.usermod, ii.datemod, ii.active
FROM item_inventory ii;


-- Creating a join from item table to item inventory tables
SELECT ii.ii_id, ii.ii_serialno, ii.oi_id, ii.item_id
     , i.item_id, i.item_name, i.item_modelno, i.item_barcode
     , i.item_price
     , i.man_id, i.it_id
FROM   item i
       JOIN item_inventory ii ON ii.item_id=i.item_id;
 

-- -------------------------------------------------------------------
-- Table: item_price (ip)- 2.1.D

DROP TABLE IF EXISTS item_price;
CREATE TABLE IF NOT EXISTS item_price (
      ip_id         BIGINT UNSIGNED AUTO_INCREMENT
    , item_id       INT                          -- FK
    , item_price    NUMERIC(7,2) 
    , ip_beg        DATETIME NULL
    , ip_end        DATETIME NULL
    , usermod       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , datemod       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , useract       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , dateact       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active        BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (ip_id)
);
      
TRUNCATE TABLE item_price;
INSERT INTO item_price 
       (ip_id, item_id, item_price, ip_beg, ip_end)
VALUES (1,1,264.74,'2021-05-18 00:00:00',NULL)
     , (2,2,207.79,'2021-05-18 00:00:00',NULL)
     , (3,3,424.58,'2021-05-18 00:00:00',NULL)
     , (4,4,374.63,'2021-05-18 00:00:00',NULL)
     , (5,5,100.00,'2021-01-13 00:00:00',NULL)
     , (6,6,133.17,'2021-01-13 00:00:00',NULL)
     , (7,7,1435.00,'2021-01-18 00:00:00',NULL)
     , (8,8,2000.00,'2021-02-24 00:00:00',NULL)
     , (9,9,69.53,'2021-01-18 00:00:00',NULL)
     , (10,10,89.41,'2021-01-18 00:00:00',NULL)
     , (11,11,6665.33,'2021-02-17 00:00:00',NULL)
     , (12,12,6065.33,'2021-02-17 00:00:00',NULL)
     , (13,13,499.50,'2021-02-26 00:00:00',NULL)
     , (14,14,1090.91,'2021-01-18 00:00:00',NULL)
     , (15,15,54.35,'2021-01-13 00:00:00',NULL)
     , (16,16,226.07,'2021-01-18 00:00:00',NULL)
     , (17,17,172.63,'2021-01-18 00:00:00',NULL)
     , (18,18,710.00,'2021-01-18 00:00:00',NULL)
     , (19,19,448.25,'2021-01-18 00:00:00',NULL)
     , (20,20,1170.00,'2021-01-18 00:00:00',NULL)
     , (21,21,1500.00,'2021-01-14 00:00:00',NULL)
     , (22,22,50.75,'2021-01-18 00:00:00',NULL)
     , (23,23,104.50,'2021-01-18 00:00:00',NULL)
     , (24,24,1272.00,'2021-01-18 00:00:00',NULL)
     , (25,25,1414.11,'2021-04-27 00:00:00',NULL)
     , (26,26,374.63,'2021-02-26 00:00:00',NULL)
     , (27,27,358.74,'2021-03-08 00:00:00',NULL)
     , (28,28,1040.00,'2021-01-18 00:00:00','2021-02-25 23:59:59')
     , (29,28,1200.00,'2021-02-26 00:00:00',NULL)
     , (30,29,1435.00,'2021-01-19 00:00:00',NULL)
     , (31,30,1842.00,'2021-01-18 00:00:00',NULL)
     , (32,31,2605.00,'2021-01-18 00:00:00',NULL)
     , (33,32,2100.00,'2021-01-13 00:00:00',NULL)
     , (34,33,358.74,'2021-02-24 00:00:00',NULL)
     , (35,34,1010.00,'2021-01-14 00:00:00',NULL)
     , (36,35,1350.00,'2021-01-18 00:00:00',NULL)
     , (37,36,1991.00,'2021-01-18 00:00:00',NULL)
     , (38,37,199.80,'2021-01-14 00:00:00',NULL)
     , (39,38,332.97,'2021-01-14 00:00:00',NULL)
     , (40,39,1500.00,'2021-03-04 00:00:00',NULL)
     , (41,40,133.17,'2021-04-28 00:00:00',NULL)
     , (42,41,374.63,'2021-05-18 00:00:00',NULL)
     , (43,42,1250.00,'2021-01-18 00:00:00',NULL)
     , (44,43,1435.00,'2021-02-26 00:00:00',NULL)
     , (45,44,504.69,'2021-01-14 00:00:00',NULL)
     , (46,45,553.95,'2021-01-18 00:00:00',NULL)
     , (47,46,2100.00,'2021-05-18 00:00:00',NULL)
     , (48,47,20013.33,'2021-05-18 00:00:00',NULL)
     , (49,48,1435.00,'2021-01-18 00:00:00','2021-03-03 23:59:59')
     , (50,48,1500.00,'2021-03-04 00:00:00',NULL)        
;
SELECT ip.ip_id, ip.item_id, ip.item_price, ip.ip_beg, ip.ip_end
     , ip.usermod, ip.datemod, ip.useract, ip.dateact, ip.active
FROM   item_price ip;

-- -------------------------------------------------------------------
-- Table: orders (o)- 2.1.E
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
      order_id      INT UNSIGNED AUTO_INCREMENT     
    , order_no      VARCHAR(8) NOT NULL
    , order_date    DATETIME 
    , p_id_cus      MEDIUMINT -- UNSIGNED NOT NULL
    , p_id_emp      MEDIUMINT NOT NULL      -- FK
    , os_override   NUMERIC(8,2) NOT NULL DEFAULT 0.00
    , usermod       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , datemod       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , useract       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , dateact       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active        BIT NOT NULL DEFAULT 1
    , CONSTRAINT orders_PK          PRIMARY KEY (order_id)
    , CONSTRAINT orders_UK_date_cus UNIQUE (order_date, p_id_cus)
    , CONSTRAINT orders_UK_no       UNIQUE (order_no)
    , CONSTRAINT orders_FK_p_cus    FOREIGN KEY (p_id_cus) REFERENCES people(p_id)
    , CONSTRAINT orders_FK_p_emp    FOREIGN KEY (p_id_emp) REFERENCES people(p_id)
);

TRUNCATE TABLE orders;
INSERT INTO orders 
       (order_id, order_no, order_date, p_id_cus, p_id_emp)
VALUES (1 ,'00001003','2021-01-13 13:01:13',100 ,2)
     , (2 ,'00001021','2021-01-13 13:01:14',200 ,2)
     , (3 ,'00001026','2021-01-13 13:01:15',300 ,2)
     , (4 ,'00001030','2021-01-13 13:01:16',400 ,2)
     , (5 ,'00001031','2021-01-14 14:01:01',500 ,2)
     , (6 ,'00001033','2021-01-14 14:01:02',600 ,2)
     , (7 ,'00001034','2021-01-14 14:01:03',700 ,2)
     , (8 ,'00001036','2021-01-18 18:01:00',800 ,2)
     , (9 ,'00001040','2021-01-18 18:01:01',900 ,2)
     , (10,'00001042','2021-01-18 18:01:02',1000,2)
     , (11,'00001043','2021-01-18 18:01:03',1100,2)
     , (12,'00001044','2021-01-18 18:01:04',1200,2)
     , (13,'00001046','2021-01-18 18:01:05',1300,2)
     , (14,'00001048','2021-01-18 18:01:06',1400,2)
     , (15,'00001049','2021-01-18 18:01:07',1500,2)
     , (16,'00001051','2021-01-18 18:01:08',1600,2)
     , (17,'00001052','2021-01-18 18:01:09',1700,2)
     , (18,'00001054','2021-01-18 18:01:10',1800,2)
     , (19,'00001056','2021-01-18 18:01:11',1900,2)
     , (20,'00001057','2021-01-18 18:01:12',2000,2)
     , (21,'00001058','2021-01-18 18:01:13',2100,2)
     , (22,'00001064','2021-01-19 19:01:01',2200,2)
     , (23,'00001089','2021-02-24 22:02:01',2300,2)
     , (24,'00001090','2021-02-24 22:02:02',2400,2)
     , (25,'00001091','2021-02-17 17:02:01',2500,2)
     , (26,'00001102','2021-02-26 21:02:01',2600,2)
     , (27,'00001105','2021-02-26 21:02:02',2700,2)
     , (28,'00001107','2021-03-05 05:03:01',2800,2)
     , (29,'00001111','2021-02-26 21:02:03',2900,2)
     , (30,'00001114','2021-03-08 08:03:01',3000,2)
     , (31,'00001117','2021-03-04 04:03:01',3100,2)
     , (32,'00001119','2021-03-04 04:03:02',3200,2)
     , (33,'00001150','2021-04-27 20:04:01',3300,2)
     , (34,'00001151','2021-04-28 20:04:01',3400,2)
     , (35,'00001157','2021-05-17 17:05:01',3500,2)
     , (36,'00001160','2021-05-18 18:05:01',3600,2)
     , (37,'00001168','2021-05-18 18:05:02',3700,2)
     , (38,'00001169','2021-05-18 18:05:03',3800,2)
     , (39,'00001170','2021-05-18 18:05:04',3900,2)
     , (40,'00001171','2021-05-18 18:05:05',4000,2)
     , (41,'00001173','2021-05-18 18:05:06',4100,2);
                                   
SELECT o.order_id, o.order_no, o.order_date, o.p_id_cus, o.p_id_emp
     , o.usermod, o.datemod, o.active
FROM orders o;

-- creating a join to get the employee's full name, 
-- the employee number and the customer's full name
SELECT o.order_id, o.order_no, o.order_date,o.p_id_cus, o.p_id_emp
     , CONCAT(e.first_name,' ', e.last_name) AS employee_name
     , pe_employee_id
     , CONCAT(c.first_name,' ', c.last_name) AS customer_name
FROM orders o
     JOIN people e ON o.p_id_emp=e.p_id
     JOIN people_employee pe ON pe.p_id=e.p_id 
     JOIN people c ON o.p_id_cus=c.p_id;
     

-- -------------------------------------------------------------------
-- Table: orders_item (oi) - 2.1.F

DROP TABLE IF EXISTS orders__item;
CREATE TABLE IF NOT EXISTS orders__item (
      oi_id         BIGINT UNSIGNED AUTO_INCREMENT
    , order_id      INT -- FK
    , item_id       INT -- FK
    , oi_qty        SMALLINT                       
    , ip_override   NUMERIC(7,2) NOT NULL DEFAULT 0.00               
    , usermod       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , datemod       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , useract       MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , dateact       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active        BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (oi_id)
    , CONSTRAINT oi_UK UNIQUE (order_id, item_id, oi_qty)
);

TRUNCATE TABLE orders__item;
INSERT INTO orders__item  (oi_id, order_id, item_id, oi_qty)  
VALUES (1,1,5,1)
     , (2,2,15,2)
     , (4,3,32,2)
     , (6,4,6,-1)
     , (7,4,6,1)
     , (8,5,21,2)
     , (10,5,37,2)
     , (12,5,38,4)
     , (16,6,34,-1)
     , (17,6,34,1)
     , (18,7,44,2)
     , (20,8,34,2)
     , (22,9,22,2)
     , (24,9,23,14)
     , (38,10,28,1)
     , (39,11,24,1)
     , (40,12,9,2)
     , (42,12,10,2)
     , (44,13,7,2)
     , (46,13,42,2)
     , (48,14,14,1)
     , (49,15,18,1)
     , (50,15,20,1)
     , (51,16,45,1)
     , (52,17,48,1)
     , (53,18,16,3)
     , (56,18,17,1)
     , (57,18,19,2)
     , (59,19,30,2)
     , (61,19,36,2)
     , (63,20,31,2)
     , (65,21,35,1)
     , (66,21,35,-1)
     , (67,22,29,-2)
     , (69,23,33,-2)
     , (71,24,8,4)
     , (75,25,11,3)
     , (76,25,12,3)
     , (78,26,26,6)
     , (84,27,13,3)
     , (87,28,26,3)
     , (90,29,28,2)
     , (92,29,43,-1)
     , (93,29,43,1)
     , (94,30,27,2)
     , (96,31,18,-1)
     , (97,31,18,1)
     , (98,31,48,2)
     , (100,32,18,1)
     , (101,32,39,2)
     , (103,33,25,1)
     , (104,34,40,1)
     , (105,35,35,1)
     , (106,36,46,2)
     , (108,36,47,4)
     , (112,37,1,2)
     , (114,38,41,1)
     , (115,39,4,1)
     , (116,40,3,1)
     , (117,41,2,4)
;

SELECT oi.oi_id, oi.order_id, oi.item_id, oi.oi_qty
     , oi.usermod, oi.datemod, oi.active
FROM orders__item oi;

-- Creating a BIG JOIN from orders_item to all the required tables
SELECT oi.oi_id, oi.item_id, oi.oi_qty, oi.order_id
     , o.order_id, o.order_no, o.order_date, o.p_id_cus, o.p_id_emp
     , i.item_id, i.item_name, i.item_modelno, i.item_barcode, i.item_price
     , i.man_id
     , man.man_id, man.man_name
     , i.it_id
     , it.it_id, it.it_desc
     , ip.item_id, ip.item_price, ip.ip_beg, ip.ip_end
     , FORMAT(oi.oi_qty * ip.item_price,2) AS subtotal_item
     , GROUP_CONCAT(ii.ii_serialno ORDER BY ii.ii_serialno SEPARATOR ',')
       AS serial_numbers
FROM orders__item oi
     JOIN orders o ON oi.order_id=o.order_id
     JOIN item i  ON oi.item_id=i.item_id
     JOIN manufacturer man ON i.man_id=man.man_id
     JOIN item_type it ON i.it_id=it.it_id
     JOIN item_price ip ON oi.item_id=ip.item_id
     JOIN item_inventory ii ON oi.oi_id=ii.oi_id
WHERE o.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, o.order_date)
GROUP BY oi.oi_id, oi.item_id, oi.oi_qty, oi.order_id
       , o.order_id, o.order_no, o.order_date, o.p_id_cus, o.p_id_emp
       , i.item_id, i.item_name, i.item_modelno, i.item_barcode
       , i.item_price
       , i.man_id
       , man.man_id, man.man_name
       , i.it_id
       , it.it_id, it.it_desc
       , ip.item_id, ip.item_price, ip.ip_beg, ip.ip_end
;


-- -------------------------------------------------------------------
-- Table: taxes (t)-2.1.G
DROP TABLE IF EXISTS taxes;
CREATE TABLE IF NOT EXISTS taxes (
      tax_id   TINYINT UNSIGNED AUTO_INCREMENT
    , tax_type CHAR(3)
    , tax_beg  DATE
    , tax_end  DATE
    , tax_perc NUMERIC(4,2)
    , usermod  MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , datemod  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , useract  MEDIUMINT NOT NULL DEFAULT 2  -- FK
    , dateact  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active   BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (tax_id)
);

TRUNCATE TABLE taxes;
-- bulk insert
INSERT INTO taxes (tax_type, tax_beg, tax_end, tax_perc)  
VALUES            ('PST', '1987-07-01', '2013-06-30', 7.00)
                , ('GST', '1991-01-01', '1997-03-31', 7.00)
                , ('GST', '1997-04-01', '2007-12-31', 6.00)
                , ('GST', '2008-01-01', NULL, 5.00)
                , ('PST', '2013-07-01', '2018-06-30', 8.00)
                , ('PST', '2019-07-01', NULL, 7.00);
        
SELECT t.tax_id, t.tax_type, t.tax_beg, t.tax_end, t.tax_perc
     , t.usermod, t.datemod, t.active
FROM taxes t;

-- -------------------------------------------------------------------
-- Receipt views - 1st View
CREATE OR REPLACE VIEW receipt_00_header_company_info AS 
SELECT man.man_name, man.email_addr
     , man.phone_pri, man.phone_sec, man.phone_fax
     , man.addr_prefix, man.addr, man.addr_code
     , gat.addr_type
     , gtc.tc_name, grg.rg_name, grg.rg_abbr, gco.co_name, gco.co_abbr 
FROM   manufacturer man
       JOIN geo_address_type gat ON man.addr_type_id=gat.addr_type_id
       JOIN geo_towncity     gtc ON man.tc_id=gtc.tc_id
       JOIN geo_region       grg ON gtc.rg_id=grg.rg_id
       JOIN geo_country      gco ON grg.co_id=gco.co_id
WHERE man.man_id = 1;

SELECT man_name
     , addr_prefix, addr
     , addr_type
     , tc_name, rg_abbr, co_name, addr_code
     , phone_pri, phone_sec, phone_fax
FROM  receipt_00_header_company_info
;

-- -------------------------------------------------------------------
-- Receipt views - 2nd View

CREATE OR REPLACE VIEW receipt_01_header_order_employee_customer AS 
SELECT o.order_id, o.order_no, o.order_date
     , CONCAT(e.first_name,' ', e.last_name) AS employee_name
     , pe_employee_id
     , CONCAT(c.first_name,' ', c.last_name) AS customer_name
FROM orders o
     JOIN people e ON o.p_id_emp=e.p_id
     JOIN people c ON o.p_id_cus=c.p_id
     JOIN people_employee pe ON pe.p_id=e.p_id;

SELECT order_no, order_date
     , employee_name, pe_employee_id
     , customer_name
FROM  receipt_01_header_order_employee_customer;
-- WHERE order_id=1;


-- -------------------------------------------------------------------
-- Receipt views - 3rd View
CREATE OR REPLACE VIEW receipt_10_body_line_items AS 

SELECT o.order_id, o.order_date
     , i.item_name, i.item_modelno, i.item_barcode
     , man.man_id, man.man_name
     , it.it_desc
     , ip.item_price
     , oi.oi_qty
     , FORMAT(oi.oi_qty * ip.item_price,2) AS subtotal_item
     , GROUP_CONCAT(ii.ii_serialno ORDER BY ii.ii_serialno SEPARATOR ',')
       AS serial_numbers
FROM orders__item oi
     JOIN orders o ON oi.order_id=o.order_id
     JOIN item i  ON oi.item_id=i.item_id
     JOIN manufacturer man ON i.man_id=man.man_id
     JOIN item_type it ON i.it_id=it.it_id
     JOIN item_price ip ON oi.item_id=ip.item_id
     JOIN item_inventory ii ON oi.oi_id=ii.oi_id
WHERE o.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, o.order_date)
GROUP BY o.order_id, o.order_no, o.order_date
      ,  i.item_name, i.item_modelno, i.item_barcode
      ,  man.man_id, man.man_name
      ,  it.it_desc
      ,  ip.item_price
      ,  oi.oi_qty
;


SELECT order_id, order_date, item_name, item_modelno, item_barcode
     , man_name, item_price, oi_qty, subtotal_item
     , serial_numbers

FROM  receipt_10_body_line_items; 
-- WHERE order_id=1;


-- -------------------------------------------------------------------
-- Receipt views - 4th View

CREATE OR REPLACE VIEW receipt_20_footer_subtotal AS 
SELECT order_id, order_date, FORMAT(SUM(subtotal_item),2) AS subtotal
FROM  receipt_10_body_line_items 
GROUP BY order_id
;

SELECT order_id, subtotal
FROM receipt_20_footer_subtotal;

-- -------------------------------------------------------------------
-- Receipt views - 5th View
CREATE OR REPLACE VIEW receipt_21_footer_subtotal_taxes AS
SELECT sub.order_id, sub.subtotal, t.tax_type, t.tax_perc
     , sub.subtotal * (t.tax_perc/100.00) AS taxes
FROM  receipt_20_footer_subtotal sub, taxes t
WHERE order_date BETWEEN tax_beg AND IFNULL(tax_end, order_date);

SELECT order_id, subtotal, tax_type, tax_perc, taxes
FROM receipt_21_footer_subtotal_taxes;

-- -------------------------------------------------------------------
-- Receipt views - 6th View

CREATE OR REPLACE VIEW receipt_22_footer_grandtotal AS 
SELECT order_id, FORMAT(MIN(subtotal) + SUM(taxes),2) AS grand_total 
FROM  receipt_21_footer_subtotal_taxes
GROUP BY order_id;

SELECT order_id, grand_total
FROM receipt_22_footer_grandtotal;

















































