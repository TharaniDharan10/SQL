USE SalesDB;

--Rank the orders based on sales from highest to lowest
SELECT *,
       ROW_NUMBER() OVER (ORDER BY Sales DESC) AS [SalesRank_Row_NUMBER],
       RANK() OVER (ORDER BY Sales DESC) AS [SalesRank_Rank],
       DENSE_RANK() OVER (ORDER BY Sales DESC) AS [SalesRank_DENSE_RANK]
FROM   Sales.Orders;

--Find the top highest sales for each product
SELECT *
FROM   (SELECT *,
               RANK() OVER (PARTITION BY ProductID ORDER BY Sales DESC) AS [SalesRank_RANK]
        FROM   Sales.Orders) AS t
WHERE  [SalesRank_RANK] = 1;

--Find the lowest 2 customers based on their total sales
SELECT *
FROM   (SELECT   CustomerID,
                 SUM(Sales) AS [Customer_Total_Sales],
                 RANK() OVER (ORDER BY SUM(Sales)) AS [Rank]
        FROM     Sales.Orders
        GROUP BY CustomerID) AS t
WHERE  [Rank] <= 2;

--Assign unique IDs to the rows of Orders Archive
SELECT ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) AS Primary_Key,
       *
FROM   Sales.OrdersArchive;

--Identify duplicate rows in table OrdersArchive and return clean result without any duplicates
SELECT *
FROM   (SELECT ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) AS [Rank],
               *
        FROM   Sales.OrdersArchive) AS t
WHERE  Rank = 1;




--NTILE
SELECT OrderID,
       Sales,
       NTILE(1) OVER (ORDER BY Sales DESC) AS [Total Buckets: 1],
       NTILE(2) OVER (ORDER BY Sales DESC) AS [Total Buckets: 2],
       NTILE(3) OVER (ORDER BY Sales DESC) AS [Total Buckets: 3],
       NTILE(4) OVER (ORDER BY Sales DESC) AS [Total Buckets: 4],
       NTILE(5) OVER (ORDER BY Sales DESC) AS [Total Buckets: 5]
FROM   Sales.Orders;

--Use Case of NTILE

--USE CASE 1: Data Segmentation(Data Analyst)
--Segment all orders into 3 categories: high, medium and low sales
SELECT 
       *,
       CASE WHEN Total_Buckets_3 = 1 THEN 'High'
       WHEN Total_Buckets_3 = 2 THEN 'Medium'
       WHEN Total_Buckets_3 = 3 THEN 'Low'
       END AS Sales_Category
FROM(
SELECT OrderID,
       Sales,
       NTILE(3) OVER (ORDER BY Sales DESC) AS [Total_Buckets_3]
FROM Sales.Orders
) t 


--Use Case 2: Equalizing load(Data Engineer)
--Inorder to export the data, divide the orders into 2 groups
SELECT 
    NTILE(2) OVER(ORDER BY OrderID) AS [Buckets],
    *
FROM Sales.Orders


--Find the products that fall within 40% of prices



