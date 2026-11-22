### DATA PROFILING



1. ##### DATA OVERVIEW
* Number of rows >> 10,194 records

&#x20;

* Number of columns >> 21 columns



* Number of sheets  >> 3 Sheets



* Dataset size (MB) >> 1.60 MB



* Time period covered >> 2023-01-03 to 2026-12-30



Granularity (What does one row represent?) >> One product line within one order.



##### 2\. Column Classification



|COLUMN|DATA TYPE|SEMANTIC CATEGORY|
|-|-|-|
|Row ID<br />|integer|Identifier|
|Order ID<br />|Text/VARCHAR|identifier|
|Order Date<br />|Date|Time|
|Ship Date<br />|Date|Time|
|Ship Mode<br />|Text|Dimension|
|Customer ID<br />|Text/VARCHAR|Identifier|
|Customer Name<br />|Text|descriptive attribute/Dimension|
|Segment<br />|Text|Dimension|
|Country/Region<br />|Text|Dimension|
|City<br />|Text|Dimension|
|State/Province<br />|Text|Dimension|
|Postal Code<br />|Text/VARCHAR|Geographic attribute|
|Region<br />|Text|Dimension|
|Product ID<br />|Text/VARCHAR|identifier|
|Category<br />|Text|Dimension|
|Sub-Category<br />|Text|Dimension|
|Product Name<br />|Text/VARCHAR|descriptive attribute/dimension|
|Sales<br />|Float/decimal|Measure|
|Quantity<br />|Integer|Measure|
|Discount<br />|float/decimal|Measure|
|Profit<br />|float/decimal|Measure|









###### **Sheet 2**



|COLUMN|DATA TYPE|SEMANTIC CATEGORY|
|-|-|-|
|REGIONAL MANAGER|Text|Dimension|
|REGION|Text|Dimension|





###### **Sheet 3**



|COLUMN|DATA TYPE|SEMANTIC CATEGORY|
|-|-|-|
|ORDER ID|Array|Identifier|
|RETURNED|Boolean|Identifier|









##### 3.Initial Profiling



##### **ORDERS TABLE**

|COLUMN|DATA INSUFFICIENCY:?|VALUE TYPE|Possible issues|
|-|-|-|-|
|Row ID<br />|none identified|unique values|none identified|
|Order ID<br />|none identified|Repeated values|Repeated values expected at order-line level|
|Order Date<br />|none identified|Repeated values|Repeated values expected at order-line level|
|Ship Date<br />|none identified|Repeated values|Repeated values expected at order-line level|
|Ship Mode<br />|none identified|Repeated values|Repeated values expected at order-line level|
|Customer ID<br />|none identified|Repeated values|Repeated values expected at order-line level|
|Customer Name<br />|none identified|Repeated values|Repeated values expected at order-line level|
|Segment<br />|none identified|Repeated values|Expected repetition because this is a categorical dimension.|
|Country/Region<br />|none identified|Repeated values|Expected repetition because this is a categorical dimension.|
|City<br />|none identified|Repeated values|Expected repetition because this is a categorical dimension.|
|State/Province<br />|none identified|Repeated values|Expected repetition because this is a categorical dimension.|
|Postal Code<br />|formatting issues|Repeated values|Repeated values expected at order-line level|
|Region<br />|formatting issues|Repeated values|Expected repetition because this is a categorical dimension.|
|Product ID<br />|formatting issues|Repeated values|Repeated values expected at order-line level|
|Category<br />|formatting issues|Repeated values|Expected repetition because this is a categorical dimension.|
|Sub-Category<br />|none identified|Repeated values|Expected repetition because this is a categorical dimension.|
|Product Name<br />|formatting issues|Repeated values|Repeated values expected at order-line level|
|Sales<br />|formatting issues|Continuous measure|To be validated using SQL.|
|Quantity<br />|formatting issues|Repeated values|Repeated values expected at order-line level|
|Discount<br />|none identified|Repeated values|Repeated values expected at order-line level|
|Profit<br />|formatting issues|Continuous measure|To be validated using SQL.|





##### **PEOPLE TABLE**

|COLUMN|DATA INSUFFICIENCY:?|VALUE TYPE|Possible issues|
|-|-|-|-|
|REGIONAL MANAGER|none identified|Dimension|To be validated using SQL.|
|REGION|none identified|Dimension|To be validated using SQL.|









##### **RETURNS TABLE**

|COLUMN|DATA INSUFFICIENCY:?|VALUE TYPE|Possible issues|
|-|-|-|-|
|ORDER ID|formatting issues|Identifier|To be validated using SQL.|
|RETURNED|formatting issues|Boolean/Categorical|To be validated using SQL.|









##### 4\. Data validation rules







|COLUMN|VALIDITY RULES|
|-|-|
|Row ID<br />|NOT NULL, Cannot be negative|
|Order ID<br />|NOT NULL, valid text identifier|
|Order Date<br />|NOT NULL, Cannot be after SHIP DATE|
|Ship Date<br />|NOT NULL, cannot be before order date|
|Ship Mode<br />|NOT NULL|
|Customer ID<br />|NOT NULL, valid text identifier|
|Customer Name<br />|NOT NULL|
|Segment<br />|NOT NULL|
|Country/Region<br />|NOT NULL|
|City<br />|NOT NULL|
|State/Province<br />|NOT NULL|
|Postal Code<br />|NOT NULL, valid postal-code format|
|Region<br />|NOT NULL|
|Product ID<br />|NOT NULL, valid text identifier|
|Category<br />|NOT NULL|
|Sub-Category<br />|NOT NULL|
|Product Name<br />|NOT NULL|
|Sales<br />|NOT NULL, Greater than or equal to zero|
|Quantity<br />|NOT NULL, greater than zero|
|Discount<br />|NOT NULL, float values only, numeric value between 0 and 1 inclusive|
|Profit<br />|NOT NULL, can be negative|







|COLUMN|VALIDITY RULES|
|-|-|
|ORDER ID|NOT NULL, must be alphanumeric|
|RETURNED|NOT NULL, valid Boolean/categorical value|







##### 

##### 5\. Data validation checklist





|CHECKING:?|STATUS|NOTES|
|-|-|-|
|Missing values|NO|Only formatting issues identified|
|Duplicate rows|To be validated using SQL.|-|
|Invalid dates|NO|NONE IDENTIFIED|
|Negative sales|NO|NONE IDENTIFIED|
|Duplicate Order IDs|YES|Repeated Order IDs are expected because one order can contain multiple product lines. This is not considered a duplicate-row issue.|
|Invalid discounts|To be validated using SQL.|-|



