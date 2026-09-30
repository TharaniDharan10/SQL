USE SalesDB

--Calculate moving average of sales for each product over time
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) AS [Avg Sales For Product Over time]
FROM Sales.Orders


--Calculate moving average of sales for each product over time, including only the next order 
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS [Avg Sales For Product Over time with 1 Following]
FROM Sales.Orders