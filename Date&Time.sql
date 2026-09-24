use SalesDB

--3 Types of Dates

--1-> Tables date
SELECT 
	OrderID,
	CreationTime
FROM Sales.Orders

--2-> Hard coded String date
SELECT 
	OrderID,
	CreationTime,
	'2025-08-12' AS 'date'
FROM Sales.Orders

--3-> Getdate()
SELECT 
	OrderID,
	CreationTime,
	'2025-08-12' AS 'date',
	GETDATE() AS 'todays_date'
FROM Sales.Orders

--Extraction of Year, month, day from a date
--Note: Return type is int
SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) AS 'year',
	MONTH(CreationTime) AS 'month',
	DAY(CreationTime) AS 'day'
FROM Sales.Orders

--Use of Datepart and datename function
--Note: Return type is int for Datepart and type is String for datename
SELECT 
	OrderID,
	CreationTime,
	DATEPART(YEAR, CreationTime) AS Year,
	DATEPART(MONTH, CreationTime) AS 'Month',
	DATEPART(DAY, CreationTime) AS 'Day',
	DATEPART(WEEK, CreationTime) AS 'Week',
	DATEPART(WEEKDAY, CreationTime) AS 'WeekDayNumber',
	DATEPART(QUARTER, CreationTime) AS 'Quarter',
	DATEPART(HOUR, CreationTime) AS 'Hour',
	DATENAME(WEEKDAY, CreationTime) AS 'WeekDayName',
	DATENAME(MONTH, CreationTime) AS 'WeekDayName',
	((DATEPART(WEEKDAY, CreationTime) + @@DATEFIRST - 2) % 7 + 1) AS 'WeekDayForCorrectMaths'
FROM Sales.Orders


--Use of Datetrunc
--Note: Truncates values until mentioned thing. Return value is also datetime2 forma
SELECT 
	OrderID,
	CreationTime,
	Datetrunc(YEAR, CreationTime) AS Reset_after_year,
	Datetrunc(MONTH, CreationTime) AS Reset_after_month,
	Datetrunc(DAY, CreationTime) AS Reset_after_day,
	Datetrunc(HOUR, CreationTime) AS Reset_after_hour,
	Datetrunc(MINUTE, CreationTime) AS Reset_after_min
FROM Sales.Orders

--How is Datetrunc useful? Its useful in granular level of aggregations
SELECT DATETRUNC(MONTH, CreationTime) AS Creation, COUNT(*) AS Agg_Count
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH, CreationTime) 

--EOMonth: Returns last date of a months date
SELECT 
	CreationTime,
	EOMONth(CreationTime) AS End_Of_Month
FROM Sales.Orders

--How to get 1st day of a month?
SELECT 
	CreationTime,
	DATETRUNC(MONTH, CreationTime) AS Start_Of_Month,
	CAST(DATETRUNC(MONTH, CreationTime) AS DATE) AS Start_Of_Only_Month,
	EOMONth(CreationTime) AS End_Of_Month
FROM Sales.Orders


--How many orders were placed each month
SELECT 
	MONTH(OrderDate) AS [Month], 
	COUNT(*)  AS  Orders_per_month
FROM Sales.Orders
GROUP BY MONTH(OrderDate)


--How many orders were placed each year
SELECT 
	YEAR(OrderDate), 
	COUNT(*) AS Orders_per_year
FROM Sales.Orders
GROUP BY YEAR(OrderDate)


--How many orders were placed each month
SELECT 
	DATENAME(MONTH, OrderDate) AS [Month], 
	COUNT(*)  AS  Orders_per_month
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)


--Orders that were placed in month of February
--This is preferred
SELECT * 
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2
--or
SELECT * 
FROM Sales.Orders
WHERE DATENAME(MONTH, OrderDate) = 'February'


--Sample combination to understand
SELECT 
    'Year' 
        AS DatePart, 
    'yy' 
        AS Abbreviation,
    YEAR(GETDATE()) 
        AS DatePart_Output_INT, 
    DATENAME(year, GETDATE()) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(year, GETDATE()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Quarter' 
        AS DatePart, 
    'qq' 
        AS Abbreviation,
    DATEPART(quarter, GETDATE()) 
        AS DatePart_Output_INT, 
    'Q' + DATENAME(quarter, GETDATE()) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(quarter, GETDATE()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Month' 
        AS DatePart, 
    'mm' 
        AS Abbreviation,
    MONTH(GETDATE()) 
        AS DatePart_Output_INT, 
    DATENAME(month, GETDATE()) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(month, GETDATE()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Week' 
        AS DatePart, 
    'wk' 
        AS Abbreviation,
    DATEPART(week, GETDATE()) 
        AS DatePart_Output_INT, 
    DATENAME(week, GETDATE()) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(week, GETDATE()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Weekday' 
        AS DatePart, 
    'dw' 
        AS Abbreviation,
    DATEPART(weekday, GETDATE()) 
        AS DatePart_Output_INT, 
    DATENAME(weekday, GETDATE()) 
        AS DateName_Output_NVARCHAR, 
    NULL 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Day' 
        AS DatePart, 
    'dd' 
        AS Abbreviation,
    DAY(GETDATE()) 
        AS DatePart_Output_INT, 
    DATENAME(day, GETDATE()) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(day, GETDATE()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Hour' 
        AS DatePart, 
    'hh' 
        AS Abbreviation,
    DATEPART(hour, SYSDATETIME()) 
        AS DatePart_Output_INT, 
    CAST(DATEPART(hour, SYSDATETIME()) AS VARCHAR(2)) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(hour, SYSDATETIME()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Minute' 
        AS DatePart, 
    'mi' 
        AS Abbreviation,
    DATEPART(minute, SYSDATETIME()) 
        AS DatePart_Output_INT, 
    CAST(DATEPART(minute, SYSDATETIME()) AS VARCHAR(2)) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(minute, SYSDATETIME()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Second' 
        AS DatePart, 
    'ss' 
        AS Abbreviation,
    DATEPART(second, SYSDATETIME()) 
        AS DatePart_Output_INT, 
    CAST(DATEPART(second, SYSDATETIME()) AS VARCHAR(2)) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(second, SYSDATETIME()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Millisecond' 
        AS DatePart, 
    'ms' 
        AS Abbreviation,
    DATEPART(millisecond, SYSDATETIME()) 
        AS DatePart_Output_INT, 
    CAST(DATEPART(millisecond, SYSDATETIME()) AS VARCHAR(3)) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(millisecond, SYSDATETIME()) 
        AS DateTrunc_Output_DATETIME2

UNION ALL

SELECT 
    'Microsecond' 
        AS DatePart, 
    'mcs' 
        AS Abbreviation,
    DATEPART(microsecond, SYSDATETIME()) 
        AS DatePart_Output_INT, 
    CAST(DATEPART(microsecond, SYSDATETIME()) AS VARCHAR(6)) 
        AS DateName_Output_NVARCHAR, 
    DATETRUNC(microsecond, SYSDATETIME()) 
        AS DateTrunc_Output_DATETIME2;

