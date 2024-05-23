--Excercise 1
select count(distinct( company_id)) from job_listings
where company_id in (select company_id from job_listings
group by company_id 
having count(title)>1 and count(description)>1)

--Excercise 2
select category, product, sum(spend) as total_spend
from product_spend 
where extract (year from transaction_date)=2022 
group by category, product
having sum(spend) in (select sum(spend) 
from product_spend
where category='appliance' 
and extract(year from transaction_date)=2022
group by product,category
ORDER BY sum(spend) desc
limit 2) or sum(spend) in (select sum(spend) 
from product_spend
where category='electronics'
and extract(year from transaction_date)=2022
group by product,category
ORDER BY sum(spend) desc
limit 2)
order by category, sum(spend) desc

--Excercise 3
select count(distinct(policy_holder_id)) from callers
where policy_holder_id in (select policy_holder_id from callers
group by policy_holder_id
having count(case_id)>=3)

--Excercise 4
select a.page_id
from pages as a
left join page_likes as b on a.page_id=b.page_id
where b.page_id is null
order by a.page_id 

--Excercise 6
 with approved as(select country, concat(year(trans_date),'-',month(trans_date)) as month, count(id) as approved_count,
sum(amount) as approved_total_amount from Transactions
where state='approved'
group by country, concat(year(trans_date),'-',month(trans_date))),
total as(select country, concat(year(trans_date),'-',month(trans_date)) as month, count(id) as trans_count,
sum(amount) as trans_total_amount from Transactions
group by country, concat(year(trans_date),'-',month(trans_date)))
select a.month,
a.country, a.trans_count,b.approved_count, a.trans_total_amount,b.approved_total_amount 
from total as a
left join approved as b on a.country=b.country
where a.month=b.month

--Excercise 7
select product_id, year as first_year,quantity,price from sales 
where  year in (select min(year)from sales group by product_id)

--Excercise 8
