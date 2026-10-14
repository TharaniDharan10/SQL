
/*
================================================================================
VARIABLES & PRINT STATEMENTS IN STORED PROCEDURES
================================================================================
1. T-SQL Variables (@Variable):
   - Scoped strictly to the execution batch or procedure where they are declared.
   - Declared using DECLARE @VarName DataType.
   - Assigned data using SELECT @VarName = Column (or SET @VarName = Value).
   - When assigning a variable inside a SELECT, you cannot assign variables and 
     return row data to the client in the very same SELECT statement.

2. PRINT vs. SELECT Outputs:
   - SELECT returns structured tabular datasets that appear under the 
     "Results" tab in SSMS.
   - PRINT sends text directly to the client as informational messages, 
     appearing under the "Messages" tab (useful for logging, debugging, or progress).
   - Concatenating values into PRINT requires casting non-string types 
     (INT, FLOAT, DATE) into VARCHAR / NVARCHAR.
================================================================================
*/


CREATE PROCEDURE SP_Variable_Parameter_Customer_Summary_Based_On_Country @Country NVARCHAR(50) = 'USA' AS
BEGIN
--Step 1: Declare the variables
DECLARE @Total_Customers INT, @Avg_Score FLOAT;
--For a Country based Customers, find the total number of customers and the average score, keeping USA as a default country if not mentione
SELECT 
--Step 2: Assign the variables the values. Ensure no alias is used for these columns
	@Total_Customers = COUNT(CustomerID),
	@Avg_Score =  AVG(Score)
FROM Sales.Customers
WHERE Country = @Country;

--Step 3: Use the variables. This query doesnot show any result like a table under Results tab, instead find output under Messages tab
PRINT 'Total Customers from ' + @Country + ' is: ' + CAST(@Total_Customers AS NVARCHAR);
PRINT 'Average Score of Customers from ' + @Country + ' is: ' + CAST(@Avg_Score AS NVARCHAR);

--Find total no of orders and sales WHERE Country = 'USA'
SELECT
	COUNT(OrderID) AS [Total Orders],
	SUM(Sales) AS [Total Sales]
FROM Sales.Orders o 
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country;

END

--Here we are mwntioning Germany, thus overriding default country value 'USA'
EXEC SP_Variable_Parameter_Customer_Summary_Based_On_Country @Country = 'Germany'

--Here it used Defasult value 'USA'
EXEC SP_Variable_Parameter_Customer_Summary_Based_On_Country