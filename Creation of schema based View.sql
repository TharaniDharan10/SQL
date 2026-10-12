--Creating view under Sales Schema
CREATE VIEW Sales.V_Monthly_Summary AS(
	SELECT
		MONTH(OrderDate) AS [Month],
		SUM(Sales) AS [Sales],
		COUNT(OrderID) AS [CountOfOrders],
		SUM(Quantity) AS [TotalQuantity]
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)


