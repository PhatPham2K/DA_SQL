ex1: leetcode-mmediate-food-delivery.
Select 
    round(avg(order_date = customer_pref_delivery_date)*100, 2) as immediate_percentage
from Delivery
where (customer_id, order_date) 
in (Select customer_id, min(order_date) 
  from Delivery
  group by customer_id);

ex2: 
SELECT
ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM Activity
WHERE(player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
IN (SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id);

ex3:  leetcode-exchange-seats
SELECT 
    CASE 
        WHEN id % 2 = 1 AND id < (SELECT MAX(id) FROM Seat) THEN id + 1
        WHEN id % 2 = 0 THEN id - 1
        ELSE id
    END AS id, student
FROM Seat
ORDER BY id;

ex4: leetcode-restaurant-growth
SELECT
    c.visited_on, (SELECT SUM(cust.amount)
        FROM Customer cust
        WHERE cust.visited_on BETWEEN DATE_SUB(c.visited_on, INTERVAL 6 DAY) AND c.visited_on) AS amount, 
ROUND(( SELECT SUM(cust.amount) / 7
            FROM Customer cust
            WHERE cust.visited_on BETWEEN DATE_SUB(c.visited_on, INTERVAL 6 DAY) AND c.visited_on), 2) AS average_amount
FROM Customer c
WHERE c.visited_on >= (
        SELECT DATE_ADD(MIN(cust.visited_on), INTERVAL 6 DAY)
        FROM Customer cust)
GROUP BY c.visited_on
ORDER BY c.visited_on;

ex5: leetcode-investments-in-2016.
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1)

ex6: leetcode-department-top-three-salaries.
WITH RankedSalaries AS (
    SELECT
        e.id AS employee_id,
        e.name AS employee,
        e.salary,
        e.departmentId,
        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS salary_rank
    FROM Employee e)
SELECT
    d.name AS Department,
    r.employee,
    r.salary
FROM RankedSalaries r
JOIN Department d ON r.departmentId = d.id
WHERE r.salary_rank <= 3;

ex7: leetcode-last-person-to-fit-in-the-bus.
SELECT q1.person_name
FROM Queue q1 JOIN Queue q2 ON q1.turn >= q2.turn
GROUP BY q1.turn
HAVING SUM(q2.weight) <= 1000
ORDER BY SUM(q2.weight) DESC
LIMIT 1;

ex8: leetcode-product-price-at-a-given-date.
SELECT 
    product_id,
    COALESCE(MAX(CASE WHEN change_date <= '2019-08-16' THEN new_price END), 10) AS price
FROM Products
GROUP BY product_id;

  
