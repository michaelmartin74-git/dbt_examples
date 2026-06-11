{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

with 

paid_orders as (
    select * from {{ ref('int_orders') }}
),

final as (
    select
         order_id
        ,customer_id
        ,order_placed_at
        ,order_status
        ,total_amount_paid
        ,payment_finalized_date
        ,given_name
        ,last_name
        ,new_vs_return
        ,transaction_seq
        ,customer_sales_seq
        ,first_order_date
        -- NOTE: scalar aggregation like this requires checking window semantics 
        -- if group by all is retained, but keeping your original logic intact here
        ,sum(total_amount_paid) as customer_lifetime_value
    from paid_orders

    {% if is_incremental() %}
    -- The incremental filter must live inside the WHERE clause of the CTE pulling data
    where order_placed_at >= (select coalesce(max(order_placed_at), '1900-01-01') from {{ this }} )
    {% endif %}

    group by all
)

select * from final
order by order_id