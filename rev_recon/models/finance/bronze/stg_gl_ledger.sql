{{ config(materialized='view', schema='analytics') }}

select
  journal_id,
  period,
  cast(ledger_date as date) as ledger_date,
  cast(loaded_at as timestamp) as loaded_at,
  account,
  cast(amount_usd as numeric) as amount_usd
from {{ ref('raw_gl_ledger') }}
