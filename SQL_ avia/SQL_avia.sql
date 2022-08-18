/*1. Which cities have more than one airport?*/

/*Description of the query logic:
- take data from the table "airports";
- group by the name of the city with an airport;
- filter the grouped data by the condition "number of airports > 1";
- display the names of cities that satisfy the filtering condition.*/

select a.city
from airports a 
group by a.city 
having count(a.airport_name) > 1

/*2. At which airports are there flights performed by an aircraft with the maximum range of flight?*/

/*Description of query execution logic:
- find the value of maximum flight range from the table "aircrafts" (this is the 2nd subquery);
- find the code of the aircraft with the maximum flight range (this is the 1st subquery);
- output the list of airport codes (removing duplicates) from the "flights" table, where there are the flights operated by the aircraft with the maximum flight range.*/

select distinct f.departure_airport 
from flights f 
where f.aircraft_code = (
						select a2.aircraft_code
						from aircrafts a2 
						where a2."range" = (select max(a."range") 
											from aircrafts a
											)
						)
						
/*3. Withdraw 10 flights with maximum delay time.*/
						
/*Description of the query execution logic:
- count the departure delay of each plane;
- filter the data where there is no information (flight delay = NULL) by flight delay;
- sort data by decreasing flight delay;
- output the first 10 flight id.*/

select f.flight_id
from flights f 
where f.actual_departure - f.scheduled_departure is not null
order by f.actual_departure - f.scheduled_departure desc
limit 10

/*4. Were there any reservations for which boarding passes were not received?*/	

/*Description of the query execution logic:
- We take the table "tickets", which contains numbers of reservations;
- through "left join" merge it with the table "boarding_passes", which contains numbers of reservations and boarding passes;
- filter the obtained data by the "is null" condition by the column with the boarding_passes number;
- we get the list of reservations for which boarding passes have not been received.*/

select distinct t.book_ref
from tickets t 
left join boarding_passes bp on t.ticket_no = bp.ticket_no 
where bp.boarding_no is null

/*5. Find vacant seats for each flight, their % ratio to the total number of seats on the plane. Add a column with a cumulative total - a summary cumulative accumulation of the number of departed passengers from each airport for each day. I.e. this column should reflect the cumulative amount - how many people have already left the airport on this or earlier flights per day.*/

/*Description of query execution logic:
- the first subquery "from_bp" counts the number of seats occupied for each flight;
- the second subquery "from_seats" counts the number of seats for each aircraft model;
- combine data on flights from the "flights" table with the number of occupied seats for each flight and the total number of seats of the aircraft that is flying;
- remove flights without passengers from the data obtained;
- calculate the percentage of empty seats on each flight;
- add a cumulative total of the number of passengers departing from each airport per day.*/

select f.actual_departure, f.departure_airport, f.flight_id,
		concat (round (cast (s2_count_seat_no - from_bp.bp_max as numeric) / cast (s2_count_seat_no as numeric) * 100, 2), '%') as free_seats,
		sum (from_bp.bp_max) over (partition by f.departure_airport, date(f.actual_departure) order by f.actual_departure)
from flights f
join (
	select bp.flight_id as bp_flight_id, max(bp.boarding_no) as bp_max
	from boarding_passes bp 
	group by bp.flight_id
	) from_bp on from_bp.bp_flight_id = f.flight_id 
join (
	select s2.aircraft_code as s2_aircraft_code, count(s2.seat_no) as s2_count_seat_no
	from seats s2 
	group by s2.aircraft_code
	) from_seats on from_seats.s2_aircraft_code = f.aircraft_code 
where from_bp.bp_max > 0

/*6. Find the percentage of flights by types of aircraft from the total number.*/

/*Description of query execution logic:
- calculate the total number of flights "count(f.flight_id)" from the "flights" table by subquery;
- group the data from the "flights" table by "aircraft_code" and obtain the number of flights for each aircraft type;
- convert the values of the total number of flights and the number of flights for each aircraft type to "numeric";
- calculate the percentage of flights by aircraft type from the total number of flights with rounding to 2 decimal places.*/

