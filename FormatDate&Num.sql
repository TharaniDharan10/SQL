USE SalesDB;

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


--Show creation time using the format Day Wed Jan Q1 2025 12:34:56 PM
SELECT 
    OrderID,
    CreationTime,
    'Day ' + FORMAT(CreationTime, 'ddd MMM') + ' Q' + DATENAME(QUARTER, CreationTime) +  ' ' + FORMAT(CreationTime, 'yyyy HH:mm:ss tt') AS Formatted_Day
FROM Sales.Orders


--Use case of Format in date
SELECT 
    'D' AS FormatType, 
    FORMAT(GETDATE(), 'D') AS FormattedValue, 
    'Full date pattern' AS Description
UNION ALL
SELECT 'd', FORMAT(GETDATE(), 'd'), 'Short date pattern'
UNION ALL
SELECT 'dd', FORMAT(GETDATE(), 'dd'), 'Day of month with leading zero'
UNION ALL
SELECT 'ddd', FORMAT(GETDATE(), 'ddd'), 'Abbreviated name of day'
UNION ALL
SELECT 'dddd', FORMAT(GETDATE(), 'dddd'), 'Full name of day'
UNION ALL
SELECT 'M', FORMAT(GETDATE(), 'M'), 'Month without leading zero'
UNION ALL
SELECT 'MM', FORMAT(GETDATE(), 'MM'), 'Month with leading zero'
UNION ALL
SELECT 'MMM', FORMAT(GETDATE(), 'MMM'), 'Abbreviated name of month'
UNION ALL
SELECT 'MMMM', FORMAT(GETDATE(), 'MMMM'), 'Full name of month'
UNION ALL
SELECT 'yy', FORMAT(GETDATE(), 'yy'), 'Two-digit year'
UNION ALL
SELECT 'yyyy', FORMAT(GETDATE(), 'yyyy'), 'Four-digit year'
UNION ALL
SELECT 'm', FORMAT(GETDATE(), 'm'), 'Minutes without leading zero'
UNION ALL
SELECT 'mm', FORMAT(GETDATE(), 'mm'), 'Minutes with leading zero'
UNION ALL
SELECT 's', FORMAT(GETDATE(), 's'), 'Seconds without leading zero'
UNION ALL
SELECT 'ss', FORMAT(GETDATE(), 'ss'), 'Seconds with leading zero'
UNION ALL
SELECT 'f', FORMAT(GETDATE(), 'f'), 'Tenths of a second'
UNION ALL
SELECT 'ff', FORMAT(GETDATE(), 'ff'), 'Hundredths of a second'
UNION ALL
SELECT 'fff', FORMAT(GETDATE(), 'fff'), 'Milliseconds'
UNION ALL
SELECT 'T', FORMAT(GETDATE(), 'T'), 'Full AM/PM designator'
UNION ALL
SELECT 't', FORMAT(GETDATE(), 't'), 'Single character AM/PM designator'
UNION ALL
SELECT 'tt', FORMAT(GETDATE(), 'tt'), 'Two character AM/PM designator';


--Sample for numeric
-- All numeric format specifiers can be used in FORMAT SQL Function
SELECT 'N' AS FormatType, FORMAT(1234.56, 'N') AS FormattedValue
UNION ALL
SELECT 'P', FORMAT(1234.56, 'P')
UNION ALL
SELECT 'C', FORMAT(1234.56, 'C')
UNION ALL
SELECT 'E', FORMAT(1234.56, 'E')
UNION ALL
SELECT 'F', FORMAT(1234.56, 'F')
UNION ALL
SELECT 'N0', FORMAT(1234.56, 'N0')
UNION ALL
SELECT 'N1', FORMAT(1234.56, 'N1')
UNION ALL
SELECT 'N2', FORMAT(1234.56, 'N2')
UNION ALL
SELECT 'N_de-DE', FORMAT(1234.56, 'N', 'de-DE')
UNION ALL
SELECT 'N_en-US', FORMAT(1234.56, 'N', 'en-US');