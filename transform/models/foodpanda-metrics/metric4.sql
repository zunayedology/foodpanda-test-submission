{{ config(materialized = "view") }}

WITH
    individual_products AS (
        SELECT
            rdbms_id AS order_id,
            date_local,
            TRIM(products) AS individual_product_id
        FROM
            {{ ref("orders") }},
            UNNEST(SPLIT(product_id, ",")) AS products
    ),
    ordered_products AS (
        SELECT
            date_local,
            order_id,
            COUNT(*) AS total_products
        FROM individual_products
        GROUP BY
            date_local,
            order_id
    )

SELECT
    date_local,
    ROUND(AVG(total_prodtcs), 2) AS avg_product_per_order_day
FROM ordered_products
GROUP BY date_local;
