with 

--raw
source as (

    select * from {{ source('jaffle_shop', 'customers') }}

),

--staging
transformed as (

    select
        id as customer_id,
        first_name as given_name,
        last_name as last_name,
        first_name || ' ' || last_name as full_name
    from source

)

select * from transformed