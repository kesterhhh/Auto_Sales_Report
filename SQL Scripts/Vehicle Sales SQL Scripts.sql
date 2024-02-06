use auto_sales;

select *
from asd;

-- Check for null values in all columns of the table
SELECT 
  COUNT(*) as Null_Values
FROM 
  asd
WHERE 
  ORDER_ID IS NULL OR
  QUANTITY_ORDERED IS NULL OR
  PRICE_FOR_EACH IS NULL OR
  ORDER_LINE_NUMBER IS NULL OR
  SALES IS NULL OR
  ORDER_DATE IS NULL OR
  DAYS_SINCE_LASTORDER IS NULL OR
  ORDER_STATUS IS NULL OR
  PRODUCT_LINE IS NULL OR
  MANUFACTURERS_SUGGESTED_RETAIL_PRICE IS NULL OR
  PRODUCT_CODE IS NULL OR
  CUSTOMER_NAME IS NULL OR
  PHONE IS NULL OR
  ADDRESS_LINE IS NULL OR
  CITY IS NULL OR
  POSTAL_CODE IS NULL OR
  COUNTRY IS NULL OR
  CONTACT_LASTNAME IS NULL OR
  CONTACT_FIRSTNAME IS NULL OR
  DEAL_SIZE IS NULL; -- RESULT ZERO NULL_VALUES

-- Total Sales, Average Sales, Average Quantity Ordered, and Average Price for Each Order (Rounded to the nearest whole number)
SELECT 
  ROUND(SUM(SALES)) AS Total_Sales,
  ROUND(AVG(SALES)) AS Average_Sales,
  ROUND(AVG(QUANTITY_ORDERED)) AS Average_Quantity_Ordered,
  ROUND(AVG(PRICE_FOR_EACH)) AS Average_Price_For_Each
FROM Asd;

-- Total quantity of orders made by each customer:
SELECT
    CUSTOMER_NAME, 
	SUM(QUANTITY_ORDERED) AS sum_quantity
FROM asd
GROUP BY customer_name
ORDER BY sum_quantity DESC;

-- Countries with the highest number of orders:
SELECT
	COUNTRY,
    count(order_id) AS Number_of_orders
FROM asd
GROUP BY COUNTRY
ORDER BY Number_of_orders DESC
LIMIT 5;

-- Average price for each order:
SELECT 
	ORDER_ID, 
    AVG(PRICE_FOR_EACH) as Average_Price
FROM Asd
GROUP BY ORDER_ID;

-- Average price for each Product Line:
SELECT
	PRODUCT_LINE,
    AVG(PRICE_FOR_EACH) as Average_Price
FROM Asd
GROUP BY PRODUCT_LINE;

-- Average quantity ordered per product line
SELECT 
	PRODUCT_LINE, 
    AVG(QUANTITY_ORDERED) as Average_Quantity
FROM Asd
GROUP BY PRODUCT_LINE;

-- Average price for each Product:
SELECT
	PRODUCT_CODE,
    PRODUCT_LINE,
    AVG(PRICE_FOR_EACH) as Average_Price
FROM Asd
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY AVERAGE_PRICE DESC;

-- Average quantity ordered per product
SELECT 
	PRODUCT_CODE, 
    PRODUCT_LINE,
    AVG(QUANTITY_ORDERED) as Average_Quantity
FROM Asd
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY Average_Quantity DESC;

-- Top 5 Product line with the highest sales:
SELECT 
	PRODUCT_LINE, 
    SUM(SALES) as Total_Sales
FROM Asd
GROUP BY PRODUCT_LINE
ORDER BY Total_Sales DESC
LIMIT 1;

-- Distribution of deal sizes across different countries:
SELECT 
	COUNTRY, 
    DEAL_SIZE, 
    COUNT(ORDER_ID) as Number_Of_Deals
FROM Asd
GROUP BY COUNTRY, DEAL_SIZE
ORDER BY COUNTRY DESC;

-- Top customers in terms of sales:
SELECT 
    CUSTOMER_NAME,
    CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
    SUM(SALES) as Total_Sales
