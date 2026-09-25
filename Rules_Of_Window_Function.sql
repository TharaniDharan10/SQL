USE SalesDB
	
--Window Function Rules
--Rule 1: Windows Function can be used only in Select and Order By Statement, meaning, it cannot be used to filter data
SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSales
FROM Sales.Orders
ORDER BY SUM(Sales) OVER(PARTITION BY OrderStatus) DESC
/* It cannot be used to filter data
WHERE SUM(Sales) OVER(PARTITION BY OrderStatus) > 100 
GROUP BY SUM(Sales) OVER(PARTITION BY OrderStatus) 
*/


--Rule 2: Nesting of Window function is not allowed
/* SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(SUM(Sales) OVER(PARTITION BY OrderStatus)) OVER(PARTITION BY OrderStatus) AS TotalSales
FROM Sales.Orders
*/



--Rule 3: SQL Executes Window Function after WHERE clause
 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	PRODUCTID,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSales
FROM Sales.Orders
--Compare each other to find the difference
 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	PRODUCTID,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSales
FROM Sales.Orders
WHERE ProductID IN (101, 102)

--Rule 4: Window Function can be used together with GROUP BY in the same query, only if same columns are used
--Rank customers based on their total sales
--This is wrong, because if we see, GROUP BY already grouped the data by Customer ID, so Partitioning again by CustomerID makes no sense
SELECT 
	CustomerID,
	SUM(Sales) AS [TotalSales],
	RANK() OVER(PARTITION BY CustomerID ORDER BY SUM(Sales) DESC) AS [Rank based onn TotalSales]
FROM Sales.Orders
GROUP BY (CustomerID)
--Right one
--If we see, we used SUM(Sales) in both GROUP BY and inside Window Function
SELECT 
	CustomerID,
	SUM(Sales) AS [TotalSales],
	RANK() OVER(ORDER BY SUM(Sales) DESC) AS [Rank Based on TotalSales]
FROM Sales.Orders
GROUP BY (CustomerID)
--If we see, we used CustomerID in both GROUP BY and inside Window Function
SELECT 
	CustomerID,
	SUM(Sales) AS [TotalSales],
	RANK() OVER(ORDER BY CustomerID DESC) AS [Rank Based on CustomerID]
FROM Sales.Orders
GROUP BY (CustomerID)
