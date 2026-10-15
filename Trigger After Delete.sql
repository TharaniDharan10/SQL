-- =============================================================================
-- 3. AFTER DELETE TRIGGER
-- Fires automatically when row(s) are deleted from Sales.Employees
-- =============================================================================
CREATE TRIGGER Sales.TRG_After_Delete_Employee 
ON Sales.Employees
AFTER DELETE
AS 
BEGIN
    -- 'DELETED' holds the removed employee record(s)
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        EmployeeID, 
        'Employee Deleted: ' + CAST(EmployeeID AS NVARCHAR(20)) 
        + ' (' + FirstName + ' ' + LastName + ')',
        GETDATE()
    FROM DELETED;
END

-- =============================================================================
-- VERIFICATION & TESTING WORKFLOW
-- =============================================================================

-- View starting state
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;

-- DELETE Action (Fires TRG_After_Delete_Employee)
DELETE FROM Sales.Employees
WHERE EmployeeID = 6;

-- Verify final audit trail
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;