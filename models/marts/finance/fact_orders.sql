 select
 id as customer_id
,orderid as order_id
,paymentmethod as payment_method
,status
,case when status = 'success' then amount end as amount
,created as order_date
from dbt-tutorial.stripe.payment 