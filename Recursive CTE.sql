USE SalesDB;

/*
================================================================================
RECURSIVE CTE: OPTION (MAXRECURSION) EXPLANATION & RULES
================================================================================

1. DEFAULT LIMIT (100):
   - SQL Server sets a default safety limit of 100 recursions to prevent runaway loops.
   - If recursion exceeds 100 steps (e.g., generating numbers past 101, such as
     WHERE MyNumber < 200), SQL Server throws an error:
     "Msg 530: The statement terminated. The maximum recursion 100 has been exhausted..."

2. EXTENDING THE LIMIT:
   - Use the query hint: OPTION (MAXRECURSION n)
   - Value range for 'n' is 0 to 32,767.
   - Example: To generate numbers up to 200, use OPTION (MAXRECURSION 200) or higher.

3. REMOVING THE LIMIT COMPLETELY (0):
   - Setting OPTION (MAXRECURSION 0) means UNLIMITED recursion.
   - Warning: Use with caution. If your termination logic (WHERE condition) is flawed,
     the query can loop infinitely and exhaust server resources.

4. QUERY HINT PLACEMENT:
   - OPTION (MAXRECURSION n) must always be placed at the very end of the final
     SELECT statement that consumes the CTE, NOT inside the CTE definition itself.
================================================================================
*/


-- 1. Number Generation: Basic sequence (1 to 20)
WITH SERIES AS (
    -- Anchor Member: Starting base value
    SELECT 1 AS MyNumber
    UNION ALL
    -- Recursive Member: Self-referencing until termination condition met
    SELECT 
        MyNumber + 1
    FROM Series
    WHERE MyNumber < 20 -- Termination Condition
)
-- Main Query
SELECT * FROM SERIES;


-- 2. Number Generation: Exceeding default limit (> 100) using OPTION (MAXRECURSION)
WITH SERIES AS (
    SELECT 1 AS MyNumber
    UNION ALL
    SELECT 
        MyNumber + 1
    FROM Series
    WHERE MyNumber < 180
)
SELECT * FROM SERIES
OPTION (MAXRECURSION 200);


/*
================================================================================
ORGANIZATIONAL HIERARCHY / GRAPH TRAVERSAL PATTERN
================================================================================
- Anchor Member:
  Identifies the root level (e.g., CEO/Top Manager where ManagerID IS NULL).
  Initializes the hierarchy depth (e.g., Level = 1).

- Recursive Member:
  Joins the underlying table back to the CTE itself (e.g., e.ManagerID = eh.EmployeeID)
  to step down the organizational tree one tier at a time.
  Increments the counter: Level + 1.

- Automatic Termination:
  Recursion stops naturally when the INNER JOIN produces no new matching child rows
  (leaf nodes / individual contributors with no direct reports).
================================================================================
*/

-- 3. Employee Hierarchy Traversal
WITH CTE_Emp_Hierarchy AS (
    -- Anchor Member: Top of the hierarchy (CEO / Root level)
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive Member: Subordinates linked to their parent tier
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.ManagerID,
        eh.Level + 1 AS Level
    FROM Sales.Employees e
    INNER JOIN CTE_Emp_Hierarchy eh
        ON e.ManagerID = eh.EmployeeID
)
-- Main Query: Sort by hierarchy level to display reporting tiers clearly
SELECT * 
FROM CTE_Emp_Hierarchy
ORDER BY Level, ManagerID;