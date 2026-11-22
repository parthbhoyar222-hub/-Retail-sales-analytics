-- 03_customer_profitability.sql
-- Business story: identify economically valuable customers and profit concentration.

WITH customer_metrics AS (
    SELECT
        Customer_ID,
        Customer_name,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit
    FROM Orders
    GROUP BY Customer_ID, Customer_name
),
positive_profit AS (
    SELECT *
    FROM customer_metrics
    WHERE total_profit > 0
),
ranked AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_profit DESC) AS profit_rank,
        SUM(total_profit) OVER () AS positive_profit_pool
    FROM positive_profit
)
SELECT
    Customer_ID,
    Customer_name,
    total_sales,
    total_profit,
    profit_rank,
    ROUND(total_profit / NULLIF(positive_profit_pool, 0) * 100, 2)
        AS profit_contribution_pct,
    ROUND(
        SUM(total_profit) OVER (
            ORDER BY total_profit DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) / NULLIF(positive_profit_pool, 0) * 100,
        2
    ) AS cumulative_profit_contribution_pct
FROM ranked
ORDER BY profit_rank;

-- Profit-making versus loss-making customers
WITH customer_metrics AS (
    SELECT
        Customer_ID,
        Customer_name,
        SUM(Profit) AS total_profit
    FROM Orders
    GROUP BY Customer_ID, Customer_name
)
SELECT
    CASE
        WHEN total_profit > 0 THEN 'Profit-making'
        WHEN total_profit < 0 THEN 'Loss-making'
        ELSE 'Break-even'
    END AS customer_status,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_profit), 2) AS total_profit
FROM customer_metrics
GROUP BY customer_status
ORDER BY customer_status;

-- Top 10%, 20% and 25% of the positive-profit customer pool.
-- This intentionally uses fixed counts based on the current 804-customer dataset.
WITH customer_metrics AS (
    SELECT
        Customer_ID,
        Customer_name,
        SUM(Profit) AS total_profit
    FROM Orders
    GROUP BY Customer_ID, Customer_name
),
positive_profit AS (
    SELECT *
    FROM customer_metrics
    WHERE total_profit > 0
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY total_profit DESC) AS rn,
        COUNT(*) OVER () AS positive_customer_count
    FROM positive_profit
)
SELECT
    'Top 10%' AS customer_group,
    COUNT(*) AS customers,
    ROUND(SUM(total_profit), 2) AS profit,
    ROUND(
        SUM(total_profit)
        / NULLIF((SELECT SUM(total_profit) FROM positive_profit), 0) * 100,
        2
    ) AS profit_contribution_pct
FROM ranked
WHERE rn <= CEIL(positive_customer_count * 0.10)

UNION ALL

SELECT
    'Top 20%',
    COUNT(*),
    ROUND(SUM(total_profit), 2),
    ROUND(
        SUM(total_profit)
        / NULLIF((SELECT SUM(total_profit) FROM positive_profit), 0) * 100,
        2
    )
FROM ranked
WHERE rn <= CEIL(positive_customer_count * 0.20)

UNION ALL

SELECT
    'Top 25%',
    COUNT(*),
    ROUND(SUM(total_profit), 2),
    ROUND(
        SUM(total_profit)
        / NULLIF((SELECT SUM(total_profit) FROM positive_profit), 0) * 100,
        2
    )
FROM ranked
WHERE rn <= CEIL(positive_customer_count * 0.25);
