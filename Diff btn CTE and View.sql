USE SalesDB;


/*
================================================================================
CTE vs. VIEW: KEY DIFFERENCES & WHEN TO USE EACH
================================================================================

1. DEFINITION & PERSISTENCE:
   - CTE (Common Table Expression):
     * A temporary, in-memory named result set defined inline within a script.
     * Ephemeral: Exists ONLY for the single immediate statement that follows it.
     * Not stored as a database object in metadata.
   - VIEW:
     * A permanent, reusable database object stored in metadata (sys.views / INFORMATION_SCHEMA.VIEWS).
     * Accessible across multiple sessions, stored procedures, scripts, and users.
     * Stores only the SQL query definition, not physical data (unless indexed).

2. LIFECYCLE & SCOPE:
   - CTE:
     * Scope: Strictly local to the query.
     * Cannot be reused across separate batches, stored procedures, or reporting tools.
   - VIEW:
     * Scope: Database-wide (subject to schema permissions).
     * Centrally updated: changing the view definition updates it for all downstream consumers.

3. RECURSION:
   - CTE: Supports recursion natively (recursive CTEs for hierarchies/sequences).
   - VIEW: Cannot be recursive on its own.

4. SECURITY & ACCESS CONTROL:
   - CTE: Inherits table permissions directly; cannot restrict column/row access independently.
   - VIEW: Acts as a security layer to expose specific columns/rows while hiding base tables.

5. WHEN TO USE WHICH:
   - Use a CTE: For one-off transformations, breaking down complex multi-step queries,
     window function staging, or recursive hierarchy traversal.
   - Use a VIEW: For standardized reporting logic, shared business metrics (e.g., monthly sales),
     data layer abstraction, and reusable joins across the team.
================================================================================
*/



--if we want to see all schemas, go inside a DB , Security -> Schemas -> here we see

--Find the running total of sales, count of orderid, sum of quantity for each month
--Using CTE
WITH CTE_Monthly_Summary AS(
	SELECT
		MONTH(OrderDate) AS [Month],
		SUM(Sales) AS [Sales],
		COUNT(OrderID) AS [CountOfOrders],
		SUM(Quantity) AS [TotalQuantity]
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)

SELECT 
	[Month],
	[Sales],
	SUM(Sales) OVER(ORDER BY Month) AS [Running Sales]
FROM CTE_Monthly_Summary


--Using Views
SELECT 
	[Month],
	[Sales],
	SUM(Sales) OVER(ORDER BY Month) AS [Running Sales]
FROM V_Monthly_Summary

--From a different view
SELECT
	*
FROM Sales.V_Order_Details