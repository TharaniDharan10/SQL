USE SalesDB;


/*
================================================================================
COMMON TABLE EXPRESSION (CTE) RULES & BEST PRACTICES SUMMARY
================================================================================

1. PRECEDING TERMINATION:
   - Always terminate the statement immediately before a CTE with a semicolon (;)
     or start the CTE with ';WITH' to prevent syntax errors (Msg 319).

2. DEFINING MULTIPLE CTEs:
   - Use the 'WITH' keyword ONLY ONCE at the start of the first CTE.
   - Separate every subsequent CTE with a COMMA (,).
   - DO NOT repeat the 'WITH' keyword for subsequent CTEs.
   - Syntax:
       WITH CTE_1 AS (...),
       CTE_2 AS (...),
       CTE_3 AS (...)

3. DEPENDENCIES (NESTED CTEs):
   - A later CTE can reference any previously declared CTE in the same block.
   - Order matters: a CTE cannot reference another CTE defined after it.

4. SCOPE & LIFECYCLE:
   - CTEs are temporary and exist ONLY for the single immediate statement 
     (SELECT, INSERT, UPDATE, DELETE, or MERGE) that follows them.
   - You cannot run multiple standalone queries off the same CTE block; 
     the first terminating query consumes and clears the CTEs from memory.

5. ORDER BY RESTRICTION:
   - ORDER BY is NOT permitted inside a CTE definition unless paired with 
     TOP, OFFSET, or XML clauses. Place sorting in the final outer query.
================================================================================
*/



--Standalone CTE
--Find the total sales per customer
--Note: Only restriction in CTE is we cannot use ORDER BY within CTE. We can use it in Main query
WITH CTE_Sales_Per_Customer AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--Main Query
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte_1.TotalSales
FROM Sales.Customers c
LEFT JOIN CTE_Sales_Per_Customer cte_1
ON c.CustomerID = cte_1.CustomerID
ORDER BY c.CustomerID;


--Multiple Standalone CTE
--Rule: When we have multiple standalone CTE, we should start the 1st CTE with 'WITH CTE_Sales_Per_Customer AS' and the following CTE should be just started with ',CTE_Last_Order AS 'without WITH
--Step_1: Find the total sales per customer
--Step_2: Find the last order date per customer
WITH CTE_Sales_Per_Customer AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)

, CTE_Last_Order AS(
SELECT 
	CustomerID,
	MAX(OrderDate) AS LastOrder
FROM Sales.Orders
GROUP BY CustomerID
)
--Main Query
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte_1.TotalSales,
	cte_2.LastOrder
FROM Sales.Customers c
LEFT JOIN CTE_Sales_Per_Customer cte_1
ON c.CustomerID = cte_1.CustomerID
LEFT JOIN CTE_Last_Order cte_2
ON c.CustomerID = cte_2.CustomerID
ORDER BY c.CustomerID;





--Nested CTE
--Rule: When we have multiple standalone CTE, we should start the 1st CTE with 'WITH CTE_Sales_Per_Customer AS' and the following CTE should be just started with ',CTE_Last_Order AS 'without WITH
--Step_1: Find the total sales per customer
--Step_2: Find the last order date per customer
--Step_3: Rank Customers based on total sales per customer
--Step_4: Segment customers based on their total sales
--This CTE is completely Standalone, meaning could be executed alone
WITH CTE_Sales_Per_Customer AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)

--This CTE is completely Standalone, meaning could be executed alone
, CTE_Last_Order AS(
SELECT 
	CustomerID,
	MAX(OrderDate) AS LastOrder
FROM Sales.Orders
GROUP BY CustomerID
)

--This CTE is Nested meaning, it cannot execute alone and is dependent on another CTE results
, CTE_Total_Sales_Per_Customer AS(
SELECT
	*,
	RANK() OVER(ORDER BY TotalSales DESC) AS [Rank]
FROM CTE_Sales_Per_Customer
)

, CTE_Segment AS(
SELECT 
	CustomerID,
	CASE WHEN TotalSales > 100 THEN 'High'
		WHEN TotalSales > 50 THEN 'Medium'
		ELSE 'Low'
	END AS Segment
FROM CTE_Sales_Per_Customer
)
--Main Query
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte_1.TotalSales,
	cte_4.Segment,
	cte_2.LastOrder,
	cte_3.Rank
FROM Sales.Customers c
LEFT JOIN CTE_Sales_Per_Customer cte_1
ON c.CustomerID = cte_1.CustomerID
LEFT JOIN CTE_Last_Order cte_2
ON c.CustomerID = cte_2.CustomerID
LEFT JOIN CTE_Total_Sales_Per_Customer cte_3
ON c.CustomerID = cte_3.CustomerID
LEFT JOIN CTE_Segment cte_4
ON c.CustomerID = cte_4.CustomerID