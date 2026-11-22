#SQL Analysis Inventory — Superstore dataset Project

1.Status: Portfolio-ready working inventory  
2.Database: MySQL Workbench  
3.Primary table: 'Orders' — one row = one product line within an order  
4.Supporting tables: 'People', 'Returns'  
5.Dataset size: 10,194 order-line records  
6.Analysis period: 2023-01-03 to 2026-12-30


# 1. Grain and metric-control checklist

### Orders
`Orders` = one product line within one order.

Therefore:

sql
COUNT(*)                  -- order lines
COUNT(DISTINCT Order_ID)  -- distinct orders

#  2. Purpose

This inventory consolidates the substantive **SQL analysis from the surviving SQL work** into business-oriented portfolio analyses.

**The original 15 learning files contained a mixture of:**
- data-loading/setup work,
- syntax exercises,
- intermediate practice,
- analytical queries,
- repeated versions of the same analysis.

**For GitHub**, the objective is **not** to preserve the learning history. The objective is to present a small set of reproducible analyses that demonstrate business reasoning, aggregation, joins, CTEs, window functions, conditional logic, and time-series analysis.

### Portfolio rule

A query is retained when it:
1. answers a meaningful business question;
2. demonstrates an analytical technique at an appropriate level;
3. produces an interpretable result;
4. is materially different from another retained query.

Basic syntax demonstrations and repetitive exercises are deliberately excluded.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 3. ORIGINAL WORK 

| Original file | Decision | Portfolio treatment |
|---|---|---|
| `Superstore.sql` | KEPT | Setup/schema/import validation only |
| `People.sql` | KEPT | Supporting region-manager lookup |
| `Returns.sql` | KEPT | Supporting return-status lookup |
| `Exercise 1-8.sql` | REMOVED | Basic SQL practice; no portfolio value |
| `Exercise 2-8.sql` | REMOVED | Basic aggregation practice superseded by stronger analysis |
| `INTERMEDIATE.sql` | REMOVED | String-function practice |
| `Time_functions.sql` | REMOVED | Date-function drills superseded by analytical time-series queries |
| `Case Conditional Case.sql` | REMOVED | CASE/function practice superseded by business classifications |
| `Join table.sql` | KEPT | Manager/return analysis |
| `SUBQUERY.sql` | REMOVED | Technique practice rather than business story |
| `CORRELATED_SUBQUERY.sql` | REMOVED | Technique practice; retain only in personal learning archive |
| `CTE Functions.sql` | KEPT | Substantive category, region and customer analyses |
| `Windows function.sql` | KEPT | Ranking, contribution and time-series analyses |
| `Assessment.sql` | KEPT | Customer profitability and concentration |
| `Final check.sql` | KEPT | Core sales, profitability, discount and time analyses |

**Important:** Not all original files were placed in the final GitHub `sql/` folder. The consolidated files below are cleaner portfolio Findings.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


### 4. Portfolio SQL architecture

Current GitHub structure:

