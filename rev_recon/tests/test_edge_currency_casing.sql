{{ config(tags=['edge_cases']) }}

-- Fails when currency codes are not uppercase
select
  invoice_id,
  currency
from {{ ref('edge_invoices') }}
where currency <> upper(currency)
