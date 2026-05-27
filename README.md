# 🍕 Pizza Sales Analysis Using SQL

## 📌 Project Overview

This project analyzes pizza sales data using SQL to extract meaningful business insights related to orders, revenue, pizza categories, pizza sizes, and customer ordering patterns.

The main objective of this project is to understand sales performance, identify top-selling pizzas, analyze category-wise revenue contribution, and find business trends that can help improve decision-making.

---

## 📂 Dataset Used

The project uses four CSV files:

- `orders.csv`
- `order_details.csv`
- `pizzas.csv`
- `pizza_types.csv`

---

## 🛠️ Tools & Technologies Used

- SQL
- MySQL
- MySQL Workbench
- CSV Dataset
- PowerPoint for result presentation

---

## 🗃️ Database Structure

### 1. `orders`

Stores order-level information.

| Column | Description |
|---|---|
| order_id | Unique ID of each order |
| date | Date of order |
| time | Time of order |

### 2. `order_details`

Stores item-level order details.

| Column | Description |
|---|---|
| order_details_id | Unique ID for each order item |
| order_id | Order reference ID |
| pizza_id | Pizza reference ID |
| quantity | Number of pizzas ordered |

### 3. `pizzas`

Stores pizza size and price details.

| Column | Description |
|---|---|
| pizza_id | Unique pizza ID |
| pizza_type_id | Pizza type reference ID |
| size | Pizza size |
| price | Price of pizza |

### 4. `pizza_types`

Stores pizza name, category, and ingredients.

| Column | Description |
|---|---|
| pizza_type_id | Unique pizza type ID |
| name | Pizza name |
| category | Pizza category |
| ingredients | Ingredients used |

---

## 🔍 SQL Analysis Performed

The following business questions were answered using SQL:

1. Total number of orders placed
2. Total revenue generated from pizza sales
3. Highest-priced pizza
4. Most common pizza size ordered
5. Top 5 most ordered pizza types
6. Total quantity of pizzas ordered by category
7. Distribution of orders by hour
8. Number of pizza varieties in each category
9. Number of pizza size variants in each category
10. Average number of pizzas ordered per day
11. Top 3 pizza types based on revenue
12. Percentage contribution of each pizza category to total revenue
13. Cumulative revenue generated over time
14. Top 3 pizza types by revenue for each category

---

## 📊 Key Insights

- Total orders placed: **21,350**
- Total pizzas sold: **49,574**
- Total revenue generated: **$817,860.05**
- Most ordered pizza size: **Large**
- Highest revenue-generating pizza: **The Thai Chicken Pizza**
- Most ordered pizza type: **The Classic Deluxe Pizza**
- Best-performing category by quantity: **Classic**
- Highest revenue-contributing category: **Classic**
- Peak order hours can help in better staff and inventory planning
- Category-wise revenue analysis helps understand which pizza categories contribute most to sales

---

## 📈 Business Insights

### 1. Revenue Performance

The total revenue generated from pizza sales shows strong business performance. Revenue was calculated by multiplying pizza quantity with pizza price.

### 2. Customer Preference

Large-sized pizzas were ordered the most, which indicates that customers prefer bigger pizza sizes.

### 3. Category Performance

The Classic category performed best in terms of quantity sold and revenue contribution.

### 4. Product Performance

The Thai Chicken Pizza generated the highest revenue, while The Classic Deluxe Pizza was the most ordered pizza.

### 5. Time-Based Analysis

Hourly order distribution helps identify peak business hours, which can be useful for staffing, kitchen preparation, and promotional offers.

---

## 🧾 Important SQL Concepts Used

- `JOIN`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- Aggregate functions:
  - `COUNT()`
  - `SUM()`
  - `AVG()`
  - `ROUND()`
- Subqueries
- Window functions:
  - `RANK()`
  - `SUM() OVER()`

---

## 📌 Sample Query

```sql
-- Calculate the percentage contribution of each pizza category to total revenue.
SELECT 
    pizza_types.category,
    ROUND(
        (
            SUM(order_details.quantity * pizzas.price) / 
            (
                SELECT 
                    SUM(order_details.quantity * pizzas.price)
                FROM order_details
                JOIN pizzas 
                    ON pizzas.pizza_id = order_details.pizza_id
            )
        ) * 100, 
        2
    ) AS revenue_percentage
FROM pizza_types
JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
    ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;
```
---

## 📁 Project Files

```text
Pizza-Sales-SQL-Analysis/
│
├── orders.csv
├── order_details.csv
├── pizzas.csv
├── pizza_types.csv
├── PizzaSalesSQL_Script.sql
├── PIZZA SALES SQL Project Results and Insights.pptx
└── README.md
```
--- 

## 🎯 Project Objective

The objective of this project is to use **SQL** for analyzing pizza sales data and generating useful insights that can help a business understand:

- Sales trends
- Revenue contribution
- Customer preferences
- Product performance
- Category-wise performance
- Time-based order patterns

---

## ✅ Conclusion

This **Pizza Sales SQL Analysis** project helped in understanding how SQL can be used for real-world business analysis.

By using **joins, aggregations, subqueries, and window functions**, important insights were extracted from raw sales data.

The analysis shows that the **Classic category** and **Large pizza size** are highly popular among customers. Revenue-based analysis also highlights the top-performing pizzas, which can help the business improve:

- Marketing strategy
- Inventory planning
- Sales strategy
- Product promotion
- Business decision-making

---

## 👨‍💻 Author

**Abhishek Savita**

GitHub: [Abhishek-Savita-3012](https://github.com/Abhishek-Savita-3012)
