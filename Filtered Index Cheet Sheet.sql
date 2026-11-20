/* ============================================================================
   FILTERED INDEX CHEAT SHEET (Sales.Orders)
   ============================================================================
   What is a Filtered Index?
     A Nonclustered Index with a WHERE clause that indexes ONLY a subset of rows
     (e.g., only the 50,000 'Shipped' rows out of 1,000,000 total rows).

   1. WHERE CAN YOU PUT A FILTER? (Index + WHERE)
   ----------------------------------------------------------------------------
   Clustered Rowstore + WHERE           = ❌ FAILS (Main table can't drop rows)
   Clustered Columnstore + WHERE        = ❌ FAILS (Main table can't drop rows)
   Nonclustered Rowstore + WHERE        = ✅ WORKS (Sorted B-tree subset)
   Nonclustered Columnstore + WHERE     = ✅ WORKS (Compressed subset, SQL 2016+)

   2. VALID TABLE + FILTERED INDEX COMBINATIONS
   ----------------------------------------------------------------------------
   Heap (no clustered)   + Filtered Nonclustered Rowstore      = ✅ WORKS (uses RID pointer)
   Heap (no clustered)   + Filtered Nonclustered Columnstore   = ✅ WORKS (SQL 2016+)
   Clustered Rowstore    + Filtered Nonclustered Rowstore      = ✅ WORKS (uses Clustered Key pointer)
   Clustered Rowstore    + Filtered Nonclustered Columnstore   = ✅ WORKS (SQL 2016+)
   Clustered Columnstore + Filtered Nonclustered Rowstore      = ✅ WORKS (SQL 2016+)
   Clustered Columnstore + Filtered Nonclustered Columnstore   = ❌ FAILS (Max 1 columnstore/table)

   3. ANATOMY & B-TREE SORT ORDER (How Rowstore Filtered Indexes Are Organized)
   ----------------------------------------------------------------------------
   Given: CREATE NONCLUSTERED INDEX IX_Orders_ShippedOnly
          ON Sales.Orders (OrderDate)
          INCLUDE (CustomerID, ShipDate)
          WHERE OrderStatus = 'Shipped';

   - Key Column(s)  : ON Sales.Orders (OrderDate)
       -> SORTED. The B-tree is physically sorted by OrderDate first, then
          automatically by the Clustered Key (e.g., OrderID) or RID as a tie-breaker.
   - INCLUDE Columns: INCLUDE (CustomerID, ShipDate)
       -> NOT SORTED. Stored only at the bottom (leaf level) as extra payload
          so queries can grab these columns without an expensive Key/RID Lookup.
   - WHERE Clause   : WHERE OrderStatus = 'Shipped'
       -> NOT SORTED. Only decides which rows enter the B-tree (keeps index small).

   4. HOW TO USE INCLUDE IN A QUERY (100% Covered — Zero Extra Lookups)
   ----------------------------------------------------------------------------
   Optimal Query:
       SELECT OrderDate, CustomerID, ShipDate
       FROM Sales.Orders
       WHERE OrderStatus = 'Shipped'
         AND OrderDate >= '2026-11-01';

   - Why it uses INCLUDE: SQL Server seeks straight to '2026-11-01' in the sorted
     B-tree (OrderDate) and immediately grabs CustomerID and ShipDate right off
     the leaf page without ever touching the main table.
   - Bonus: If your main table has a Clustered Index on OrderID, you can also
     include OrderID in your SELECT list and it will still be 100% covered!

   5. KEY RULES & GOTCHAS FOR THE WHERE CLAUSE
   ----------------------------------------------------------------------------
   - Allowed operators  : =, !=, <, >, <=, >=, IN, IS NULL, IS NOT NULL, AND
   - Disallowed         : OR, LIKE, NOT IN, subqueries, computed columns, functions
   - Query matching     : Query's WHERE clause must match (or be a subset of) the
                          index filter; parameterized queries may skip the index
                          unless OPTION (RECOMPILE) is used.
   ============================================================================ */

-- Example 1: Filtered Nonclustered Rowstore (Fast lookups on active 'Shipped' orders)
CREATE NONCLUSTERED INDEX IX_Orders_ShippedOnly
ON Sales.Orders (OrderDate)
INCLUDE (CustomerID, ShipDate)
WHERE OrderStatus = 'Shipped';

-- Example 2: Filtered Nonclustered Columnstore (Fast analytics on 'Delivered' orders)
CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Orders_DeliveredOnly
ON Sales.Orders (OrderDate, ShipDate, CustomerID)
WHERE OrderStatus = 'Delivered';
