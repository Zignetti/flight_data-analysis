-- analysis of flights data set for various airline operating between cities in India.

SELECT * FROM airline.flights_data;

-- number of rows and columns in the dataset

select count(*) as numOfrows
from flights_data;
-- data has 6685 rows

select count(*) as columnTotal
from information_schema.columns
where table_name='flights_data';
-- data contain 12 columns

-- check for missing values

select count(*) as totalMissing,
count(if(`index` is null,1,null)) as indexMissing,
count(if(airline is null or airline='',1,null)) as airlineMissing,
count(if(flight is null or flight='',1,null)) as flightMissing,
count(if(source_city is null or source_city='',1,null)) as sourceMissing,
count(if(departure_time is null or departure_time='',1,null)) as departureMissing,
count(if(stops is null or stops='',1,null)) as stopsMissing,
count(if(arrival_time is null or arrival_time='',1,null)) as arrivalMissing,
count(if(destination_city is null or destination_city='',1,null)) as destinationMissing,
count(if(class is null or class='',1,null)) as classMissing,
count(if(duration is null,1,null)) as durationMissing,
count(if(days_left is null,1,null)) as daysleftMissing,
count(if(price is null,1,null)) as missingPrice
from flights_data;

-- no missing values

--   Analysis

-- Q1. What are the airlines in the dataset, accompanied by their frequencies?

select airline, count(*) as airline_frequency
from flights_data
group by airline
order by airline_frequency desc;

-- we have a total of 6 airline in the dataset. Vistara is the leading airline in terms of frequency
-- with a total flight of 5,581, followed by Air india(4405),Indigo(3518),Go_first(3084),Air_Asia(2139)
-- and SpiceJet(1091).

-- Q2. Does price varies with airlines ?
select airline, min(price)
from flights_data
where duration = 2.33
group by airline;

-- the results shows that for a journey of 2hours 33mins, Vistara charge the highest fair of 2,700
-- followed by Air india(2,482), SpiceJet charge the least (2281).

-- Q3. Does ticket price change based on the departure time and arrival time?
select departure_time, min(price)as min_ticket_price,max(price) as max_ticket_price, round(avg(price),2) as avg_ticket_price
from flights_data
group by departure_time;

select arrival_time, min(price)as min_ticket_price,max(price) as max_ticket_price, round(avg(price),2) as avg_ticket_price
from flights_data
group by arrival_time;

-- shows that ticket prices varies based on departure time albeit marginally except for late_night flights.
-- for arrival time, the min ticket price are generally thesame for all arrival time except late night arrival.

-- Q4. How the price changes with change in Source and Destination?
select source_city, destination_city, min(price)
from flights_data
group by source_city, destination_city;

-- shows that flights originating from Mumbai are more expensive than those from Delhi.
-- and for flights originating from Delhi, those going to Bangalore are most expensive.


-- Q5. How is the price affected when tickets are bought in just 1 or 2 days before departure?

select airline, days_left, min(price) as min_price, round(avg(price),2) as avg_price
from flights_data
where days_left=1 or days_left=2
group by airline,days_left;

-- For Spicejet the min price for a ticket bought 1 day to is 5953 compare to 5943 for 2 days to.
-- Air Asia its 5625 when bought 1 day to and 5949 if its 2 days to. For Indigo the price is thesame
-- whether bought a day or 2 days to. For Vistara its 5943(1 day to) and 5208( 2 days to). 
-- overall, its cheaper to buy a ticket well ahead of your departure date.


-- Q6. How does the ticket price vary between Economy and Business class?

select class, min(price) as minPrice, max(price) as maxprice, round(avg(price),2) as avgPrice
from flights_data
group by class;

-- from the first 50,000 rows examin, there was no business class.

-- Q7. What will be the Average Price of Vistara airline for a flight from Delhi to Hyderabad in Business Class ?

select round(avg(price),2) as avg_price, source_city, destination_city
from flights_data
where airline='vistara' and class='business'
group by source_city, destination_city;

-- no business class info



