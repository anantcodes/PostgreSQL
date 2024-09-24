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

/* COUNT */

SELECT COUNT(*) FROM sales;

SELECT COUNT(order_line) AS "Number of Products Ordered", COUNT (DISTINCT order_id) AS "Number of Orders" FROM sales WHERE customer_id='CG-12520';

/* SUM */

SELECT SUM(Profit) AS "Total Profit" FROM sales;

SELECT SUM(quantity) AS "Total Quantity" FROM sales WHERE product_id='FUR-TA-10000577';

/* AVERAGE */

SELECT AVG(age) AS "Average Customer Age" FROM customer;

SELECT AVG(sales*.10) AS "Average Commission Value" FROM sales;

/* MIN & MAX */

SELECT MIN(sales) AS "Minimum sales value June 15" FROM sales WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30';

SELECT sales FROM sales WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30' ORDER BY sales ASC;

SELECT MAX(sales) AS "Minimum sales value June 15" FROM sales WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30';

SELECT sales FROM sales WHERE order_date BETWEEN '2015-06-01' AND '2015-06-30' ORDER BY sales DESC;

/* GROUP BY */

SELECT * from customer;

SELECT region, COUNT(customer_id) as customer_count FROM customer GROUP BY region;

SELECT region, AVG(age) as age, COUNT(customer_id) as customer_count FROM customer GROUP BY region;

SELECT region,state, AVG(age) as age, COUNT(customer_id) as customer_count FROM customer GROUP BY region, state;

SELECT product_id, SUM(quantity) AS quantity_sold FROM sales GROUP BY product_id ORDER BY quantity_sold DESC;

SELECT customer_id, MIN(sales) AS minimum_sales, MAX(sales) AS max_sales, AVG(sales) AS average_sales, SUM(sales) AS total_sales
FROM sales GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

/* HAVING */ 

SELECT region, COUNT(customer_id) AS customer_count FROM customer GROUP BY region HAVING COUNT (customer_id)>200;

SELECT region, COUNT(customer_id) AS customer_count FROM customer WHERE customer_name LIKE 'A%' GROUP BY region;

SELECT region, COUNT(customer_id) AS customer_count FROM customer WHERE customer_name LIKE 'A%' GROUP BY region HAVING COUNT(customer_id) > 15;

/* CAASE */

SELECT *, CASE
			WHEN age<30 THEN 'Young'
			WHEN age>60 THEN 'SENIOR CITIZEN'
			ELSE 'Middle Aged'
			END AS Age_category
FROM customer;

/* JOIN */

/*Creating sales table of year 2015*/

Create table sales_2015 as select * from sales where ship_date between '2015-01-01' and '2015-12-31';
select count(*) from sales_2015; --2131
select count(distinct customer_id) from sales_2015;--578

/* Customers with age between 20 and 60 */
create table customer_20_60 as select * from customer where age between 20 and 60;
select count (*) from customer_20_60;--597

/* INNER JOIN */

SELECT customer_id FROM sales_2015 ORDER BY customer_id;
SELECT customer_id FROM customer_20_60 ORDER BY customer_id;

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 AS a
INNER JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY customer_id;

/* LEFT JOIN */

SELECT customer_id FROM sales_2015 ORDER BY customer_id;
SELECT customer_id FROM customer_20_60 ORDER BY customer_id;

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 AS a
LEFT JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY customer_id;

/* RIGHT JOIN */

SELECT customer_id FROM sales_2015 ORDER BY customer_id;
SELECT customer_id FROM customer_20_60 ORDER BY customer_id;

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 AS a
RIGHT JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY customer_id;

/* FULL OUTER JOIN */

SELECT customer_id FROM sales_2015 ORDER BY customer_id;
SELECT customer_id FROM customer_20_60 ORDER BY customer_id;

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age,
	b.customer_id
FROM sales_2015 AS a
FULL JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY a.customer_id,b.customer_id;

/* CROSS JOIN */

CREATE TABLE month_values (MM integer);
CREATE TABLE year_values (YYYY integer);

INSERT INTO MONTH_values VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12);
INSERT INTO year_values VALUES (2011), (2012),(2013),(2014),(2015),(2016),(2017),(2018),(2019);

SELECT * FROM month_values;
SELECT * FROM year_values;

SELECT a.YYYY,b.MM
FROM year_values AS a, month_values AS b
ORDER BY a.YYYY, b.MM;

/* INTERSECT */

SELECT customer_id FROM sales_2015
INTERSECT
SELECT customer_id FROM customer_20_60

/* EXCEPT */

SELECT customer_id FROM sales_2015 ORDER BY customer_id;
SELECT customer_id FROM customer_20_60 ORDER BY customer_id;

SELECT customer_id FROM sales_2015
EXCEPT
SELECT customer_id FROM customer_20_60
ORDER BY customer_id;

/* UNION */

SELECT customer_id FROM sales_2015
UNION
SELECT customer_id FROM customer_20_60
ORDER BY customer_id;

/* SUBQUERY */

SELECT * FROM sales
WHERE customer_id IN (SELECT customer_id FROM customer WHERE age > 60);

SELECT a.product_id, a.product_name, a.category,b.quantity
FROM product AS a
LEFT JOIN (SELECT product_id,SUM(quantity) AS quantity FROM sales GROUP BY product_id) AS b
ON a.product_id=b.product_id
ORDER BY b.quantity DESC;

