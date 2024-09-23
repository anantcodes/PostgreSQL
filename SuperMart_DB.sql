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