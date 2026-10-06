USE SalesDB

--Value Function: Lead, Lag, First_value, Last_value

--Analyse the month over month performance by finding the percentage change in sales btn current and previous month
SELECT
	*,
	[Total_Sales_in_curr_Month] - [Total_Sales_in_Prev_Month] AS MOM_Change,
	--Casted as dividing an int by int gives 0, so casted one of it to float.
	ROUND(CAST(([Total_Sales_in_curr_Month]-[Total_Sales_in_Prev_Month]) AS FLOAT)/[Total_Sales_in_Prev_Month] * 100, 1) AS [% change btn curr and prev month]
	FROM
	(

SELECT 
	DATEPART(MONTH, OrderDate) AS [Month],
	SUM(Sales) AS [Total_Sales_in_curr_Month],
	LAG(SUM(Sales)) OVER(ORDER BY DATEPART(MONTH, OrderDate)) AS [Total_Sales_in_Prev_Month]
FROM Sales.Orders
GROUP BY DATEPART(MONTH, OrderDate)
) t
--OR
SELECT
	*,
	[Total_Sales_in_curr_Month] - [Total_Sales_in_Prev_Month] AS MOM_Change,
	ROUND(CAST(([Total_Sales_in_curr_Month]-[Total_Sales_in_Prev_Month]) AS FLOAT)/[Total_Sales_in_Prev_Month] * 100, 1) AS [% change btn curr and prev month]
	FROM
	(

SELECT 
	MONTH(OrderDate) AS [Month],
	SUM(Sales) AS [Total_Sales_in_curr_Month],
	LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS [Total_Sales_in_Prev_Month]
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
) t


--Analyse customer loyalty by ranking customers based on the average number of days btn orders
SELECT * FROM Sales.Orders
SELECT
	CustomerID,
	AVG(Gap_Btn_Orders) AS [AvgDaysForACostumerToOrder],
	--Used coalesce as we dont want null to be listed on top in rank
	RANK() OVER(ORDER BY COALESCE(AVG(Gap_Btn_Orders), 9999)) AS [Rank]
FROM (
SELECT 
	OrderID,
	CustomerID,
	OrderDate,
	DATEDIFF(DAY, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS Gap_Btn_Orders
FROM Sales.Orders
) t
GROUP BY CustomerID


--Find the lowest and highest sales for each product
SELECT * FROM Sales.Orders
SELECT 
	OrderID,
	ProductID,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS [Lowest_Value],
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS [Highest_Value]
FROM Sales.Orders
--OR 
SELECT 
	OrderID,
	ProductID,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS [Lowest_Value],
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS [Lowest_Value]
FROM Sales.Orders	
--OR
SELECT 
	OrderID,
	ProductID,
	MIN(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS [Lowest_Value],
	MAX(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS [Lowest_Value]
FROM Sales.Orders


--Find the lowest and highest sales for each product. find diff in sales btn curr and lowest sales for products
SELECT * FROM Sales.Orders
SELECT 
	OrderID,
	ProductID,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS [Lowest_Value],
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS [Highest_Value],
	Sales,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS [Sales DIff]
FROM Sales.Orders