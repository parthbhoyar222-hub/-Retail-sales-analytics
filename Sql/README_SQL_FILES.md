### SQL Portfolio Files
## File types

- `.sql` files contain executable MySQL scripts.
- `.md` files contain project documentation, including the analysis performed.

## SQL folder structure

The `Sql/` folder contains eight numbered scripts, from data setup through time trend analysis. The [SQL analysis inventory](SQL_ANALYSIS_INVENTORY.md) explains what each analysis covers, what one row represents, and which checks matter when interpreting the metrics.

## Important setup notes

1. These scripts contain the SQL analysis for the Superstore dataset. Run them against the schema created for this project, since results can depend on the table definitions, data types, and MySQL settings.
2. Download or clone the repository. The three import files are in the [inputs folder](inputs/): `orders.csv`, `people.csv`, and `returns_clean.csv`.
3. Open [01_data_setup.sql](01_data_setup.sql). In your local copy, replace the path in each `LOAD DATA LOCAL INFILE` statement with the path to its corresponding CSV file. On Windows, use forward slashes in these paths.
4. Run the setup script once in an empty schema. Confirm the row counts below before running scripts 02–08 against that same schema. Running the import again on populated tables can duplicate rows.

## SQL query outputs

| Section | Saved results |
| --- | --- |
| 01 — Data setup | [Import row counts](Results/01_data_setup/01_import_row_counts.csv): 10,194 order lines, 4 people records, and 296 return records. |
| 02 — Sales and profitability | [View CSV results](Results/02_Sales_Profitability/) |
| 03 — Customer profitability | [View CSV results](Results/03_Customer_Profitability/) |
| 04 — Product category analysis | [View CSV results](Results/04_Product_category_analysis/) |
| 05 — Discount profitability | [View CSV results](Results/05_Discount_profitability/) |
| 06 — Geographic analysis | [View CSV results](Results/06_Geographic_analysis/) |
| 07 — Operations and returns | [View CSV results](Results/07_Operational_return_analysis/) |
| 08 — Time trends | [View CSV results](Results/08_Time_trend_analysis/) |
