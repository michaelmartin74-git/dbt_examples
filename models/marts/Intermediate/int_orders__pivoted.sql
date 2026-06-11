{{ 
    config(
        meta={
            "required_tests": None
        } 
    ) 
}}

{%- set payment_method = ['credit_card','bank_transfer','coupon','gift_card'] -%}

with

orders as (
    select * from {{ ref('fact_orders') }}
)

select
 order_id,
{% for method in payment_method %}
 sum(case when payment_method = '{{method}}' then amount else 0 end) as {{method}}_amount
    {%- if not loop.last -%}
    ,
    {%- endif -%}
{% endfor %}
from orders
group by order_id