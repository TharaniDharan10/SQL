use MyDatabase

--List of Customers 1st name together with their county in 1 column
SELECT 
	first_name,
	country,
	CONCAT(first_name,' ',country) AS 'Name_Country',
	LOWER(first_name) AS 'Lower_name',
	UPPER(first_name) AS 'Upper_Name'
FROM customers

--Find customers whose 1st name contains leading or trailing spaces
SELECT 
	first_name,
	LEN(first_name) AS 'Len_before_trim',
	LEN(TRIM(first_name)) AS 'Len_after_trim'
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name))

--Remove dashes from phone number
--Note: Replace is not only used to replace values but also to remve values
SELECT 
	'123-456-7890' AS 'Phone',
	REPLACE('123-456-7890', '-', '/') AS 'Using_/',
	REPLACE('123-456-7890', '-', '') AS 'Using_Nospace'

--Replace extension from csv to txt
SELECT 
	'file1.csv' AS 'Old_ext',
	REPLACE('file1.csv', '.csv', '.txt') AS 'New_ext'

--Retrive 1st 2 characters of each firstname
--Here For John, 1st 2 letters will only be as J as there is a white space after J. To avoid that, we use trim
SELECT first_name,
	LEFT(first_name, 2) AS '1st_2_letters',
	LEFT(TRIM(first_name), 2) AS '1st_2_letters',
	RIGHT(first_name, 2) AS 'last_2_letters'
FROM customers

SELECT * FROM customers

--Retrive a list of customers firstname after removing 1st letter
SELECT 
	first_name,
	SUBSTRING(first_name, 2, LEN(first_name)) AS 'Without_1st_letter',
	SUBSTRING(TRIM(first_name), 2, LEN(first_name)) AS 'Without_1st_letter'
FROM customers

