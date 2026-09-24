use SalesDB

--Combine the data from employees and customers into one table without duplicates
--Note: The column names are determined by 1st table alone in Union. So if we want to make some column name, make alias on 1st table alone
SELECT 
	CustomerID AS ID,
	FirstName, 
	LastName 
FROM Sales.Customers
UNION
SELECT 
	EmployeeID,
	FirstName, 
	LastName 
FROM Sales.Employees

--Combine the data from employees and customers into one table including duplicates
SELECT 
	CustomerID AS ID,
	FirstName, 
	LastName 
FROM Sales.Customers
UNION ALL
SELECT 
	EmployeeID,
	FirstName, 
	LastName 
FROM Sales.Employees

--Find employees who are not customers at the same time
SELECT 
	EmployeeID AS ID,
	FirstName, 
	LastName 
FROM Sales.Employees 
EXCEPT
SELECT 
	CustomerID,
	FirstName, 
	LastName 
FROM Sales.Customers 



--Find employees who are also customers at the same time
SELECT 
	FirstName, 
	LastName 
FROM Sales.Employees 
INTERSECT
SELECT 
	FirstName, 
	LastName 
FROM Sales.Customers 

--Orders are stored in separate tables(Orders, OrdersArchive). Combine all orders into one report without duplicates
SELECT * FROM Sales.Orders
UNION
SELECT * FROM Sales.OrdersArchive
--Note: Best practice: Use column names instead of * bcoz, later when we change something on source table level like changing order of columns, added new column or something. It can be found out in this case when we add column names insetad of *
SELECT 
	'Orders' AS Source_Table,
	[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT
	'OrdersArchive' AS Source_Table,
	[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID
