-- Adjust if in your case it can be negative
select *
from {{ ref('fct_revenue_recon_detail') }}
where net_revenue_usd < 0
