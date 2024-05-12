--Excercise 1
select NAME from CITY
where POPULATION>120000 and COUNTRYCODE='USA';
--Exercise 2
select * from CITY 
where COUNTRYCODE ='JPN';
--Excercise 3
select CITY, STATE from STATION; 
--Excercise 4
select distinct CITY from STATION
where CITY like 'A%' or CITY like 'E%' or CITY like 'I%' or CITY like 'O%' or CITY like 'U%';
--Excercise 5
select distinct CITY from STATION
where CITY like '%a' or CITY like '%e' or CITY like '%i' or CITY like '%o' or CITY like '%u';
--Excercise 6
select distinct CITY from STATION
where CITY not like 'A%' and CITY not like 'E%' and CITY not like 'I%' and CITY not like 'O%' and CITY not like 'U%';
--Excercise 7
select name from Employee
order by name;
--Excercise 8
select name from Employee
where salary > 2000 and months < 10 
order by employee_id;
--Excercise 9
select product_id from products 
where low_fats = 'Y' and recyclable = 'Y';
--Excercise 10
select name from Customer
where referee_id <> 2 or referee_id is null;
--Excercise 11
select  name, population, area  from World
where area >=3000000 or population >=25000000
order by name;
--Excercise 12 
select distinct author_id as id from views 
where author_id=viewer_id
order by author_id;
--Excercise 13
SELECT * FROM parts_assembly
where finish_date is null;
--Excercise 14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary>=70000;
--Excercise 15
select advertising_channel from uber_advertising
where money_spent >100000;

