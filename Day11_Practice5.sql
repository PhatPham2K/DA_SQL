***Theory
---INNER JOIN	
SELECT t1.*, t2.*
from table1 as t1
inner join table 2 as t2
on t1.key1 = t2.key2

/*How manny passengers in business, economy, comfort || join = inner join*/ 
select * from bookings.seats;
select *from bookings.boarding_passes;

select t2.fare_conditions, 
count(flight_id) as number_of_flights
from bookings.boarding_passes as t1
join bookings.seats as t2
on t1.seat_no = t2.seat_no
group by t2.fare_conditions



***Midterm Test
Question 1:
select distinct replacement_cost
from film
order by replacement_cost asc

Question 2:
SELECT 
    CASE
        WHEN replacement_cost >= 9.99 and replacement_cost <= 19.99 THEN 'Low'
        WHEN replacement_cost >= 20 and replacement_cost <=24.99 THEN 'Medium'
        else 'High'
    END AS category,
	count(*) as number_of_films
FROM film
group by category 


Question 3:
SELECT
film.title AS film_title,
film.length,
category.name AS category_name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name IN ('Drama', 'Sports')
ORDER BY film.length DESC
LIMIT 1;


Question 4:
SELECT
category.name AS category_name,
COUNT(film.film_id) AS title_count
FROM category
LEFT JOIN
film_category ON category.category_id = film_category.category_id
LEFT JOIN
film ON film_category.film_id = film.film_id
GROUP BY category.name
ORDER BY title_count DESC
LIMIT 1;


Question 5:

