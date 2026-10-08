USE SalesDB


/*
================================================================================
SQL SUBQUERY CHEAT SHEET & KEY OBSERVATIONS
================================================================================
1. PLACEMENT & USAGE:
   - FROM: Acts as a derived table (always requires an alias).
   - SELECT: Must be a scalar subquery (returns exactly 1 row & 1 column).
   - JOIN: Pre-aggregates or filters dataset before joining.
   - WHERE: Filters rows using operators:
       • Comparison (=, >, <): Needs a scalar subquery.
       • Multi-Row (IN, NOT IN, ANY, ALL): Evaluates against a list of values.

2. SUBQUERY TYPES:
   - Non-Correlated: Executes once independently of the outer query.
   - Correlated: Evaluates row-by-row; references columns from the outer query.

3. EXISTENCE CHECKS:
   - EXISTS / NOT EXISTS: Evaluates presence without returning full datasets;
     typically faster than IN/NOT IN and handles NULL values safely.
================================================================================
*/



--1> Subquery in FROM Clause:
--Find the products that have a price higher than the average price of all products
SELECT * FROM Sales.Products
SELECT
	ProductID,
	Price
FROM (
SELECT
	ProductID,
	Price,
	AVG(Price) OVER() AS [Avg Price]
FROM Sales.Products
) AS t
WHERE Price > [Avg Price]


--Rank customers based on total amount of sales
SELECT 
	*,
	RANK() OVER(ORDER BY [Sum Sales] DESC) AS [Rank Based on Total Sales]
FROM(
SELECT 
	CustomerID,
	SUM(Sales) AS [Sum Sales]
FROM Sales.Orders
GROUP BY CustomerID
) t


--2> Subquery in SELECT Clause:
/*
Note: Only scaler subqueries are allowed to be used. Thats why we use aggregations, as they produce only one value. If you want to find the difference, in subquery, instead of Count(*), use OrderID. We will see
the following message : 'Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <= , >, >= or when the subquery is used as an expression.' 
*/
--Show the productID, name, price, total no of orders
SELECT 
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) AS [Total Orders]
FROM Sales.Products 


--3> Subquery in JOIN Clause:
--Show all customer details and find the total orders for each customer
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders

SELECT 
	c.*,
	o.TotalOrders
FROM Sales.Customers c
LEFT JOIN (
	SELECT 
	CustomerID,
	COUNT(*) AS TotalOrders
	FROM Sales.Orders 
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID


--4.1> Subquery in WHERE Clause(Comparison Operator):
--Find the products that have a price higher than the avg price of all products
SELECT *
FROM Sales.Products 
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)


--4.2> Subquery in WHERE Clause(Logical Operator):
--Show the details of orders made by customers in Germany
SELECT 
	*
FROM Sales.Orders
--here we used IN instead of = as it returns more than 1 value i.e 2
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany') 



--Show the details of orders for customers who are not from Germany
SELECT 
	*
FROM Sales.Orders
--here we used IN instead of = as it returns more than 1 value i.e 2
WHERE CustomerID NOT IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany') 
--OR
SELECT 
	*
FROM Sales.Orders
--here we used IN instead of = as it returns more than 1 value i.e 2
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country != 'Germany') 




--Find female employees whose salaries are greater than salaries of any male employees
SELECT * FROM Sales.Employees
--ANY checks if the value matches with atleast one of the following
WHERE Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M') AND Gender = 'F'




--Find female employees whose salaries are greater than salaries of all male employees
SELECT * FROM Sales.Employees
--ALL checks if the value matches with all values within a list
WHERE Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M') AND Gender = 'F'



--Showing diff btn Non Corelated and corelated subquery

--Show all customer details and find total orders of each customer
--Non Corelated Subquery: Here subquery in not dependent on main query 
SELECT
	c.*,
	o.Total
FROM Sales.Customers c
LEFT JOIN (
	SELECT 
	CustomerID, 
	COUNT(*) AS Total 
	FROM Sales.Orders 
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID
--Corelated Subquery: Here subquery is dependent on main query for each iteration of rows
SELECT
	c.*,
	(SELECT  
	COUNT(*)  
	FROM Sales.Orders o
	WHERE c.CustomerID = o.CustomerID) AS [Total]
FROM Sales.Customers c
	


--EXISTS Logical Operator(Corelated Subquery): Checking existance of rows from one table to another table. Here results of Main query is passed to subquery
--Show the details of orders made by customers in Germany
SELECT 
	*
FROM Sales.Orders o
--We can use any column name in this subquery as it is just used for reference. We can also use *, 1, 2, 3 etc
WHERE EXISTS (SELECT 1 FROM Sales.Customers c WHERE Country = 'Germany' AND o.CustomerID = c.CustomerID)

--Show the details of orders made by customers not in Germany
SELECT 
	*
FROM Sales.Orders o
WHERE NOT EXISTS (SELECT CustomerID FROM Sales.Customers c WHERE Country = 'Germany' AND o.CustomerID = c.CustomerID)