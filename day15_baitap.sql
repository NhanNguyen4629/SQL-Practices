--Excerxise 1
select extract(year from transaction_date) as year,product_id, spend as curr_year_spend,  
Lag(spend) OVER (PARTITION BY product_id ORDER BY extract(year from transaction_date)) as prev_year_spend,
round((spend-Lag(spend) OVER (PARTITION BY product_id ORDER BY extract(year from transaction_date)))*100/
Lag(spend) OVER (PARTITION BY product_id ORDER BY extract(year from transaction_date)),2) as yoy_rate
from user_transactions

--Excercise 2
SELECT DISTINCT card_name , 
first_value(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year) as issued_amount
FROM monthly_cards_issued
order by first_value(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year)desc

--Excercise 3
with rank2 as(select *,
ROW_NUMBER ()OVER (PARTITION BY user_id ORDER BY transaction_date ) as rank1
from transactions )
select user_id, spend,transaction_date  from rank2
where rank1=3

--Excercise 4
with a as(select transaction_date,user_id, count(product_id) as purchase_count,
row_number() over(partition by user_id order by transaction_date desc) as stt_ngay
from user_transactions 
group by transaction_date,user_id)
select transaction_date,user_id,purchase_count from a
where stt_ngay=1
order by transaction_date

--Excercise 5
SELECT user_id , tweet_date,
round(avg(tweet_count) over (partition by user_id order by tweet_date rows between 2 preceding and current row ),2) as rolling_avg
FROM tweets

--Excercise 6
select count(merchant_id) from (select * ,
lag(transaction_timestamp) over(partition by merchant_id,credit_card_id,amount order by transaction_timestamp) as prev,
first_value(amount) over (partition by merchant_id,credit_card_id,amount order by transaction_timestamp) as first_amount
from transactions ) as a
where (extract(epoch from a.transaction_timestamp)-extract(epoch from a.prev))between 1 and 600

 
--Excercise 7
with a as(select category,product, sum(spend) as total_spend,
rank() over (partition by category order by sum(spend)desc) as rank1
from product_spend
where extract(year from transaction_date)=2022
group by category,product)
select category,product,total_spend from a
where rank1 in ('1','2')

--Excercise 8
select artist_name,artist_rank from(SELECT a.artist_name, 
dense_rank() over( order by count(c.song_id)desc) as artist_rank
from artists as a
join songs as b on a.artist_id=b.artist_id
join global_song_rank as c on b.song_id=c.song_id
where c.rank <= 10
group by a.artist_name) as top10
where artist_rank <=5
