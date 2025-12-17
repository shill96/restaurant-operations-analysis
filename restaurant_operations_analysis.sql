/*
===========================================
RESTAURANT OPERATIONS ANALYSIS
===========================================

THE SITUATION
You've just been hired as a Data Analyst for the Taste of the World Café, a
restaurant that has diverse menu offerings and serves generous portions

THE ASSIGNMENT
The Taste of the World Café debuted a new menu at the start of the year.
You've been asked to dig into the customer data to see which menu items
are doing well / not well and what the top customers seem to like best

THE OBJECTIVES
1. Explore the menu_items table to get an idea of what's on the new menu
2. Explore the order_details table to get an idea of the data that's been collected
3. Use both tables to understand how customers are reacting to the new menu
===========================================
*/

-- ============ SECTION 1: MENU EXPLORATION ============
-- Start the database
use restaurant_db;

-- explore the tables in the db
show tables; -- there are only two tables in the db

-- view menu_items table
SELECT 
    *
FROM
    menu_items;

    
-- check the number of rows 
select count(*) from menu_items; -- there are 32 different menu
select count(*) from order_details; -- there are 12234 rows

-- The most expensive order
SELECT 
    *
FROM
    menu_items
WHERE
    price = (SELECT 
            MAX(price)
        FROM
            menu_items) 
UNION SELECT 
    *
FROM
    menu_items
WHERE
    price = (SELECT 
            MIN(price)
        FROM
            menu_items);
-- the most expensive menu id shrimp scamping and least is Edamame

-- select menu where italian
SELECT 
    *
FROM
    menu_items
WHERE
    category = 'Italian';  
    
-- count the number of italian menu
SELECT 
    COUNT(*) AS count_of_italian_menu
FROM
    menu_items
where category = 'Italian'; -- there are 9 italian dish

-- count number of meals in each category
SELECT 
    category AS category, COUNT(*) AS category_count
FROM
    menu_items
GROUP BY category;

-- Explore the order table
-- view order_details
SELECT 
    *
FROM
    order_details; 

-- ============ SECTION 2: ORDER PATTERNS ============
-- view min and max date    
SELECT 
    MIN(order_date) AS earliest,
    MAX(order_date) AS latest
FROM order_details;

-- break down by month
SELECT 
    MONTHNAME(order_date) AS month,
    COUNT(DISTINCT order_id) AS num_orders,
    COUNT(*) AS items_ordered
FROM order_details
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);-- January & March has the most order

-- group the order by day and find the peak order
SELECT 
    DAYNAME(order_date) AS 'Day_of_Week',
    COUNT(DISTINCT order_id) AS num_orders,
    COUNT(*) AS items_ordered
FROM
    order_details
GROUP BY DAYNAME(order_date)
order by COUNT(DISTINCT order_id) desc;
/*
DAY OF WEEK FINDINGS:
- Monday is peak day (885 orders) 
- Wednesday is slowest (682 orders)
- Weekdays outperform weekends — suggests strong lunch/office crowd
- Avg 2.3 items per order across all days
- Recommendation: Consider weekend promotions to boost Saturday/Sunday traffic
*/

-- Time
SELECT 
    MIN(order_time) AS ealier, MAX(order_time) AS latest
FROM
    order_details;
    
-- search for peak hr
SELECT 
    CASE 
        WHEN HOUR(order_time) BETWEEN 10 AND 14 THEN 'Lunch'
        WHEN HOUR(order_time) BETWEEN 15 AND 17 THEN 'Afternoon'
        WHEN HOUR(order_time) BETWEEN 18 AND 20 THEN 'Dinner'
        ELSE 'Late Night'
    END AS meal_period,
    COUNT(DISTINCT order_id) AS num_orders,
    COUNT(*) AS items_ordered,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / (SELECT COUNT(DISTINCT order_id) FROM order_details), 1) AS order_pct
FROM order_details
GROUP BY meal_period
ORDER BY num_orders DESC;
/*
MEAL PERIOD FINDINGS:
- Lunch is the busiest period (1,958 orders, 4,850 items)
- Dinner comes second (1,507 orders)
- Late Night is slowest (445 orders) — only 8% of daily traffic
- Lunch generates 36% of all orders
- Avg items per order: Lunch (2.5), Dinner (2.2), Afternoon (2.2), Late Night (2.1)
- Recommendation: Focus staffing and inventory on lunch rush (10 AM - 2 PM)
- Opportunity: Late night is underperforming — consider promotions or reduced hours
*/

-- day & Hour
SELECT 
    DAYNAME(order_date) AS day_of_week,
    HOUR(order_time) AS hour,
    COUNT(DISTINCT order_id) AS num_orders
FROM order_details
GROUP BY DAYOFWEEK(order_date), DAYNAME(order_date), HOUR(order_time)
ORDER BY DAYOFWEEK(order_date), num_orders DESC;
    
-- orders and number of item
CREATE VIEW order_summary AS
    SELECT DISTINCT
        od.order_id,
        COUNT(*) AS order_item,
        SUM(mi.price) AS total_price,
        GROUP_CONCAT(mi.item_name
            SEPARATOR ', ') AS items_ordered
    FROM
        order_details od
            JOIN
        menu_items mi ON od.item_id = mi.menu_item_id
    GROUP BY order_id
    ORDER BY order_item DESC;
    
-- view the order summary
select * from order_summary;

