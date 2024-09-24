/* Window functions */

/* Row Number */

SELECT * FROM customer LIMIT 10;

SELECT * FROM sales LIMIT 10;

SELECT a.*, b.order_num, b.sales_tot, b.quantity_tot, b.profit_tot
FROM customer AS a
LEFT JOIN (SELECT customer_id, COUNT( DISTINCT order_id) AS order_num, SUM(sales) as sales_tot, SUM(quantity) AS quantity_tot,
		   SUM(profit) AS profit_tot FROM sales GROUP BY customer_id) AS b
ON a.customer_id=b.customer_id;



SELECT * from sales WHERE customer_id='AA-10315' ORDER BY order_id; -- to check the above query is correct



CREATE TABLE customer_order AS (SELECT a.*, b.order_num, b.sales_tot, b.quantity_tot, b.profit_tot
FROM customer AS a
LEFT JOIN (SELECT customer_id, COUNT( DISTINCT order_id) AS order_num, SUM(sales) as sales_tot, SUM(quantity) AS quantity_tot,
		   SUM(profit) AS profit_tot FROM sales GROUP BY customer_id) AS b
ON a.customer_id=b.customer_id);


SELECT * FROM customer_order;


SELECT customer_id, customer_name, state, order_num, row_number() OVER (PARTITION BY state ORDER BY order_num DESC) AS row_n
FROM customer_order;


SELECT * FROM (SELECT customer_id, customer_name, state, order_num, row_number() OVER (PARTITION BY state ORDER BY order_num DESC) AS row_n
FROM customer_order) AS a WHERE a.row_n<=3;

/* rank & dense rank */

SELECT customer_id, customer_name, state, order_num, 
row_number() OVER (PARTITION BY state ORDER BY order_num DESC) AS row_n,
rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS rank_n,
dense_rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS dense_rank_n
FROM customer_order;

/* ntile */

SELECT customer_id, customer_name, state, order_num, 
row_number() OVER (PARTITION BY state ORDER BY order_num DESC) AS row_n,
rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS rank_n,
dense_rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS dense_rank_n,
ntile(5) OVER (PARTITION BY state ORDER BY order_num DESC) AS tile_n
FROM customer_order;

SELECT * from (SELECT customer_id, customer_name, state, order_num, 
row_number() OVER (PARTITION BY state ORDER BY order_num DESC) AS row_n,
rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS rank_n,
dense_rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS dense_rank_n,
ntile(5) OVER (PARTITION BY state ORDER BY order_num DESC) AS tile_n
FROM customer_order) as a WHERE a.tile_n = 1; -- for top 20% customers


SELECT * from (SELECT customer_id, customer_name, state, order_num, 
row_number() OVER (PARTITION BY state ORDER BY order_num DESC) AS row_n,
rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS rank_n,
dense_rank() OVER (PARTITION BY state ORDER BY order_num DESC) AS dense_rank_n,
ntile(5) OVER (PARTITION BY state ORDER BY order_num DESC) AS tile_n
FROM customer_order) as a WHERE a.tile_n = 5; -- for bottom 20% customers


/* Average function */

SELECT * FROM customer_order;

SELECT customer_id, customer_name, state, sales_tot as revenue,
avg(sales_tot) OVER (PARTITION BY state) AS avg_revenue
FROM customer_order;

-- customers with less then average revenue

SELECT * FROM (SELECT customer_id, customer_name, state, sales_tot as revenue,
avg(sales_tot) OVER (PARTITION BY state) AS avg_revenue
FROM customer_order) AS a WHERE a.revenue < a.avg_revenue;

/* COUNT function */

SELECT customer_id, customer_name, state,
count(customer_id) OVER(PARTITION BY state) AS Count_cust
FROM customer_order;

/* TOTAL/SUM function */

SELECT * FROM sales;

SELECT order_id, MAX(order_date) AS order_date, MAX(customer_id) AS customer_id, SUM(sales) AS sales 
FROM sales GROUP BY order_id;

CREATE TABLE order_rollup AS SELECT order_id, MAX(order_date) AS order_date, MAX(customer_id) AS customer_id, SUM(sales) AS sales 
FROM sales GROUP BY order_id;

CREATE TABLE order_rollup_state AS SELECT a.*, b.state
FROM order_rollup AS a
LEFT JOIN customer As b
ON a.customer_id = b.customer_id;

SELECT * FROM order_rollup_state;

SELECT *,
SUM(sales) OVER (PARTITION BY state) AS sales_state_total
FROM order_rollup_state;

/* Running Total/SUM function */

SELECT *,
SUM(sales) OVER (PARTITION BY state) AS sales_state_total,
SUM(sales) OVER (PARTITION BY state ORDER BY order_date) AS running_total
FROM order_rollup_state;

/* LAG functon */

SELECT customer_id, order_date, order_id, sales,
lag(sales,1) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_sales,
lag(order_id,1) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_id
FROM order_rollup_state;

/* LEAD functon */

SELECT customer_id, order_date, order_id, sales,
lead(sales,1) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_sales,
lead(order_id,1) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_id
FROM order_rollup_state;

/* COALESCE function */

CREATE table emp_name(
S_No int,
First_name varchar(255),
Middle_name varchar(255),
Last_name varchar(255));

INSERT INTO emp_name (S_No, First_name, Middle_name, Last_name) VALUES (1, 'Paul' , 'Van', 'Hugh');
INSERT INTO emp_name (S_No, First_name, 			  Last_name) VALUES (2, 'David', 		 'Flashing');
INSERT INTO emp_name (S_No, 			 Middle_name, Last_name) VALUES (3,   'Lena', 'Hugh');
INSERT INTO emp_name (S_No, First_name,				  Last_name) VALUES (4, 'Henry' , 'Goldwyn');
INSERT INTO emp_name (S_No,							  Last_name) VALUES (5,'Holden');
INSERT INTO emp_name (S_No, First_name, Middle_name, Last_name) VALUES (6, 'Erin' , 'T', 'Mull');

SELECT * FROM emp_name;

SELECT *, COALESCE(First_name, Middle_name, Last_name) AS name_corr FROM emp_name;