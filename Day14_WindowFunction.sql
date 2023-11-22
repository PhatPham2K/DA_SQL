/*OVER() WITH PARTITION BY
Window Function with Sum, count, avg
-- Tính tỉ lệ số tiền thanh toán từng ngày với tổng số tiền đã thanh toán
của mỗi khách hàng
Output: mã KH, tên KH, ngày thanh toán, số tiền thanh toán tại ngày, tổng số 
tiền thanh toán, tỉ lệ*/

select t1.customer_id, t2.first_name, t1.payment_date, t1.amount,
(select sum(amount) 
from payment as x
where x.customer_id = t1.customer_id
group by customer_id), 
t1.amount/ (select sum(amount) 
from payment as x
where x.customer_id = t1.customer_id
group by customer_id) as ratio
from payment as t1
join customer as t2
on t1.customer_id = t2.customer_id;

/* Viết truy vấn trả về danh sách film bao gồm: film_id, title, 
length, category, avg(length) của film trong type đó, sắp kq theo id*/
select t1.film_id, t1.title, t1.length, t2.category, t2.avg(length) from film 
as t1
join public.category as t2
on t1.last_update= t2.last_update
group by film_id, title







