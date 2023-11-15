*** Theory
-- Find how many tickets were sold
-- low-mid-high price: <20k, 20-150k, >=150k
select 
case
	when amount < 20000 then 'Low price ticket'
	when amount >= 150000 then 'High price ticket'
	else 'Mid price ticket'
end category,
count(*) as quantity
from bookings.ticket_flights
group by category


-- Find how many flights in each season (2,4) (5,7) (8,10) (11,1)
select 
case
	when extract (month from scheduled_departure) in (2,3,4) then 'Spring'
	when extract (month from scheduled_departure) in (5,6,7) then 'Summer'
	when extract (month from scheduled_departure) in (8,9,10) then 'Autumn'
	else 'Winter'
end season,
count(*)
from bookings.flights
group by season

*** Practice
--ex1: datalemur-laptop-mobile-viewership.
SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END)  laptop_views, 
  SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END)  mobile_views 
FROM viewership;

--ex2: datalemur-triangle-judgement.
SELECT x,y,z,
    case when (x+y)>z and x+z>y and z+y>x   then 'Yes' else 'No' 
    end as 'triangle'
from Triangle


--ex3: datalemur-uncategorized-calls-percentage.
SELECT
    ROUND(SUM(CASE 
      WHEN call_category IS NULL THEN 1 
      WHEN call_category = 'n/a' THEN 1
      ELSE 0
    END) * 100.0 / COUNT(case_id), 1)
FROM callers

--ex4: datalemur-find-customer-referee.
SELECT name
FROM customer
WHERE 
    CASE 
        WHEN referee_id = 2 THEN 0
        ELSE 1
    END = 1 OR referee_id IS NULL;

--ex5: stratascratch the-number-of-survivors.
SELECT
    survived,
    COUNT(CASE WHEN pclass = 1 THEN 1 END) AS first_class,
    COUNT(CASE WHEN pclass = 2 THEN 1 END) AS second_class,
    COUNT(CASE WHEN pclass = 3 THEN 1 END) AS third_class
FROM titanic
GROUP BY survived;

	






















