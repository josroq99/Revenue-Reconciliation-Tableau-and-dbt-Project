{{ config(materialized='view', schema='analytics') }}

with modeled as (
  select
    period,
    sum(net_revenue_usd) as modeled_revenue_usd
  from {{ ref('fct_revenue') }}
  group by 1
),

ledger as (
  select
    period,
    sum(amount_usd) as ledger_revenue_usd
  from {{ ref('stg_gl_ledger') }}
  where account = 'Revenue'
  group by 1
)

select
  coalesce(m.period, l.period) as period,
  coalesce(m.modeled_revenue_usd, 0) as modeled_revenue_usd,
  coalesce(l.ledger_revenue_usd, 0) as ledger_revenue_usd,
  coalesce(m.modeled_revenue_usd, 0) - coalesce(l.ledger_revenue_usd, 0) as delta_usd
from modeled m
full outer join ledger l using (period)

