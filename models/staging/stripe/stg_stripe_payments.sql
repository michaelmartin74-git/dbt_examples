with 

--raw
source as (

    select * from {{ source('stripe', 'payment') }}

),

transformed as (

    select
        id as customer_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as payment_status,
        {{ convert_to_decimals('amount', 2) }} as payment_amount,
        created as payment_created_at,
        _batched_at

    from source

)

select * from transformed