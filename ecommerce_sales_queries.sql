-- =============================================
-- E-Commerce Sales Analysis Project - SQL Queries
-- Author: Rani
-- Description: Final versions of 12 business insight queries
-- =============================================
--products(product_id, name, category, price)
--orders(order_id, customer_id, order_date)
--order_items(order_item_id, order_id, product_id, quantity, unit_price)
--customers(customer_id, name, email, city, signup_date)
--=============================================
--SELECT table_name, column_name, data_type
--FROM information_schema.columns
--WHERE table_schema = 'public'
--ORDER BY table_name, ordinal_position;
--=============================================

	-- 1. Total revenue per month
SELECT
    TO_CHAR(o.order_date, 'YYYY-MM') AS month,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM
    orders o
JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY
    month;

-- 2. Total revenue by product category month-wise
SELECT
    TO_CHAR(o.order_date, 'YYYY-MM') AS month,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM
    orders o
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    products p ON oi.product_id = p.product_id
GROUP BY
    month, p.category
ORDER BY
    month, p.category;

-- 3. Top 5 customers who spent the most
SELECT 
  c.name AS customer_name,
  SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 5;

-- 4. Month-wise total revenue
SELECT 
  TO_CHAR(o.order_date, 'YYYY-MM') AS month,
  SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY month;

-- 5. Revenue by city
SELECT 
  c.city,
  SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- 6. Product Category Performance (total revenue and quantity sold per category)
-- Product Category Performance: total revenue and quantity sold per category
SELECT 
  p.category,
  SUM(oi.quantity) AS total_quantity_sold,
  SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- 7. Top 3 products by revenue in each category
-- Top 3 Products by Revenue in Each Category
WITH CTE AS (
    SELECT 
        p.category,
        p.name AS product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.name
)
SELECT *
FROM (
    SELECT 
        category,
        product_name,
        total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY category ORDER BY total_revenue DESC
        ) AS rank
    FROM CTE
) ranked
WHERE rank <= 3
ORDER BY category, rank;


-- 8.Customers Who Bought All Products in a Category (e.g., category = 'Electronics')
WITH category_products AS (
    SELECT product_id
    FROM products
    WHERE category = 'Clothing'
),
customer_purchases AS (
    SELECT o.customer_id, oi.product_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE oi.product_id IN (SELECT product_id FROM category_products)
    GROUP BY o.customer_id, oi.product_id
),
product_counts AS (
    SELECT COUNT(*) AS total_products
    FROM category_products
),
qualified_customers AS (
    SELECT customer_id, COUNT(DISTINCT product_id) AS products_bought
    FROM customer_purchases
    GROUP BY customer_id
)
SELECT c.customer_id, c.name
FROM qualified_customers qc
JOIN customers c ON qc.customer_id = c.customer_id,
     product_counts pc
WHERE qc.products_bought = pc.total_products;

-- 9. Best-selling month (by total revenue)
WITH monthly_revenue AS (
    SELECT 
        TO_CHAR(o.order_date, 'YYYY-MM') AS month,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
)
SELECT month, total_revenue
FROM (
    SELECT 
        month, 
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS rank
    FROM monthly_revenue
) ranked
WHERE rank = 1;

-- 10. Month-over-month revenue growth
WITH monthly_revenue AS (
    SELECT 
        TO_CHAR(o.order_date, 'YYYY-MM') AS month,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
)
SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue,
    (total_revenue - LAG(total_revenue) OVER (ORDER BY month)) AS revenue_change,
    ROUND(
        100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY month)) 
        / NULLIF(LAG(total_revenue) OVER (ORDER BY month), 0),
        2
    ) AS percent_change
FROM monthly_revenue
ORDER BY month;

-- 11. Identify repeated customers (more than one order)
WITH customer_order_summary AS (
    SELECT 
        c.customer_id,
        c.name,
        c.email,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.name, c.email
)
SELECT *
FROM customer_order_summary
WHERE total_orders > 1
ORDER BY total_spent DESC;

-- 12. Most profitable product per category
WITH product_revenue AS (
    SELECT 
        p.category,
        p.name AS product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.name
),
ranked_products AS (
    SELECT *,
           RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rnk
    FROM product_revenue
)
SELECT category AS category_name, product_name, total_revenue
FROM ranked_products
WHERE rnk = 1
ORDER BY category_name;