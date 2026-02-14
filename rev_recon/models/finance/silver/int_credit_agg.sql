{{ config(materialized='view', schema='analytics') }}

with cr as (
    select
        invoice_id,
        credit_date,
        currency,
        amount as credit_amount
    from {{ ref('stg_credit_notes') }}
),

fx as (
    select
        fx_date,
        currency,
        rate_to_usd
    from {{ ref('stg_fx_rates') }}
),

cr_fx as (
    select
        c.invoice_id,
        (c.credit_amount * f.rate_to_usd) as credit_amount_usd
    from cr c
    left join fx f
      on f.fx_date = c.credit_date
     and f.currency = c.currency
)

select
    invoice_id,
    sum(credit_amount_usd) as credit_usd
from cr_fx
group by 1
