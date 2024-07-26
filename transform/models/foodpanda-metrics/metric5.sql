{{ config(materialized = "view") }}

WITH
    customer_orders AS (
        SELECT customer_id,
               date_local
        FROM
            {{ ref("orders") }}
        WHERE
            is_successful_order = TRUE
    ),

    last_order_date AS (
        SELECT
            MAX(date_local) AS last_date
        FROM
            customer_orders
    ),

    customers_with_prev_orders AS (
        SELECT
            DISTINCT customer_id
        FROM
            customer_orders
        WHERE
            date_local < DATE_SUB(
                    (SELECT last_date FROM last_order_date),
                    INTERVAL 7 DAY
                )
    ),

    reordering_customers AS (
        SELECT
            DISTINCT customer_id
        FROM
            customer_orders
        WHERE
            date_local >= DATE_SUB(
                    (SELECT last_date FROM last_order_date),
                    INTERVAL 7 DAY
                )
    )

SELECT
    COUNT(DISTINCT reordering_customers.customer_id) AS total_reordering_customers
FROM
    reordering_customers
JOIN customers_with_prev_orders
    ON reordering_customers.customer_id = customers_with_prev_orders.customer_id;
