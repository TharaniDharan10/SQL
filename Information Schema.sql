--INFORMATION SCHEMA: A system-defined schema with built-in views that provide info about the database, like tables and columns.
SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM INFORMATION_SCHEMA.COLUMNS

SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS

SELECT * FROM INFORMATION_SCHEMA.VIEWS

--Temporary tables are found in System databases -> tempdb -> temporary tables


/*
================================================================================
1. INFORMATION_SCHEMA VIEWS
================================================================================
- WHAT IT IS:
  An ANSI-SQL standard set of built-in views that provide metadata about 
  database objects (tables, columns, views, constraints, routines).

- KEY ADVANTAGES:
  * Portability: ANSI-compliant, meaning query syntax works across multiple 
    RDBMS engines (SQL Server, PostgreSQL, MySQL).
  * Security-Filtered: Only displays objects the current user has permission 
    to view.

- COMMON USE CASES:
  * Schema auditing & dynamic SQL script generation.
  * Checking if a table or column exists before executing DDL.
  * Searching for specific column names across all tables.

- COMMON VIEWS:
  * INFORMATION_SCHEMA.TABLES      -> User tables & system views (TABLE_TYPE: 'BASE TABLE' vs 'VIEW')
  * INFORMATION_SCHEMA.COLUMNS     -> Column metadata (DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH)
  * INFORMATION_SCHEMA.VIEWS       -> View definitions and properties
  * INFORMATION_SCHEMA.TABLE_CONSTRAINTS -> Primary Keys, Foreign Keys, Unique constraints
  * INFORMATION_SCHEMA.ROUTINES    -> Stored procedures and functions

- LIMITATION:
  Does not expose SQL Server-specific engine details (indexes, partition schemes, 
  compression, spatial data). Use sys.* catalog views (e.g., sys.tables, sys.indexes) 
  when deep SQL Server-native metadata is required.
================================================================================
*/


/*
================================================================================
2. TEMPORARY TABLES (#Local and ##Global)
================================================================================
- STORAGE & LOCATION:
  Physical tables written to disk/buffer pool inside the system database:
  [tempdb] -> [System Databases] -> [tempdb] -> [Temporary Tables].

- TYPES OF TEMPORARY TABLES:

  1) Local Temporary Tables (#TableName):
     - Scope: Visible ONLY to the connection/session (SPID) that created it.
     - Storage Name: SQL Server appends an underscore + unique random suffix 
       in tempdb to prevent collisions across multiple simultaneous users.
     - Lifecycle: Dropped automatically when the current session/connection closes 
       or when an explicit DROP TABLE #TableName is executed.

  2) Global Temporary Tables (##TableName):
     - Scope: Visible to ALL active connections and users across the server.
     - Storage Name: Stored in tempdb exactly as declared (no random suffix).
     - Lifecycle: Dropped when the creating session disconnects AND all active 
       queries referencing it from other sessions finish.

- WHY USE TEMPORARY TABLES (vs. CTEs or Table Variables @Table):
  * Physical Indexes: You can add clustered and non-clustered indexes for performance.
  * Column Statistics: The SQL Server query optimizer maintains distribution 
    statistics on temp tables, producing accurate execution plans for large datasets.
  * Parallel Execution: Supports parallel query processing (unlike @Table variables).
  * Best for: Intermediate transformation staging, heavy joins, and data > 1,000 rows.

- CLEANUP BEST PRACTICE:
  Always explicitly clean up temp tables at the end of scripts:
  IF OBJECT_ID('tempdb..#MyTempTable') IS NOT NULL
      DROP TABLE #MyTempTable;
================================================================================
*/