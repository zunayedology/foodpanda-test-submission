{{ config(materialized = "view") }}

WITH successful_orders AS (
   SELECT
       date_local,
       COUNT(*) AS total_successful_orders
   FROM {{ ref("orders") }}
   WHERE is_successful_order = TRUE
   GROUP BY date_local
)

SELECT * FROM successful_orders;
