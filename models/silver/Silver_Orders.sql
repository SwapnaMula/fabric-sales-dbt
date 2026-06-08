SELECT
    order_id,
    customer_id,
    product_id,
    CAST(order_date AS DATE)        AS order_date,
    quantity,
    YEAR(CAST(order_date AS DATE))  AS order_year,
    MONTH(CAST(order_date AS DATE)) AS order_month,
    CURRENT_TIMESTAMP()             AS ingested_at
FROM {{ source('Data_Storing', 'Bronze_Orders') }}
WHERE order_id IS NOT NULL
  AND quantity > 0