-- check the orders had more than 12 items?
SELECT 
    COUNT(*) as item_12_more
FROM
    order_summary
WHERE
    order_item > 12; -- there are 20 orders that had more than 12 items;
    
/*
---------------- OBJECTIVE 3: ANALYSE CUSTOMER BEHAVIOUR ----------------------------
Your final objective is to combine the items and orders tables, 
find the least and most ordered categories, and dive into 
the details of the highest spend orders.
*/
CREATE VIEW full_order_summary AS
    SELECT 
        mi.menu_item_id,
        mi.item_name,
        mi.category,
        mi.price,
        od.order_id,
        od.order_date,
        od.order_time
    FROM
        menu_items mi
            JOIN
        order_details od ON mi.menu_item_id = od.item_id;
        
-- view full_order_summary
select * from full_order_summary;

-- What were the least and most ordered items? What categories were they in?
SELECT 
    item_name, COUNT(*) as num_of_order, category, price
FROM
    full_order_summary
GROUP BY item_name,category,price
order by num_of_order desc; 
/*
the most ordered items are [Hamburger(622), Edamame(620)]
the least ordered is chicken tacos with 123 which belong to Mexican category
*/-- 

-- What were the top 5 orders that spent the most money?
SELECT 
    *
FROM
    order_summary
ORDER BY total_price DESC
LIMIT 5; -- it seems orders with more items say > 12 usually acquires the most money spent.

-- -- Which category brings in the most money?
SELECT 
    category,
    count(*) AS category_count,
    concat('$', SUM(price)) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(SUM(price) * 100.0 / (SELECT 
                    SUM(price)
                FROM
                    full_order_summary),
            2) AS revenue_pct
FROM
    full_order_summary
GROUP BY category
ORDER BY total_revenue desc;
/*
CATEGORY REVENUE FINDINGS:

Italian dominates revenue at $49,463 (31%) despite having fewer orders than Asian.
This is driven by the highest average price point ($16.78) — making it the premium
category on the menu.

Asian leads in volume with 3,470 items sold but generates less revenue ($46,721)
due to lower average pricing ($13.46). This is the high-volume, accessible option.

American underperforms across all metrics — lowest revenue ($28,238), lowest 
average price ($10.33), and fewest items sold (2,734).
*/

/*
KEY INSIGHT: VOLUME VS REVENUE DISCONNECT

American items dominate the bestseller list with 3 of the top 5 spots:
- #1 Hamburger (622 orders)
- #4 Cheeseburger (583 orders)  
- #5 French Fries (571 orders)

Yet American ranks LAST in revenue at just 18% ($28,238).

Italian tells the opposite story — no items in the top 5 bestsellers, 
but leads all categories in revenue at 31% ($49,463).

THE REASON: PRICE POINT
- American avg price: $10.33
- Italian avg price: $16.78

American sells more, earns less. Italian sells less, earns more.

BUSINESS IMPLICATION:
Popular items aren't always profitable items. If the restaurant 
optimized only for order volume, they'd focus on American — and 
leave money on the table. The real opportunity is converting 
high-traffic American customers into Italian buyers.
*/

-- What do top spenders order? (categories in top 5 orders)
SELECT 
    fo.order_id,
    fo.category,
    COUNT(*) AS items,
    SUM(fo.price) AS category_spend
FROM full_order_summary fo
JOIN (
    SELECT order_id 
    FROM order_summary 
    ORDER BY total_price DESC 
    LIMIT 5
) top_orders ON fo.order_id = top_orders.order_id
GROUP BY fo.order_id, fo.category
ORDER BY fo.order_id, category_spend DESC;
/*
---- KEY INSIGHT:
4 out of 5 top spenders have Italian as their highest spend category.
Order #330 is the exception — Asian leads, but Italian is still #2.

This confirms the earlier finding: Italian drives revenue. 
Big spenders are buying Italian dishes.
*/

-- Monthly trend; Is the business growing
SELECT 
    MONTHNAME(order_date) AS month,
    COUNT(DISTINCT order_id) AS num_orders,
    COUNT(*) AS items_sold,
    concat('$', sum(price)) as total_revenue,
    round(sum(price) * 100 / (select sum(price) from full_order_summary),2) as revenue_pct
FROM full_order_summary
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY total_revenue desc;
/*
KEY OBSERVATIONS:
- Business is stable — no major swings between months
- February dipped slightly (shorter month + possible slow season)
- March recovered and slightly exceeded January

*/

-- DAILY AVERAGE PERFORMANCE:
SELECT 
    ROUND(COUNT(DISTINCT order_id) / COUNT(DISTINCT order_date),
            1) AS avg_orders_per_day,
    ROUND(COUNT(*) / COUNT(DISTINCT order_date), 1) AS avg_items_per_day,
    CONCAT('$',
            FORMAT(SUM(price) / COUNT(DISTINCT order_date),
                2)) AS avg_daily_revenue,
    ROUND(COUNT(*) / COUNT(DISTINCT order_id), 1) AS avg_items_per_order,
    CONCAT('$',
            FORMAT(SUM(price) / COUNT(DISTINCT order_id),
                2)) AS avg_order_value
FROM
    full_order_summary;
/*
	INTERPRETATION:
The restaurant handles approximately 60 orders daily with customers 
ordering 2-3 items per visit and spending around $30 per order. 
This generates roughly $1,770 in daily revenue, translating to 
approximately $53,000 monthly — consistent with the monthly breakdown.
*/