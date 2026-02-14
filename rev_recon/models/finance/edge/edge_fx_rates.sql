{{ config(materialized='view', schema='analytics_edge') }}

select
  cast(fx_date as date) as fx_date,
  cast(loaded_at as timestamp) as loaded_at,
  currency,
  cast(rate_to_usd as numeric) as rate_to_usd
from {{ ref('raw_fx_rates_edge') }}
