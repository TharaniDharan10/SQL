/*
================================================================================
WORKFLOW: DATA STAGING & TRANSFORMATION VIA TEMPORARY TABLE
================================================================================
Purpose:
  Safely isolate, transform, and export data without affecting production tables.

Process Overview:
  1. Extraction (SELECT INTO #Orders):
     - Pulls a full snapshot of Sales.Orders into a session-scoped Local Temp Table (#Orders)
       located in tempdb. Creates the schema and types on the fly (excluding constraints/indexes).

  2. Transformation (DELETE WHERE OrderStatus = 'Delivered'):
     - Cleans/filters intermediate records in isolation within #Orders, ensuring zero lock 
       contention or risk of unintended data loss on the base table.

  3. Persistence (SELECT INTO Sales.OrdersTest):
     - Materializes the sanitized staging data into a new permanent table (Sales.OrdersTest).
     - Note: Requires dropping Sales.OrdersTest beforehand if it already exists, as SELECT INTO 
       fails if the target table is already present.
================================================================================
*/

SELECT
	* 
INTO #Orders
FROM Sales.Orders

SELECT * FROM #Orders

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

SELECT * FROM #Orders

--Persisting temp tables data into permanent table(CTAs) after transformation
SELECT	
	* 
INTO Sales.OrdersTest
FROM #Orders

SELECT  * FROM Sales.OrdersTest