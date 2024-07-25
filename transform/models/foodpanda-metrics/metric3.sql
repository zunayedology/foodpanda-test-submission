{{ config(materialized = "view") }}

WITH
    successful_orders_per_restaurants AS (
        SELECT
            o.date_local,
            o.vendor_id AS restaurant_id,
            v.vendor_name AS restaurant_name,
            COUNT(*) AS total_successful_orders

        FROM {{ ref("orders") }} o
        JOIN {{ ref("vendors") }} v ON o.vendor_id = v.id
        WHERE o.is_successful_order = TRUE
        GROUP BY
            o.date_local,
            o.vendor_id,
            v.vendor_name
    )

SELECT * FROM successful_orders_per_restaurants;
