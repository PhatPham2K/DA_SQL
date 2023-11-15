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