FROM Asd
GROUP BY CUSTOMER_NAME, FULL_NAME
ORDER BY Total_Sales DESC
LIMIT 10;

-- Trend of sales over time:
SELECT
  ORDER_DATE,
  SUM(SALES) AS Total_Sales
FROM asd
GROUP BY ORDER_DATE
ORDER BY ORDER_DATE ASC;

-- Total sales for each month
SELECT 
	DATE_FORMAT(ORDER_DATE, '%Y-%m') as Month, 
    SUM(SALES) as Sales 
FROM Asd 
GROUP BY Month;

-- Total sales for each year
SELECT 
	DATE_FORMAT(ORDER_DATE, '%Y') as Year, 
    SUM(SALES) as Sales 
FROM Asd 
GROUP BY Year;

-- Quantity ordered trend over time
SELECT 
	DATE(ORDER_DATE) as Order_Date, 
    SUM(QUANTITY_ORDERED) as Total_Quantity
FROM Asd
GROUP BY Order_Date
ORDER BY Order_Date;

-- Customers with most orders
SELECT 
    CUSTOMER_NAME,
    CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
    COUNT(ORDER_ID) as Total_Orders
FROM Asd
GROUP BY CUSTOMER_NAME, FULL_NAME
ORDER BY Total_Orders DESC;

-- Product with highest MANUFACTURERS_SUGGESTED_RETAIL_PRICE(MSRP)
SELECT 
	PRODUCT_CODE,
    PRODUCT_LINE,
    MAX(MANUFACTURERS_SUGGESTED_RETAIL_PRICE) as MAX_MSRP
FROM Asd
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY MAX_MSRP DESC;

-- Number of Shipped orders
SELECT COUNT(ORDER_ID) as Shipped_Orders
FROM Asd
WHERE ORDER_STATUS = 'Shipped';

-- Number of cancelled orders
SELECT COUNT(ORDER_ID) as Cancelled_Orders
FROM Asd
WHERE ORDER_STATUS = 'Cancelled';

-- Top 5 Product line with most Shipped_orders
SELECT 
	PRODUCT_LINE, 
    COUNT(ORDER_ID) as Shipped_Orders
FROM Asd
WHERE ORDER_STATUS = 'Shipped'
GROUP BY PRODUCT_LINE
ORDER BY Cancelled_Orders DESC
LIMIT 5;

-- Top 5 Product line with most cancelled orders
SELECT 
	PRODUCT_LINE, 
    COUNT(ORDER_ID) as Cancelled_Orders
FROM Asd
WHERE ORDER_STATUS = 'Cancelled'
GROUP BY PRODUCT_LINE
ORDER BY Cancelled_Orders DESC
LIMIT 5;

-- Top 10 products by sales
SELECT
	PRODUCT_CODE, 
    PRODUCT_LINE,
    SUM(SALES) as Total_Sales 
FROM Asd 
GROUP BY PRODUCT_CODE, PRODUCT_LINE 
ORDER BY Total_Sales DESC 
LIMIT 10;

-- Number of customers in each deal size category
SELECT 
	DEAL_SIZE, 
    COUNT(DISTINCT CUSTOMER_NAME) as Customers
FROM Asd 
GROUP BY DEAL_SIZE;

-- Number of times each customer purchased each deal size
SELECT 
	CUSTOMER_NAME, 
    CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
    DEAL_SIZE, 
    COUNT(*) as Number_Of_Purchases
FROM Asd 
GROUP BY CUSTOMER_NAME, FULL_NAME, DEAL_SIZE
ORDER BY CUSTOMER_NAME ASC;

-- Number of orders exceeding the MSRP
SELECT 
	COUNT(*) as Orders 
FROM Asd 
WHERE SALES > MANUFACTURERS_SUGGESTED_RETAIL_PRICE;

-- Number of PRODUCT_LINE exceeding the MSRP
SELECT 
	PRODUCT_LINE, 
	COUNT(*) as Orders 
