-- 01_data_setup.sql
-- Portfolio purpose: recreate the analytical database objects and validate grain.
-- Keep loading/import commands environment-specific; this file focuses on schema.

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
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS People (
    REGIONAL_MANAGER VARCHAR(100),
    REGION VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS Returns (
    ORDER_ID VARCHAR(20),
    RETURNED BOOLEAN
);

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
