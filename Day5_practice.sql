-- ex1
select distinct city from station
where (id%2=0)
-- ex2
select count(city) - count(distinct city) from station

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










