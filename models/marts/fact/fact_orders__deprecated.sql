 
 
 select
 customer_id
,order_id
,payment_method
,payment_status
--,case when payment_status = 'success' then payment_amount end as amount
,payment_amount as amount --creates example for dbt show -s compare_queries   
,payment_created_at as order_date
from {{ ref('stg_stripe_payments') }}