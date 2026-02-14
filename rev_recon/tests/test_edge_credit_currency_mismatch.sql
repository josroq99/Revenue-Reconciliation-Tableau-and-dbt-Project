{{ config(tags=['edge_cases']) }}

-- Fails when credit currency differs from invoice currency
select
  c.invoice_id,
  c.currency as credit_currency,
  i.currency as invoice_currency
from {{ ref('edge_credit_notes') }} c
join {{ ref('edge_invoices') }} i
  on c.invoice_id = i.invoice_id
where c.currency <> i.currency
