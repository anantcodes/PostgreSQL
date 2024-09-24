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


/* Average window function */

SELECT * FROM customer_order;

SELECT customer_id, customer_name, state, sales_tot as revenue,
avg(sales_tot) OVER (PARTITION BY state) AS avg_revenue
FROM customer_order;

-- customers with less then average revenue

SELECT * FROM (SELECT customer_id, customer_name, state, sales_tot as revenue,
avg(sales_tot) OVER (PARTITION BY state) AS avg_revenue
FROM customer_order) AS a WHERE a.revenue < a.avg_revenue;

/* COUNT window function */

SELECT customer_id, customer_name, state,
count(customer_id) OVER(PARTITION BY state) AS Count_cust
FROM customer_order;