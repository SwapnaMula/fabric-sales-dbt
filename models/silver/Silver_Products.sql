SELECT
    product_id,
    product_name,
    INITCAP(category)               AS category,
    ROUND(unit_price, 2)            AS unit_price,
    CURRENT_TIMESTAMP()             AS ingested_at
FROM {{ source('Data_Storing', 'Bronze_Products') }}
WHERE product_id IS NOT NULL
  AND unit_price > 0