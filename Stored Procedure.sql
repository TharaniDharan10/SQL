/*
================================================================================
STORED PROCEDURES (SP) VS. PYTHON / APPLICATION LAYER
================================================================================

1. WHAT IS A STORED PROCEDURE?
   - A pre-compiled collection of one or more SQL statements saved directly 
     inside the database catalog.
   - It accepts input parameters, executes DML/DDL operations, implements 
     procedural logic (IF/ELSE, loops, transactions), and returns result sets, 
     output parameters, or status codes.

2. PHYSICAL LOCATION IN SQL SERVER / SSMS:
   - Object Explorer Path:
     [Your Database] (e.g., SalesDB)
       └── [Programmability]
             └── [Stored Procedures]
                   ├── System Stored Procedures
                   └── dbo.YourStoredProcedureName (User-defined procedures)

3. STORED PROCEDURE ADVANTAGES:
   - Zero Network Overhead for Intermediate Steps:
     Executes directly inside the database engine memory next to the storage engine. 
     Multi-step pipelines process data locally on the server without shuttling millions 
     of raw rows back and forth over a network connection to an external client.
   - Pre-Compiled Execution Plans:
     On first execution, SQL Server parses, compiles, and caches an optimal query 
     execution plan in the plan cache. Subsequent runs reuse this plan instantly, 
     reducing compilation overhead.
   - Centralized Security & Abstraction:
     Users and client applications can be granted EXECUTE permissions on the stored 
     procedure without needing direct SELECT/INSERT/UPDATE permissions on the 
     underlying base tables, reducing SQL injection and privilege exposure risks.

4. PYTHON / CLIENT-SIDE ADVANTAGES:
   - Complex Business & Data Science Logic:
     Python excels at non-relational workflows: statistical modeling, machine 
     learning, graph algorithms, complex string parsing, regex, and API integrations 
     where T-SQL procedural loops (CURSORS/WHILE) are slow and awkward.
   - Native CI/CD & Version Control:
     Python applications fit natively into standard Git-based workflows, automated 
     testing frameworks (pytest), modular packaging, and containerized deployments.
   - Portability & Vendor Decoupling:
     Keeps business logic independent of proprietary database dialects (T-SQL, PL/SQL, 
     pgSQL), making underlying database migrations or multi-engine pipelines simpler.

5. DECISION FRAMEWORK — WHEN TO USE WHICH:
   - Use STORED PROCEDURES when:
     * Logic is data-heavy, relational, and needs to run directly next to disk/memory.
     * Enforcing strict transactional integrity (ACID) across multiple tables.
     * Batch processing or scheduled database maintenance tasks on the native instance.
     * Reducing network latency and bandwidth on large aggregation/transformation batches.
   - Use PYTHON when:
     * Orchestrating end-to-end data pipelines (e.g., Airflow, Prefect, FastAPI/Flask backend).
     * Extracting data across disparate systems (REST APIs, cloud object stores, 3rd party tools).
     * Implementing advanced analytical algorithms, machine learning, or data visualization.
     * Building microservices where business logic belongs in the application layer.
================================================================================
*/


--For US Customers, find the total number of customers and the average score
CREATE PROCEDURE SP_US_Customer_Summary AS
BEGIN
SELECT 
	COUNT(CustomerID) AS [Total US Customers],
	AVG(Score) AS [Avg Score]
FROM Sales.Customers
WHERE Country = 'USA'
END

EXEC SP_US_Customer_Summary