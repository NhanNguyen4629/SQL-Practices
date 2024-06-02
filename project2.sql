--II.1.Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select * from(select format_date('%Y-%m',created_at) as month_year,count(distinct(user_id)) as total_user ,count(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
where status ='Complete' and (created_at between '2019-01-01' and '2022-05-01')
group by format_date('%Y-%m',created_at))
order by month_year
--Nhận xét: lượng KH và order tăng theo thời gian, có tháng giảm nhưng không đáng kể
 
--II.2.Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
 select * from (select format_date('%Y-%m', created_at ) as month_year,
count(distinct(user_id)) as distinct_user,
round(sum(sale_price)/(count(order_id)),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where format_date('%Y-%m', created_at ) between '2019-01' and '2022-04'
group by format_date('%Y-%m', created_at )) 
order by month_year
 
--II.3.Nhóm khách hàng theo độ tuổi
with cte as (select a.user_id,b.first_name,b.last_name,b.gender,b.age
  from bigquery-public-data.thelook_ecommerce.orders as a
  join bigquery-public-data.thelook_ecommerce.users as b on a.user_id=b.id
  where a.created_at between '2019-01-01' and '2022-05-01'),
age as(select min(age) as minage,max(age) as maxage,gender from cte
group by gender)
select a.first_name, a.last_name,a.gender, a.age,
case when a.age=b.minage then 'youngest' else 'oldest' end as tag
 from cte as a
join age as b on a.gender=b.gender
where a.gender=b.gender and a.age=b.minage or a.age=b.maxage
--Nhận xét: Female:youngest_222 KH, oldest_194 KH
  --        Male: youngest_224 KH, oldest_203 KH 
 
-II.4.Top 5 sản phẩm mỗi tháng
with sale as(select format_date('%Y-%m',a.created_at) as month_year, 
b.product_id,c.name, round(sum(b.sale_price),2) as sales, round(sum(c.cost),2) as cost, 
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where a.status='Complete'
group by format_date('%Y-%m',a.created_at),b.product_id,c.name)
select * from (select *, round(sales-cost,2) as profit ,
dense_rank() over(partition by month_year order by (sales-cost) desc) as topprofit from sale)
where topprofit between 1 and 5
order by month_year

  
--II.5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
select*from(select cast(a.created_at as date)as dates, c.category as product_categories,
round(sum(b.sale_price),2) as revenue
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id  
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where a.status='Complete' and a.created_at between '2022-01-15'and'2022-04-16' 
group by cast(a.created_at as date), c.category) order by dates

--III.1. tạo dataset
with cte1 as(select format_date('%Y-%m',a.created_at) as month, format_date('%Y',a.created_at) as year,
c.category as product_category,round(sum(b.sale_price),2) as TPV, round(sum(a.order_id),2) as TPO, 
round(sum(c.cost),2) as total_cost
from bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where a.status='Complete'
group by format_date('%Y-%m',a.created_at) , format_date('%Y',a.created_at),
c.category)
select *,
round(cast((TPV - lag(TPV) over(partition by product_category order by month))/
lag(TPV) over(partition by product_category order by month) as Decimal)*100.00,2) || '%'
as revenue_growth,
round(cast((TPO - lag(TPO) over(partition by product_category order by month))/
lag(TPO) over(partition by product_category order by month) as Decimal)*100.00,2) || '%'
as order_growth,
 round(TPV-total_cost,2) as total_profit,
 round((TPV-total_cost)/total_cost,2) as profit_to_cost_ratio from cte1
order by month

--III.2.Retention cohort
with user_order as(select order_id,user_id, created_at
from bigquery-public-data.thelook_ecommerce.orders),
cohort_index as(select user_id,order_id,format_date('%Y-%m',created_at)as cohort_date, 
((extract(year from created_at)-extract(year from first_day))*12+(extract(month from created_at)-extract(month from first_day)+1)) as index from (select *,min(created_at) over (partition by user_id) as first_day from user_order)),
cohort as(select cohort_date, index, count(distinct(user_id))as user,count(order_id) as orders from cohort_index
where index between 1 and 3
group by cohort_date, index),
user_cohort as(select cohort_date,
sum(case when index=1 then user else 0 end) as m1,
sum(case when index=2 then user else 0 end) as m2,
sum(case when index=3 then user else 0 end) as m3 from cohort
group by cohort_date)
select cohort_date ,
round(100*m1/m1,2)||'%' as m1,
round(100*m2/m1,2)||'%' as m2,
round(100*m3/m1,2)||'%' as m3
from user_cohort
order by cohort_date
