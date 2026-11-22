-- 08_time_trend_analysis.sql
-- Business objective: Identified growth, deterioration and regional volatility.

-- 1. Monthly sales and profit
WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(Order_date, '%Y-%m') AS year_months,
        SUM(Sales) AS monthly_sales,
        SUM(Profit) AS monthly_profit
    FROM Orders
    GROUP BY year_months
)
SELECT
    year_months,
    monthly_sales,
    monthly_profit,
    ROUND(monthly_profit / NULLIF(monthly_sales, 0) * 100, 2)
        AS profit_margin_percent
FROM monthly_metrics
ORDER BY year_months;

-- 2. Month-over-month change
WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(Order_date, '%Y-%m') AS year_months,
        SUM(Sales) AS monthly_sales,
        SUM(Profit) AS monthly_profit
    FROM Orders
    GROUP BY year_months
),
with_prior AS (
    SELECT
        *,
        LAG(monthly_sales) OVER (ORDER BY year_months) AS prior_month_sales,
        LAG(monthly_profit) OVER (ORDER BY year_months) AS prior_month_profit
    FROM monthly_metrics
)
SELECT
    year_months,
    monthly_sales,
    monthly_profit,
    prior_month_sales,
    prior_month_profit,
    ROUND(monthly_sales - prior_month_sales, 2) AS sales_change,
    ROUND(monthly_profit - prior_month_profit, 2) AS profit_change
FROM with_prior
WHERE prior_month_sales IS NOT NULL
ORDER BY year_months;

-- 3. Monthly performance classification
WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(Order_date, '%Y-%m') AS year_months,
        SUM(Sales) AS monthly_sales,
        SUM(Profit) AS monthly_profit
    FROM Orders
    GROUP BY year_months
),
with_prior AS (
    SELECT
        *,
        LAG(monthly_sales) OVER (ORDER BY year_months) AS prior_month_sales,
        LAG(monthly_profit) OVER (ORDER BY year_months) AS prior_month_profit
    FROM monthly_metrics
)
SELECT
    year_months,
    CASE
        WHEN monthly_sales > prior_month_sales
         AND monthly_profit > prior_month_profit
            THEN 'Both Increased (Strong Growth)'
        WHEN monthly_sales < prior_month_sales
         AND monthly_profit < prior_month_profit
            THEN 'Both Decreased (Broad Deterioration)'
        WHEN monthly_sales > prior_month_sales
         AND monthly_profit < prior_month_profit
            THEN 'Sales Increased - Profit Decreased'
        WHEN monthly_sales < prior_month_sales
         AND monthly_profit > prior_month_profit
            THEN 'Sales Decreased - Profit Increased'
        ELSE 'No comparable change'
    END AS performance_category
FROM with_prior
WHERE prior_month_sales IS NOT NULL
ORDER BY year_months;

-- 4. Year-over-year monthly comparison
WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(Order_date, '%Y-%m') AS year_months,
        SUM(Sales) AS monthly_sales,
        SUM(Profit) AS monthly_profit
    FROM Orders
    GROUP BY year_months
),
with_prior_year AS (
    SELECT
        *,
        LAG(monthly_sales, 12) OVER (ORDER BY year_months)
            AS prior_year_month_sales,
        LAG(monthly_profit, 12) OVER (ORDER BY year_months)
            AS prior_year_month_profit
    FROM monthly_metrics
)
SELECT
    year_months,
    monthly_sales,
    monthly_profit,
    prior_year_month_sales,
    prior_year_month_profit,
    ROUND(monthly_sales - prior_year_month_sales, 2) AS yoy_sales_change,
    ROUND(monthly_profit - prior_year_month_profit, 2) AS yoy_profit_change
FROM with_prior_year
WHERE prior_year_month_sales IS NOT NULL
ORDER BY year_months;

-- 5. Count of YoY performance patterns
WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(Order_date, '%Y-%m') AS year_months,
        SUM(Sales) AS monthly_sales,
        SUM(Profit) AS monthly_profit
    FROM Orders
    GROUP BY year_months
),
with_prior_year AS (
    SELECT
        *,
        LAG(monthly_sales, 12) OVER (ORDER BY year_months)
            AS prior_year_month_sales,
        LAG(monthly_profit, 12) OVER (ORDER BY year_months)
            AS prior_year_month_profit
    FROM monthly_metrics
),
classified AS (
    SELECT
        CASE
            WHEN monthly_sales > prior_year_month_sales
             AND monthly_profit > prior_year_month_profit
                THEN 'Both Increased (Strong Growth)'
            WHEN monthly_sales < prior_year_month_sales
             AND monthly_profit < prior_year_month_profit
                THEN 'Both Decreased (Broad Deterioration)'
            WHEN monthly_sales > prior_year_month_sales
             AND monthly_profit < prior_year_month_profit
                THEN 'Sales Increased - Profit Decreased'
            WHEN monthly_sales < prior_year_month_sales
             AND monthly_profit > prior_year_month_profit
                THEN 'Sales Decreased - Profit Increased'
        END AS performance_category
    FROM with_prior_year
    WHERE prior_year_month_sales IS NOT NULL
)
SELECT
    performance_category,
    COUNT(*) AS month_count,
    ROUND(
        COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (), 0) * 100,
        2
    ) AS percent_of_comparable_months
FROM classified
GROUP BY performance_category
ORDER BY month_count DESC;

-- 6. Worst month-over-month sales deterioration by region
WITH regional_monthly AS (
    SELECT
        Region,
        DATE_FORMAT(Order_date, '%Y-%m') AS year_months,
        SUM(Sales) AS monthly_sales
    FROM Orders
    GROUP BY Region, year_months
),
with_prior AS (
    SELECT
        *,
        LAG(monthly_sales) OVER (
            PARTITION BY Region
            ORDER BY year_months
        ) AS prior_month_sales
    FROM regional_monthly
),
growth AS (
    SELECT
        Region,
        year_months,
        monthly_sales,
        prior_month_sales,
        ROUND(
            (monthly_sales - prior_month_sales)
            / NULLIF(prior_month_sales, 0) * 100,
            3
        ) AS mom_sales_growth_percent
    FROM with_prior
    WHERE prior_month_sales IS NOT NULL
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Region
            ORDER BY mom_sales_growth_percent ASC, year_months
        ) AS rn
    FROM growth
)
SELECT
    Region,
    year_months,
    monthly_sales,
    prior_month_sales,
    mom_sales_growth_percent
FROM ranked
WHERE rn = 1
ORDER BY Region;
