/*
================================================================================
MULTIPLE STATEMENTS IN A STORED PROCEDURE
================================================================================
- NOT limited to SELECT:
  A stored procedure is not just for viewing data. You can run any valid SQL 
  statement inside it, such as inserting records, updating tables, deleting rows, 
  or creating temporary staging tables.

- Sequence Execution:
  All statements run in top-to-bottom order within a single call from your 
  application or tool, reducing network traffic and keeping related logic together.

- Multiple Result Sets:
  When a procedure contains more than one SELECT query, SQL Server outputs 
  each one as a separate table (result set) in the order they were executed.
================================================================================
*/


CREATE PROCEDURE SP_MultipleQuery_Customer_Summary_Based_On_Country @Country NVARCHAR(50) = 'USA' AS
BEGIN

--For a Country based Customers, find the total number of customers and the average score, keeping USA as a default country if not mentione
SELECT 
	COUNT(CustomerID) AS [Total Customers],
	AVG(Score) AS [Avg Score]
FROM Sales.Customers
WHERE Country = @Country;

--Find total no of orders and sales WHERE Country = 'USA'
SELECT
	COUNT(OrderID) AS [Total Orders],
	SUM(Sales) AS [Total Sales]
FROM Sales.Orders o 
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;

END

--Here we are mwntioning Germany, thus overriding default country value 'USA'
EXEC SP_MultipleQuery_Customer_Summary_Based_On_Country @Country = 'Germany'

--Here it used Defasult value 'USA'
EXEC SP_MultipleQuery_Customer_Summary_Based_On_Country