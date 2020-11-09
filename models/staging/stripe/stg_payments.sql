with

payments as (

    select * from {{ source('stripe', 'payment') }}

),

final as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status,
        {{ cents_to_dollars('amount') }} as amount,
        created as created_at,
        status = 'fail' as is_failed

    from payments
)

select * from final
