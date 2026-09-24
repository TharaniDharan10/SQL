USE SalesDB;

--Date Calculations
--1>Dateadd
--2>DateDiff
SELECT OrderID,
       OrderDate,
       DATEADD(YEAR, 2, OrderDate) AS two_year_later,
       DATEADD(MONTH, 3, OrderDate) AS three_month_later,
       DATEADD(DAY, -10, OrderDate) AS ten_day_back,
       DATEADD(MONTH, -3, OrderDate) AS three_month_back
FROM   Sales.Orders;

--Calculate age if employees
SELECT EmployeeID,
       CONCAT(FirstName, ' ', LastName) AS Name,
       BirthDate,
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS AGE
FROM   Sales.Employees;

--Calculate average shipping duration in days for each month
SELECT   MONTH(OrderDate) AS Month,
         AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS Avg_Days_for_Each_Month
FROM     Sales.Orders
GROUP BY MONTH(OrderDate);

--OR
SELECT   DATENAME(MONTH, OrderDate) AS Month,
         AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS Avg_Ship_Days_For_Each_Month
FROM     Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);

--Time Gap Analysis
--Find no of days btn each order and previous order
--Here we use a window fucntion LAG to fetch value of previous row
SELECT OrderID,
       OrderDate AS Current_Order_date,
       LAG(OrderDate) OVER (ORDER BY OrderDate) AS Previous_Order_Date,
       DATEDIFF(DAY, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) AS Days_btn_Orders
FROM   Sales.Orders;

SELECT *
FROM   Sales.Orders;

--Date Validation
--1>IsDate
--Cast only valid dates into date
SELECT OrderDate,
       ISDATE(OrderDate) AS [IsDate],
       CASE WHEN ISDATE(OrderDate) = 1 THEN CAST (OrderDate AS DATE) ELSE --ELSE '9999-01-01'
       CAST ('9999-01-01' AS DATE) END AS New_Order_Date_in_Date_Type
FROM   (SELECT '2025-08-20' AS OrderDate
        UNION
        SELECT '2025-08-21'
        UNION
        SELECT '2025-08-23'
        UNION
        SELECT '2025-31-01'
        UNION
        SELECT '2025-08') AS t;
--WHERE ISDATE(OrderDate) = 0


--Note: 
--Question? So if we dont have AS t, it wont work?
--Answer: No, it will not work. 
--If you remove the t, SQL Server will throw a syntax error: “Incorrect syntax near ')'.”
--In SQL, whenever you place a query inside parentheses (SELECT ...)  and treat it like a table, it is called a Subquery or a Derived Table.
--SQL Server strictly requires you to give every subquery an alias (a temporary nickname), even if you don't use it anywhere else in the query.

