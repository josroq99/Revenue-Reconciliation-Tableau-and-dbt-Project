{{ config(tags=['edge_cases']) }}

-- Ensures FX latest logic produces a single rate per date/currency
select
  fx_date,
  currency,
  count(*) as rate_count
from {{ ref('edge_fx_latest') }}
group by 1, 2
having count(*) > 1
