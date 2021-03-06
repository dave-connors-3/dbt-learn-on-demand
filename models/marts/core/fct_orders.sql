with orders as (

    select  * from {{ref('stg_orders')}}
),

order_payments as (

    select  * from {{ref('stg_order_payments')}}
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.ordered_at,
        coalesce(order_payments.total_order_amount,0) as amount

    from orders
    left join order_payments
        on orders.order_id = order_payments.order_id
)

select * from final
