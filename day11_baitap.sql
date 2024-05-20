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

--Excercise 4
SELECT c.customer_id
FROM customer_contracts as c
inner join products as p
on c.product_id=p.product_id
group by c.customer_id
having count(distinct( p.product_category))=3
--Excercise 5
select emp.reports_to as employee_id , mng.name, count(emp.employee_id) as reports_count, ceiling(avg(emp.age)) as average_age
from Employees as emp
left join Employees as mng
on emp. reports_to=mng.employee_id
where  coalesce(emp.reports_to,'null') <> 'null'
