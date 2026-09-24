Use SalesDB

--CONVERT can do both casting and formatting
SELECT
CreationTime,
CONVERT(DATE, CreationTime) AS [Datetime to DATE Convert],
CONVERT(VARCHAR, CreationTime, 32) AS [USA Std, Style:32],
CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std, Style:34],
CAST(CreationTime AS DATE) AS Casted
FROM Sales.Orders

--Cast converts datatype of one value to other
SELECT
CreationTime,
CAST('123' AS INT) AS [String to Int],
CAST(456 AS VARCHAR) AS [Int to String],
CAST('2025-08-02' AS DATE) AS [String to Date],
CAST(CreationTime AS DATE) AS [Datetime2 to Date]
FROM Sales.Orders
 

 --Format 
 SELECT OrderID,
       CreationTime,
       FORMAT(CreationTime, 'MM-dd-yyyy') AS USA_Format,
       FORMAT(CreationTime, 'yyyy-MM-dd') AS ISO_Format,
       FORMAT(CreationTime, 'dd-MM-yyyy') AS European_Format,
       FORMAT(CreationTime, 'dd') AS dd,
       FORMAT(CreationTime, 'ddd') AS ddd,
       FORMAT(CreationTime, 'dddd') AS dddd,
       FORMAT(CreationTime, 'MM') AS MM,
       FORMAT(CreationTime, 'MMM') AS MMM,
       FORMAT(CreationTime, 'MMMM') AS MMMM,
       FORMAT(CreationTime, 'yy') AS yy,
       FORMAT(CreationTime, 'yyyy') AS yyyy
FROM   Sales.Orders;
