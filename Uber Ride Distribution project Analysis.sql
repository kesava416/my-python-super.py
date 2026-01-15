use Uber_project;

show tables;

show  columns  from uber_supply_demand_final ;

alter table uber_supply_demand_final
modify column `Request timestamp` TEXT,
modify column `Drop timestamp` TEXT,
modify column `request_hour` TEXT,
modify column `Pickup point` VARCHAR(20),
modify column `Status` VARCHAR(30),
modify column `request_day` varchar(15);


show columns from uber_supply_demand_final;

# 1)Peak Demand Hours
select request_hour, count(*)as total_requests
from uber_supply_demand_final
group by request_hour
order by total_requests desc
limit 5;

# 2) Low Supply Hours (No Cars Available)
select request_hour, count(*) as no_car_requests
from uber_supply_demand_final
where status = "No Cars Available"
group by request_hour
order by no_car_requests desc
limit 5;

# 3)Demand vs Supply By Hour
select request_hour, Status, count(*) as request_count
from uber_supply_demand_final
group by request_hour, Status
order by request_hour;

# 4) Airport Supply - Demand Gap
select request_hour, Status, count(*) as total_requests
from uber_supply_demand_final
where `Pickup point` = 'Airport'
group by request_hour, Status
order by request_hour;

# 5)Overall Supply Efficiency
select Round(sum(case when Status = 'Trip Completed' Then 1 Else 0 end) * 100.0/ count(*), 2) as 
supply_efficiency_percentage
from uber_supply_demand_final;

# 6) REQUEST BY HOUR

select request_hour, count(*) as total_requests
from uber_supply_demand_final
group by request_hour
order by total_requests desc;

# 7) DEMAND GAP 

select Status, count(*) as count
from uber_supply_demand_final
group by Status;

# 8) AIRPORT VS CITY 
select `Pickup point`, Status, count(*) as cnt
from uber_supply_demand_final
group by `Pickup point`, Status;

# 9) DAYWISE DEAMAND
select request_day, count(*) as total
from uber_supply_demand_final
group by request_day;

# 10) OVERALL DEMAND AND SUPPLY GAP

select Status, count(*) as total_requests
from uber_supply_demand_final
group by Status;

# 11) DEMAND BY PICKUP LOCATION
select `Pickup point`, count(*) as total_requests
from uber_supply_demand_final
group by `Pickup point`;

# 12) SUPPLAY FAILURE RATE BY PICKUP POINT
select
`Pickup point`, Status, count(*) as count
from uber_supply_demand_final
where Status in ('Canceled', 'No Cars Avilable')
group by `Pickup point`, Status;

# 13) HOUR WISE DEMAND TREND

select request_hour, count(*) as total_requests
from uber_supply_demand_final
group by request_hour
order by request_hour;

# 14)HOUR-WISE SUPPLY GAP 

select request_hour, Status, count(*) as count
from uber_supply_demand_final
where Status != 'Trip Completed'
group by request_hour, Status
order by request_hour;

# 15) PEAK FAILURE HOURS

select request_hour, count(*) as failures
from uber_supply_demand_final
where Status in ('Canceled', 'No Cars Available')
group by request_hour
order by failures desc
limit 5;

# 16) DAY WISE DEMAND PATTERN
select request_day, count(*) as total_requests
from uber_supply_demand_final
group by request_day;

# 17) DAY WISE SUPPLY GAP 

select request_day, count(*) as failed_requests
from uber_supply_demand_final
where Status !='Trip Copleted'
group by request_day;

# 18) AIRPORT DEMAND GAP BY HOUR

select request_hour, Status, count(*) as count
from uber_supply_demand_final
where `Pickup point` = 'Airport'
group by request_hour, Status
order by request_hour;

# 19) CITY DEMAND GAP BY HOUR 

 select request_hour , Status, count(*) as count
 from uber_supply_demand_final
 where `Pickup point` = 'City'
 group by request_hour, Status
 order by request_hour;
 
 # 20) COMPLETION RATE %
 select ROUND(
          sum(case when Status = 'Trip Completed' then 1 else 0 end) * 100.0
           /count(*), 2
		)as completion_rate_percentage
	from uber_supply_demand_final;
    
# CANCELATION RATE %
select  
   round(
       sum(case when Status = 'Canceled' then 1 else 0 end) * 100.0
       / count(*), 2
	) as cancellation_rate_percentage
from uber_supply_demand_final;

#  21) NO CARS AVILABLE % (TRUE SUPPLY GAP)
select
   round( 
     sum(case when Status = 'No Cars Avilable' then 1 else 0 end) * 100.0/count(*), 2)
     as no_car_percentage
     from uber_supply_demand_final;
     
# 22) TOP BUSIEST HOURS 
select request_hour, count(*) as requests
from uber_supply_demand_final
group by request_hour
order by requests desc
limit 5; 

# 23) LEAST BUSY HOURS (OPTIMIZATION OPPORTUNITY)
select request_hour, count(*) as requests
from uber_supply_demand_final
group by request_hour
order by requests asc
limit 5;