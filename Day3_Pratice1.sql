--ex1
select name from city
where population >= 120000 and CountryCode = 'USA'
--ex2 
select * from city 
where COUNTRYCODE like 'JPN'
--ex3
select city, state from station
--ex4
select distinct city from station
where city like 'A%' or city like 'E%' or city like 'O%' or city like 'U%' or city like 'I%'
--solution 2
SELECT DISTINCT CITY FROM STATION WHERE LEFT(CITY,1) IN ('A','E','I','O','U')
-- ex5
select distinct city from station
where right (city,1) in ('A','E','I','O','U')
-- ex6
select distinct city from station
where left (city,1) not in ('A','E','I','O','U')
-- ex7
select name from employee
order by name asc
--ex8
select name from employee
where (salary > 2000) and (months < 10) order by employee_id asc
--ex9
select product_id from products where low_fats = 'y' and recyclable = 'y' 
--ex10
select name from customer
where  referee_id != 2 OR referee_id is NULL
--ex11
select name, population, area from world
where area > 3000000 or population > 25000000
--ex12
select distinct author_id as id from views
where author_id = viewer_id order by id asc
--ex13
SELECT part, assembly_step  FROM parts_assembly
WHERE  finish_date IS NULL
--ex14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000
--ex15
select advertising_channel from uber_advertising
where money_spent >=100000 and year = '2019'










