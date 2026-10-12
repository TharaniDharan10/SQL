USE SalesDB;

--How to modify a view?
--Method 1> Drop the view, then recreate one with same name
DROP VIEW Sales.V_View1

CREATE VIEW Sales.V_View1 AS(
	SELECT
		MONTH(OrderDate) AS [Month],
		SUM(Sales) AS [Sales],
		COUNT(OrderID) AS [CountOfOrders],
		SUM(Quantity) AS [TotalQuantity]
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)

--Method 2> Use T-SQL(Adds Programming feature)
--'V' for view
IF OBJECT_ID('Sales.V_View1', 'V') IS NOT NULL
	DROP VIEW Sales.V_View1
GO

CREATE VIEW Sales.V_View1 AS(
--Make modification logic here
	SELECT
		MONTH(OrderDate) AS [Month],
		SUM(Sales) AS [Sales],
		COUNT(OrderID) AS [CountOfOrders],
		SUM(Quantity) AS [TotalQuantity]
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)
