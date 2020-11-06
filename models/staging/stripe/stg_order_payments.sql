with final as (

    select 
        order_id, 
        
        sum(amount) as total_order_amount,
        count(*) as total_payments
    
    from
        {{ref('stg_payments')}}
    where
        is_failed = false

    group by 1

)

select * from final