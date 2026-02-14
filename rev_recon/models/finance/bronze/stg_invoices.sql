{{ config(materialized='view', schema='analytics') }}

select
  invoice_id,
  customer_id,
  cast(invoice_date as date) as invoice_date,
  currency,
  cast(amount as numeric) as amount
from {{ ref('raw_erp_invoices') }}
