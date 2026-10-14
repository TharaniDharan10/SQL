/*
================================================================================
DEFAULT PARAMETERS IN STORED PROCEDURES
================================================================================
- Assigning a default value (`@Country NVARCHAR(50) = 'USA'`) makes the 
  parameter optional during execution.
- If an argument is provided, it overrides the default value.
- If called without arguments, SQL Server automatically falls back to 'USA',
  preventing execution errors for missing parameters.
================================================================================
*/


--For a Country based Customers, find the total number of customers and the average score, keeping USA as a default country if not mentioned
CREATE PROCEDURE SP_ParameterDefault_Customer_Summary_Based_On_Country @Country NVARCHAR(50) = 'USA' AS
BEGIN
SELECT 
	COUNT(CustomerID) AS [Total Customers],
	AVG(Score) AS [Avg Score]
FROM Sales.Customers
WHERE Country = @Country
END

--Here we are mwntioning Germany, thus overriding default country value 'USA'
EXEC SP_ParameterDefault_Customer_Summary_Based_On_Country @Country = 'Germany'

--Here it used Defasult value 'USA'
EXEC SP_ParameterDefault_Customer_Summary_Based_On_Country