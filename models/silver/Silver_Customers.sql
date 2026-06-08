SELECT
    customer_id,
    INITCAP(customer_name)          AS customer_name,
    INITCAP(city)                   AS city,
    UPPER(region)                   AS region,
    CURRENT_TIMESTAMP()             AS ingested_at
FROM {{ source('Data_Storing', 'Bronze_Customers') }}
WHERE customer_id IS NOT NULL