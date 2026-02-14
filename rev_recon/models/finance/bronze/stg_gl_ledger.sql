{{ config(materialized='view', schema='analytics') }}

select
  journal_id,
  period,
  account,
  cast(amount_usd as numeric) as amount_usd
from {{ ref('raw_gl_ledger') }}
