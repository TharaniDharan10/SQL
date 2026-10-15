-- =============================================================================
-- 2. AFTER UPDATE TRIGGER
-- Fires automatically when existing row(s) are updated in Sales.Employees
-- =============================================================================
CREATE TRIGGER Sales.TRG_After_Update_Employee ON Sales.Employees
AFTER UPDATE
AS 
BEGIN
    -- Compare 'DELETED' (old values) and 'INSERTED' (new values)
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        i.EmployeeID, 
        'Employee Updated: ' + CAST(i.EmployeeID AS NVARCHAR(20)) 
        + ' | Old Salary: ' + CAST(d.Salary AS NVARCHAR(20)) 
        + ' -> New Salary: ' + CAST(i.Salary AS NVARCHAR(20)),
        GETDATE()
    FROM INSERTED i
    INNER JOIN DELETED d 
        ON i.EmployeeID = d.EmployeeID;
END

-- =============================================================================
-- VERIFICATION & TESTING WORKFLOW
-- ============================================================================

-- View starting state
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;

--UPDATE Action (Fires TRG_After_Update_Employee)
UPDATE Sales.Employees
SET Salary = 85000
WHERE EmployeeID = 6;

-- Verify final audit trail
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;