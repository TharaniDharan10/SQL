-- Find the average score for each country considering only customers whose score is not equal to 0 and return only those countries whose avg score is > 430 

SELECT country, AVG(score) AS avg_score FROM customers WHERE score != 0
GROUP BY country HAVING AVG(score) > 430



SELECT DISTINCT country from customers

--select top 3 customers with highest scores 
SELECT TOP 3 * from customers ORDER BY score DESC

--Retrieve lowest 2 customers based on scores 
SELECT TOP 2 * FROM customers ORDER BY score ASC

--Retrieve 2 most recent orders
SELECT TOP 2 * from orders ORDER BY order_date DESC

--Static value from user
SELECT id, first_name, 'Static_value' AS static_column FROM customers