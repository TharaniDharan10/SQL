--Provide a view that combines details from orders, products, customers and employees
CREATE VIEW Sales.V_Order_Details AS(
SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category AS [Product Category],

	CONCAT(c.FirstName, ' ' , c.LastName) AS Customer_Name,
	c.Country AS Customer_Country,
	
	--Another way to concat with null values
	COALESCE(e.FirstName, ' ') + ' ' + COALESCE(e.LastName, ' ') AS Sales_Name,
	e.Department AS Sales_Department,
	o.Quantity,
	o.Sales
FROM Sales.Orders o
LEFT JOIN Sales.Customers c 
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.CustomerID
)