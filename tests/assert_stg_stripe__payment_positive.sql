select
 order_id
,sum(payment_amount) as total_amount
from {{ref('stg_stripe_payments')}}
group by all
having total_amount < 0