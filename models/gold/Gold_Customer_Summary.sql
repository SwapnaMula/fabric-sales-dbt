SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.region,
    COUNT(DISTINCT o.order_id)      AS total_orders,
    SUM(s.net_sales_amount)         AS total_net_sales,
    ROUND(AVG(s.net_sales_amount),2) AS avg_order_value,
    MAX(o.order_date)               AS last_order_date
FROM {{ ref('Silver_Customers') }}  c
JOIN {{ ref('Silver_Orders') }}     o ON c.customer_id  = o.customer_id
JOIN {{ ref('Silver_Sales') }}      s ON o.order_id     = s.order_id
GROUP BY c.customer_id, c.customer_name, c.city, c.region