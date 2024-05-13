--Excercise 1
select distinct CITY from STATION
where ID %2=0 
--Excercise 2
select count(CITY)-count(distinct(CITY)) from STATION 
--Excercise 3

--Excercise 4
SELECT round(cast(sum(item_count *order_occurrences)/sum(order_occurrences)as decimal),1)as mean from items_per_order
--Excercise 5
SELECT candidate_id FROM candidates
group by candidate_id
having count(skill) = 3
