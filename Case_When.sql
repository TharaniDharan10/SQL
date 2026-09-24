--Create a report showing total sales for each of the following categories:
/* High (sales over 50), medium (Sales 21-50), Low (Sales less or equal to 20).
Sort categories from highest to lowest*/

USE SalesDB

SELECT Categories, SUM(Sales) AS Total_Sales FROM
(SELECT 
	OrderID,
	Sales,
	CASE 
		WHEN Sales > 50 THEN 'High'
		WHEN Sales > 20 THEN 'Medium'
		WHEN Sales <= 20 THEN 'Low'
	END AS Categories
FROM Sales.Orders) t
GROUP BY Categories 
ORDER BY Total_Sales DESC

--Retrieve employee details with gender displayed as full text
SELECT 
	EmployeeID, 
	Gender,
	CASE 
	WHEN Gender = 'M' THEN 'Male'
	WHEN Gender = 'F' THEN 'Female'
	ELSE 'Not_Determined' 
	END AS GenderFullText
FROM Sales.Employees

--Retrieve customer details with abbreviated country code
SELECT 
	CustomerID,
	Country,
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'Not mentioned'
		END AS CountryAbbByFullForm,
	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'Not mentioned'
		END AS CountryAbbByQuickForm
FROM Sales.Customers
--Used to know all cases: SELECT DISTINCT Country FROM  Sales.Customers


--Find the average score of customers and treat nulls as 0 and additionally provide details such as customerID and lastname
SELECT 
	CustomerID,
	LastName,
	CASE
		WHEN LastName IS NULL THEN ''
		ELSE LastName
	END AS Lastname_Clean,
	Score,
	CASE
		WHEN Score iS NULL THEN 0
		ELSE Score
	END AS Score_Clean,
	AVG(Score) OVER() AS Avg_Score_Unclean,
	AVG(
	CASE
		WHEN Score iS NULL THEN 0
		ELSE Score
	END) OVER() AS Avg_Score_Clean
FROM Sales.Customers

--Count how many times each customer has made an order with sales greater than 30
--Approach 1
SELECT 
	c.CustomerID,
	SUM(
	CASE
		WHEN o.Sales > 30 THEN 1
		ELSE 0
	END) AS Count
	FROM Sales.Customers AS c
	LEFT JOIN Sales.Orders AS o
	ON c.CustomerID = o.CustomerID
	GROUP BY c.CustomerID

--Approach 2
	SELECT 
	CustomerID,
	--Cause COUNT on a column level doesnot count null
	COUNT(
	CASE
		WHEN Sales > 30 THEN 1
		ELSE Null
	END) AS [Count more than 30 Using COUNT],
	--OR
--Approach 3
	SUM(
	CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) AS [Count more than 30 Using SUM],
	COUNT(*) AS [Total orders by a customer]
	FROM Sales.Orders
	GROUP BY CustomerID

