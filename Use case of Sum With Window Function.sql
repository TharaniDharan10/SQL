USE SalesDB

--3 Use Cases of Sum


--Find total sales across all orders and total sales for each product. additionally provide details about OrderID and OrderDate
--Use Case 1> Quick summary or snapshot of entire dataset
--Use Case 2> Group wise analysis to underdstand patterns within different categories
SELECT 
	OrderID, 
	OrderDate,
	ProductID, 
	Sales,
	SUM(Sales) OVER () AS [Total Sales],
	SUM(Sales) OVER(PARTITION BY ProductID) AS [Total sales by Product]
FROM Sales.Orders


--Find % contribution of each product sales to Total sales
--Use Case 3> shows the contribution of each data point to overall dataset
SELECT 
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER() AS [Total sales],
	--We convert it to float as both sales and sum(sales) are int and we need atleast one to be float to get a value. We round it to 2 to get formatted outptu
	ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100, 2) AS [% Contribution]
FROM Sales.Orders