select f.aircraft_code, concat (round (cast (count(f.flight_id) as numeric) / 
										cast ((select count(f.flight_id) from flights f) as numeric) * 100, 2), ' %')
from flights f 
group by f.aircraft_code 

/*7. Were the cities to which business class can be reached cheaper than economy class as part of the flight?*/	

/*Description of query execution logic:
- in "cte1" put the minimum business class cost for each flight;
- in "cte2" the maximum cost of economy class for each flight;
- merge the data on the maximum/minimum cost for business/economy class ("cte1" and "cte2") with the codes for the airports ("flights") and for the cities ("airports");
- output the city of the airport of arrival (removing the redundancy through "group by"), where there was a situation that the maximum cost of business class is lower than the minimum cost of economy class.*/

with cte1 as (
	select tf.flight_id as business_flight_id, min(tf.amount) as min_business
	from ticket_flights tf 
	where tf.fare_conditions = 'Business'
	group by tf.flight_id
),
	cte2 as(
	select tf.flight_id as economy_flight_id, max(tf.amount) as max_economy
	from ticket_flights tf 
	where tf.fare_conditions = 'Economy'
	group by tf.flight_id
)
select a.city
from cte1
join cte2 on cte2.economy_flight_id = cte1.business_flight_id
join flights f on f.flight_id = cte1.business_flight_id
join airports a on a.airport_code = f.arrival_airport
where cte1.min_business < cte2.max_economy
group by a.city 

/*8. What cities don’t have direct flights between them?*/

/*Description of the query execution logic:
- create a representation of "task_1" as a сartesian product of city names from the "airports" table;
- combine the "flights" and "airports" tables;
- get departure city and arrival city for each flight, and put them into "task_2" view;
- subtract "task_2" data from "task_1" data;
- obtain cities with no direct flights between them.*/

create view task_1 as
	select a.city as city_departure, a2.city as city_arrival
	from airports a, airports a2 
	where a.city != a2.city
	group by a.city, a2.city 


create view task_2 as
	select a2.city as city_departure, a3.city as city_arrival
	from flights f 
	join airports a2 on a2.airport_code = f.departure_airport
	join airports a3 on a3.airport_code = f.arrival_airport 
	group by a2.city, a3.city 

select * 
from task_1
except
select * 
from task_2

/*9. Calculate the distance between airports connected by direct flights, compare with the permissible maximum range of flights in aircraft serving these flights.*/

/*Description of query execution logic:
- merge "flights" and "airports" tables to get for each flight the coordinates of departure and arrival airports; 
- merge "flights" and "aircrafts" tables to get the maximum range of the aircraft used for the flights;
- use the formula to calculate the distance between the airports;
- calculate the difference between the maximum range of the aircraft and the distance between the airports;
- display the names of the departure/arrival airports, the distance between the airports, and the distance reserve after the flight.*/

select concat(a1.airport_name, ' – ', a2.airport_name) as airports, 
		6371 * acos(sin(radians(a1.latitude)) * 
		sin(radians(a2.latitude)) + 
		cos(radians(a1.latitude)) * 
		cos(radians(a2.latitude)) * 
		cos(radians(a1.longitude) - 
		radians(a2.longitude))) as distance,
		a3."range" - 6371 * acos(sin(radians(a1.latitude)) * 
						sin(radians(a2.latitude)) + 
						cos(radians(a1.latitude)) * 
						cos(radians(a2.latitude)) * 
						cos(radians(a1.longitude) - 
						radians(a2.longitude))) as reserves_distance
from flights f 
join airports a1 on a1.airport_code = f.departure_airport
join airports a2 on a2.airport_code = f.arrival_airport 
join aircrafts a3 on a3.aircraft_code = f.aircraft_code 
group by airports, distance, reserves_distance














						