FROM 
	Asd 
WHERE PRICE_FOR_EACH > MANUFACTURERS_SUGGESTED_RETAIL_PRICE
GROUP BY PRODUCT_LINE
ORDER BY Orders DESC;

-- Average order frequency for each customer
SELECT 
	CUSTOMER_NAME,
    CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
    COUNT(DISTINCT ORDER_ID) / DATEDIFF(MAX(ORDER_DATE), MIN(ORDER_DATE)) as Frequency 
FROM Asd 
GROUP BY CUSTOMER_NAME, FULL_NAME;

-- ----------------------------------------------------------------------------------------------
-- -----------------VIEWS FOR POWERBI VISUALIZATION----------------------------------------------

-- Creating view for Total Sales, Average Quantity Ordered, Average Sales, and Average Price for Each Order
DROP VIEW IF EXISTS sales_report_queries_view;
CREATE VIEW sales_report_queries_view AS
SELECT 
  ROUND(SUM(SALES)) AS Total_Sales,
  ROUND(AVG(SALES)) AS Average_Sales,
  ROUND(AVG(QUANTITY_ORDERED)) AS Average_Quantity_Ordered,
  ROUND(AVG(PRICE_FOR_EACH)) AS Average_Price_For_Each
FROM Asd;


-- Creating view for Total Quantity of Orders Made by Each Customer
DROP VIEW IF EXISTS total_quantity_per_customer_view;
CREATE VIEW total_quantity_per_customer_view AS
SELECT
  CUSTOMER_NAME,
  SUM(QUANTITY_ORDERED) AS sum_quantity
FROM asd
GROUP BY CUSTOMER_NAME;

-- Creating view for Countries with the Highest Number of Orders
DROP VIEW IF EXISTS countries_highest_orders_view;
CREATE VIEW countries_highest_orders_view AS
SELECT
  COUNTRY,
  COUNT(ORDER_ID) AS Number_of_orders
FROM asd
GROUP BY COUNTRY
ORDER BY Number_of_orders DESC
LIMIT 5;

-- Creating view for Average Price for Each Order
DROP VIEW IF EXISTS avg_price_per_order_view;
CREATE VIEW avg_price_per_order_view AS
SELECT
  ORDER_ID,
  AVG(PRICE_FOR_EACH) AS Average_Price
FROM Asd
GROUP BY ORDER_ID;

-- Creating view for Average Price for Each Product Line
DROP VIEW IF EXISTS avg_price_per_product_line_view;
CREATE VIEW avg_price_per_product_line_view AS
SELECT
  PRODUCT_LINE,
  AVG(PRICE_FOR_EACH) AS Average_Price
FROM Asd
GROUP BY PRODUCT_LINE;

-- Creating view for Average Quantity Ordered per Product Line
DROP VIEW IF EXISTS avg_quantity_per_product_line_view;
CREATE VIEW avg_quantity_per_product_line_view AS
SELECT
  PRODUCT_LINE,
  AVG(QUANTITY_ORDERED) AS Average_Quantity
FROM Asd
GROUP BY PRODUCT_LINE;

-- Creating view for Average Price for Each Product
DROP VIEW IF EXISTS avg_price_per_product_view;
CREATE VIEW avg_price_per_product_view AS
SELECT
  PRODUCT_CODE,
  PRODUCT_LINE,
  AVG(PRICE_FOR_EACH) AS Average_Price
FROM Asd
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY AVERAGE_PRICE DESC;

-- Creating view for Average Quantity Ordered per Product
DROP VIEW IF EXISTS avg_quantity_per_product_view;
CREATE VIEW avg_quantity_per_product_view AS
SELECT
  PRODUCT_CODE,
  PRODUCT_LINE,
  AVG(QUANTITY_ORDERED) AS Average_Quantity
FROM Asd
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY Average_Quantity DESC;

-- Creating view for Top 5 Product Line with the Highest Sales
DROP VIEW IF EXISTS top_product_line_sales_view;
CREATE VIEW top_product_line_sales_view AS
SELECT
  PRODUCT_LINE,
  SUM(SALES) AS Total_Sales
