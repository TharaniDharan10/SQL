USE SalesDB

--This has a Default Clustered index as this table had a primary key
SELECT * FROM Sales.Customers

--Now lets create a new table without creating a primary key. If we open and see Sales.DBCustomers -> Indexes, it is empty, meaning it uses heap structure and thus simply dumps the data in no proper order
SELECT 
	* 
INTO Sales.DBCustomers
FROM Sales.Customers

--Now this query did a full scan on this table to find it
SELECT 
	* 
FROM Sales.DBCustomers 
WHERE CustomerID = 1

--Create index. Ensure to create index with such naming convention only as during monitoring, it will be easy to understand.
--If we open and see Sales.DBCustomers -> Indexes, now we can find it
--Rule: Only one Cluster index can be created for a table
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers (CustomerID)


--Executing it will not create one more cluster index on the same table
CREATE CLUSTERED INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName)

--Say i unknowingly created a clustered index on CustomerID instead of creating it on FirstName, what we need to do is to drop the index 1st, then create one
--DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers
--CREATE CLUSTERED INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName)

--Say i frequently search for a user by firstname or lastname, in such cases, it is good to have a non clustered index
SELECT 
	* 
FROM Sales.DBCustomers 
WHERE LastName = 'Brown'

--We can have multiple non clustered index
CREATE NONCLUSTERED INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName)

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName ON Sales.DBCustomers (LastName)

--Composite non clustered index. If we havenot mentioned as clustered or non clustered, the default is Non Clustered
CREATE INDEX idx_DBCustomers_CountryScore ON Sales.DBCustomers (Country, Score)

SELECT 
	* 
FROM Sales.DBCustomers 
--Note: The order of these columns must match the order as per the index columns order
WHERE Country = 'USA' AND Score > 500

--What happens when I use only the 1st column from index? Does sql use index to find the answer? 
--Answer: Yes, as long as we use the 1st column from index, it will work
SELECT 
	* 
FROM Sales.DBCustomers 
--Note: The order of these columns must match the order as per the index columns order
WHERE Country = 'USA' 


--What happens when I use only the 2nd column from index? Does sql use index to find the answer? 
--Answer: No, if we use only 2nd column without 1st, it doesnot use index to find the answers
SELECT 
	* 
FROM Sales.DBCustomers 
--Note: The order of these columns must match the order as per the index columns order
WHERE Score < 500





