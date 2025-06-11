# E-Commerce Sales Analysis SQL Project

## Overview
This project provides a comprehensive analysis of an e-commerce sales database using SQL. It demonstrates the extraction of key business insights such as revenue trends, customer behavior, product performance, and repeat purchase patterns. The queries utilize advanced SQL concepts including joins, aggregations, window functions, and common table expressions (CTEs) to answer practical business questions.

## Database Schema
The project uses the following simplified schema for the e-commerce database:

- **customers**(`customer_id`, `name`, `email`, `city`, `signup_date`)  
- **orders**(`order_id`, `customer_id`, `order_date`)  
- **order_items**(`order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`)  
- **products**(`product_id`, `name`, `category`, `price`)  

This schema supports detailed tracking of customer orders and the products purchased.

## Queries Included
The project contains 12 key queries, each designed to reveal important aspects of the e-commerce business:

1. Total revenue per month  
2. Revenue by product category month-wise  
3. Top 5 customers by total spend  
4. Month-wise total revenue  
5. Revenue by city  
6. Product category performance (total revenue and quantity sold)  
7. Top 3 products by revenue in each category  
8. Customers who bought all products in a specific category  
9. Best-selling month by total revenue  
10. Month-over-month revenue growth analysis  
11. Identification of repeat customers and their spending  
12. Most profitable product per category  

## Skills Demonstrated
- Writing efficient **JOINs** across multiple tables  
- Using **aggregate functions** like SUM and COUNT  
- Applying **GROUP BY** for data segmentation  
- Utilizing **window functions** such as RANK(), DENSE_RANK(), and LAG()  
- Crafting **Common Table Expressions (CTEs)** for modular query design  
- Filtering and ranking data for advanced business insights  

## How to Use
1. Set up your PostgreSQL environment (e.g., using pgAdmin).  
2. Load the e-commerce database schema and data.  
3. Open the `.sql` file containing all queries in the query tool.  
4. Execute the queries individually or all at once to generate analysis reports.  
5. Review the output to understand customer behavior and sales performance.  

Feel free to modify queries or extend the analysis based on your business needs.

## Final Notes
This project is ideal for showcasing SQL analytical skills on a realistic e-commerce dataset. It can be integrated into your portfolio or GitHub repository to demonstrate your ability to solve real-world data problems. Consider expanding it by adding visualization layers or incorporating more complex metrics like customer lifetime value or cohort analysis.

---

Happy querying! 🚀