FROM Asd
GROUP BY PRODUCT_LINE
ORDER BY Total_Sales DESC
LIMIT 1;

-- Creating view for Distribution of Deal Sizes Across Different Countries
DROP VIEW IF EXISTS deal_size_distribution_view;
CREATE VIEW deal_size_distribution_view AS
SELECT
  COUNTRY,
  DEAL_SIZE,
  COUNT(ORDER_ID) AS Number_Of_Deals
FROM Asd
GROUP BY COUNTRY, DEAL_SIZE
ORDER BY COUNTRY DESC;

-- Creating view for Top Customers in Terms of Sales
DROP VIEW IF EXISTS top_customers_sales_view;
CREATE VIEW top_customers_sales_view AS
SELECT
  CUSTOMER_NAME,
  CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
  SUM(SALES) AS Total_Sales
FROM Asd
GROUP BY CUSTOMER_NAME, FULL_NAME
ORDER BY Total_Sales DESC
LIMIT 10;

-- Creating view for Trend of Sales Over Time
DROP VIEW IF EXISTS sales_trend_over_time_view;
CREATE VIEW sales_trend_over_time_view AS
SELECT
  ORDER_DATE,
  SUM(SALES) AS Total_Sales
FROM asd
GROUP BY ORDER_DATE
ORDER BY ORDER_DATE ASC;

-- Creating view for Total Sales for Each Month
DROP VIEW IF EXISTS total_sales_per_month_view;
CREATE VIEW total_sales_per_month_view AS
SELECT
  DATE_FORMAT(ORDER_DATE, '%Y-%m') AS Month,
  SUM(SALES) AS Sales
FROM Asd
GROUP BY Month;

-- Creating view for Total Sales for Each Year
DROP VIEW IF EXISTS total_sales_per_year_view;
CREATE VIEW total_sales_per_year_view AS
SELECT
  DATE_FORMAT(ORDER_DATE, '%Y') AS Year,
  SUM(SALES) AS Sales
FROM Asd
GROUP BY Year;

-- Creating view for Quantity Ordered Trend Over Time
DROP VIEW IF EXISTS quantity_ordered_trend_over_time_view;
CREATE VIEW quantity_ordered_trend_over_time_view AS
SELECT
  DATE(Asd.ORDER_DATE) AS Order_Date,
  SUM(QUANTITY_ORDERED) AS Total_Quantity
FROM Asd
GROUP BY Asd.Order_Date
ORDER BY Asd.Order_Date;

-- Creating view for Customers with Most Orders
DROP VIEW IF EXISTS customers_the_most_orders_view;
CREATE VIEW customers_the_most_orders_view AS
SELECT
  CUSTOMER_NAME,
  CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
  COUNT(ORDER_ID) AS Total_Orders
FROM Asd
GROUP BY CUSTOMER_NAME, FULL_NAME
ORDER BY Total_Orders DESC;

-- Creating view for Product with Highest Manufacturers Suggested Retail Price (MSRP)
DROP VIEW IF EXISTS product_highest_msrp_view;
CREATE VIEW product_highest_msrp_view AS
SELECT
  PRODUCT_CODE,
  PRODUCT_LINE,
  MAX(MANUFACTURERS_SUGGESTED_RETAIL_PRICE) AS MAX_MSRP
FROM Asd
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY MAX_MSRP DESC;

-- Creating view for Number of Shipped Orders
DROP VIEW IF EXISTS shipped_orders_view;
CREATE VIEW shipped_orders_view AS
SELECT
  COUNT(ORDER_ID) AS Shipped_Orders
FROM Asd
WHERE ORDER_STATUS = 'Shipped';

-- Creating view for Number of Cancelled Orders
DROP VIEW IF EXISTS cancelled_orders_view;
CREATE VIEW cancelled_orders_view AS
SELECT
  COUNT(ORDER_ID) AS Cancelled_Orders
