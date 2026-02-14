{{ config(materialized='view', schema='analytics') }}

select
  credit_id,
  invoice_id,
  cast(credit_date as date) as credit_date,
  currency,
  cast(amount as numeric) as amount
from {{ ref('raw_credit_notes') }}
