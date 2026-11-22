-- 04_product_category_analysis.sql
-- Business story: identify category leaders, high-value products and persistent losses.

-- 1. Top products by total sales
SELECT
    Product_ID,
    Product_name,
    Category,
    Sub_category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM Orders
GROUP BY Product_ID, Product_name, Category, Sub_category
ORDER BY total_sales DESC
LIMIT 20;

-- 2. Top product by sales in each year
WITH product_year AS (
    SELECT
        YEAR(Order_date) AS order_year,
        Product_ID,
        Product_name,
        SUM(Sales) AS total_sales
    FROM Orders
    GROUP BY YEAR(Order_date), Product_ID, Product_name
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY order_year
            ORDER BY total_sales DESC, Product_ID
        ) AS rn
    FROM product_year
)
SELECT
    order_year,
    Product_ID,
    Product_name,
    total_sales
FROM ranked
WHERE rn = 1
ORDER BY order_year;

-- 3. Products with the largest cumulative losses
SELECT
    Product_ID,
    Product_name,
    SUM(Profit) AS total_profit,
    SUM(CASE WHEN Profit < 0 THEN Profit ELSE 0 END) AS cumulative_losses,
    SUM(Sales) AS total_sales
FROM Orders
GROUP BY Product_ID, Product_name
HAVING SUM(CASE WHEN Profit < 0 THEN Profit ELSE 0 END) < 0
ORDER BY cumulative_losses ASC
LIMIT 20;

-- 4. Products with year-over-year sales growth in every comparable year
WITH product_year AS (
    SELECT
        Product_ID,
        Product_name,
        YEAR(Order_date) AS order_year,
        SUM(Sales) AS annual_sales,
        SUM(Profit) AS annual_profit,
        SUM(Quantity) AS annual_quantity
    FROM Orders
    GROUP BY Product_ID, Product_name, YEAR(Order_date)
),
with_prior AS (
    SELECT
        *,
        LAG(annual_sales) OVER (
            PARTITION BY Product_ID
            ORDER BY order_year
        ) AS prior_year_sales,
        LAG(annual_profit) OVER (
            PARTITION BY Product_ID
            ORDER BY order_year
        ) AS prior_year_profit,
        LAG(annual_quantity) OVER (
            PARTITION BY Product_ID
            ORDER BY order_year
        ) AS prior_year_quantity
    FROM product_year
),
growth_summary AS (
    SELECT
        Product_ID,
        Product_name,
        COUNT(*) AS observed_years,
        SUM(
            CASE
                WHEN prior_year_sales IS NOT NULL
                 AND annual_sales > prior_year_sales
                THEN 1 ELSE 0
            END
        ) AS growing_years
    FROM with_prior
    GROUP BY Product_ID, Product_name
)
SELECT
    Product_ID,
    Product_name,
    observed_years,
    growing_years
FROM growth_summary
WHERE observed_years >= 2
  AND growing_years = observed_years - 1
ORDER BY Product_name;
