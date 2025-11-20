create database IDC_Pizza;
use IDC_Pizza;
-- 1. Create the pizza_types table (No Foreign Keys)
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY, 
    name VARCHAR(100),                      
    category VARCHAR(50),                   
    ingredients TEXT                        
);
describe pizza_types;
-- 2. Create the pizzas table (FK to pizza_types)
CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,   
    pizza_type_id VARCHAR(50) REFERENCES pizza_types(pizza_type_id),
    size VARCHAR(10),                   
    price NUMERIC(5, 2)                 
);
desc pizzas;
-- 3. Create the orders table (No Foreign Keys)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    date DATE,
    time TIME
);
desc orders;
-- 4. Create the order_details table (FK to orders and pizzas)
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    pizza_id VARCHAR(50) REFERENCES pizzas(pizza_id),
    quantity INT
);
desc order_details;

-- phase 1
-- 2.List all unique pizza categories (DISTINCT).
SELECT DISTINCT CATEGORY FROM PIZZA_TYPES;

-- 3. Display `pizza_type_id`, `name`, and ingredients, replacing NULL ingredients with `"Missing Data"`. Show first 5 rows.
SELECT PIZZA_TYPE_ID,NAME,COALESCE(INGREDIENTS,'MISSING DATA') FROM PIZZA_TYPES LIMIT 5;

-- 4.Check for pizzas missing a price (IS NULL).
SELECT * FROM PIZZAS WHERE PRICE IS NULL;

-- phase 2
-- 1.Orders placed on '2015-01-01' (SELECT + WHERE).
SELECT * FROM ORDERS WHERE DATE='2015-01-01';

-- 2.List pizzas with price descending.
SELECT * FROM PIZZAS ORDER BY PRICE DESC;

-- 3.Pizzas sold in sizes 'L' or 'XL'.
SELECT PIZZA_TYPE_ID,SIZE FROM PIZZAS WHERE SIZE='L' OR SIZE='XL';

-- 4.Pizzas priced between $15.00 and $17.00.
SELECT PRICE FROM PIZZAS WHERE PRICE BETWEEN 15 AND 17;

-- 5.Pizzas with "Chicken" in the name.
SELECT NAME FROM PIZZA_TYPES WHERE NAME LIKE '%CHICKEN%'; 

-- 6.Orders on '2015-02-15' or placed after 8 PM.
SELECT * FROM orders WHERE date = '2015-02-15' OR HOUR(time) >= 20;

-- phase 3
-- 1.Total quantity of pizzas sold (SUM).
SELECT SUM(QUANTITY) AS TOTAL_PIZZAS_SOLD FROM ORDER_DETAILS;

-- 2.Average pizza price (AVG).
SELECT AVG(PRICE) AS AVERAGE_PIZZA_PRICE FROM PIZZAS;

-- 3.Total order value per order (JOIN, SUM, GROUP BY).
SELECT OD.ORDER_ID,
SUM(P.PRICE * OD.QUANTITY) AS TOTAL_VALUE
FROM ORDER_DETAILS OD
JOIN PIZZAS P ON OD.PIZZA_ID = P.PIZZA_ID
GROUP BY OD.ORDER_ID;

-- 4.Total quantity sold per pizza category (JOIN, GROUP BY).
SELECT CATEGORY, SUM(QUANTITY) AS TOTAL
FROM ORDER_DETAILS OD
JOIN PIZZAS P ON OD.PIZZA_ID = P.PIZZA_ID
JOIN PIZZA_TYPES PT ON P.PIZZA_TYPE_ID = PT.PIZZA_TYPE_ID
GROUP BY CATEGORY;

-- 5.Categories with more than 5,000 pizzas sold (HAVING).
SELECT CATEGORY, SUM(QUANTITY) AS TOTAL
FROM ORDER_DETAILS OD
JOIN PIZZAS P ON OD.PIZZA_ID = P.PIZZA_ID
JOIN PIZZA_TYPES PT ON P.PIZZA_TYPE_ID = PT.PIZZA_TYPE_ID
GROUP BY CATEGORY
HAVING SUM(QUANTITY) > 5000;

-- 6.Pizzas never ordered (LEFT/RIGHT JOIN).
SELECT P.PIZZA_ID, P.PIZZA_TYPE_ID, P.SIZE, P.PRICE
FROM PIZZAS P
LEFT JOIN ORDER_DETAILS OD ON P.PIZZA_ID = OD.PIZZA_ID
WHERE OD.PIZZA_ID IS NULL;

-- 7.Price differences between different sizes of the same pizza (SELF JOIN).
SELECT P1.PIZZA_TYPE_ID,P1.SIZE AS SIZE_1,P1.PRICE AS PRICE_1,
P2.SIZE AS SIZE_2,P2.PRICE AS PRICE_2,ABS(P2.PRICE - P1.PRICE) AS PRICE_DIFF
FROM PIZZAS P1
JOIN PIZZAS P2 ON P1.PIZZA_TYPE_ID = P2.PIZZA_TYPE_ID
AND P1.SIZE < P2.SIZE;



