/* ============================================================
   Superstore Sales Analysis — SQL Layer
   Database: SQLite (superstore.db)
   Table: orders (loaded from train.csv, 9,800 rows)
   ============================================================ */


/* ------------------------------------------------------------
   Query 1: Monthly Sales Trend with Month-over-Month Growth
   Technique: CTE + LAG() window function
   ------------------------------------------------------------ */
WITH monthly_sales AS (
  SELECT
    strftime('%Y-%m', "Order Date") AS month,
    SUM(Sales) AS total_sales
  FROM orders
  GROUP BY month
)
SELECT
  month,
  ROUND(total_sales, 2) AS total_sales,
  ROUND(LAG(total_sales) OVER (ORDER BY month), 2) AS prev_month_sales,
  ROUND(((total_sales - LAG(total_sales) OVER (ORDER BY month)) * 100.0 /
    LAG(total_sales) OVER (ORDER BY month)), 2) AS mom_growth_pct
FROM monthly_sales
ORDER BY month;


/* ------------------------------------------------------------
   Query 2: Customer Value Segmentation
   Technique: CTE + CASE WHEN tiering

   RESULTS:
   Tier         | Customers | Total Sales   | Avg Spend/Customer
   High Value   | 114       | $889,525.86   | $7,802.86
   Mid Value    | 320       | $1,007,968.76 | $3,149.90
   Low Value    | 359       | $364,042.16   | $1,014.05

   Finding: Mid Value tier generates the highest AGGREGATE revenue
   despite lower per-customer spend than High Value — volume in the
   middle tier outweighs the smaller, bigger-spending High Value group.
   ------------------------------------------------------------ */
WITH customer_value AS (
  SELECT "Customer ID", "Customer Name",
    SUM(Sales) AS total_spent,
    COUNT(DISTINCT "Order ID") AS num_orders
  FROM orders
  GROUP BY "Customer ID"
)
SELECT
  CASE
    WHEN total_spent > 5000 THEN 'High Value'
    WHEN total_spent > 2000 THEN 'Mid Value'
    ELSE 'Low Value'
  END AS customer_tier,
  COUNT(*) AS num_customers,
  ROUND(SUM(total_spent), 2) AS tier_total_sales,
  ROUND(AVG(total_spent), 2) AS avg_spent
FROM customer_value
GROUP BY customer_tier
ORDER BY avg_spent DESC;


/* ------------------------------------------------------------
   Query 3: Top Sub-Category per Region
   Technique: CTE + RANK() window function

   RESULTS:
   Region  | Top Sub-Category | Total Sales
   Central | Chairs            | $82,372.78
   East    | Phones            | $99,884.66
   South   | Phones            | $58,098.34
   West    | Chairs            | $100,023.20
   ------------------------------------------------------------ */
WITH region_category_sales AS (
  SELECT Region, "Sub-Category",
    ROUND(SUM(Sales), 2) AS total_sales,
    RANK() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS rnk
  FROM orders
  GROUP BY Region, "Sub-Category"
)
SELECT * FROM region_category_sales WHERE rnk = 1;


/* ------------------------------------------------------------
   Query 4: Shipping Performance by Ship Mode
   Technique: Aggregation + julianday() date math

   RESULTS:
   Ship Mode      | Orders | Avg Days | Total Sales
   Same Day       | 538    | 0.04     | $125,219.04
   First Class    | 1,501  | 2.18     | $345,572.26
   Second Class   | 1,902  | 3.25     | $449,914.18
   Standard Class | 5,859  | 5.01     | $1,340,831.31

   Finding: Standard Class is the slowest tier but carries ~59% of
   total sales volume — the revenue backbone despite being the
   least premium shipping option.
   ------------------------------------------------------------ */
SELECT
  "Ship Mode",
  COUNT(*) AS num_orders,
  ROUND(AVG(julianday("Ship Date") - julianday("Order Date")), 2) AS avg_shipping_days,
  ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY "Ship Mode"
ORDER BY avg_shipping_days;


/* ------------------------------------------------------------
   Query 5: Sales Contribution by Segment and Category
   Technique: Aggregation + correlated subquery for % of total

   RESULTS (top 3 of 9):
   Consumer / Technology       | $401,011.66 | 17.73%
   Consumer / Furniture        | $387,696.26 | 17.14%
   Consumer / Office Supplies  | $359,352.61 | 15.89%

   Finding: The Consumer segment alone drives roughly 50% of total
   sales across every category — the single most important customer
   segment in the dataset.
   ------------------------------------------------------------ */
SELECT
  Segment, Category,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Sales) * 100.0 / (SELECT SUM(Sales) FROM orders), 2) AS pct_of_total_sales
FROM orders
GROUP BY Segment, Category
ORDER BY total_sales DESC;
