-- 07_operational_returns_analysis.sql
-- Business story: evaluate shipping behavior and returns without violating table grain.

-- 1. Shipping mode usage
SELECT
    Ship_mode,
    COUNT(DISTINCT Order_id) AS distinct_orders,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM Orders
GROUP BY Ship_mode
ORDER BY distinct_orders DESC;

-- 2. Average shipping delay by customer segment
SELECT
    Segment,
    ROUND(AVG(DATEDIFF(Ship_date, Order_date)), 2) AS avg_shipping_delay_days,
    COUNT(DISTINCT Order_id) AS distinct_orders
FROM Orders
GROUP BY Segment
ORDER BY avg_shipping_delay_days DESC;

-- 3. Profitability by shipping mode
SELECT
    Ship_mode,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM Orders
GROUP BY Ship_mode
ORDER BY total_profit DESC;

-- 4. Return rate by regional manager.
-- Returns is order-level; aggregate Orders to one row per order before joining.
WITH order_metrics AS (
    SELECT
        Order_id,
        MAX(Region) AS Region
    FROM Orders
    GROUP BY Order_id
),
manager_orders AS (
    SELECT
        o.Order_id,
        o.Region,
        p.REGIONAL_MANAGER
    FROM order_metrics o
    LEFT JOIN People p
        ON o.Region = p.REGION
),
return_flags AS (
    SELECT DISTINCT
        ORDER_ID
    FROM Returns
    WHERE RETURNED = TRUE
)
SELECT
    mo.REGIONAL_MANAGER,
    mo.Region,
    COUNT(*) AS total_orders,
    COUNT(r.ORDER_ID) AS returned_orders,
    ROUND(
        COUNT(r.ORDER_ID) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS return_rate_pct
FROM manager_orders mo
LEFT JOIN return_flags r
    ON mo.Order_id = r.ORDER_ID
GROUP BY mo.REGIONAL_MANAGER, mo.Region
ORDER BY return_rate_pct DESC;
