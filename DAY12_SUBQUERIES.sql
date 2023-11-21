***SUBQUERIES IN WHERE 
--Tìm những hóa đơn có số tiền lớn hơn số tiền trung bình các hóa đơn

select * from payment 
where amount > (select avg(amount) from payment);
--Tìm những hóa đơn có tên là Adam
select * from payment
where customer_id = (select customer_id from customer
					where first_name = 'ADAM');
--Tìm những bộ phim có thời lượng lớn hơn trung bình các bộ phim
select film_id, title 
from film
where length > (select avg(length) from film);
				
--Tìm những film có ở store 2 ít nhất 3 lần
select film_id, title from film
where film_id IN (select film_id from public.inventory
where store_id = 2
group by film_id
having count(*) >= 3);

-- Tìm những khách hàng đến từ California và đã chi tiêu hơn 100
select customer_id,first_name,last_name,email from public.customer
where  customer_id IN (select customer_id 
			   from payment 
			   group by customer_id 
			   having sum(amount) >100)

***Subqueries IN FROM
-- Tìm khách hàng có nhiều hơn 30 hóa đơn
select customer.first_name, new_table.so_luong
from(select customer_id, 
	 count(payment_id) as so_luong
	 from payment
	 group by customer_id) as new_table 
inner join customer on customer.customer_id= new_table .customer_id
where so_luong >30

***Subqueries IN SELECT
	
select *, 4 as cl1, 'hello' as cl2,
(select round(avg(amount),2) from payment) as average,
(select round(avg(amount),2) from payment) - amount as diff 
from payment;

select *,
(select amount from payment limit 1)
from payment;

select payment_id, amount,
(select max(amount) from payment) as max_amount,
(select max(amount) from payment) - amount as diff
from payment

***Correlated Subqueries IN SELECT
-- mã KH, tên KH, mã thanh toán, số tiền lớn nhất của từng khách hàng

/*số tiền lớn nhất của từng khách hàng 
select customer_id, max(amount) 
from payment
group by customer_id */

select t1.customer_id, 
t1.first_name || ' ' || t1.last_name as full_name,
t2.payment_id,
(select max(amount) from payment 
	  where customer_id = t1.customer_id
	  group by customer_id
)
from customer as t1 
join payment as t2
on t1.customer_id = t2.customer_id
group by t1.customer_id, 
		t1.first_name || t1.last_name,
		t2.payment_id
order by customer_id;

--- Liệt kê các khoản thanh toán với tổng số hóa đơn và tổng số tiền mỗi khách hàng phải trả
select * from payment;
select customer_id, count (*) as count_payment, sum(amount) as sum_amount from payment group by customer_id;

select t1.*, t2.count_payment, t2.sum_amount
from payment t1
join(select customer_id, 
	 count (*) as count_payment, 
	 sum(amount) as sum_amount 
	 from payment 
	 group by customer_id) t2
on t1.customer_id = t2.customer_id;

/*Lấy danh sách các films có chi phí thay thế lớn nhất trong mỗi loại rating.
ngoài film_id, title, rating, chi phí thay thế cần hiển thị thêm avg(repalcement_cost) for each rating*/

select film_id, title, rating, replacement_cost,
(select avg(replacement_cost) 
 from film t1
 where t1.rating =t2.rating
 group by rating) 
from film t2
where replacement_cost=(select max(replacement_cost)
						 from film t3
						 where t3.rating = t2.rating
						 group by rating)

***CTEs
---CTEs (Common table Expression)
WITH name_of_table AS
(
...
)
SELECT * FROM name_of_table;

/*Tìm khách hàng có nhiều hơn 30 hóa đơn,
kết quả tìm được trả ra gồm các thông tin:
mã KH, tên KH, số lượng hóa đơn, tổng số tiền, 
thời gian thuê trung bình*/
With id_count_amount AS(
	Select customer_id, count(payment_id) as so_luong, 
	sum(amount) as so_tien
	from payment
	group by customer_id),
avg_rental_time AS(
	select customer_id,
	avg(return_date - rental_date) as rental_time
	from rental
	group by customer_id)
SELECT t1.customer_id, t1.first_name, t2.so_luong, t2.so_tien, t3.rental_time
from customer as t1
join id_count_amount as t2
on t1.customer_id=t2.customer_id
join avg_rental_time as t3 
on t3.customer_id=t2.customer_id
where t2.so_luong >30

/* Tìm những hóa đơn có số tiền cao hơn số tiền trung bình của khách hàng đó chi tiêu trên mỗi hóa đơn,
kết quả tra ra bao gồm các thông tin: mã KH, tên KH, số lượng hóa đơn, số tiền trung bình của khách hàng đó*/

with quantity_payment AS(
	select customer_id, count(payment_id) as quantity
	from payment
	group by customer_id), 
average_paymentID AS(
	select customer_id, avg(amount) as avg_amount
	from payment
	group by customer_id)
SELECT t1.customer_id, t1.first_name, t2.quantity, t4.amount, t3.avg_amount
from customer as t1
join quantity_payment as t2
on t1.customer_id =t2.customer_id
join average_paymentID as t3
on t3.customer_id= t1.customer_id
join payment as t4
on t4.customer_id= t1.customer_id 
where t4.amount > t3.avg_amount










