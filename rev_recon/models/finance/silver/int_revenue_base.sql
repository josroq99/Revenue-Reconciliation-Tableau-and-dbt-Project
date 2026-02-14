{{ config(materialized='view', schema='analytics') }}

with inv as (
  select
    invoice_id,
    customer_id,
    invoice_date,
    currency,
    amount as gross_amount
  from {{ ref('stg_invoices') }}
),

fx as (
  select
    fx_date,
    currency,
    rate_to_usd
  from {{ ref('stg_fx_rates') }}
),

inv_fx as (
  select
    i.invoice_id,
    i.customer_id,
    i.invoice_date,
    to_char(date_trunc('month', i.invoice_date), 'YYYY-MM') as period,
    i.currency,
    i.gross_amount,
    f.rate_to_usd,
    (i.gross_amount * f.rate_to_usd) as gross_revenue_usd
  from inv i
  left join fx f
    on f.fx_date = i.invoice_date
   and f.currency = i.currency
)

select
  invoice_id,
  customer_id,
  invoice_date,
  period,
  currency,
  gross_amount,
  rate_to_usd,
  gross_revenue_usd
from inv_fx