sql/
├── 01_data_setup.sql
├── 02_sales_profitability.sql
├── 03_customer_profitability.sql
├── 04_product_category_analysis.sql
├── 05_discount_profitability.sql
├── 06_geographic_analysis.sql
├── 07_operational_returns_analysis.sql
└── 08_time_trend_analysis.sql
```

The eight files are intentionally business-analysis oriented rather than technique-syntax oriented.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#### 5. Analysis inventory

## Sales & Profitability Performance

### Business objective
Establish the overall commercial performance of the business and identify major sales/profit contributors and loss areas.

### Retained analyses

| Analysis | Business question | Technique | Decision |
|----------|-------------------|-----------|----------|
| Overall sales/profit by category | Which categories contribute most to sales and profit? | GROUP BY | 
| Category ranking within region | Which categories lead within each region? | CTE + window ranking | 
| Category sales contribution | What percentage of regional/category sales comes from each category? | Window SUM | 
| Sub-category profitability | Which sub-categories generate the most profit? | GROUP BY / ORDER BY | 
| Loss-making sub-categories | Which sub-categories create the largest cumulative losses? | Conditional aggregation | 
| State profitability | Which states are most/least profitable? | GROUP BY | MERGE with geography |

### Portfolio conclusion
This story should establish that sales volume alone is insufficient: category/sub-category performance must be evaluated alongside profit.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 6. Customer Profitability & Concentration

## Business objective
Identify the customers that create economic value and determine how concentrated profitability is across the customer base.

### Retained analyses

| Analysis | Business question | Technique | Decision |
|----------|-------------------|-----------|----------|
| Customer sales/profit summary | How much sales and profit does each customer generate? | GROUP BY | 
| Profit-making vs loss-making customers | How many customers create vs destroy profit? | CASE + aggregation | 
| Customer profitability ranking | Which customers contribute the most profit? | RANK / ROW_NUMBER | 
| Profit contribution % | What share of total positive profit comes from each customer? | Window SUM | 
| Cumulative profit contribution | How concentrated is profitability? | Window SUM + ranking | 
| Top 10/20/25% concentration | How much profit is generated by the highest-profit customer groups? | CTE + ranking | 
| Customer order sequence | What is the sequence/timing of customer orders? | Window functions | OPTIONAL / DROP |
| Basic top-customer list | Which five customers have highest sales? | ORDER BY/LIMIT | MERGE into summary |


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 7. Product & Category Analysis

## Business objective
Identified products/categories driving commercial performance and isolate products that create persistent losses.



### Retained analyses

| Analysis | Business question | Technique | Decision |
|---|---|---|---|
| Top products by sales | Which products contribute most to sales? | Aggregation + ranking | 
| Products by yearly sales contribution | Which products lead each year? | CTE + window ranking | 
| Category ranking by region | Which category leads each region? | RANK | 
| Product cumulative losses | Which products create the largest losses? | Aggregation | 
| Products with consistent YoY sales growth | Which products demonstrate sustained sales growth? | CTE + LAG | KEEP if result is used |
| Profitability of consistently growing products | Does sales growth translate into profit growth? | CTE + LAG | 
| Quantity trend for consistently growing products | Does unit volume support the sales trend? | CTE + LAG | 
| Product repeated-purchase query | Which products appear in multiple orders? | COUNT(DISTINCT Order_ID) | OPTIONAL |
| Basic product average-sales subquery | Which rows are above/below average sales? | Scalar subquery | DROP |

### Important note
A product appearing in multiple distinct orders is **not automatically evidence of customer repeat purchase**. Customer retention requires customer-level recurrence logic.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 8. Discount & Profitability

## Business objective
Assessed whether higher discount levels are associated with weaker profitability.


### Retained analysis

Orders are classified using the overall average discount:

- Below/equal average discount
- Above average discount

The analysis aggregates at the distinct-order level for order counts and loss rates.


### Interpretation rule
This supports a **strong association** between higher discounting and weaker profitability in this dataset.
It does **not** establish causation.

### Important grain note
`Orders` is line-level. Therefore, order-level profitability must be calculated after aggregating each `Order_ID`; otherwise multi-line orders can distort order-level metrics.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 9. Geographic Performance

## Business objective
Identified geographic markets with strong sales/profit performance and locations requiring investigation.



### Retained analyses

| Analysis | Business question | Technique | Decision |
|----------|-------------------|-----------|----------|
| Country sales/orders/quantity | Which countries generate the most business? | Aggregation | 
| State profitability | Which states generate highest profit? | GROUP BY | 
| State losses | Which states generate the largest losses? | Conditional aggregation | 
| Regional profitability by country | How does profitability vary across regions within countries? | GROUP BY | 
| Regional sales by customer segment | How do segments perform across geography? | Multi-dimensional aggregation | 
| Highest-order state by country | Which state has most distinct orders in each country? | CTE + ranking | 
| Highest-order city by country | Which city has most distinct orders in each country? | CTE + ranking | 
| Lowest-order city by country | Which city has least distinct orders in each country? | CTE + ranking | 
| Sub-category in highest-order city | What sells most in the strongest city? | Nested aggregation + ranking | 
| Sub-category in lowest-order city | What sells most in the weakest city? | Nested aggregation + ranking | 
| Geographic MoM deterioration | Which regions experienced their sharpest monthly sales decline? | CTE + LAG + ROW_NUMBER | 

### Grain rule
Order-based geographic analysis must use `COUNT(DISTINCT Order_ID)`, not `COUNT(*)`.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#  10. Operational & Returns Analysis

## Business objective
Evaluate shipping behavior and return patterns to identify operational areas requiring investigation.


### Retained analyses

| Analysis | Business question | Technique | Decision |
|----------|-------------------|-----------|----------|
| Shipping mode frequency | Which shipping modes are most used? | Aggregation | 
| Shipping mode by city | How does shipping preference vary geographically? | GROUP BY | 
| Shipping delay by segment | Which segment has the longest average shipping delay? | DATEDIFF + aggregation | 
| Profitability by shipping mode | Does profitability vary by shipping mode? | GROUP BY | 
| Return rate by regional manager | Which manager's region has the highest return rate? | JOIN + distinct order counts | 
| Manager regional KPI | How do regional managers compare on operational KPIs? | JOIN + aggregation | 


The exact labels for these two percentages should be taken from the final SQL output before publishing.

### Important Note
Returns` is at order level while `Orders` is at order-line level. Joining them directly and summing sales can duplicate returned-order sales across multiple lines.
For return-rate analysis, use distinct order counts.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 11. Time & Trend Analysis

