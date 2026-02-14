select *
from {{ ref('fct_revenue_recon_detail') }}
where net_amount_local != (gross_amount - credit_amount)
