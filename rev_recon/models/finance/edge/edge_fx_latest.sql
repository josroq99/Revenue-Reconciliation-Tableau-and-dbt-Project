{{ config(materialized='view', schema='analytics_edge') }}

{% if var('use_fx_snapshot', false) %}
select
  fx_date,
  currency,
  rate_to_usd,
  loaded_at
from {{ ref('fx_rates_snapshot') }}
where dbt_valid_to is null
{% else %}
select distinct on (fx_date, currency)
  fx_date,
  currency,
  rate_to_usd,
  loaded_at
from {{ ref('edge_fx_rates') }}
order by fx_date, currency, loaded_at desc
{% endif %}
