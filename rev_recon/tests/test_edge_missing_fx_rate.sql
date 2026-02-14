{{ config(tags=['edge_cases']) }}

-- Fails when an invoice has no FX rate for the same date/currency
select
  i.invoice_id,
  i.invoice_date,
  i.currency
from {{ ref('edge_invoices') }} i
left join {{ ref('edge_fx_latest') }} f
  on f.fx_date = i.invoice_date
 and f.currency = i.currency
where i.currency <> 'USD'
  and f.rate_to_usd is null
