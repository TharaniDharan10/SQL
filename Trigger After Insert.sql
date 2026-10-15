/*
================================================================================
DML AFTER TRIGGERS: INSERT, UPDATE, AND DELETE AUDIT SYSTEM
================================================================================
How SQL Server Special Tables Work:
  1. INSERT:
     - Populates 'INSERTED' table with the brand-new incoming records.
     - 'DELETED' table remains empty.

  2. UPDATE:
     - SQL Server handles an UPDATE as a DELETE followed by an INSERT.
     - 'DELETED'  holds the original data prior to the modification.
     - 'INSERTED' holds the new replaced values.
     - You join INSERTED and DELETED on Primary Key to compare Old vs. New values.

  3. DELETE:
     - Populates 'DELETED' table with the records being removed.
     - 'INSERTED' table remains empty.

Note:
  - Both INSERTED and DELETED are set-based pseudo-tables. If a query modifies 
    multiple rows at once, these tables contain ALL affected rows.
================================================================================
*/


-- =============================================================================
-- 1. AFTER INSERT TRIGGER
-- Fires automatically after new row(s) are added to Sales.Employees
-- =============================================================================


CREATE TRIGGER TRG_After_Insert_Employee ON Sales.Employees
AFTER INSERT
AS 
BEGIN
	-- 'INSERTED' holds the newly inserted employee record(s)
	INSERT INTO EmployeeLogs(EmployeeID, LogMessage, LogDate)
	SELECT 
		EmployeeID, 
		'New Employee Added: ' + CAST(EmployeeID AS NVARCHAR),
		GETDATE()
	FROM INSERTED
END


-- 1. Check existing state of tables
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;

-- 2. Triggering action: Insert a new employee record
-- This automatically fires TRG_After_Insert_Employee in the background
INSERT INTO Sales.Employees 
VALUES (6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);

-- 3. Verify: Employee row added AND audit entry created in EmployeeLogs
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;