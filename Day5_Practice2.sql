***THEORY***
***GROUP BY***
-- Find max min avg for total_cost of film 
select film_id,
max (replacement_cost) as max_cost,
min (replacement_cost) as min_cost,
round(avg (replacement_cost)) as avg_cost,
sum (replacement_cost) as sum_cost
from film
group by film_id
order by film_id
  
-- Find how much each customer paid
select customer_id, staff_id,
sum(amount) as total_amount,
round(avg(amount)) as average_amount,
max(amount) as max_amount,
min(amount) as min_amount,
count(*) as total_bill
from payment
group by customer_id, staff_id
order by customer_id, staff_id

-- ***HAVING:  is used to filter the results of aggregate functions  (e.g., SUM, AVG, COUNT, etc.) after the grouping >< WHERE clause is used to filter rows before any grouping or aggregation is applied.
--find which customer paid > $100
select customer_id,
sum(amount) as total_paid
from payment
group by customer_id
having sum(amount) >100

--find which customer paid > $10 n Jan 2020
select customer_id,
sum(amount) as total_paid
from payment
where payment_date between '2020-01-01' and '2020-02-01'
group by customer_id
having sum(amount) >10

-- find revenue on April 28th - 30th, find avg payment group by customer and payment date that having more than 1 payment_id
/* use BETWEEN when you want to filter based on a range, and use IN when you want to filter based on a specific set of values.*/
select customer_id, date(payment_date),
avg(amount) as average_amount,
count(payment_id)
from payment
where date(payment_date) IN ('2020-04-28', '2020-04-29', '2020-04-30')
group by customer_id, date(payment_date)
having count(payment_id) >1
order by avg(amount) desc

--Mathematics operations & functions
select film_id,
rental_rate,
round(rental_rate*0.5,2) as new_rental_rate
--ceiling(rental_rate*1.1) as new_rental_rate
--floor(rental_rate*0.5) -0.1 as new_rental_rate
from film

-- Create a list of films having rental_rent less than 4% of the replacement cost.
select film_id,
rental_rate as "giá thuê phim",
replacement_cost as "chi phí thay thế",
round((rental_rate/replacement_cost)*100,2) as percentage
from film 
where round((rental_rate/replacement_cost)*100,2) <4

  *** Order of querries: SELECT ... FROM ... WHERE ... GROUP BY ... HAVING ... ORDER BY ... LIMIT

***PRACTICE

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









