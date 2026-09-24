USE SalesDB
--Find average of score of the customers

SELECT 
	CustomerID,
	Score,
	AVG(Score) OVER() AS [2500/4 Ignoring null row],
	COALESCE(Score,0)AS [Coalesce],
	AVG(COALESCE(Score,0)) OVER() AS [2500/5 Expected AVG]
FROM Sales.Customers

--Display full name of customers in a single field by merging rtheir 1st and last name and add 10 bonus point to their score
SELECT 
	FirstName,
	LastName,
	FirstName + '' + COALESCE(LastName, '') AS FullName,
	Score AS [Before bonus 10],
	COALESCE(Score,0) + 10 AS [After bonus 10]
FROM Sales.Customers


--Sort the customers from lowest to highest scores with nulls appearing last
--Lazy method
SELECT
	CustomerID,
	Score
FROM Sales.Customers
ORDER BY COALESCE(Score, 999999) ASC	

--Professional method
SELECT
	CustomerID,
	Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score
--This 1st sorts data based on Flag, then by Score

--Find the sales price for each order by dividing the sales by the quantity
SELECT 
	OrderID,
	Quantity,
	Sales,
	Sales / NULLIF(Quantity,0) AS [Price of Each]
FROM Sales.Orders


--Identify the customers who has no scores
SELECT 
	*
FROM Sales.Customers
WHERE Score IS NULL



--Identify the customers who has scores
SELECT 
	*
FROM Sales.Customers
WHERE Score IS NOT NULL


--List details of all customers who have not placed any orders
--Left Anti Join
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders
SELECT 
	c.*,
	o.OrderID
FROM Sales.Customers AS c LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL


--Lets Understand some data policy
WITH Orders AS (
SELECT 1 AS Id, 'A' AS category UNION
SELECT 2 , NULL UNION
SELECT 3, '' UNION
SELECT 4, '  ' 
)
SELECT 
	*,
	DATALENGTH(Category) AS [Category Length],

	--Data Policy 1: Only use null and empty string, but avoid using blank spaces
	DATALENGTH(TRIM(Category)) AS [Policy1],

	--Because SQL Server treats trailing/blank spaces as equivalent to empty strings during comparisons, '' matches ' '. 
	--Therefore, NULLIF evaluates this as a match and returns NULL
	--NULLIF(Category,'') AS [Policy2]

	--Data Policy 2: Only use null and avoid using empty strings and blank spaces
	NULLIF(TRIM(Category),'') AS [Policy2],

	--Data Policy 3: Use the default value 'unknown' and avoid using null, empty string and blank spaces
	COALESCE(NULLIF(TRIM(Category),''), 'unknown') AS [Policy3]
FROM Orders


