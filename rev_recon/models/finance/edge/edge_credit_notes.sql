{{ config(materialized='view', schema='analytics_edge') }}

select
  credit_id,
  invoice_id,
  cast(credit_date as date) as credit_date,
  cast(loaded_at as timestamp) as loaded_at,
  currency,
  cast(amount as numeric) as amount
from {{ ref('raw_credit_notes_edge') }}
