--1
select productline,year_id,dealsize,
sum(quantityordered*priceeach) as revenue
from public.sales_dataset_rfm_prj
group by productline,year_id,dealsize
order by year_id
--2
select month_id, sum(quantityordered*priceeach) as revenue, 
count(ordernumber) as order_number from public.sales_dataset_rfm_prj
group by month_id
order by sum(quantityordered*priceeach) desc
--3
select month_id,productline,
sum(quantityordered*priceeach) as revenue,
dense_rank() over (order by sum(quantityordered*priceeach) desc) as rank
from public.sales_dataset_rfm_prj
where month_id=11
group by month_id,productline
--4
select year_id, productline, sum(quantityordered*priceeach) as revenue,
dense_rank() over (partition by year_id order by sum(quantityordered*priceeach) desc) as rank
from public.sales_dataset_rfm_prj
where country='UK'
group by year_id, productline
--5
with customer_rfm as(select customername,
current_date-max(orderdate) as R,
Count(ordernumber) as F,
Sum(quantityordered*priceeach) as M
from public.sales_dataset_rfm_prj
group by customername),
rfm_scores as (select customername,
ntile(5) OVER(ORDER BY R desc) as R_score,
ntile(5) OVER(ORDER BY F desc) as F_score,
ntile(5) OVER(ORDER BY M desc) as M_score
from customer_rfm),
rfm_score as(select customername,
cast(R_score as varchar)||cast(F_score as varchar)||cast(M_score as varchar) as rfm_score
from rfm_scores)
select count(a.customername),b.segment
from rfm_score as a
join public.segment_score as b on a.rfm_score = b.scores
group by b.segment
order by count(a.customername) desc
