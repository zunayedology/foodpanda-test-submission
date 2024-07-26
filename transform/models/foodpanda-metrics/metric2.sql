{{ config(materialized = "view") }}

WITH
    customers_with_min_one_successful_order AS (
        SELECT
            COUNT(DISTINCT customer_id) AS total_customers
        FROM
            {{ ref("orders") }}
        WHERE
            is_successful_order = TRUE
    )

SELECT * FROM customers_with_min_one_successful_order;
