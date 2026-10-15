
CREATE PROCEDURE SP_IfElse_Variable_Parameter_Customer_Summary_Based_On_Country @Country NVARCHAR(50) = 'USA' AS
BEGIN
--Step 1: Declare the variables
DECLARE @Total_Customers INT, @Avg_Score FLOAT;


--Preparing and cleaning up data from Null score to 0 inorder to perform average score
IF EXISTS(SELECT 1 FROM Sales.Customers WHERE Country = @Country AND Score IS NULL)
BEGIN
	PRINT('Converting NULL Score to 0')
	UPDATE Sales.Customers	
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country
END

ELSE 
BEGIN
	PRINT('No score is NULL')
END;


--Generating reports
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

--Here we are mentioning Germany, thus overriding default country value 'USA'
EXEC SP_IfElse_Variable_Parameter_Customer_Summary_Based_On_Country @Country = 'Germany'

--Here it used Defasult value 'USA'
EXEC SP_IfElse_Variable_Parameter_Customer_Summary_Based_On_Country