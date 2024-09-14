CREATE TABLE Customer_table(
Cust_id int,
First_name varchar,
Last_name varchar,
age int,
email_id varchar);

INSERT INTO Customer_table
VALUES (1,'bee','cee',32,'bc@xyz.com')

INSERT INTO Customer_table(cust_id, first_name,age,email_id)
VALUES (2,'dee',23,'d@xyz.com')

INSERT INTO Customer_table VALUES
(3,'ee','ef',27,'ef@xyz.com'),
(4,'gee','eh',35,'gh@xyz.com')

copy Customer_table from '/Users/postgres (Deleted)/copy.csv' DELIMITER ',' CSV HEADER;

copy Customer_table from '/Users/postgres (Deleted)/copytext.txt' DELIMITER ',';

SELECT first_name from Customer_table;

SELECT first_name,last_name from Customer_table;

SELECT * from Customer_table;

SELECT DISTINCT first_name from customer_table;

SELECT DISTINCT first_name,age from customer_table;

SELECT DISTINCT * from customer_table;

SELECT first_name from customer_table WHERE age=25;

SELECT DISTINCT first_name from customer_table WHERE age=25;

SELECT DISTINCT first_name from customer_table WHERE age>25;

SELECT * from customer_table WHERE first_name = 'Gee'; 

SELECT first_name, last_name, age from customer_table WHERE age>20 AND age<30;

SELECT first_name, last_name, age from customer_table WHERE age<20 OR age>=30;

SELECT * from customer_table WHERE NOT age=25;

SELECT * from customer_table WHERE NOT age=25 AND NOT first_name='Jay' ;