use SalesDB

--Using SalesDB, Retrive list of all orders along with the related customer, product and employee details. For each order, display:
--Order ID, Customer's name, Product name, sales, Price, Sales Person's name
SELECT 
	o.OrderID,
	CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
	p.Product,
	o.Sales, 
	p.Price,
	CONCAT(e.FirstName, ' ', e.LastName) AS Sales_Person

	

FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c 
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID
