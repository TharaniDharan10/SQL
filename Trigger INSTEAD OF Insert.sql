/*
================================================================================
DML INSTEAD OF TRIGGERS: INSERT, UPDATE, AND DELETE
================================================================================
How INSTEAD OF Triggers Work:
  1. Interception:
     - The trigger intercepts the issued DML operation BEFORE it touches the table.
     - The original INSERT, UPDATE, or DELETE statement is completely bypassed.
     - Whatever custom SQL logic is written inside the trigger body executes INSTEAD.

  2. Virtual Tables in INSTEAD OF Triggers:
     - Just like AFTER triggers, SQL Server populates the virtual memory tables:
       * INSERT: 'INSERTED' contains the values the user attempted to insert.
       * DELETE: 'DELETED' contains the rows targeted for deletion.
       * UPDATE: 'DELETED' contains pre-modification rows; 'INSERTED' contains new values.

  3. Primary Real-World Use Cases:
     - Soft Deletion: Intercepting a physical DELETE statement to toggle an 
       'IsActive = 0' flag instead of permanently dropping the record.
     - Updatable Views: Allowing users to insert/update multi-table join views 
       by breaking up the operation across the underlying physical base tables.
     - Custom Business Validation / Data Cleansing: Modifying or formatting data 
       before it physically commits to disk.
================================================================================
*/


-- =============================================================================
-- 1. INSTEAD OF INSERT TRIGGER (Data Validation & Default Enrichment)
-- Intercepts raw inserts to enforce salary bounds or clean up inputs before saving
-- =============================================================================
CREATE OR ALTER TRIGGER Sales.TRG_InsteadOf_Insert_Employee
ON Sales.Employees
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Block invalid inserts (e.g., negative or zero salary)
    IF EXISTS (SELECT 1 FROM INSERTED WHERE Salary <= 0)
    BEGIN
        -- 16 is the standard Severity level for user-correctable errors (triggers CATCH blocks), and 1 is the State code identifying the error occurrence.
        RAISERROR('Insert aborted: Salary must be greater than 0.', 16, 1);
        RETURN;
    END;

    -- Manually perform the physical INSERT using the sanitized/validated rows from INSERTED
    INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID)
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        ISNULL(Department, 'General'), -- Enrich default if missing
        BirthDate,
        Gender,
        Salary,
        ManagerID
    FROM INSERTED;

    -- Log the intercepted and allowed action
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        EmployeeID, 
        'Employee Inserted via INSTEAD OF: ' + CAST(EmployeeID AS NVARCHAR(20)),
        GETDATE()
    FROM INSERTED;
END

-- =============================================================================
-- VERIFICATION & TESTING WORKFLOW
-- =============================================================================

-- View starting state
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;

-- Test 1: INSTEAD OF INSERT (Successful insertion with log)
INSERT INTO Sales.Employees 
VALUES (7, 'Carlos', 'Ray', 'IT', '1992-04-10', 'M', 0, 3);

-- Verify: Employee 7 still exists physically because INSTEAD OF DELETE intercepted it!
SELECT * FROM Sales.Employees WHERE EmployeeID = 7;
SELECT * FROM Sales.EmployeeLogs ORDER BY LogDate ASC;