{% snapshot fx_rates_snapshot %}

{{
  config(
    target_schema='analytics_snapshots',
    unique_key="fx_date || '-' || currency",
    strategy='check',
    check_cols=['rate_to_usd']
  )
}}

select
  cast(fx_date as date) as fx_date,
  currency,
  cast(rate_to_usd as numeric) as rate_to_usd,
  cast(loaded_at as timestamp) as loaded_at
from {{ ref('raw_fx_rates') }}

{% endsnapshot %}
