{{ config(materialized='view', schema='analytics_edge') }}

select
  invoice_id,
  customer_id,
  cast(invoice_date as date) as invoice_date,
  cast(loaded_at as timestamp) as loaded_at,
  currency,
  cast(amount as numeric) as amount
from {{ ref('raw_erp_invoices_edge') }}
