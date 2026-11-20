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


--ColumnStore Index

-- ============================================================================
-- 1. CLUSTERED COLUMNSTORE INDEX (CCI)
-- ============================================================================
-- Architecture:
--   * NO sorted B-Tree rowstore table exists.
--   * The ENTIRE table (all columns) is stored as unsorted, compressed columns.
-- Storage Usage (sp_spaceused):
--   * Data Space  : YES (It IS the main table itself; smallest total storage).
--   * Index Space : NO  (0 KB extra index space, unless you add separate B-tree indexes).
-- Best For:
--   * Data warehouses, bulk inserts, and heavy analytical queries (SUM, AVG, GROUP BY).
--   * Not ideal for frequent single-row updates or point lookups.


--Note: No ColumnStore index uses any index storage, meaning, they dont create a B-Tree structure.
--Executing it fails as one cannot use a column name in a clustered columnstore index
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS ON Sales.DBCustomers (CustomerID)



--Executing it fails as one cannot have more than one clustered index in a Table.So lets drop clustered index
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS ON Sales.DBCustomers 

--Dropping clustered index
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS ON Sales.DBCustomers 

--This fails as I cannot create more than one Columnstore index for a table(Inclusive of both clustered or non clustered index). So i can have only one columnstore index
--This limitation of creating only one columnstore index is only with sql server. In other servers, we can create more than 2 columnstore index.
--So lets drop this columnstore index to create one
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName ON Sales.DBCustomers (FirstName)

--Drop clustered index to create one
DROP INDEX idx_DBCustomers_CS ON Sales.DBCustomers 



-- ============================================================================
-- 2. NONCLUSTERED COLUMNSTORE INDEX (NCCI)
-- ============================================================================
-- Architecture:
--   * TWO structures exist side-by-side:
--     1. Main Table (Rowstore): Sorted B-Tree on FirstName -> keeps single-row writes/updates fast.
--     2. Columnar Copy: Unsorted, compressed copy of ONLY selected columns -> makes analytics fast.
-- Storage Usage (sp_spaceused):
--   * Data Space  : YES (Used by the main sorted rowstore table).
--   * Index Space : YES (Used by this secondary compressed columnar copy).
-- Best For:
--   * Active transactional (OLTP) tables that also need real-time reporting/analytics.

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName ON Sales.DBCustomers (FirstName)


--Lets see if really the columnstore take less space than rowstroe and heap. For this lets use AdventureWorksDW2025 db as the data in SalesDB are smaller. Look into (Storage Comparison for Heap RowStore ColumnStore.sql) for understanding it better.



--UNIQUE INDEX

SELECT * FROM Sales.Products

--Executing it will not let it create unique index as this table has duplicate values in the mentioned column. 
--I can still create this index if this table was empty. In that case, sql will not allow to enter duplicate values in Category column
CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Category ON Sales.Products (Category) 

--This index will be created as Product is unique column
CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product ON Sales.Products (Product) 

--Trying to insert a duplicate value on which the unique index is build will not allow the insert to happen
INSERT INTO Sales.Products (ProductID, Product) VALUES (106, 'Caps')




--Filtered INDEX

--This did a full scan on table
SELECT *
FROM Sales.Customers 
WHERE Country = 'USA'

--Creating a Filtered index to improve search
CREATE NONCLUSTERED INDEX idx_Customers_Country ON Sales.Customers (Country) 
WHERE Country = 'USA'


--This now used index to search, thus increased performance
SELECT *
FROM Sales.Customers 
WHERE Country = 'USA'


--This did a full scan on table as no index was made on Country = 'Germany'
SELECT *
FROM Sales.Customers 
WHERE Country = 'Germany'

SELECT * FROM Sales.Orders
