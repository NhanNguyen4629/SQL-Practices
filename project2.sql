select year||'-'||month as month_year, total_user, total_order from( select count(distinct(user_id)) as total_user ,count(order_id) as total_order, extract (year from created_at) as year, extract(month from created_at) as month from bigquery-public-data.thelook_ecommerce.orders
where status ='Complete' and (created_at between '2019-01-01' and '2022-05-01')
group by extract (year from created_at), extract(month from created_at)) as a
order by year, month

select year||'-'||month as month_year,distinct_user,avg_order_value from (select count(distinct(a.user_id)) as distinct_user, round(avg(b.sale_price),2)as avg_order_value ,extract(year from a.created_at) as year, extract(month from a.created_at) as month
from bigquery-public-data.thelook_ecommerce.orders as a
join  bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
where a.created_at between '2019-01-01' and '2022-05-01' 
group by extract(year from a.created_at),extract(month from a.created_at))
order by year,month
