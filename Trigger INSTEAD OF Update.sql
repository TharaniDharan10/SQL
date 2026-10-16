
-- =============================================================================
-- 2. INSTEAD OF UPDATE TRIGGER (Restricting Updates to Locked Fields)
-- Intercepts updates to protect sensitive columns (e.g., prevent modifying BirthDate)
-- =============================================================================
CREATE OR ALTER TRIGGER Sales.TRG_InsteadOf_Update_Employee
ON Sales.Employees
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Intercept and apply updates only to allowed columns (e.g., Department, Salary)
    -- Leaving BirthDate and EmployeeID locked to their original values in the table
    UPDATE e
    SET 
        e.FirstName   = i.FirstName,
        e.LastName    = i.LastName,
        e.Department  = i.Department,
        e.Salary      = i.Salary,
        e.ManagerID   = i.ManagerID
        -- Notice: e.BirthDate is ignored, preventing alterations
    FROM Sales.Employees e
    INNER JOIN INSERTED i 
        ON e.EmployeeID = i.EmployeeID;

    -- Log the intercepted update
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        i.EmployeeID, 
        'Employee Updated via INSTEAD OF Trigger. Old Sal: ' 
        + CAST(d.Salary AS NVARCHAR(20)) + ' -> New Sal: ' + CAST(i.Salary AS NVARCHAR(20)),
        GETDATE()
    FROM INSERTED i
    INNER JOIN DELETED d 
        ON i.EmployeeID = d.EmployeeID;
END


-- View starting state
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeeLogs;


-- Test 2: INSTEAD OF UPDATE (Applies updates through trigger logic)
INSERT INTO Sales.Employees 
VALUES (7, 'Carlos', 'Ray', 'IT', '1992-04-10', 'M', 86000, 3);

UPDATE Sales.Employees
SET 
    Salary = 83000,
    BirthDate  = '2000-04-10'
WHERE EmployeeID = 7;

-- Verify: Employee 7 still exists physically because INSTEAD OF DELETE intercepted it!
SELECT * FROM Sales.Employees WHERE EmployeeID = 7;
SELECT * FROM Sales.EmployeeLogs ORDER BY LogDate ASC;
