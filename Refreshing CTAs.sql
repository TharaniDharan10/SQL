USE SalesDB

--How to refresh CTAs
--We used T-SQL to write programming in order to drop table to recreate it inorder to get fresh data.'U' specifies the object type: User-defined Table
IF OBJECT_ID('Sales.MonthlyOrders' , 'U') IS NOT NULL
		DROP TABLE Sales.MonthlyOrders;
GO

SELECT
	DATENAME(MONTH, OrderDate) AS [OrderMonth],
	COUNT(OrderID) AS [Count of Orders]
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)

--To see whats inside CTAs table
SELECT * FROM Sales.MonthlyOrders

