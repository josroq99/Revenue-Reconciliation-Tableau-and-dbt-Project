{{ config(tags=['edge_cases']) }}

-- Ensures conversion math matches within rounding tolerance
select
  invoice_id,
  amount,
  rate_to_usd,
  converted_amount
from {{ ref('edge_revenue_calc') }}
where rate_to_usd is not null
  and abs(converted_amount - (amount * rate_to_usd)) > 0.0001
