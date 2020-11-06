with final as (

    select
        id as payment_id, 
        orderid as order_id,
        paymentmethod as payment_method,
        status,
        (amount/100)::int as amount,
        created as created_at,
        status = 'fail' as is_failed
    from    
        raw.stripe.payment
)

select * from final