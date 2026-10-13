USE SalesDB

--Create a CTAs for Monthly orders
SELECT
	DATENAME(MONTH, OrderDate) AS [OrderMonth],
	COUNT(OrderID) AS [Count of Orders]
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)

--To see whats inside CTAs table
SELECT * FROM Sales.MonthlyOrders

--To drop this table
DROP TABLE Sales.MonthlyOrders



