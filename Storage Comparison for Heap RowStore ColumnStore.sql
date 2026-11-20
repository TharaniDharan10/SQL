USE AdventureWorksDW2025
/*
   =======================================================================
    HEAP vs. CLUSTERED vs. NONCLUSTERED (How Data Actually Lives on Disk)
   =======================================================================
   - HEAP (No Clustered Index):
       The main table itself, stored UNSORTED on disk. Holds 100% of rows.

   - CLUSTERED INDEX (Rowstore or Columnstore):
       The main table itself, physically SORTED by the key column (or compressed
       by column). Holds 100% of rows. Max 1 per table.

   - NONCLUSTERED INDEX (Like the index at the back of a textbook):
       Does NOT sort the main table. Instead, it creates a SEPARATE copy of
       just the indexed key column(s) + a pointer back to the main table row:
         * Nonclustered Rowstore    = Physically SORTED B-tree copy of key columns
         * Nonclustered Columnstore = Compressed column segments (not sorted B-tree)
       Can hold 100% of rows OR a filtered subset (WHERE). Many allowed per table.

    */


--Lets use FactInternetSales table. This is already clustered. So lets make a copy of it to make it non clustered.

/*Structure 1: Heap*/

--Since we didnot define any cluster index, this is going to be a heap structure
SELECT * 
INTO FactInternetSales_HP 
FROM FactInternetSales




/*Structure 2: Rowstore*/

SELECT * 
INTO FactInternetSales_RS
FROM FactInternetSales

--Creating Clustered index to make it rowstore
CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber)




/*Structure 3: Columnstore*/

SELECT * 
INTO FactInternetSales_CS
FROM FactInternetSales

--Creating Clustered index to make it rowstore
CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK ON FactInternetSales_CS 

/* To view the storage of each, click on each of the 
tables created -> Properties -> Storage. 
Here we can see Data space and index space and come to a conclusion that 
Column store is better in storage, followed by heap, then by rowStore */
