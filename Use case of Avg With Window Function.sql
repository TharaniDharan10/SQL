USE SalesDB

-- Use Cases of Avg


--Find average sales across all orders and avg sales for each product. Additionally provide details for order id and order date
--Use Case 1> Quick summary or snapshot of entire dataset
--Use Case 2> Group wise analysis to underdstand patterns within different categories
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() AS [Avg Sales],
	AVG(Sales) OVER(PARTITION BY ProductID) AS [Avg Sales by Product]
FROM Sales.Orders


--Find avg scores of customers, additionally provide CustomerID and LastName
--Use Case 3> Handling null while performing avg
SELECT 
	CustomerID,
	LastName AS [LastName without coalesce],
	COALESCE(LastName, '') AS [LastName with coalesce],
	Score AS [Score Without Coaleasce],
	COALESCE(Score,0) AS [Score With Coalesce],
	AVG(Score) OVER() AS [Avg Score Without Coalesce],
	AVG(COALESCE(Score,0)) OVER() AS [Avg Score With Coalesce]
FROM Sales.Customers


--Find all orders where sales are higher than the avg sales across all orders
--Use Case 4> Helps to evaluate whether a value is above or below the average
--Note: We cannot use Window function in where clause like 
/* SELECT 
	OrderID,
	Sales,
	AVG(Sales) OVER() AS [AvgSales]
FROM Sales.Orders
WHERE Sales > AVG(Sales) OVER()
*/
SELECT 
	*
FROM(
SELECT 
	OrderID,
	Sales,
	AVG(Sales) OVER() AS [AvgSales]
FROM Sales.Orders
) t 
WHERE Sales > AvgSales
 
