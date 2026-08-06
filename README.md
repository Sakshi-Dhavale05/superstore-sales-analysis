▫️Superstore Sales Analysis
End-to-end retail sales analysis built three ways — SQL, Python, and Power BI — on the Superstore dataset (9,800 orders, 2015-2018). Includes a fully interactive two-page Power BI dashboard with a custom data model, DAX measures, and drillthrough navigation.

▫️Overview
This project analyzes retail sales data to uncover trends in revenue, customer value, regional performance, and shipping logistics. The same underlying dataset is explored through three complementary tools, then brought together in an interactive Power BI dashboard as the final deliverable.

▫️Key Findings
- Mid-Value customers outsell High-Value customers in aggregate. 320 Mid-Value customers generated $1.01M in total sales, ahead of 114 High-Value customers at $889K despite High-Value customers spending more individually ($7,803 vs. $3,150 average). Volume in the middle tier matters more than the highest-spending segment alone.
- Standard Class shipping is the revenue backbone. It's the slowest shipping tier (5.01 days average) but carries 59% of total sales ($1.34M of $2.26M), used in 5,859 of 9,800 orders.
- Regional leaders differ by sub-category. West ($100K) and Central ($82K) are both led by Chairs, while East ($100K) and South ($58K) are led by Phones — showing distinct regional product preferences rather than one uniform top seller.
- The Consumer segment drives roughly half of all sales, outperforming Corporate and Home Office across every product category.
- 793 unique customers placed orders across the full dataset, with an average shipping time of 3.96 days.
-

▫️Tools & Techniques

- SQL (SQLite)
├──CTEs, window functions (LAG, RANK), CASE WHEN tiering logic
├──Month-over-month growth calculation, customer segmentation, regional ranking, shipping performance, segment contribution analysis

- Python (Pandas, Seaborn, Matplotlib)
├──Data cleaning and datetime parsing
├──Monthly sales trend, sales by category & segment, sales by region, shipping time distribution visualizations

- Power BI
├──Custom data model with a dedicated Date table (CALENDAR(), marked as an official date table) to support accurate time intelligence
├──DAX measures: Total Sales, MoM Growth % (using DATEADD), Avg Shipping Days
├──DAX calculated column: Customer Tier (CALCULATE + ALLEXCEPT + SWITCH)
├──Advanced visuals: filled map, decomposition tree (AI-assisted "High value" splitting), funnel chart
├──Cross-filtering tile slicers, conditional formatting (data bars), and a drillthrough page from Sub-Category to product-level detail
├──Custom dark theme applied via an importable theme JSON

▫️Dashboard
├──Page 1 — Overview: KPI cards, Region/Category/Segment slicers, monthly sales trend, sales-by-region map, Sales decomposition tree, customer tier funnel, and a detail table with conditional formatting.
├──Page 2 — Sub-Category Detail: Drillthrough destination showing product-level sales, reached by right-clicking any row in the Page 1 detail table.

▫️Repository Structure
superstore-sales-analysis/
├── README.md
├── train.csv
├── sql/
│   └── analysis_queries.sql
├── python/
│   ├── superstore_analysis.ipynb
│   └── charts/
│       ├── monthly_sales_trend.png
│       ├── sales_by_category_segment.png
│       ├── sales_by_region.png
│       └── shipping_days_by_mode.png
└── dashboard/
    ├── Superstore_Sales_Analysis_Aug2026.pbix
    ├── overview_page_screenshot.png
    └── product_detail_screenshot.png
    
▫️Dataset:
Superstore Sales dataset — 9,800 rows, 18 columns including Order Date, Ship Date, Ship Mode, Customer, Segment, Region, Category, Sub-Category, Product, and Sales.

▫️Author
Built as an end-to-end portfolio project demonstrating SQL, Python, and Power BI proficiency on a single consistent dataset — August 2026.
