SELECT
    s.sales_id,
    o.order_id,
    o.order_date,
    o.order_year,
    o.order_month,
    c.customer_id,
    c.customer_name,
    c.city,
    c.region,
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    o.quantity,
    s.sales_amount,
    s.discount_pct,
    s.net_sales_amount,
    s.status
FROM {{ ref('Silver_Sales') }}      s
JOIN {{ ref('Silver_Orders') }}     o ON s.order_id     = o.order_id
JOIN {{ ref('Silver_Customers') }}  c ON o.customer_id  = c.customer_id
JOIN {{ ref('Silver_Products') }}   p ON o.product_id   = p.product_id