FROM Asd
WHERE ORDER_STATUS = 'Cancelled';

-- Creating view for Top 5 Product Line with Most Shipped Orders
DROP VIEW IF EXISTS top_product_line_shipped_orders_view;
CREATE VIEW top_product_line_shipped_orders_view AS
SELECT
  PRODUCT_LINE,
  COUNT(ORDER_ID) AS Shipped_Orders
FROM Asd
WHERE ORDER_STATUS = 'Shipped'
GROUP BY PRODUCT_LINE
ORDER BY Shipped_Orders DESC
LIMIT 5;

-- Creating view for Top 5 Product Line with Most Cancelled Orders
DROP VIEW IF EXISTS top_product_line_cancelled_orders_view;
CREATE VIEW top_product_line_cancelled_orders_view AS
SELECT
  PRODUCT_LINE,
  COUNT(ORDER_ID) AS Cancelled_Orders
FROM Asd
WHERE ORDER_STATUS = 'Cancelled'
GROUP BY PRODUCT_LINE
ORDER BY Cancelled_Orders DESC
LIMIT 5;

-- Creating view for Top 10 Products by Sales
DROP VIEW IF EXISTS top_products_sales_view;
CREATE VIEW top_products_sales_view AS
SELECT
  PRODUCT_CODE,
  PRODUCT_LINE,
  SUM(SALES) AS Total_Sales
FROM Asd
GROUP BY PRODUCT_CODE, PRODUCT_LINE
ORDER BY Total_Sales DESC
LIMIT 10;

-- Creating view for Number of Customers in Each Deal Size Category
DROP VIEW IF EXISTS customers_in_each_deal_size_view;
CREATE VIEW customers_in_each_deal_size_view AS
SELECT
  DEAL_SIZE,
  COUNT(DISTINCT CUSTOMER_NAME) AS Customers
FROM Asd
GROUP BY DEAL_SIZE;

-- Creating view for Number of Times Each Customer Purchased Each Deal Size
DROP VIEW IF EXISTS customer_purchases_each_deal_size_view;
CREATE VIEW customer_purchases_each_deal_size_view AS
SELECT
  CUSTOMER_NAME,
  CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
  DEAL_SIZE,
  COUNT(*) AS Number_Of_Purchases
FROM Asd
GROUP BY CUSTOMER_NAME, FULL_NAME, DEAL_SIZE
ORDER BY CUSTOMER_NAME ASC;

-- Creating view for Number of Orders Exceeding the MSRP
DROP VIEW IF EXISTS orders_exceeding_msrp_view;
CREATE VIEW orders_exceeding_msrp_view AS
SELECT
  COUNT(*) AS Orders
FROM Asd
WHERE SALES > MANUFACTURERS_SUGGESTED_RETAIL_PRICE;

-- Creating view for Number of Product Lines Exceeding the MSRP
DROP VIEW IF EXISTS product_lines_exceeding_msrp_view;
CREATE VIEW product_lines_exceeding_msrp_view AS
SELECT
  PRODUCT_LINE,
  COUNT(*) AS Orders
FROM Asd
WHERE PRICE_FOR_EACH > MANUFACTURERS_SUGGESTED_RETAIL_PRICE
GROUP BY PRODUCT_LINE
ORDER BY Orders DESC;

-- Creating view for Average Order Frequency for Each Customer
DROP VIEW IF EXISTS avg_order_frequency_view;
CREATE VIEW avg_order_frequency_view AS
SELECT
  CUSTOMER_NAME,
  CONCAT(CONTACT_FIRSTNAME, ' ', CONTACT_LASTNAME) AS FULL_NAME,
  COUNT(DISTINCT ORDER_ID) / DATEDIFF(MAX(ORDER_DATE), MIN(ORDER_DATE)) AS Frequency
FROM Asd
GROUP BY CUSTOMER_NAME, FULL_NAME;

-- Creating view for Auto Sales Data
DROP VIEW IF EXISTS auto_sales_data_view;
CREATE VIEW auto_sales_data_view AS
select *
from asd;
