### SQL Portfolio Files

Used:

1. .sql for executable SQL scripts.
2. .md  for documentation, analysis inventory and project explanation.


* ecommended upload

1. The eight .sql files are uploaded in a GitHub 'sql/' folder.
2. 'SQL_ANALYSIS_INVENTORY.md' is placed inside the SQL folder.


* Important

1.These scripts are consolidated from the my substantive SQL work on superstore dataset. 
2.Please run each script against the actual MySQL database once, because SQL behavior can depend on the exact schema, data types, and server settings.
3.The inventory deliberately documents grain and metric-control risks so that review can focus on analytical correctness rather than syntax cleanup.
4.I have uploaded the .csv files used in the analysis of the dataset into 'sql/'folder. Please download these files on local machine and change the directory path in '01_data_setup' for importing these three csv files as per your machine. 5.Change the address under the code 'LOAD DATA LOCAL INFILE' as per your machine for all three files.**

* SQL query outputs

| Section | Saved results |
| --- | --- |
| 01 — Data setup |- [Import row-count validation](Results/01_data_setup/01_import_row_counts.csv) — Orders: 10,194 rows; People: 4; Returns: 296. |
| 02 — Sales and profitability | [View CSV results](Results/02_Sales_Profitability/) |
| 03 — Customer profitability | [View CSV results](Results/03_Customer_Profitability/) |
| 04 — Product category analysis | [View CSV results](Results/04_Product_category_analysis/) |
| 05 — Discount and profitability | [View CSV results](Results/05_Discount_profitability/) |
| 06 — Geographic analysis | [View CSV results](Results/06_Geographic_analysis/) |
| 07 — Operations and returns | [View CSV results](Results/07_Operational_return_analysis/) |
| 08 — Time trends | [View CSV results](Results/08_TIme_trend_analysis/) |