## Business objective
Identified growth patterns, deteriorations, seasonality and regional volatility.


### Retained analyses

| Analysis | Business question | Technique | Decision |
|---|---|---|---|
| Monthly sales/profit | How does business performance change month to month? | Date aggregation | 
| MoM sales/profit | Which months improved or deteriorated? | LAG | 
| Monthly performance classification | Did sales and profit move in the same direction? | LAG + CASE | 
| YoY sales/profit | How does each month compare with the same month one year earlier? | LAG(...,12) | 
| Best/worst month by metric | Which months have highest/lowest sales/profit/margin? | CTE + ranking | 
| Regional MoM sales | How does each region change month over month? | PARTITION BY + LAG | 
| Worst regional deterioration | Which month was each region's sharpest decline? | ROW_NUMBER | 
| Quarterly YoY trend | Which quarters show consistent growth? | Date aggregation + LAG | 
| Basic date extraction | What year/month/day is an order date? | Date functions | DROP |
| Shipping-year average sales drill | How does average sales vary by shipping year? | Basic aggregation | DROP |

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# 12. Queries deliberately excluded

The following exercises are **not** be representing as customer-level portfolio analyses, hence they are not included here:

### Syntax-only exercises
- SELECT/DISTINCT drills
- WHERE drills
- ORDER BY/LIMIT drills
- basic GROUP BY drills
- string functions
- date-function demonstrations
- simple CASE examples

### Technique demonstrations without business value
- scalar subquery against overall average
- IN/NOT IN syntax demonstrations
- correlated-subquery demonstrations
- EXISTS/NOT EXISTS demonstrations
- RANK vs DENSE_RANK comparison
- simple CTE syntax examples




# 13. SQL techniques demonstrated by the Superstore dataset Project.

The consolidated project still demonstrates the important analytical SQL techniques:

- Filtering and aggregation
- GROUP BY / HAVING
- Multi-level aggregation
- CTEs
- INNER / LEFT JOIN logic
- CASE WHEN
- Scalar and derived calculations
- Window functions
- RANK / ROW_NUMBER
- Window SUM for contribution percentages
- LAG for MoM and YoY analysis
- Date/time aggregation
- Conditional aggregation
- Distinct-order logic
- Customer concentration analysis
- Regional analysis
- Operational KPI analysis
- Return-rate analysis
- Basic query-logic awareness and grain control

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





