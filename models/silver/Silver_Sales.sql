SELECT
    sales_id,
    order_id,
    ROUND(sales_amount, 2)                                      AS sales_amount,
    discount_pct,
    ROUND(sales_amount * (1 - discount_pct), 2)                 AS net_sales_amount,
    UPPER(status)                                               AS status,
    CURRENT_TIMESTAMP()                                         AS ingested_at
FROM {{ source('Data_Storing', 'Bronze_Sales') }}
WHERE sales_id IS NOT NULL
  AND sales_amount > 0