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
