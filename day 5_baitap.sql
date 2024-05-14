--Excercise 1
select distinct CITY from STATION
where ID %2=0 
--Excercise 2
select count(CITY)-count(distinct(CITY)) from STATION 
--Excercise 3

--Excercise 4
select round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1)
from items_per_order 
--Excercise 5
SELECT candidate_id FROM candidates
group by candidate_id
having count(skill) = 3
--Excercise 6
SELECT user_id, max(date(post_date))-min(date(post_date)) as days_between FROM posts
where post_date between '01/01/2021' and '01/01/2022'
group by user_id
having count(post_id)>1
--Excercise 7
SELECT card_name, max(issued_amount)-min(issued_amount) as difference FROM monthly_cards_issued
group by card_name
order by difference desc
--Excercise 8
SELECT  manufacturer, count(drug) as drug, abs(sum(total_sales-cogs)) as total_loss FROM pharmacy_sales
where total_sales-cogs < 0
group by manufacturer
order by total_loss desc
--Excercise 9
select id, movie, description, rating from Cinema
where (id=1 or id%2<>0) and description <> 'boring'
order by rating desc
--Excercise 10
select teacher_id, count(distinct(subject_id)) as cnt from Teacher
group by teacher_id
--Excercise 11
select user_id, count(follower_id) as followers_count from  Followers
where user_id <> follower_id
group by user_id
order by user_id 
--Excercise 12
select class from Courses 
group by class
having count(student)>=5
