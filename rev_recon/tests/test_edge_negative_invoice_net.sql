{{ config(tags=['edge_cases']) }}

-- Ensures net math holds even for negative invoices
select
  invoice_id,
  amount,
  credit_amount,
  net_amount_local
from {{ ref('edge_revenue_calc') }}
where net_amount_local <> (amount - credit_amount)
