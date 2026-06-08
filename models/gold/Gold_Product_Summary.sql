SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    COUNT(DISTINCT o.order_id)       AS total_orders,
    SUM(o.quantity)                  AS total_quantity_sold,
    SUM(s.net_sales_amount)          AS total_net_sales,
    ROUND(AVG(s.discount_pct)*100,2) AS avg_discount_pct
FROM {{ ref('Silver_Products') }}   p
JOIN {{ ref('Silver_Orders') }}     o ON p.product_id   = o.product_id
JOIN {{ ref('Silver_Sales') }}      s ON o.order_id     = s.order_id
GROUP BY p.product_id, p.product_name, p.category, p.unit_price