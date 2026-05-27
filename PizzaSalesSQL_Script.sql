-- Create a new database for the pizza sales analysis project.
-- Insight: This keeps all pizza-related tables and queries organized in one database.
CREATE DATABASE dominospizza;

-- Select the database so all upcoming tables and queries run inside it.
USE dominospizza;


-- Create table to store pizza variants like size and price.
-- Insight: One pizza type can have multiple sizes, so pizza_id is unique for each size variant.
CREATE TABLE pizzas(
    pizza_id TEXT NOT NULL,
    pizza_type_id TEXT NOT NULL,
    size TEXT NOT NULL,
    price DOUBLE NOT NULL,
    PRIMARY KEY(pizza_id)
);


-- Create table to store pizza type details like name, category, and ingredients.
-- Insight: This table helps analyze pizza performance by name, category, and ingredients.
CREATE TABLE pizza_types(
    pizza_type_id TEXT NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    ingredients TEXT NOT NULL,
    PRIMARY KEY(pizza_type_id)
);


-- Create table to store order-level information.
-- Insight: Each row represents one customer order with date and time.
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);


-- Create table to store item-level order details.
-- Insight: One order can contain multiple pizzas, so this table connects orders with pizza items.
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);


-- View all records from pizzas table.
-- Insight: Helps verify pizza sizes, prices, and pizza IDs.
SELECT * FROM pizzas;

-- View all records from pizza_types table.
-- Insight: Helps check pizza names, categories, and ingredients.
SELECT * FROM pizza_types;

-- View all records from orders table.
-- Insight: Helps understand order dates and order timings.
SELECT * FROM orders;

-- View all records from order_details table.
-- Insight: Helps check which pizzas were ordered and in what quantity.
SELECT * FROM order_details;


-- Retrieve the total number of orders placed.
-- Insight: This gives the overall order volume of the business.
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;


-- Calculate the total revenue generated from pizza sales.
-- Insight: Revenue is calculated by multiplying quantity ordered with pizza price.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;


-- Identify the highest-priced pizza.
-- Insight: Useful for finding the premium/highest-value pizza item.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.
-- Insight: Shows which size is ordered most frequently, useful for inventory and marketing.
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities.
-- Insight: Shows the most popular pizzas based on total quantity sold.
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;


-- Find the total quantity of pizzas ordered in each category.
-- Insight: Helps identify which category performs best in terms of sales volume.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;


-- Determine the distribution of orders by hour of the day.
-- Insight: Helps identify peak business hours for staffing and offers.
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);


-- Count how many different pizza varieties are available in each category.
-- Insight: This counts pizza types, not size variants.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- Count how many pizza size variants/items are available in each category.
-- Insight: This includes different sizes of the same pizza, so count is higher than pizza varieties.
SELECT 
    pizza_types.category,
    COUNT(pizzas.pizza_id) AS total_pizzas
FROM pizza_types
JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category;


-- Calculate the average number of pizzas ordered per day.
-- Insight: First calculates daily pizza quantity, then finds the average across all days.
SELECT 
    ROUND(AVG(quantity), 0) AS average_per_day_pizza_orders
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;


-- Determine the top 3 pizza types based on revenue.
-- Insight: Shows the pizzas contributing the most money, not just quantity.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza category to total revenue.
-- Insight: This shows which pizza category contributes the highest share to total sales revenue.
SELECT 
    pizza_types.category,
    ROUND(((SUM(order_details.quantity * pizzas.price) / (SELECT 
            SUM(order_details.quantity * pizzas.price)
        FROM
            order_details
                JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100), 2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;


-- Analyze cumulative revenue generated over time.
-- Insight: Shows running total revenue day by day and helps understand business growth trend.
SELECT 
    order_date,
    SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM
    (
        SELECT 
            orders.order_date,
            ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue
        FROM
            orders
                JOIN
            order_details ON orders.order_id = order_details.order_id
                JOIN
            pizzas ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY orders.order_date
    ) AS sales;


-- Determine the top 3 pizza types based on revenue for each pizza category.
-- Insight: RANK() ranks pizzas inside each category separately, helping find best performers category-wise.
SELECT 
    category,
    name,
    revenue
FROM
    (
        SELECT 
            pizza_types.category,
            pizza_types.name,
            ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue,
            RANK() OVER (
                PARTITION BY pizza_types.category 
                ORDER BY SUM(order_details.quantity * pizzas.price) DESC
            ) AS rn
        FROM
            pizza_types
                JOIN
            pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
                JOIN
            order_details ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY 
            pizza_types.category,
            pizza_types.name
    ) AS ranked_pizzas
WHERE rn <= 3;