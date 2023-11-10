--- Select (display)
select * from actor  ---display all
select first_name, last_name from actor;
select first_name as "tên diễn viên", last_name as "họ diễn viên" from actor;
--- Order by
select * from actor
order by first_name asc, actor_id desc
select * from payment
order by customer_id, amount desc, payment_date desc
--- distinct
select distinct first_name, last_name from actor
order by first_name, last_name asc
select distinct amount from payment
order by amount asc
---Limit (always stand at the end of the sentence)
-- top 100 largest amount bill
select * from payment 
order by amount desc limit 100
-- where 
select * from payment
Where amount <> 10.99  -- <> or !=
Where not amount  >2 order by amount desc
select * from actor
where first_name is not null
where first_name = 'NICK'
---KH 322, 246, 354
--money < 2, or > 10
-- customer_id asc, amount desc
select * from payment
where (customer_id = 322 or customer_id = 346 or customer_id = 354)
and (amount < 2 or  amount > 10) 
order by customer_id asc, amount desc


-- all bill in payment_id 16055, 16061, 16065, 16068

select * from payment 
where payment_id in (16055, 16061, 16065, 16068)

--- 6 complains about bill customer_id 12,25,67,93,124,234
--- money 4.99, 7.99 and 9.99 in Jan 2020
select * from payment
where customer_id in (12,25,67,93,124,234) 
and amount in (4.99, 7.99, 9.99)
and payment_date between '2020-01-01' and '2020-02-01'

--- LIKE
select * from customer
where first_name like 'J%'  -- start with J and do not care after J
where first_name like '%N'  -- end with N
where first_name like '%N%' -- has N
where first_name like '__N%' -- the 3rd letter is N
-- find customer_id has lastname starting J or S
where last_name like 'J%' or last_name like 'S%' 
-- find customer_id Not have lastname starting J or S
select * from customer
--where not (last_name like 'J%' or last_name like 'S%')
where last_name not like 'J%' and last_name not like 'S%'
-- list movies having Saga in description starting with A or end with R
select * from film
where description like '%Saga%'
and (title like 'A%' or title like '%R')
-- find all customers has ER, 2nd letter is A
select customer_id, first_name from customer
where first_name like '%ER%' and first_name like '_A%'















