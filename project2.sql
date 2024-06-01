select year||'-'||month as month_year, total_user, total_order from( select count(distinct(user_id)) as total_user ,count(order_id) as total_order, 
extract (year from created_at) as year, extract(month from created_at) as month from bigquery-public-data.thelook_ecommerce.orders
where status ='Complete' and (created_at between '2019-01-01' and '2022-05-01')
group by extract (year from created_at), extract(month from created_at)) as a
order by year, month

 select  * from( select count(distinct(user_id)) as total_user ,count(order_id) as total_order, 
substring(cast(created_at as string),1,7) as month_year from bigquery-public-data.thelook_ecommerce.orders
where status ='Complete' and (created_at between '2019-01-01' and '2022-05-01')
group by substring(cast(created_at as string),1,7))
order by month_year
--Nhận xét: lượng KH và order tăng theo thời gian

 with cte_value as(select extract(year from a.created_at)as year, extract(month from a.created_at) as month , 
a.user_id ,a.num_of_item as num, b.sale_price,a.order_id
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
where (a.created_at between '2019-01-01' and '2022-05-01') and a.status='Complete')
select year||'-'||month as month_year, 
count(distinct(user_id)) as distinct_user,
round(sum(num*sale_price)/count(order_id),2) as average_order_value
from cte_value
group by year,month
order by year,month
--Nhận xét: từ 1/2019-4/2022lượng khách hàng có xu hướng tăng mạnh, tuy có một số tháng giảm nhưng không đáng kể
  
with user_infor as(select a.order_id,a.user_id,b.first_name,b.last_name, b.age,b.gender
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.users as b on a.user_id=b.id
where (a.created_at between '2019-01-01' and '2022-05-01') and a.status='Complete'),
min_max_age as(select gender, min(age) as min_age,max(age) as max_age from user_infor 
group by gender)
select a.first_name,a.last_name,a.gender,a.age,
case when a.age=b.min_age then 'youngest'else 'oldest' end as tag
from user_infor as a
join min_max_age as b on a.gender=b.gender
where a.age=b.min_age or a.age=b.max_age
--Nhận xét: Female:youngest_60 KH, oldest_76 KH
  --        Male: youngest_72 KH, oldest_56 KH 

with sale as(select extract(year from a.created_at) as year, extract(month from a.created_at) as month, 
a.order_id, b.product_id,c.name, a.num_of_item as num,b.sale_price as sales, c.cost, 
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where a.status='Complete'),
rank_of_month as (select year||'-'||month as month_year,product_id, name, sales, cost, (sales-cost)*num as profit,
dense_rank() over (partition by year,month order by (sales-cost)*num desc) as rank_per_month
from sale
order by year, month)
select * from rank_of_month
where rank_per_month between 1 and 5


select * from(select cast(a.created_at as date) as dates,c.category,sum(a.num_of_item*b.sale_price) as revenue
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where a.status='Complete' and a.created_at between '2022-01-15'and'2022-04-16'
group by cast(a.created_at as date), c.category)
order by dates







with cte as (select extract(year from a.created_at) as year,
extract(month from a.created_at ) as month,
c.category, a.num_of_item as num,b.sale_price as price,a.order_id,c.cost
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where a.status='Complete'),
cte1 as(select *,
sum(num*price) over (partition by year,month) as TPV,
count(order_id) over (partition by year,month) as TPO,
sum(cost*num) over (partition by year,month) as total_cost,
sum(num*price-cost*num) over (partition by year,month) as total_profit,
from cte
order by year,month),
cte2 as(select *,
total_profit/total_cost as profit_to_cost_ratio 
 from cte1)
 select*,((tpv-lag(tpv)over(order by year,month))/(lag(tpv)over(order by year,month)))||' %' as revenue_growth from (select distinct month,year,tpv,
from cte2 )
order by year, month
