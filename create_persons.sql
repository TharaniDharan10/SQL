use MyDatabase

CREATE TABLE persons (
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL
CONSTRAINT pk_persons PRIMARY KEY (id)
)

INSERT INTO persons (id, person_name)
VALUES(6, 'Sam')

SELECT * FROM persons


--Adding a new column will be added at end of table. If we want column name be be somewhere in middle, then we have to drop the table and recreate again
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL

ALTER TABLE persons
DROP COLUMN phone

DROP TABLE persons

--Insert data from customers into persons
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT id, first_name, NULL,'Unknown' from customers

SELECT * FROM persons

--Change score of customer with id 6 to 0 and country to Eipstein
INSERT INTO customers 
VALUES(6, 'Sam', 'India', 753)

UPDATE customers set score = 0, country = 'Eipstein'
WHERE id = 6

--Change score of customer to 0 when its NULL
UPDATE customers set score = 0
WHERE score = NULL

SELECT * FROM customers WHERE score = 0

--Delete rows whose id > 5
DELETE customers WHERE id > 5


--Delete all rows from persons
TRUNCATE TABLE persons

--Customers not from Germany
SELECT * FROM customers WHERE country != 'Germany'


--Customers who are from USA and score > 500
SELECT * FROM customers WHERE country = 'USA' AND score > 500

--Customers who are from USA or score > 500
SELECT * FROM customers WHERE country = 'USA' OR score > 500

--Customers whose score not < 500
SELECT * FROM customers WHERE NOT score < 500

--Customers whose score btn 100 to 500(inclusive)
SELECT * FROM customers WHERE  score BETWEEN 100 AND 500
--Both are same. For better undefstanding, use this method
SELECT * FROM customers WHERE score >= 100 AND score <= 500

--Customers from either Germany, USA, France, Canada
SELECT * FROM customers WHERE country IN ('Germany', 'USA', 'France', 'Canada')
--Same
SELECT * FROM customers WHERE country = 'Germany' OR country = 'USA' OR country = 'France' OR country = 'Canada'

--Customers from neither Germany, USA, France, Canada
SELECT * FROM customers WHERE country NOT IN ('Germany', 'USA', 'France', 'Canada')

--Like
 SELECT * FROM customers WHERE country LIKE '%many%'
 SELECT * FROM customers WHERE first_name LIKE 'M%'
 SELECT * FROM customers WHERE first_name LIKE '%n'
 SELECT * FROM customers WHERE first_name LIKE '%r%'
 SELECT * FROM customers WHERE first_name LIKE '__r%'



