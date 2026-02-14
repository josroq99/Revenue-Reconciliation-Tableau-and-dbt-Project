-- Ensures credit note currency matches the invoice currency
select
  c.invoice_id,
  c.currency as credit_currency,
  i.currency as invoice_currency
from {{ ref('stg_credit_notes') }} c
join {{ ref('stg_invoices') }} i
  on c.invoice_id = i.invoice_id
where c.currency <> i.currency
