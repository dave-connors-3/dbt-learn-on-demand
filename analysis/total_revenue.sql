with

payments as (

    select * from {{ ref('stg_payments') }}

),

final as (

    select
        sum(amount) as total_revenue

    from payments
    where is_failed = false
)

select * from final
