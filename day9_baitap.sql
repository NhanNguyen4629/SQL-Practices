--Excercise 1
SELECT 
sum(case
when device_type = 'laptop' then 1
else 0
end) as laptop_reviews,
sum(case
when device_type in ('phone','tablet') then 1
else 0
end) as mobile_reviews
from viewership
--Excercise 2
select * ,
case 
  when x+y>z then 'Yes'
  else 'No' 
end as 'Triangle'
from Triangle
--Excercise 3
SELECT  
round(cast((sum(CASE
when COALESCE(call_category,'null') in ('n/a','null') then 1
else 0
end)) as decimal)*100/200,1) as categorised_call
from callers
