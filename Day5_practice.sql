--ex1
select distinct city from station
where (id%2=0)
--ex 2
select count(city) - count(distinct city) from station

--ex 3
select 
ceil(avg(salary - replace(salary, '0', '')))
from employees

--ex4
SELECT ROUND(SUM(item_count::Decimal * order_occurrences)/ SUM(order_occurrences),1)
AS mean
from items_per_order

--ex5
SELECT candidate_id FROM candidates
WHERE skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) =3
ORDER BY candidate_id;

--ex 6

SELECT user_id,
date(MAX(post_date))-date(MIN(post_date)) AS days_between
FROM posts
WHERE post_date > '2020-12-31' AND post_date < '2022-01-01'
GROUP BY user_id
HAVING COUNT(post_id) >1;

--ex 7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

--ex 8
-- Cogs = Cost of goods sold
-- numberOfDrugs = COUNT(drugs)
-- find total sales < cogs => total_loss = sales - cogs
-- output manufacturer @ drugs_count @ total_loss
SELECT manufacturer, 
COUNT(drug) as drugs_count,
ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC;

-- ex 9
-- output all
-- find odd id, description # boring, rating desc
select * from cinema
where (id%2=1) and description <> 'boring'
order by rating desc

--ex 10
select teacher_id,
count(distinct subject_id) as cnt 
from teacher
group by teacher_id

--ex 11
select user_id,
count(distinct follower_id) as followers_count
from followers
group by user_id
order by user_id asc

--ex 12
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;









