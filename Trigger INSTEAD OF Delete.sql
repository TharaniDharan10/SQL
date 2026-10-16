-- =============================================================================
-- 3. INSTEAD OF DELETE TRIGGER (Soft Delete Pattern)
-- Never physically deletes the row from disk; marks an audit trail or archival status
-- =============================================================================
CREATE OR ALTER TRIGGER Sales.TRG_InsteadOf_Delete_Employee
ON Sales.Employees
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Instead of deleting from Sales.Employees, record the cancellation in the log
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        EmployeeID, 
        'Intercepted DELETE: Employee marked inactive, record retained. (ID: ' 
        + CAST(EmployeeID AS NVARCHAR(20)) + ')',
        GETDATE()
    FROM DELETED;

    -- Note: If the table had an 'IsActive' or 'Status' column, you would run:
    -- UPDATE e SET IsActive = 0 FROM Sales.Employees e INNER JOIN DELETED d ON e.EmployeeID = d.EmployeeID;
END


-- View starting state
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;


-- Test 3: INSTEAD OF DELETE (Intercepted: row is preserved, not dropped from disk)
DELETE FROM Sales.Employees
WHERE EmployeeID = 7;

-- Verify: Employee 7 still exists physically because INSTEAD OF DELETE intercepted it!
SELECT * FROM Sales.Employees WHERE EmployeeID = 7;
SELECT * FROM Sales.EmployeeLogs ORDER BY LogDate ASC;