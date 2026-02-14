-- Ensures MXN FX rates are within a reasonable range
select *
from {{ ref('stg_fx_rates') }}
where currency = 'MXN'
  and (rate_to_usd < 0.04 or rate_to_usd > 0.08)
