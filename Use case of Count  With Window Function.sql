USE SalesDB

--4 Use Cases of Count

--Find totoal no of orders
SELECT 
COUNT(*) AS TotalOrders
FROM Sales.Orders



--Find totoal no of orders. Additionally provide details about order id and order date
--Use Case 1> Overall Analysis
SELECT
	OrderID,
	OrderDate,
COUNT(*) OVER() AS TotalOrders
FROM Sales.Orders



--Find total no of orders. Additionally provide details about order id and order date. Find total no of orders for each customers
--Use Case 2> Category Analysis
SELECT 
	OrderID,
	OrderDate,
	CustomerID,
COUNT(*) OVER() AS TotalOrders,
COUNT(OrderID) OVER(PARTITION BY CustomerID) AS [Total Order For Each Customer]
FROM Sales.Orders

--Find total no of customers. Additionally provide details about customers
SELECT 
	*,
	COUNT(CustomerID) OVER() AS Total_Customers
FROM Sales.Customers


--Find total no of customers. Find total no of scores for customers. Additionally provide details about customers
--Use Case 3> Identify Nulls
SELECT 
	*,
	COUNT(CustomerID) OVER() AS Total_Customers,
	COUNT(Score) OVER() AS Customer_Scores
FROM Sales.Customers

SELECT * FROM Sales.Customers

--Check whether the table 'OrdersArchieve' contains any duplicate rows
--Use Case 4> Identify Duplicates
SELECT
	OrderID,
	[Count of OrderID]
	FROM
(SELECT 
	OrderID,
	COUNT(OrderID) OVER(PARTITION BY OrderID) AS [Count of OrderID]
FROM Sales.OrdersArchive) t WHERE [Count of OrderID] > 1


