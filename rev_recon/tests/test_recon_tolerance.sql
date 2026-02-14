{{ config(severity='warn') }}

-- Fails when monthly variance exceeds tolerance
-- Change 50 to the threshold you want
select *
from {{ ref('audit_revenue_vs_ledger') }}
where abs(delta_usd) > 50