-- Initialize Database Analysis
USE pizza_sales_db;

-- 1. Core Business Performance KPIs
SELECT 
    SUM(total_price) AS Total_Revenue,
    SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value,
    SUM(quantity) AS Total_Pizzas_Sold,
    COUNT(DISTINCT order_id) AS Total_Orders,
    SUM(quantity) / COUNT(DISTINCT order_id) AS Avg_Pizzas_Per_Order
FROM pizza_sales;

-- 2. Hourly Demand Distribution (Staffing Optimization)
SELECT 
    HOUR(order_time) AS order_hour,
    SUM(quantity) AS Total_pizza_sold
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY order_hour;

-- 3. Revenue Metrics by Product Size
SELECT 
    pizza_size, 
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC;

-- 4. Top 5 Alpha Performers by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

-- 5. Bottom 5 Underperformers by Volume (Menu Optimization)
SELECT pizza_name, SUM(quantity) AS Total_Quantity 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity ASC
LIMIT 5;

