/* Window functions */

-- Row Number

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