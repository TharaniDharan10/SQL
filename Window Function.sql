USE MyDatabase

--Aggregation functions
SELECT 
	COUNT(*) AS Count,
	SUM(sales) AS SUM,
	AVG(sales) AS Avg,
	MAX(sales) AS Max,
	MIN(sales) AS Min
FROM Orders

USE SalesDB
--Find Total sales for all products
SELECT SUM(sales) FROM Sales.Orders


--Find Total sales for each product
SELECT 
	ProductID,
	SUM(sales) 
FROM Sales.Orders
GROUP BY ProductID


--Find Total sales across all orders. Additionally provide details of OrderId and Order Date
SELECT 
	OrderID,
	OrderDate,
	SUM(sales) OVER() AS TotalSales
FROM Sales.Orders


--Find Total sales for each product. Additionally provide details of OrderId and Order Date
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	SUM(sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders

--Find Total sales across all orders as well as across each product. Additionally provide details of OrderId and Order Date
SELECT 
	OrderID,
	ProductID,
	Sales,
	OrderDate,
	SUM(sales) OVER() AS TotalSales,
	SUM(sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders

--Find the total sales for combination of each product and order status
SELECT 
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS TotalSalesByProductIDAndStatus
FROM Sales.Orders

--Rank each order based on their sales from highest to lowest. Additionally provide details such as Order Id and Order Date
SELECT 
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS RANK
FROM Sales.Orders

--Frames
SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS [Curr & 2 Following]
FROM Sales.Orders


SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS [2 Preceding & Curr]
FROM Sales.Orders



SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS 2 PRECEDING) AS [2 Preceding & Curr shortcut]
FROM Sales.Orders



SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
--Note: Shortcut works only for preceding, not for following
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS UNBOUNDED PRECEDING) AS [Curr & Unbounded Preceding shortcut]FROM Sales.Orders



SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) AS [1 Preceding and Unbounded Following]
FROM Sales.Orders
--Note: ORDER BY inside OVER() controls the window/frame calculation order and does not necessarily sort the final output, while the outer ORDER BY controls the display order.
ORDER BY OrderStatus, OrderDate


SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Unbounded Preceding and Unbounded Following]
FROM Sales.Orders

	
