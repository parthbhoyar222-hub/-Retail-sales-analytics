-- 05_discount_profitability.sql
-- Business story: assess the association between discount intensity and profitability.
-- Grain control: order-level metrics are calculated after aggregating Orders to Order_ID.

WITH order_metrics AS (
    SELECT
        Order_id,
        SUM(Sales) AS order_sales,
        SUM(Profit) AS order_profit,
        AVG(Discount) AS order_avg_discount
    FROM Orders
    GROUP BY Order_id
),
overall_discount AS (
    SELECT AVG(Discount) AS avg_discount
    FROM Orders
),
classified AS (
    SELECT
        o.*,
        CASE
            WHEN o.order_avg_discount > d.avg_discount
                THEN 'Above average discount'
            ELSE 'Below/equal average discount'
        END AS discount_group
    FROM order_metrics o
    CROSS JOIN overall_discount d
)
SELECT
    discount_group,
    COUNT(*) AS distinct_orders,
    ROUND(SUM(order_sales), 2) AS sales,
    ROUND(SUM(order_profit), 2) AS profit,
    ROUND(AVG(order_profit), 2) AS avg_profit_per_order,
    SUM(CASE WHEN order_profit < 0 THEN 1 ELSE 0 END)
        AS loss_making_orders,
    ROUND(
        SUM(CASE WHEN order_profit < 0 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS loss_making_order_pct
FROM classified
GROUP BY discount_group
ORDER BY discount_group;

-- Supporting view: profitability across discount bands.
WITH order_metrics AS (
    SELECT
        Order_id,
        SUM(Sales) AS order_sales,
        SUM(Profit) AS order_profit,
        AVG(Discount) AS order_avg_discount
    FROM Orders
    GROUP BY Order_id
)
SELECT
    CASE
        WHEN order_avg_discount = 0 THEN '0%'
        WHEN order_avg_discount <= 0.10 THEN '0.01–10%'
        WHEN order_avg_discount <= 0.20 THEN '10.01–20%'
        WHEN order_avg_discount <= 0.30 THEN '20.01–30%'
        WHEN order_avg_discount <= 0.40 THEN '30.01–40%'
        ELSE '>40%'
    END AS discount_band,
    COUNT(*) AS distinct_orders,
    ROUND(SUM(order_sales), 2) AS sales,
    ROUND(SUM(order_profit), 2) AS profit,
    ROUND(AVG(order_profit), 2) AS avg_profit_per_order,
    ROUND(
        SUM(CASE WHEN order_profit < 0 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS loss_making_order_pct
FROM order_metrics
GROUP BY discount_band
ORDER BY MIN(order_avg_discount);
