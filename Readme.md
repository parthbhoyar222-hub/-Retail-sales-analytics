\# Retail Sales Analytics | SQL \& Python



This project is about exploration  the Sample Superstore dataset to uncover patterns in sales performance, profitability, customer behavior, and order returns across 10,194 product line items and 5,111 unique orders.



\## What I Built



1.\[SQL Analysis](Sql/README\_SQL\_FILES.md): MySQL scripts covering database setup and queries into sales, profit margins, customer segments, discounting, regional performance, returns, and time trends.



2.\[Python Analysis](Python/): Four end-to-end Jupyter notebooks walking through data preparation, sales and profitability, customer behavior and returns, and monthly performance tracking.



\## Key Findings



1.Top-Performing Category: Technology generated the highest total profit among all three product categories.

2.Return Rate: Out of 5,111 unique orders, 296 were returned—an order-level return rate of 5.79% (It should be noted that this reflects order frequency rather than total refunded value).

3\.Sales vs. Profit Disconnect:\*\* In 7 out of 36 comparable months, year-over-year sales grew while profit declined. For example, in November 2025, sales rose by 4.53%, yet profit dropped by 8,463.38.



\## Quick Links to Key Outputs



\* \[Monthly Sales Trend](Python/results/figures/notebook\_04/monthly\_sales\_trend.png)

\* \[Monthly Profit Chart](Python/results/figures/notebook\_04/monthly\_profit.png)

\* \[Monthly Performance Summary (CSV)](Python/results/tables/notebook\_04/monthly\_performance.csv)



\## Dataset \& How to Run



Raw source workbooks and row-level import files are excluded from version control, so local copies of the source data are required to reproduce the analysis. Start by running "Notebook 01", which cleans and prepares the dataset needed for "Notebooks 02–04".

