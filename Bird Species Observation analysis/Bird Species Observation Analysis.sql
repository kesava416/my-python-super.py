    * BIRD SPECIES OBSERVATION ANALYSIS *

1)Identify the Most Biodiverse Habitat

select "Habitat", count(distinct "Common_Name") as species_diversity
from bird_observations
group by "Habitat"
order by species_diversity desc;

2) Detect Habitat With Low Observation Activity

select "Habitat",
count(*) as total_observations
from bird_observations
group by "Habitat"
order by total_observations desc;

3) Most Frequently Observed Bird Species 

select "Common_Name", count(*) as observations
from bird_observations
group by "Common_Name"
order by observations desc
limit 10;

4) Environmental Condition With Most Bird Activity

select "Sky", count(*) as bird_activity
from bird_observations
group by "Sky"
order by bird_activity desc;

5) Evaluate Monitoring Efficiency by Observer.

select "Observer", count(*) as observations_count
from bird_observations
group by "Observer"
order by observations_count desc
limit 10;

6) Identify Locations With High Disturbance

select "Disturbance",count(*) as Disturbance_count
from bird_observations
group by "Disturbance"
order by Disturbance_count desc;

7) Bird Observations Trends Over Time

select "Year", count(*) as total_observations
from bird_observations
group by "Year"
order by "Year";

8) Species Distribution  by Habitat 

select "Habitat", "Common_Name", count(*) as observations
from bird_observations
group by "Habitat", "Common_Name"
order by "Habitat", observations desc;

9) Average Environmental Conditions During Observations

select avg("Temperature") as avg_Temperature,
avg("Humidity") as avg_Humidity
from bird_observations;

10) Flyover Bird Behavior Analysis

select "Flyover_Observed", count(*) as observations
from bird_observations
group by "Flyover_Observed";


11) Total Bird Observations

select count(*) as total_observations
from bird_observations;

12)Observations by Habitat

select "Habitat", count(*) as observations
from bird_observations
group by "Habitat"
order by observations desc;

13) Top 10 Most Observed Bird Species

select "Common_Name", count(*) as observations
from bird_observations
group by "Common_Name"
order by observations desc
limit 10;

14) Bird Observations By Wind Condition

select "Wind", count(*) as observations
from bird_observations
group by "Wind"
order by observations desc;

15) Bird Observations by identification Method

select "ID_Method", count(*) as observations
from bird_observations
group by "ID_Method"
order by observations desc;

16) Top 10 Locations With Most Observations

select "Site_Name", count(*) as observations
from bird_observations
group by "Site_Name"
order by observations desc
limit 10;

17) Bird Obsrvations by Sex

select "Sex", count(*) as observations
from bird_observations
group by "Sex"
order by observations desc;

18) Average Tamperature by Habitat

select "Habitat",
avg("Temperature") as avg_temperature
from bird_observations
group by "Habitat";

19) Average Humidity by Habitat 

select "Habitat",
avg("Humidity") as avg_humidity
from bird_observations
group by "Habitat";

20) Observations By Distance Category

select "Distance", count(*) as observations 
from bird_observations
group by "Distance"
order by observations desc;
