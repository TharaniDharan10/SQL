ALTER PROCEDURE SP_TryCatch_IfElse_Variable_Parameter_Customer_Summary_Based_On_Country @Country NVARCHAR (50)='USA' 
AS
--Start of a Stored Procedure
BEGIN
    --Start of a Try block
    BEGIN TRY
        DECLARE @Total_Customers AS INT, @Avg_Score AS FLOAT;
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE  Country = @Country AND Score IS NULL)
            BEGIN
                PRINT ('Converting NULL Score to 0');
                UPDATE Sales.Customers
                SET    Score = 0
                WHERE  Score IS NULL AND Country = @Country;
            END
        ELSE
            BEGIN
                PRINT ('No score is NULL');
            END
        SELECT @Total_Customers = COUNT(CustomerID),
               @Avg_Score = AVG(Score)
        FROM   Sales.Customers
        WHERE  Country = @Country;
        PRINT 'Total Customers from ' + @Country + ' is: ' + CAST (@Total_Customers AS NVARCHAR);
        PRINT 'Average Score of Customers from ' + @Country + ' is: ' + CAST (@Avg_Score AS NVARCHAR);
        SELECT COUNT(OrderID) AS [Total Orders],
               SUM(Sales) AS [Total Sales]
               --Added a Divide by zero column to use Try Catch. Inorder to stop catch execution, remove this column
               -- 1 / 0 AS [Divide By 0]
        FROM   Sales.Orders AS o
               INNER JOIN
               Sales.Customers AS c
               ON c.CustomerID = o.CustomerID
        WHERE  c.Country = @Country;
    END TRY
    BEGIN CATCH
        --End of a Try block
        --Start of a Catch block
        PRINT ('An Error Occured.');
        PRINT ('Error Message: ' + ERROR_MESSAGE());
        PRINT ('Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR));
        PRINT ('Error Line: ' + CAST (ERROR_LINE() AS NVARCHAR));
        PRINT ('Error Procedure: ' + ERROR_PROCEDURE());
    END CATCH --End of a Catch block
 --End of a Stored Procedure
END
EXECUTE SP_TryCatch_IfElse_Variable_Parameter_Customer_Summary_Based_On_Country @Country = 'Germany';
EXECUTE SP_TryCatch_IfElse_Variable_Parameter_Customer_Summary_Based_On_Country ;