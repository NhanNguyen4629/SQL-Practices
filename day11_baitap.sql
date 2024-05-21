--Excecise 1
select country.continent, floor(avg(city.population))
from country 
inner join city 
on country.code=city.countrycode
group by country.continent

  
--Excecise 2
SELECT round(cast(count(t.email_id ) as decimal)/cast(count(e.email_id ) as decimal), 2) as activation_rate
FROM emails as e
LEFT JOIN texts as t
ON e.email_id = t.email_id
AND t.signup_action = 'Confirmed'

  
--Excercise 3
SELECT age.age_bucket,
round(cast((sum(case 
when act.activity_type='send' then act.time_spent else 0 end)*100.0/sum(time_spent)) as decimal),2) as send_per,
(100.0 - round(cast((sum(case 
when act.activity_type='send' then act.time_spent else 0 end)*100.0/sum(time_spent)) as decimal),2)) as open_per
from activities as act
left join age_breakdown as age
on act.user_id=age.user_id
where act.activity_type in('open','send')
group by age.age_bucket 
order by age.age_bucket

  
--Excercise 4
SELECT c.customer_id
FROM customer_contracts as c
inner join products as p
on c.product_id=p.product_id
group by c.customer_id
having count(distinct( p.product_category))=3

  
--Excercise 5
select mng.employee_id, mng.name, count(emp.name)  as reports_count , round(avg(emp.age),0) as average_age
from Employees as emp
left join Employees as mng
on emp.reports_to=mng.employee_id
where mng.employee_id is not null
group by  mng.employee_id, mng.name

  
--Excercise 6
select  p.product_name, sum(unit) as unit
from Products as p
left join  Orders as o
on p.product_id = o.product_id 
where extract(month from o.order_date )=2 and extract(year from o.order_date)=2020
group by p.product_name
having sum(unit)>=100

  
--Excercise 7
SELECT p.page_id
from pages as p
left join page_likes as l
on p.page_id=l.page_id
where l.page_id is null
