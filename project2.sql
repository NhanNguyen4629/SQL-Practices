select year||'-'||month as month_year, total_user, total_order from( select count(distinct(user_id)) as total_user ,count(order_id) as total_order, extract (year from created_at) as year, extract(month from created_at) as month from bigquery-public-data.thelook_ecommerce.orders
where status ='Complete' and (created_at between '2019-01-01' and '2022-05-01')
group by extract (year from created_at), extract(month from created_at)) as a
order by year, month

with user_infor as (select a.order_id,a.user_id,b.first_name, b.last_name,b.age,b.gender, a.created_at
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.users as b on a.user_id=b.id
where a.created_at between '2019-01-01' and '2022-05-01'),
min_max_age as(select gender, min(age), max(age) from user_infor 
group by gender),--min(F)=12,max(F)=70,min(M)=12, max(M)=70
user_min_max as(Select first_name, last_name,gender,age,
case when age=12 then 'youngest' else 'oldest' end as tag
from user_infor 
where age in(12,70) )
select count(age) as count, gender,tag from user_min_max
group by gender,tag
--Female: Trẻ nhất 12 tuổi_259 KH, lớn nhất 70 tuổi_251 KH
--Male: trẻ nhất 12 tuổi_222 KH, lớn nhất 70 tuổi_265 KH


with abc as(select a.order_id, a.created_at,a.num_of_item, b.product_id,c.name, c.cost,b.sale_price
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where a.status ='Complete'),
profit_total as (select extract(year from created_at) as year, extract(month from created_at) as month,
product_id, name as product_name, sale_price as sales, cost, 
(sale_price-cost)*num_of_item as profit from abc),
top as( select year||'-'||month as month_year, product_id, product_name, sales, cost, profit,
dense_rank() over (partition by month,year order by profit desc ) as rank1
from profit_total
order by year,month)
select * from top
where rank1 between 1 and 5
