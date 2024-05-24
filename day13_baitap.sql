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

--Excercise 5
 SELECT cast(extract(month from event_date) as int) as month,count(distinct(user_id))
from user_actions
where (event_date between '07/01/2022' and '08/01/2022')
and user_id in (SELECT user_id
from user_actions
where event_date between '06/01/2022' and '07/01/2022')
group by cast(extract(month from event_date) as int)
 
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
select customer_id from Customer 
group by customer_id
having count(distinct(product_key))=(select count(distinct(product_key)) from product)

--Excercise 9
select employee_id from employees
where salary<30000 and
manager_id not in (select distinct employee_id from Employees )

--Excercise 10
select employee_id,department_id from employee
where primary_flag='Y' or 
employee_id in(select employee_id from employee 
group by employee_id
having count(department_id)=1)

--Excercise 11
with greatest_user as(select a.name as results
from users as a
join MovieRating as b on a.user_id=b.user_id
group by a.name
order by count(b.rating) desc, name
limit 1),
highest_rated as (select b.title as results  
from movies as b 
join MovieRating as c on b.movie_id=c.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by b.title
order by avg(c.rating) desc, b.title 
limit 1)
select results from greatest_user
UNION ALL
select results from highest_rated

--Excercise 12
with requester as(select requester_id as id, count(accepter_id ) as num  from RequestAccepted
group by requester_id),
accepter as (select accepter_id as id, count(requester_id) as num from RequestAccepted
group by accepter_id ),
total as(select id,num from requester
UNION ALL 
select id,num from accepter)
select id, sum(num) as num from total
group by id 
order by sum(num) desc
limit 1 
