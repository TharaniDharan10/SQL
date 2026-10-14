/*
================================================================================
PARAMETERIZED STORED PROCEDURE: AVOIDING CODE DUPLICATION (DRY PRINCIPLE)
================================================================================

1. WHY USE PARAMETERS?
   - Eliminates Redundancy: 
     Without parameters, you would need separate procedures or queries for 
     every country (e.g., SP_US_Customer_Summary, SP_Germany_Customer_Summary).
   - Dynamic Reusability: 
     A single procedure handles all countries by accepting @Country as an input 
     argument, adhering to the "Don't Repeat Yourself" (DRY) principle.

2. MAINTENANCE & SCALABILITY:
   - Centralized Logic: If the aggregation logic changes (e.g., handling NULLs 
     or altering score precision), you only update code in one place rather than 
     maintaining dozens of country-specific scripts.
   - Plan Caching: SQL Server compiles a reusable execution plan parameterized 
     for the query, optimizing execution across different input values.
================================================================================
*/


--For a Country based Customers, find the total number of customers and the average score
CREATE PROCEDURE SP_Parameter_Customer_Summary_Based_On_Country @Country NVARCHAR(50) AS
BEGIN
SELECT 
	COUNT(CustomerID) AS [Total Customers],
	AVG(Score) AS [Avg Score]
FROM Sales.Customers
WHERE Country = @Country
END

EXEC SP_Parameter_Customer_Summary_Based_On_Country @Country = 'Germany'

EXEC SP_Parameter_Customer_Summary_Based_On_Country @Country = 'USA'