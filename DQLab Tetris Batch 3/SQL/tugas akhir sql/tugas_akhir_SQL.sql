SELECT DISTINCT
    store_name,
    COUNT(*) AS total_orders,
    round(sum(order_amount),2) AS total_order_amount,
    round(sum(payment_amount),2) AS total_payment_amount
FROM orders o
JOIN stores s ON s.store_id = o.store_id
JOIN payments p ON o.payment_order_id = p.payment_order_id
WHERE order_status = 'FINISHED' AND order_created_month = 2 AND order_created_year = 2021
GROUP BY 1
ORDER BY total_orders DESC
LIMIT 5;

-- sasa

WITH payments_2 AS (
	SELECT payment_order_id, payment_amount
	FROM payments
),
orders_2 AS (
	SELECT store_id, payment_order_id, order_amount  
	FROM orders 
	WHERE order_status = 'FINISHED' AND order_created_month = 2 AND order_created_year = 2021
)

SELECT DISTINCT
    s.store_name,
    COUNT(*) AS total_orders,
    round(sum(o.order_amount),2) AS total_order_amount,
    round(sum(p.payment_amount),2) AS total_payment_amount
FROM orders_2 o
JOIN stores s ON s.store_id = o.store_id
JOIN payments_2 p ON o.payment_order_id = p.payment_order_id
GROUP BY 1
ORDER BY total_orders DESC
LIMIT 5;

-- lakslkals
WITH order_store AS (
	SELECT payment_order_id, order_amount, store_name
	FROM orders o 
	JOIN stores s ON s.store_id = o.store_id
	WHERE order_status = 'FINISHED' AND order_created_month = 2 AND order_created_year = 2021
)

SELECT DISTINCT
    os.store_name,
    COUNT(*) AS total_orders,
    round(sum(os.order_amount),2) AS total_order_amount,
    round(sum(p.payment_amount),2) AS total_payment_amount
FROM order_store os
JOIN payments p ON os.payment_order_id = p.payment_order_id
GROUP BY 1
ORDER BY total_orders DESC
LIMIT 5;