-- Fails when there are invoices with currency != USD and no rate_to_usd
select *
from {{ ref('fct_revenue_recon_detail') }}
where currency != 'USD'
  and (rate_to_usd is null or rate_to_usd = 1)