SELECT customer_id, order_line, (SELECT customer_name FROM customer WHERE customer .customer_id=sales.customer_id)
FROM sales
ORDER BY customer_id;

/* VIEWS */

CREATE VIEW logistics AS
SELECT a.order_line, a.order_id, b.customer_name,b.city,b.state,b.country
FROM sales AS a
LEFT JOIN customer AS b
ON a.customer_id = b.customer_id
ORDER BY a.order_line;

SELECT * FROM logistics;

DROP VIEW logistics;

/* INDEX */

CREATE INDEX mon_idx
ON month_values(MM)

DROP INDEX mon_idx;

/* String functions */

-- Length

SELECT customer_name, length(customer_name) AS character_num
FROM customer
WHERE age > 30;

SELECT customer_name, length(customer_name) AS character_num
FROM customer
WHERE length(customer_name) > 15;

-- UPPER/LOWER

SELECT upper('Anant Kanchan');

SELECT lower('Anant Kanchan');

-- REPLACE

SELECT customer_name, country, REPLACE(country, 'United States', 'US') AS country_new FROM customer;

SELECT customer_name, country, REPLACE(lower(country), 'united states', 'US') AS country_new FROM customer;

-- TRIM, LTRIM, RTRIM

SELECT TRIM(leading ' ' FROM '  Anant Kanchan  ');

SELECT TRIM(trailing ' ' FROM '  Anant Kanchan  ');

SELECT TRIM(both ' ' FROM '  Anant Kanchan  ');

SELECT TRIM('  Anant Kanchan  ');

SELECT RTRIM('  Anant Kanchan  ', ' ');

SELECT LTRIM('  Anant Kanchan  ', ' ');

-- Concatenation

SELECT customer_name, city || ',' || state || ',' || country AS address FROM customer;

-- SUBSTRING

SELECT customer_id, customer_name,
SUBSTRING (customer_id FOR 2) AS cust_group
FROM customer
WHERE SUBSTRING (customer_id FOR 2) = 'AB';

SELECT customer_id, customer_name,
SUBSTRING (customer_id FROM 4 FOR 5) AS cust_group
FROM customer
WHERE SUBSTRING (customer_id FOR 2) = 'AB';

-- String Aggregator

SELECT * FROM sales ORDER BY order_id;

SELECT order_id, string_agg(product_id,', ')
FROM sales
GROUP BY order_id
ORDER BY order_id;

/* Mathematical functions */

-- CEIL & FLOOR

SELECT * FROM sales;

SELECT order_line, sales, CEIL(sales), FLOOR(sales) FROM sales;

-- Random

-- a=10,b=50
-- SELECT RANDOM()*(b-a)+a
-- SELECT FLOOR(RANDOM()*(b-a+1))+a

SELECT RANDOM(), RANDOM()*40+10, FLOOR(RANDOM()*40)+10;

-- SETSEED

SELECT SETSEED(0.5);

SELECT RANDOM(); -- 0.9851677175347999
SELECT RANDOM(); -- 0.825301858027981

SELECT SETSEED(0.5);

SELECT RANDOM(); -- 0.9851677175347999
SELECT RANDOM(); -- 0.825301858027981

-- ROUND

SELECT order_line, sales, ROUND(sales) FROM sales ORDER BY sales DESC;

-- POWER

SELECT POWER(age,2), age FROM customer;

SELECT age, POWER(age,2) FROM customer ORDER BY age;

/* Date-Time Functions */

-- Current Date & Time

SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIME(1), CURRENT_TIMESTAMP;

-- Age

SELECT age('2014-04-25', '2014-01-01');

SELECT order_line, order_date, ship_date, age(ship_date, order_date) AS time_taken
FROM sales ORDER BY time_taken DESC;

-- EXTRACT

SELECT EXTRACT (day from CURRENT_DATE);

SELECT CURRENT_TIMESTAMP, EXTRACT(hour from CURRENT_TIMESTAMP);

SELECT order_date, ship_date, EXTRACT(epoch from (ship_date-order_date)) from sales; -- error

SELECT order_date, ship_date, (EXTRACT(epoch from ship_date) - EXTRACT(epoch from order_date)) AS sec_taken FROM sales;

/* PATTERN(STRING) MATCHING */

/* Like commands */

SELECT * FROM customer WHERE customer_name LIKE 'J%';

SELECT * FROM customer WHERE customer_name LIKE '%Nelson%';

SELECT * FROM customer WHERE customer_name LIKE '____ %';

SELECT distinct city FROM customer WHERE city NOT LIKE 'S%';

/* REG-EX: PAttern Matching using regular expression */

CREATE TABLE users(id serial PRIMARY KEY, name character varying);

INSERT INTO users (name) VALUES ('Alex'), ('Jon Snow'), ('Christopher'), ('Arya'),('Sandip Debnath'), ('Lakshmi'),('alex@gmail.com'),('@sandip5004'), ('lakshmi@gmail.com');

SELECT * FROM customer
WHERE customer_name ~* '^a+[a-z\s]+$';

SELECT * FROM customer
WHERE customer_name ~* '^(a|b|c|d)+[a-z\s]+$';

SELECT * FROM customer
WHERE customer_name ~* '^(a|b|c|d)[a-z]{3}\s[a-z]{4}$';

SELECT * FROM users;

SELECT * FROM users
WHERE name ~* '[a-z0-9\.\-\_]+@[a-z0-9\-]+\.[a-z]{2,5}';