-- =======================================================================
-- PROJECT: Pizza Sales Performance Analysis
-- DATABASE SETUP & EXPLORATION
-- =======================================================================
USE pizza;

-- Review schema details and initial dataset layout
DESCRIBE pizza_sales;
SELECT * FROM pizza_sales;

-- =======================================================================
-- 1. EXECUTIVE METRICS & KEY PERFORMANCE INDICATORS (KPIs)
-- =======================================================================

-- Total Revenue: Sum of all transactional pricing
SELECT SUM(total_price) AS Total_revenue 
FROM pizza_sales;

-- Average Order Value: Total revenue generated divided by distinct orders
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_order_Value 
FROM pizza_sales;

-- Total Pizzas Sold: Net volume of units moved
SELECT SUM(quantity) AS Total_Pizza_Sold 
FROM pizza_sales;

-- Total Orders: Distinct count of customer transactions
SELECT COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales; 

-- Average Pizzas Per Order: Volume metric tracking order depth
SELECT SUM(quantity) / COUNT(DISTINCT order_id) AS Avg_pizza_per_order 
FROM pizza_sales;

-- =======================================================================
-- 2. TEMPORAL & SEASONAL TREND ANALYSIS
-- =======================================================================

-- Hourly Trend: Identifying peak operating windows for inventory/staffing
SELECT 
    HOUR(order_time) AS order_hour,
    SUM(quantity) AS Total_pizza_sold 
FROM pizza_sales 
GROUP BY HOUR(order_time) 
ORDER BY order_hour;

-- Weekly Trend: Monitoring order volume distributions across the calendar year
SELECT 
    WEEK(order_date, 3) AS Week_Number, 
    YEAR(order_date) AS Order_year, 
    COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales
GROUP BY Week_Number, Order_year
ORDER BY Order_year, Week_Number;

-- =======================================================================
-- 3. PRODUCT CATEGORY & PROFILE SEGMENTATION
-- =======================================================================

-- Percentage of Sales by Pizza Category (Macro view)
SELECT 
    pizza_category, 
    SUM(total_price) AS Total_sales, 
    SUM(total_Price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS PCT 
FROM pizza_sales
GROUP BY pizza_category;

-- Percentage of Sales by Pizza Category (Filtered for January seasonality)
SELECT 
    pizza_category, 
    SUM(total_price) AS Total_sales, 
    SUM(total_Price) * 100 / (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1) AS PCT 
FROM pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category;

-- Percentage of Sales by Pizza Size (Revenue contribution optimization)
SELECT 
    pizza_size, 
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_revenue, 
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC;

-- Total Pizzas Sold by Category (Macro volume view)
SELECT 
    pizza_category, 
    SUM(quantity) AS Total_pizza_sold 
FROM pizza_sales
GROUP BY pizza_category;

-- Total Pizzas Sold by Category (Filtered for February seasonality)
SELECT 
    pizza_category, 
    SUM(quantity) AS Total_pizza_sold 
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_pizza_sold DESC;

-- =======================================================================
-- 4. PRODUCT PERFORMANCE BENCHMARKING (TOP & BOTTOM RANKINGS)
-- =======================================================================

-- Top 5 / Bottom 5 Pizzas by Revenue Generation
SELECT pizza_name, SUM(total_price) AS Total_Revenue FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Revenue DESC LIMIT 5;
SELECT pizza_name, SUM(total_price) AS Total_Revenue FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Revenue ASC LIMIT 5;

-- Top 5 / Bottom 5 Pizzas by Absolute Quantity Sold
SELECT pizza_name, SUM(quantity) AS Total_Quantity FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Quantity DESC LIMIT 5;
SELECT pizza_name, SUM(quantity) AS Total_Quantity FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Quantity ASC LIMIT 5;

-- Top 5 / Bottom 5 Pizzas by Distinct Order Placements
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_order FROM pizza_sales GROUP BY pizza_name ORDER BY Total_order DESC LIMIT 5;
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_order FROM pizza_sales GROUP BY pizza_name ORDER BY Total_order ASC LIMIT 5;
