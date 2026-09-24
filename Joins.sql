--JOINS

--(No join)
--retrive data from customers and orders in 2 different results
SELECT * FROM customers;
SELECT * FROM orders;

--(Inner join)
--Customers along with their orders, but only for customers who have placed their orders
--Note: The order we place tables in inner join doesn't matter
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

--(Left join)
--Customers along with their orders, including those without orders
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

--(Right join)
--Customers along with their orders, including orders without matching customers
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
--Same using Left Join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id


--(FUll join)
--Get all customers and all orders even if there is no match
--Note: The order we place tables in Full join doesn't matter
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id

--(Left Anti join)
--Get all customers who haven't placed any order
--Note: '=' NULL wil not work. Only IS NULL will work
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

--(Right Anti join)
--Get all orders without matching customers
--Note: '=' NULL wil not work. Only IS NULL will work
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL
--Same results using Left Join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL


--(Full Anti join)
--Get all orders not placed by customers and get all customers who didnot place any order
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM orders AS o
FULL JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL

--Get all customers along with their orders, but only for customers who have placed their order without using Inner Join
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM orders AS o
FULL JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NOT NULL AND o.customer_id IS NOT NULL


--Generate all possible combination of customers with orders
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales 
FROM customers AS c
CROSS JOIN orders AS o




