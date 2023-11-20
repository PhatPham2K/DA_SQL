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
/*Question 1: 
Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
Chi phí thay thế thấp nhất là bao nhiêu?
Answer: 9.99 */

select distinct replacement_cost
from film
order by replacement_cost asc

/*Question 2: 
Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
1.	low: 9.99 - 19.99
2.	medium: 20.00 - 24.99
3.	high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?
Answer: 514
 */
SELECT 
    CASE
        WHEN replacement_cost >= 9.99 and replacement_cost <= 19.99 THEN 'Low'
        WHEN replacement_cost >= 20 and replacement_cost <=24.99 THEN 'Medium'
        else 'High'
    END AS category,
	count(*) as number_of_films
FROM film
group by category 

/*Question 3: 
Tạo danh sách các film_title  bao gồm tiêu đề (title), độ dài (length) và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần. Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?
Answer: Sports : 184
 */
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


/*Question 4: 
Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?
Answer: Sports :74 titles
 */
SELECT
t3.name AS category,
count(t1.film_id ) || ' titles' as count
FROM public.film AS t1
JOIN public.film_category as t2 
ON t1.film_id = t2.film_id
JOIN public.category as t3 ON t2.category_id = t3.category_id
group by t3.name
order by count desc
LIMIT 1;

/*Question 5: 
Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?
*/
SELECT
t3.first_name || ' ' || t3.last_name AS actor_name,
count(t1.film_id) || ' movies' AS total_movies
FROM public.film AS t1
JOIN public.film_actor AS t2 
ON t1.film_id = t2.film_id
JOIN public.actor AS t3 
ON t2.actor_id = t3.actor_id
GROUP BY t3.first_name, t3.last_name
ORDER BY total_movies DESC
LIMIT 1;

/*Question 6: 
Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy?
Answer: 4
*/
SELECT
COUNT(t1.address_id) AS total_addresses_without_customers
FROM public.address AS t1
LEFT JOIN public.customer AS t2 
ON t1.address_id = t2.address_id
WHERE t2.customer_id IS NULL;

/*Question 7:
Danh sách các thành phố và doanh thu tương ừng trên từng thành phố 
Question:Thành phố nào đạt doanh thu cao nhất?
Answer: Cape Coral : 221.55
*/

/*Danh sách các thành phố và doanh thu tương ứng trên từng thành phố 
Question:Thành phố nào đạt doanh thu cao nhất?
city -> address -> customer -> payment
Answer: Cape Coral : 221.55*/ 
select t1.city, sum(t4.amount) as total_amount
from public.city as t1
join public.address as t2 
on t1.city_id = t2.city_id
join public.customer as t3
on t3.address_id= t2.address_id
join public.payment as t4
on t4.customer_id=t3.customer_id
group by t1.city
order by total_amount desc
limit 1;

/*Question 8: Tạo danh sách trả ra 2 cột dữ liệu: 
-	cột 1: thông tin thành phố và đất nước ( format: “city, country")
-	cột 2: doanh thu tương ứng với cột 1
Question: thành phố của đất nước nào đat doanh thu cao nhất
Answer: United States, Tallahassee : 50.85.
*/
--country -> city -> address -> customer  -> payment
select t2.city || ', ' || t1.country AS city_of_country,
sum(t5.amount) as total_amount
from public.country as t1 
join public.city as t2
on t1.country_id=t2.country_id
join public.address as t3
on t3.city_id=t2.city_id
join public.customer as t4
on t4.address_id = t3.address_id
join public.payment as t5
on t5.customer_id = t5.customer_id
group by t2.city_id, t1.country_id
order by total_amount desc

***PRACTICE
--EX1: hackerrank-average-population-of-each-continent.
SELECT T2.CONTINENT, FLOOR(AVG(T1.POPULATION))
FROM CITY AS T1
INNER JOIN COUNTRY AS T2
ON T1.COUNTRYCODE = T2.CODE
GROUP BY T2.CONTINENT

--EX2: https://datalemur.com/questions/signup-confirmation-rate
SELECT 
  ROUND(COUNT(t2.email_id)::DECIMAL
    /COUNT(DISTINCT t1.email_id),2) AS activation_rate
FROM emails as t1
LEFT JOIN texts as t2
ON t1.email_id = t2.email_id
AND t2.signup_action = 'Confirmed';

--EX3: https://datalemur.com/questions/time-spent-snaps

SELECT
    age_bucket,
    ROUND(
        100 * SUM(CASE
            WHEN ac.activity_type = 'send' THEN ac.time_spent
        END) :: DECIMAL / SUM(CASE
            WHEN ac.activity_type IN ('open', 'send') THEN ac.time_spent
        END), 2) AS send_perc,
    ROUND(
        100 * SUM(CASE
            WHEN ac.activity_type = 'open' THEN ac.time_spent
        END) :: DECIMAL / SUM(CASE
            WHEN ac.activity_type IN ('open', 'send') THEN ac.time_spent
        END), 2) AS open_perc
FROM
    activities AS ac
JOIN age_breakdown AS ab ON ac.user_id = ab.user_id
GROUP BY
    ab.age_bucket;

--EX4: https://datalemur.com/questions/supercloud-customer
SELECT customer_id FROM customer_contracts as a 
inner join 
products as b on a.product_id = b.product_id
GROUP BY customer_id
having count(distinct b.product_category) = 3

--EX5:https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/description/?envType=study-plan-v2&envId=top-sql-50
SELECT
  t1.employee_id,
  t1.name,
  COUNT(t2.employee_id) AS reports_count,
  ROUND(AVG(t2.age)) AS average_age
FROM Employees as t1
LEFT JOIN Employees as t2 ON t1.employee_id = t2.reports_to
WHERE t1.employee_id IN (SELECT DISTINCT t2.reports_to FROM Employees WHERE t2.reports_to IS NOT NULL)
GROUP BY t1.employee_id, t1.name
ORDER BY t1.employee_id;

--EX6: leetcode-list-the-products-ordered-in-a-period.
SELECT
t1.product_name,
SUM(t2.unit) AS unit
FROM Products as t1
JOIN Orders as t2 
ON t1.product_id = t2.product_id
WHERE t2.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY t1.product_id, t1.product_name
HAVING SUM(t2.unit) >= 100;
--EX7: datalemur.com/questions/sql-page-with-no-likes
SELECT t1.page_id
FROM pages AS t1
LEFT JOIN page_likes AS t2 
ON t1.page_id = t2.page_id
WHERE t2.page_id IS NULL
ORDER BY t1.page_id;



