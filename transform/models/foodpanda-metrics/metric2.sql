{{ config(materialized = "view") }}

WITH
    min_one_successful_order_customers AS (
    SELECT
        COUNT(DISTINCT customer_id) AS total_customers
    FROM {{ ref("orders") }}
    WHERE is_successful_order = TRUE
)

SELECT * FROM min_one_successful_order_customers;
