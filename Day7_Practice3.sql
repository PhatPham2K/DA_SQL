***THEORY
--- LOWER, UPPER, LENGTH
SELECT email,
lower(email) as lower_mail,
upper(email) as upper_mail,
length(email) as length_email
from customer
where length(email) <29

--- List customers having surname or lastname less them 10 letters
select 
lower(first_name),
lower(last_name)
from customer
where length(first_name) >10 or length(last_name) >10

--- LEFT(), RIGHT()
select first_name,
left(first_name,3),
right(first_name,2),
left(right(first_name,4),1)
from customer


--extract the last 5 characters of the email address. The email address always ends with '.org', How to extract the '.' from the email address.
select right(email,5)
from customer   
  --> 'r.org'
  
select left(right(email,4),1)
from customer

---concatenate
select
customer_id, first_name, last_name,
first_name || ' ' || last_name as fullname
from customer

---concat()
select
customer_id, first_name, last_name,
concat(first_name,' ', last_name) as fullname
from customer


/*MARY.SMITH@sakilacustomer.org
  --> MAR***TH@sakilacustomer.org */
SELECT 
  email,
  CONCAT(LEFT(email, 3),'***', right(email,20)) AS masked_email
FROM customer;









--ex1
select name from students
where marks > 75
order by right(name,3), id 

--ex2
SELECT Users.user_id , CONCAT(UPPER(SUBSTR(Users.name,1,1)),LOWER(SUBSTR(Users.name,2))) AS name 
FROM Users
ORDER BY
Users.user_id ASC

  
--ex3
SELECT manufacturer,
('$' || round(sum(total_sales)/ 1000000) || ' million') as sale
FROM pharmacy_sales
group by 1 
ORDER BY SUM(total_sales) desc;

--ex4
SELECT EXTRACT(MONTH FROM submit_date) AS month,
product_id AS product,
ROUND(AVG(stars), 2) AS avg_value
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date),product_id
ORDER BY month,product;

--ex5
SELECT sender_id,count(message_id) FROM messages
where extract(month from sent_date) = '8' and extract(year from sent_date)= '2022'
group by 1 order by 2 desc limit 2;

--ex6
select tweet_id  from Tweets where length(content) >15;

--ex7
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE (activity_date > "2019-06-27" AND activity_date <= "2019-07-27")
GROUP BY activity_date;

--ex8
SELECT COUNT(id) AS number_employee
FROM employees
WHERE EXTRACT(MONTH FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(YEAR FROM joining_date) = 2022;

--ex9
SELECT POSITION('a' IN LOWER(first_name)) AS position_of_a
FROM employees
WHERE first_name = 'Amitah';

--ex10
select substring(title, length(winery)+2,4) 
from winemag_p2
where country 'Macedonia'
