\# Retail Sales Analytics | SQL \& Python



This project is about exploration  the Sample Superstore dataset to uncover patterns in sales performance, profitability, customer behavior, and order returns across 10,194 product line items and 5,111 unique orders.



\** What I Built



1.\[SQL Analysis](Sql/README\_SQL\_FILES.md): MySQL scripts covering database setup and queries into sales, profit margins, customer segments, discounting, regional performance, returns, and time trends.



2.\[Python Analysis](Python/): Four end-to-end Jupyter notebooks walking through data preparation, sales and profitability, customer behavior and returns, and monthly performance tracking.



\** Key Findings



1.Top-Performing Category: Technology generated the highest total profit among all three product categories.

2.Return Rate: Out of 5,111 unique orders, 296 were returned—an order-level return rate of 5.79% (It should be noted that this reflects order frequency rather than total refunded value).

3\.Sales vs. Profit Disconnect:\*\* In 7 out of 36 comparable months, year-over-year sales grew while profit declined. For example, in November 2025, sales rose by 4.53%, yet profit dropped by 8,463.38.



\** Quick Links to Key Outputs

## Quick Links to Key Outputs

- [Monthly Sales Trend](Python/results/figures/notebook_04/monthly_sales_trend.png)
- [Monthly Profit Chart](Python/results/figures/notebook_04/monthly_profit.png)
- [Monthly Performance Summary (CSV)](Python/results/tables/notebook_04/monthly_performance.csv)



\** Dataset \& How to Run

### SQL (MySQL)

The [SQL input CSVs](Sql/inputs/) are included in this repository.
Create and select an empty MySQL schema, then open [`01_data_setup.sql`](Sql/01_data_setup.sql). In your local copy of the script, replace the three `LOAD DATA LOCAL INFILE` path placeholders with the paths to `orders.csv`, `people.csv`, and `returns_clean.csv`.

Run the setup once, then compare the counts with the
[verified import results](Sql/Results/01_data_setup/01_import_row_counts.csv).
See the [SQL exercise index](Sql/README_SQL_FILES.md) for the analysis
scripts and their saved results.

### Python (Jupyter)

The original Superstore workbook is not included. Use the same workbook version used for this analysis and save it as
`Python/data/raw/sample_superstore.xlsx`.

Copy `Sql/inputs/people.csv` to `Python/data/raw/people.csv`.
Copy `Sql/inputs/returns_clean.csv` to `Python/data/raw/returns.csv`.
The cleaned Returns CSV contains the two columns used in the analysis, so the raw-column preview will differ from the one saved in Notebook 01.

Start Jupyter from the `Python/` folder and run
[`01_data_preparation.ipynb`](Python/01_data_preparation.ipynb) first.
It will create `Python/data/processed/orders_enriched.csv`, which will be used in notebooks 02–04 use.

