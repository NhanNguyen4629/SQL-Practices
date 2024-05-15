--Excercise 1
select name from students
where marks >75
order by right(name,3),ID
--Excercise 2
select user_id, concat(upper(left(name,1)),lower(right(name,length(name)-1))) as name from Users
order by user_id
--Excercise 3
SELECT manufacturer,'$'||round(sum(total_sales)/1000000,0)||' million' as sale FROM pharmacy_sales
group by (manufacturer)
order by round(sum(total_sales)/1000000,0) desc, manufacturer DESC 
--Excercise 4
SELECT extract(month from submit_date) as month, Product_ID, round(avg(stars),2) as avg_star
FROM reviews
group by product_ID, extract(month from submit_date)
order by month, product_ID
--Excercise 5
SELECT sender_id, count(message_id) as message_count  FROM messages
where extract(month from sent_date)=8 and extract(year from sent_date)=2022
group by sender_id
ORDER BY message_count DESC
limit 2
--Excercise 6
select tweet_id from tweets
where length(content)>15
--Excercise 7

--Excercise 8
select count(id) as number_of_hired  from employees
where (extract(month from joining_date) between 1 and 7) and extract(year from joining_date)=2022
--Excercise 9
select position('a'in first_name ) as position_a_Amitah from worker
where 	first_name = 'Amitah'
--Excercise 10
select title as name, substring( title from (length(winery)+2) for 4) as year from winemag_p2;
