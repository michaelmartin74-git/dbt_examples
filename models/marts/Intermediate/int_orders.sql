{{ 
    config(
        meta={
            "required_tests": None
        } 
    ) 
}}

with

 orders as (select * from {{ ref('stg_orders') }})

,payments as (select * from {{ ref('stg_stripe_payments') }})

,customers as (select * from {{ ref('stg_customers') }})

,customer_orders as (
select 
 customers.customer_id
,min(orders.order_date) as first_order_date
,max(orders.order_date) as most_recent_order_date
,count(orders.order_id) as number_of_orders
from customers
left join orders
    on orders.customer_id = customers.customer_id
group by 1
)

,total_paid as (
select 
 order_id
,max(payment_created_at) as payment_finalized_date
,sum(payment_amount) as total_amount_paid
from payments
where payment_status <> 'fail'
group by 1
)

,paid_orders as (
select 
 orders.order_id
,orders.customer_id
,orders.order_date as order_placed_at
,orders.order_status
,total_paid.total_amount_paid
,total_paid.payment_finalized_date
,customers.given_name
,customers.last_name
,case
    when row_number() over (
        partition by orders.customer_id
        order by orders.order_date, orders.order_id 
    ) = 1
    then 'new'
    else 'return'
  end as new_vs_return
,row_number() over (
    order by orders.order_id
    ) as transaction_seq
,row_number() over (
    partition by customer_orders.customer_id 
    order by orders.order_id
    ) as customer_sales_seq
,customer_orders.first_order_date
from orders
left join customer_orders
    on customer_orders.customer_id = orders.customer_id
left join total_paid 
    ON orders.order_id = total_paid.order_id
left join customers 
    on orders.customer_id = customers.customer_id 
)

select * from paid_orders