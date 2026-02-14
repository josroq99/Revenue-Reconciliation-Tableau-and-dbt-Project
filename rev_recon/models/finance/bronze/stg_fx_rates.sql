{{ config(materialized='view', schema='analytics') }}

select
  cast(fx_date as date) as fx_date,
  currency,
  cast(rate_to_usd as numeric) as rate_to_usd
from {{ ref('raw_fx_rates') }}
