{{ config(enabled = false) }}

select
    customer_id, 
    avg(payment_amount) as average_amount
from {{ ref('stg_stripe_payments') }}
group by 1
having count(customer_id) > 1 and average_amount < 1