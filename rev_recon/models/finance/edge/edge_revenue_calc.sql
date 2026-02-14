{{ config(materialized='view', schema='analytics_edge') }}

select
  i.invoice_id,
  i.invoice_date,
  i.currency,
  i.amount,
  f.rate_to_usd,
  (i.amount * f.rate_to_usd) as converted_amount,
  coalesce(c.credit_amount, 0) as credit_amount,
  (i.amount - coalesce(c.credit_amount, 0)) as net_amount_local
from {{ ref('edge_invoices') }} i
left join {{ ref('edge_fx_latest') }} f
  on f.fx_date = i.invoice_date
 and f.currency = i.currency
left join {{ ref('edge_credit_agg') }} c
  on c.invoice_id = i.invoice_id
