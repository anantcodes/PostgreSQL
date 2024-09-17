select * from customer;

select * from product;

select * from sales;

SELECT * FROM customer WHERE city IN ('Philadelphia','Seattle')

SELECT * FROM customer WHERE city = 'Philadelphia' OR city = 'Seattle';

SELECT * FROM customer WHERE age BETWEEN 20 AND 30;

SELECT * FROM customer WHERE age >=20 AND age<=30;

SELECT * FROM customer WHERE age NOT BETWEEN 20 and 30;

SELECT * FROM sales WHERE ship_date BETWEEN '2015-04-01' AND '2016-04-01';

/* Multi 
line comments
*/

-- Single line comments

/* Like commands */

SELECT * FROM customer WHERE customer_name LIKE 'J%';

SELECT * FROM customer WHERE customer_name LIKE '%Nelson%';

SELECT * FROM customer WHERE customer_name LIKE '____ %';

SELECT distinct city FROM customer WHERE city NOT LIKE 'S%';

/* ORDER BY */

SELECT * FROM customer WHERE state = 'California' ORDER BY customer_name;

SELECT * FROM customer WHERE state = 'California' ORDER BY customer_name ASC;

SELECT * FROM customer WHERE state = 'California' ORDER BY customer_name DESC;

SELECT * FROM customer ORDER BY city ASC, customer_name DESC;

SELECT * FROM customer ORDER BY 2 DESC;

SELECT * FROM customer WHERE age>25 ORDER BY city ASC, customer_name DESC;

SELECT * FROM customer ORDER BY age;

SELECT * FROM customer ORDER BY age DESC;

/* LIMIT */

SELECT * FROM customer WHERE age > 25 ORDER BY age DESC LIMIT 8;

SELECT * FROM customer WHERE age > 25 ORDER BY age ASC LIMIT 10;

/* AS */

SELECT customer_id AS "Serial Number", customer_name AS name, age as customer_age from customer;