{{ config(materialized='table', schema='analytics') }}

with invoices as (

    select
        invoice_id,
        customer_id,
        invoice_date,
        date_trunc('month', invoice_date) as period,
        currency,
        amount as gross_amount
    from {{ ref('stg_invoices') }}

),

credits as (

    select
        invoice_id,
        sum(amount) as credit_amount
    from {{ ref('stg_credit_notes') }}
    group by 1

),

fx as (

    select
        fx_date::date as fx_date,
        currency,
        rate_to_usd
    from {{ ref('stg_fx_rates') }}
    where currency is not null

)

select
    i.invoice_id,
    i.customer_id,
    i.period,
    i.currency,

    cast(i.gross_amount as numeric) as gross_amount,
    cast(coalesce(c.credit_amount, 0) as numeric) as credit_amount,

    cast((i.gross_amount - coalesce(c.credit_amount, 0)) as numeric) as net_amount_local,

    cast(coalesce(fx.rate_to_usd, 1) as numeric) as rate_to_usd,

    cast((i.gross_amount - coalesce(c.credit_amount, 0)) * coalesce(fx.rate_to_usd, 1) as numeric)
        as net_revenue_usd,

    abs(cast((i.gross_amount - coalesce(c.credit_amount, 0)) * coalesce(fx.rate_to_usd, 1) as numeric))
        as abs_amount_usd

from invoices i
left join credits c
  on i.invoice_id = c.invoice_id
left join fx
  on i.currency = fx.currency
 and i.invoice_date = fx.fx_date
