# Retail Sales Analytics | SQL & Python

This project analyzes 10,194 Superstore order lines across 5,111 orders to answer three questions: Which categories generate profit? How often are orders returned? When does sales growth fail to translate into higher profit?

## Dataset & How to Run
The three raw files used by Notebook 01 are included in this repository. No separate download or renaming is required to run the notebook.

- [Original dataset source](https://public.tableau.com/app/sample-data/sample_-_superstore.xls)
- [Excel workbook used in this analysis](Python/data/raw/sample_superstore.xlsx) 
- [All three notebook inputs include: workbook, people.csv, and returns.csv](Python/data/raw/)

## Analysis

- [SQL analysis and saved results](Sql/README_SQL_FILES.md): Eight MySQL scripts cover data setup, category and customer profitability, discounts, regional performance, returns, and sales trends.
- [Python notebooks](Python/): Four notebooks prepare the data, analyze profitability and returns, and track monthly sales and profit.

## Key Findings

1. **Technology led profitability.** Technology generated approximately 146.5k in profit, compared with 126.0k for Office Supplies and 19.7k for Furniture. Furniture generated more sales than Office Supplies (754.7k versus 731.9k), but its profit margin was only 2.61%, compared with 17.22% for Office Supplies. [Category results](Sql/Results/02_Sales_Profitability/Results_02_01_Overall_Performance.csv)
2. **Returns affected 5.79% of orders.** Of 5,111 distinct orders, 296 were returned. This measures how frequently orders were returned, not the value refunded. [Customer and returns analysis](Python/03_customer_and_returns_analysis.ipynb)
3. **Sales growth did not always translate into profit growth.** In 7 of 36 months with a prior-year comparison, sales rose while profit fell. In November 2025, sales rose 4.53% year over year while profit fell by 8,463.38. The month still earned 4,011.41 in profit. [Monthly results](Python/results/tables/notebook_04/monthly_performance.csv)
4. **Tables were a loss-making part of Furniture.** Tables recorded approximately 208.0k in sales but a net loss of 17.8k. The category-wide Furniture total therefore masks an important difference between its products. [Sales and profitability analysis](Python/02_sales_profitability_analysis.ipynb)

## Recommendations

-  Compare profit and discount bands within Tables before changing prices across all Furniture products. Check whether losses are concentrated in particular products or order types.
-  Flag months where sales rise year over year but profit falls. Start with November 2025 and compare its category mix, discounts, and margins with November 2024 before attributing the    decline to a cause.
-  Compare returned orders with total distinct orders in each segment. Review segments with both an elevated rate and enough orders to make the comparison meaningful; raw return counts alone favor larger segments.
