CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage NVARCHAR(255),
	LogDate DATE
)