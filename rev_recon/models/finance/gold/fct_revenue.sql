{{
  config(
    materialized='incremental',
    schema='analytics',
    unique_key='invoice_id',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
  )
}}

select
    b.invoice_id,
    b.customer_id,
    b.invoice_date,
    b.period,
    b.currency,   
    b.gross_revenue_usd,
    coalesce(c.credit_usd, 0) as credit_usd,
    b.gross_revenue_usd - coalesce(c.credit_usd, 0) as net_revenue_usd
from {{ ref('int_revenue_base') }} b
left join {{ ref('int_credit_agg') }} c
  on b.invoice_id = c.invoice_id
{% if is_incremental() %}
where b.invoice_date >= (
  select coalesce(max(invoice_date), '1900-01-01'::date) from {{ this }}
)
{% endif %}
