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

-- LEFT JOIN/ RIGHT JOIN 
/*
SELECT t1.*, t2.*
FROM table_name1 AS t1
LEFT JOIN table_name2 AS t2
ON t1.key1=t2.key
Find info of each flight
step 1: determine table
step 2: determine key join -> common: aircrafts_data */
select t1.aircraft_code, t2.flight_no
from bookings.aircrafts_data as t1
LEFT JOIN bookings.flights as t2
ON t1.aircraft_code = t2.aircraft_code
where t2.flight_no is NULL --find which aircraft not fly

/* 
SELECT t1.*, t2.*
FROM table_name1 AS t1
LEFT JOIN table_name2 AS t2
ON t1.key1=t2.key

Find seating booked most
which seat have never booked
which seat line booked most
*/
select t1.seat_no,
count(flight_id) as seat_count
from bookings.seats as t1
left join bookings.boarding_passes as t2
on t1.seat_no = t2.seat_no
group by t1.seat_no
order by seat_count desc

select t1.seat_no
from bookings.seats as t1
 join bookings.boarding_passes as t2
on t1.seat_no = t2.seat_no
where t2.seat_no is null

select right(t1.seat_no,1) as line,
count(flight_id) as seat_count
from bookings.seats as t1
left join bookings.boarding_passes as t2
on t1.seat_no = t2.seat_no
group by right(t1.seat_no,1)
order by seat_count desc

--FULL JOIN
select count(*) --find those have tickets but cannot fly
from bookings.boarding_passes as table_1
FULL JOIN bookings.tickets as table_2
on table_1.ticket_no=table_2.ticket_no
where table_1.ticket_no is null

/* JOIN MULTIPLE CONDITIONS
Calculate avg ticket price of each seat
step 1: determine output, input
		seat -> bookings.seats
		amount -> bookings.ticket_flights having 2 Pk
		? 2PK -> for transit flights, passenger has 1 ticket _no but 2 fight_id
	2 tables not match -> change bookings.seats
	bookings.boarding_passes has both 2 PKs that we need
step 2
*/
select t1.seat_no, avg(t2.amount) as avg_amount
from bookings.boarding_passes as t1
LEFT JOIN bookings.ticket_flights as t2
on t1.ticket_no=t2.ticket_no
and t1.flight_id=t2.flight_id
group by t1.seat_no 
order by avg(t2.amount) desc

-- find name, last_name ,email of those come from Brazil
select t1.first_name, t1.last_name, t1.email, t4.country
from public.customer as t1
JOIN public.address as t2
on t1.address_id=t2.address_id
join public.city as t3 
on t3.city_id = t2.city_id
join public.country as t4
on t4.country_id=t3.country_id
where t4.country='Brazil'

--SELF JOIN
-- find films having the same length, output title1, title2, length
select f1.title as film_1, f2.title as film_2, f1.length
from public.film as f1
left join public.film as f2
on f1.length=f2.length
where f1.title <> f2.title 
order by f1.title

--UNION 
/*
	UNION connects rows while JOIN connects columns
	numbers of columns, data_type from tables must be the same
	UNION has distinct rows while UNION ALL not

select col1, col2, ... coln
from table1
UNION/ UNION ALL
select col1, col2, ... coln
from table2
select col1, col2, ... coln
from table_n
*/

select first_name, 'actor'  as table_source from actor
union all
select first_name, 'customer' as table_source from customer
union all
select first_name, 'staff' as table_source from staff
order by first_name 

	
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
t1.title AS film_title,
t1.length,
t3.name AS category_name
FROM public.film AS t1
JOIN public.film_category as t2 
ON t1.film_id = t2.film_id
JOIN public.category as t3 ON t2.category_id = t3.category_id
WHERE t3.name IN ('Drama', 'Sports')
ORDER BY t1.length DESC
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

