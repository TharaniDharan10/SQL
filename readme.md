# SQL Reference & Learning Repository

A structured collection of Transact-SQL (T-SQL) scripts, templates, and patterns developed in SQL Server Management Studio (SSMS). This repository serves as a practical, hands-on reference guide covering core database querying, data transformations, built-in functions, and analytical SQL patterns.

---

## 📂 Repository Contents

### 1. Fundamentals & DDL
* **`basic.sql`**: Introduction to basic SQL statements, environment setup, and fundamental commands.
* **`create_persons.sql`**: Table creation scripts (`CREATE TABLE`), primary/foreign keys, schema definition, and sample test data insertion.
* **`Select_Statements.sql`**: Data retrieval patterns using `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `DISTINCT`, and filtering criteria.

### 2. Logic, Conditions & Null Handling
* **`Case_When.sql`**: Conditional branching logic (`CASE WHEN ... THEN ... ELSE ... END`), dynamic labeling, and categorization.
* **`Null_Functions.sql`**: Handling nullability and missing values using `ISNULL()`, `COALESCE()`, `NULLIF()`, and three-valued logic.

### 3. Combining & Joining Datasets
* **`Joins.sql`**: Standard two-table joins including `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`, and `CROSS JOIN`.
* **`Joins_On_Multi_Table.sql`**: Complex joins across three or more tables, bridge/junction relationships, and optimization patterns.
* **`Set_Operators.sql`**: Vertical query combinations using `UNION`, `UNION ALL`, `INTERSECT`, and `EXCEPT`.

### 4. Date & Time Operations
* **`Date&Time.sql`**: Temporal data types (`DATETIME2`, `DATE`, `TIME`) and system retrieval functions (`GETDATE()`, `SYSDATETIME()`).
* **`Date_Calculations&Date_Validation.sql`**: Date arithmetic (`DATEADD()`, `DATEDIFF()`), period boundary calculations, and validity checks (`ISDATE()`).
* **`FormatDate&Num.sql`**: Output formatting for dates and numeric values using `FORMAT()` and culture-specific specifiers.
* **`Format_Cast_Convert_of_Date_time.sql`**: Type conversions using `CAST()` and `CONVERT()` with standard SQL Server style codes.

### 5. Math, Transformations & Functions
* **`Round&abs.sql`**: Mathematical utilities including `ROUND()`, `ABS()`, `CEILING()`, `FLOOR()`, and decimal precision control.
* **`Functions.sql`**: Built-in scalar and string functions, along with reusable User-Defined Functions (UDFs).

### 6. Analytical & Window Functions
* **`Window Function.sql`**: Analytical operations using the `OVER()` clause:
  * **Ranking**: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`
  * **Offset/Navigation**: `LEAD()`, `LAG()`, `FIRST_VALUE()`, `LAST_VALUE()`
  * **Aggregations**: Running totals, moving averages, and frame specifications (`ROWS BETWEEN ...`)

### 7. Tooling & Templates
* **`Templates/`**: Boilerplate skeletons for stored procedures, table creation, script headers, and migration scripts.
* **`Code Snippets/`**: Reusable code snippets for frequent day-to-day administrative and querying tasks.

---

## 🛠️ Environment & Prerequisites

* **DBMS**: Microsoft SQL Server
* **Client Tool**: SQL Server Management Studio (SSMS) / Azure Data Studio / VS Code (mssql extension)
* **Dialect**: T-SQL

---

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   ```

2. **Open in SSMS:**
   * Launch SSMS and connect to your SQL Server instance.
   * Open any `.sql` script via `Ctrl + O` or drag-and-drop.
   * Highlight query blocks and press `F5` to execute against your target database.

---

## 📌 Roadmap

This repository is actively maintained. Upcoming topics include:
- [ ] Subqueries and Common Table Expressions (CTEs)
- [ ] Stored Procedures, Triggers, and Transactions (`BEGIN TRAN`, `COMMIT`, `ROLLBACK`)
- [ ] Indexing strategies and Execution Plan analysis
- [ ] Performance tuning and query optimization