-- 06_geographic_analysis.sql
-- Business story: identify geographic markets that drive sales and profit.

-- 1. Country performance
SELECT
    Country,
    SUM(Sales) AS total_sales,
    SUM(Quantity) AS total_quantity,
    COUNT(DISTINCT Order_id) AS distinct_orders,
    SUM(Profit) AS total_profit
FROM Orders
GROUP BY Country
ORDER BY total_sales DESC;

-- 2. State profitability
SELECT
    Country,
    State,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM Orders
GROUP BY Country, State
ORDER BY total_profit DESC;

-- 3. Largest loss-making states within each country
WITH state_profit AS (
    SELECT
        Country,
        State,
        SUM(Profit) AS total_profit
    FROM Orders
    GROUP BY Country, State
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY total_profit ASC
        ) AS rn
    FROM state_profit
)
SELECT
    Country,
    State,
    total_profit
FROM ranked
WHERE rn = 1
ORDER BY Country;

-- 4. Highest-order city within each country
WITH city_orders AS (
    SELECT
        Country,
        City,
        COUNT(DISTINCT Order_id) AS distinct_orders
    FROM Orders
    GROUP BY Country, City
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY distinct_orders DESC, City
        ) AS rn
    FROM city_orders
)
SELECT
    Country,
    City,
    distinct_orders
FROM ranked
WHERE rn = 1
ORDER BY Country;

-- 5. Lowest-order city within each country
WITH city_orders AS (
    SELECT
        Country,
        City,
        COUNT(DISTINCT Order_id) AS distinct_orders
    FROM Orders
    GROUP BY Country, City
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY distinct_orders ASC, City
        ) AS rn
    FROM city_orders
)
SELECT
    Country,
    City,
    distinct_orders
FROM ranked
WHERE rn = 1
ORDER BY Country;

-- 6. Sub-category contributing most sales in the highest-order city of each country
WITH city_orders AS (
    SELECT
        Country,
        City,
        COUNT(DISTINCT Order_id) AS distinct_orders
    FROM Orders
    GROUP BY Country, City
),
highest_order_city AS (
    SELECT
        Country,
        City
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY Country
                ORDER BY distinct_orders DESC, City
            ) AS rn
        FROM city_orders
    ) x
    WHERE rn = 1
),
subcat_sales AS (
    SELECT
        o.Country,
        o.City,
        o.Sub_category,
        SUM(o.Sales) AS total_sales
    FROM Orders o
    INNER JOIN highest_order_city h
        ON o.Country = h.Country
       AND o.City = h.City
    GROUP BY o.Country, o.City, o.Sub_category
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Country, City
            ORDER BY total_sales DESC, Sub_category
        ) AS rn
    FROM subcat_sales
)
SELECT
    Country,
    City,
    Sub_category,
    total_sales
FROM ranked
WHERE rn = 1
ORDER BY Country;
