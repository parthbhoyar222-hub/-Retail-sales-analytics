-- 01_data_setup.sql
-- Portfolio purpose:To recreate the analytical database objects and validate grain.
-- Kept loading/import commands environment-specific.(This file focuses on schema.)
-- Replace the three PATH_TO_*_CSV placeholders before running.
-- Inputs are comma-delimited CSVs with headers/
-- Orders dates must be DD-MM-YYYY. People and Returns each need two columns.

SHOW VARIABLES LIKE 'local_infile';

CREATE TABLE IF NOT EXISTS Orders (
    Row_id INT,
    Order_id VARCHAR(20),
    Order_date DATE,
    Ship_date DATE,
    Ship_mode VARCHAR(20),
    Customer_ID VARCHAR(30),
    Customer_name VARCHAR(60),
    Segment VARCHAR(20),
    Country VARCHAR(40),
    City VARCHAR(25),
    State VARCHAR(25),
    postal_code VARCHAR(30),
    Region VARCHAR(25),
    ProductID VARCHAR(40),
    category VARCHAR(25),
    sub_category VARCHAR(25),
    Product_name VARCHAR(200),
    Sales DECIMAL(10,4),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,4)
);

CREATE TABLE IF NOT EXISTS People (
    REGIONAL_MANAGER VARCHAR(100),
    REGION VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS Returns (
    ORDER_ID VARCHAR(20),
    RETURNED CHAR(3)
);
ALTER TABLE Returns MODIFY COLUMN RETURNED VARCHAR(10);
LOAD DATA LOCAL INFILE
'PATH_TO_ORDERS_CSV'
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

(
    Row_id,
    Order_id,
    @Order_date,
    @Ship_date,
    Ship_mode,
    Customer_ID,
    Customer_name,
    Segment,
    Country,
    City,
    State,
    postal_code,
    Region,
    ProductID,
    category,
    sub_category,
    Product_name,
    Sales,
    Quantity,
    Discount,
    Profit
)

SET
    Order_date = STR_TO_DATE(@Order_date, '%d-%m-%Y'),
    Ship_date  = STR_TO_DATE(@Ship_date, '%d-%m-%Y');

LOAD DATA LOCAL INFILE
'PATH_TO_PEOPLE_CSV'
INTO TABLE People
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

(
    REGIONAL_MANAGER,
    REGION
);

LOAD DATA LOCAL INFILE
'PATH_TO_RETURNS_CSV'
INTO TABLE Returns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

(
    ORDER_ID,
    @RETURNED
)
SET
    RETURNED = CASE
        WHEN UPPER(TRIM(@RETURNED)) IN ('YES', 'TRUE', '1') THEN 'Yes'
        ELSE 'No'
    END;

SELECT
    'Orders' AS table_name,
    COUNT(*) AS row_count
FROM Orders

UNION ALL

SELECT
    'People',
    COUNT(*)
FROM People

UNION ALL

SELECT
    'Returns',
    COUNT(*)
FROM Returns;


/* Date range */

SELECT
    MIN(Order_date) AS first_order_date,
    MAX(Order_date) AS last_order_date
FROM Orders;


-- Basic validation
SELECT COUNT(*) AS order_line_count
FROM Orders;

SELECT
    MIN(Order_date) AS first_order_date,
    MAX(Order_date) AS last_order_date
FROM Orders;

SELECT
    COUNT(*) AS rows_with_null_key_fields
FROM Orders
WHERE Order_id IS NULL
   OR Customer_ID IS NULL
   OR Order_date IS NULL
   OR Sales IS NULL
   OR Profit IS NULL;

-- Repeated Order_IDs are expected because Orders is line-grain.
SELECT
    Order_id,
    COUNT(*) AS order_line_count
FROM Orders
GROUP BY Order_id
HAVING COUNT(*) > 1
ORDER BY order_line_count DESC;

SELECT * FROM Orders;
SELECT * FROM  People;
SELECT * FROM  Returns;
