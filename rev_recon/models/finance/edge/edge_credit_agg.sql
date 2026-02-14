{{ config(materialized='view', schema='analytics_edge') }}

select
  invoice_id,
  sum(amount) as credit_amount
from {{ ref('edge_credit_notes') }}
group by 1
