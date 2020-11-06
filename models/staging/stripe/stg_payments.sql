with final as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status,
        round(amount/100,2) as amount,
        created as created_at,
        status = 'fail' as is_failed
    from
        {{ source('stripe', 'payment') }}
)

select * from final
