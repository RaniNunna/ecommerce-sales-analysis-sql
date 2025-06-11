-- Drop existing tables if they exist (to avoid conflicts during reruns)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- Create customers table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR,
    email VARCHAR,
    city VARCHAR,
    signup_date DATE
);

-- Create products table
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name VARCHAR,
    category VARCHAR,
    price NUMERIC
);

-- Create orders table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE
);

-- Create order_items table
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER,
    unit_price NUMERIC
);

-- Insert data into customers
INSERT INTO customers (customer_id, name, email, city, signup_date) VALUES
(1, 'Alice', 'alice@example.com', 'Delhi', '2024-01-15'),
(2, 'Bob', 'bob@example.com', 'Mumbai', '2024-02-10'),
(3, 'Carol', 'carol@example.com', 'Bangalore', '2024-02-20');

-- Insert data into products
INSERT INTO products (product_id, name, category, price) VALUES
(1, 'Laptop', 'Electronics', 50000),
(2, 'Phone', 'Electronics', 30000),
(3, 'T-shirt', 'Clothing', 800);

-- Insert data into orders
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2024-03-01'),
(2, 2, '2024-03-05'),
(3, 3, '2024-04-10'),
(4, 1, '2024-04-15');

-- Insert data into order_items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1, 50000),
(2, 1, 2, 1, 30000),
(3, 2, 2, 1, 30000),
(4, 3, 3, 3, 800),
(5, 4, 1, 1, 50000);
