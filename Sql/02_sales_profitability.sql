-- 02_sales_profitability.sql
-- Business story: sales volume must be evaluated alongside profitability.

-- 1. Overall performance by category
SELECT
    Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM Orders
GROUP BY Category
ORDER BY total_sales DESC;

-- 2. Category ranking within each region
WITH category_region AS (
    SELECT
        Region,
        Category,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit
    FROM Orders
    GROUP BY Region, Category
),
ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY Region
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM category_region
)
SELECT
    Region,
    Category,
    total_sales,
    total_profit,
    sales_rank
FROM ranked
ORDER BY Region, sales_rank;

-- 3. Category contribution to regional sales
WITH category_region AS (
    SELECT
        Region,
        Category,
        SUM(Sales) AS category_sales
    FROM Orders
    GROUP BY Region, Category
)
SELECT
    Region,
    Category,
    category_sales,
    ROUND(
        category_sales
        / NULLIF(SUM(category_sales) OVER (PARTITION BY Region), 0) * 100,
        2
    ) AS regional_sales_contribution_pct
FROM category_region
ORDER BY Region, regional_sales_contribution_pct DESC;

-- 4. Sub-category profitability
SELECT
    Sub_category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM Orders
GROUP BY Sub_category
ORDER BY total_profit DESC;

-- 5. Loss-making sub-categories
SELECT
    Sub_category,
    SUM(Profit) AS total_profit,
    SUM(CASE WHEN Profit < 0 THEN Profit ELSE 0 END) AS cumulative_losses
FROM Orders
GROUP BY Sub_category
ORDER BY cumulative_losses ASC;
