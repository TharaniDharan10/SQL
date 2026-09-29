USE SalesDB

--Find lowest and highest sales across all orders and highest sales for each product, additionally provide orderID, and orderDate
SELECT 
	OrderID,
	ProductID,
	Sales,
	MAX(Sales) OVER() AS [Sales Max],
	MIN(Sales) OVER() AS [Sales Min],
	MAX(Sales) OVER(PARTITION BY ProductID) AS [Sales Max By Product],
	MIN(Sales) OVER(PARTITION BY ProductID) AS [Sales Min By Product]
FROM Sales.Orders


--Show the employees who have highest salary
SELECT * FROM(
SELECT 
	*,
	MAX(Salary) OVER() AS [Salary Max]
FROM Sales.Employees
) t WHERE Salary = [Salary Max]


--Calculate the deviation of each sales from both minimum and maximum sales amount
SELECT 
	OrderID,
	ProductID,
	Sales,
	MIN(Sales) OVER() AS [MIN Sales],
	MAX(Sales) OVER() AS [MAX Sales],
	Sales - MIN(Sales) OVER() AS [Deviation of sales from MIN Sales],
	MAX(Sales) OVER() - Sales AS [Deviation of sales from MAX Sales]
FROM Sales.Orders