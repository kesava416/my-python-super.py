   Cricbuzz Analysis  Project 

1) List all Matches

select 
    "matchId",
	"matchDesc",
	team1_name,
	team2_name,
	venue
	city
from matches
order by "matchId" DESC;

2) Total Runs Scored Each Player

select 
    "playerName",
	sum(runs) as total_runs
from players
group by "playerName"
order by total_runs DESC;

3) Top 5 Players by Runs

select 
     "playerName",
	 sum(runs)as total_runs
from players
group by "playerName"
order by total_runs desc
limit 5;


4) Total Runs in Each Match

select 
    "matchId",
sum(runs) as total_match_runs
from players
group by "matchId"
order by total_match_runs desc;

5) Total Wickets in Each Match

select
    "matchId",
	sum(wickets)as total_wickets
from match_scores
group by "matchId"
order by total_wickets desc;

6) Highest Runs Scored by a Player in a Match

select 
    "playerName",
	"matchId",
	max(runs) as highest_runs
from players
group by "playerName", "matchId"
order by highest_runs desc;

 # INTERMIDIATE LEVEL QUERIES

7) Cricket Series Started in 2024

select
     "seriesName",
	 "matchFormat",
	 city,
	 min(to_timestamp("startDate" / 1000)) as series_start_date,
	 count("matchId")as total_matches
from matches
group by "seriesName", "matchFormat", city
order by series_start_date;


8) last 20 completed Matches

select "matchDesc",
       team1_name,
	   team2_name,
	   status,
	   venue,
	   city
from matches
where status is not null 
order by "matchId" desc;

9) Last 20 Completed Matches

select "matchDesc",
       team1_name,
	   team2_name,
	   status,
	   venue,
	   city
from matches
where status is not null
order by "matchId" desc
limit 20;

10) player performance Across Formats

select 
     p."playerName",
	 sum(case when m."matchFormat" = 'Test' then p.runs else 0 end) as test_runs,
	 sum(case when m."matchFormat" = 'ODI' then p.runs else 0 end) as odi_runs,
	 sum(case when m."matchFormat" = 'T20' then p.runs else 0 end) as t20_runs,
	 round(avg(p.runs)::numeric,2) as overall_avg_runs
	 from players p
	 join matches m 
	     on p."matchId" = m."matchId"
group by p."playerName"
order by overall_avg_runs desc;

11) Home vs Away Team Performance

select 
     team1_name as team,
	 count(*) FILTER (
          where LOWER(team1_name) like LOWER(city) || '%'
		  ) as home_matches,
		  count(*) FILTER ( 
		       WHERE LOWER(team1_name) NOT LIKE LOWER(city) || '%'
			   ) as away_matches
from matches
group by team1_name
order by home_matches desc;

12) High Scoring Player Performance 

select 
     p."playerName",
	 p."matchId",
	 m."matchDesc",
	 sum(p.runs)as total_runs
from players p
join matches m
     on p."matchId" = m."matchId"
group by p."playerName", p."matchId",m."matchDesc"
having sum(p.runs) >= 100
order by total_runs desc;

13) Bowling Performance by Venue

select 
     p."playerName",
	 m.venue,
	 count(distinct p."matchId") as total_matches,
	 COALESCE(sum(ms.wickets),0) as total_wickets,
	 Round((COALESCE(sum(ms.wickets),0)::numeric / count(distinct p."matchId")), 2) as avg_wickets_per_match
from players p
LEFT join match_scores ms
    on p."matchId" = ms."matchId"
join matches m
    on p. "matchId" = m."matchId"
group by p."playerName", m.venue
order by avg_wickets_per_match desc;

14) Performance in close Matches

select 
     p."playerName",
	 count(distinct p."matchId")as matches_played,
	 sum(p.runs)as total_runs,
	 Round(avg(p.runs)::numeric, 2) as avg_runs
from players p
join matches m
    on p."matchId" = m."matchId"
group by p."playerName"
order by avg_runs desc;

15) last 20 mtches 

select "matchId",
       "matchDesc",
	   team1_name,
	   team2_name,
	   venue,
	   city
from matches 
order by "matchId" desc
limit 20;

16) home vs Away 

select 
    team1_name,
	city,
	case
	   when team1_name Ilike '%' || city || '%' then 'home'
	   else 'Away'
	 end as match_location,
	 count(*) as total_matches
from matches
group by team1_name, city, match_location;


# Advance Level Queries

17) Most Economical Bowlers

select 
    p."playerName",
	count(distinct p."matchId") as matches_played,
	coalesce(sum(ms.runs),0)as total_runs_conceded,
	coalesce(sum(ms.wickets),0) as total_wickets,
	coalesce(Round(sum(ms.overs)::numeric, 2),0) as total_overs,
	coalesce(
	    Round(
         (sum(ms.runs) / nullif(sum(ms.overs), 0))::numeric,
		 2
	  ),0
	) as economy_rate
from players p
left join match_scores ms
     on p."matchId" = ms."matchId"
group by p."playerName"
order by economy_rate asc;


18) Find Most consistent  batsman using Standard Deviation.

select 
     p."playerName",
	 count(*) as innings_played,
	 round(avg(p.runs)::numeric, 2) as avg_runs,
     round(coalesce(stddev(p.runs), 0)::numeric, 2) as consistency_score
from players p
join matches m
     on p."matchId" = m."matchId"
group by p."playerName"
order by consistency_score asc;

19) Player Performance Across Cricket Formats

select 
     p."playerName",
	 count(case when m."matchFormat" ='Test' then 1 end) as test_matches,
	 count(case when m."matchFormat" = 'ODI' then 1 end) as odi_mathces,
	 count(case when m."matchFormat" = 'T20' then 1 end) as t20_matches,
	 round(coalesce(avg(case when m."matchFormat" = 'Test' then p.runs end),0)::numeric, 2)as test_avg,
	 round(avg(case when m."matchFormat" = 'ODI' then p.runs end)::numeric, 2)as odi_avg,
	 round(coalesce(avg(case when m."matchFormat" = 'T20' then p.runs end),0)::numeric, 2) as t20_avg
from players p 
join matches m
    on p."matchId" = m."matchId"
group by p."playerName"
having count(distinct p."matchId") >= 1
order by odi_avg desc;

20) player Performance Ranking System

select
     p."playerName",
	 sum(p.runs)as total_runs,
	 round(avg(p.runs)::numeric, 2) as batting_avg,
	 coalesce(sum(ms.wickets), 0)as total_wickets,
	 (
      (sum(p.runs) * 0.01) +
	  (avg(p.runs) * 0.5)
	 ) as batting_points,
	 (
      coalesce(sum(ms.wickets), 0) *2
	 ) as bowling_points,
	 (
      (sum(p.runs) * 0.01) +
	  (avg(p.runs) * 0.5) +
	  (coalesce(sum(ms.wickets), 0) * 2)
	 ) as total_scores,
	 rank() over (
          order by
		  (
           (sum(p.runs) * 0.01)+
		   (avg(p.runs) * 0.5)+
		   (coalesce(sum(ms.wickets),0) * 2)
		   )desc
		   ) as player_rank
from players p
left join match_scores ms
    on p."matchId" = ms."matchId"
group by p."playerName"
order by player_rank;


21) Head-to-Head Match Analysis Bitween Teams

select
     m."team1_name",
	 m."team2_name",
	 count(*) as total_matches,
	 sum(case when m."status" ilike '%' || m."team1_name" || '%' then 1 else 0 end) as team1_wins,
	 sum(case when m."status" ilike '%' || m."team2_name" || '%' then 1 else 0 end) as team2_wins,
	 round(
          sum(case when m."status" ilike '%' || m."team1_name" || '%' then 1 else 0 end)::numeric
		  /count(*) * 100, 2
		  ) as team1_win_pct,
		  round(
            sum(case when m."status" ilike '%' || m."team2_name" || '%' then 1 else 0 end)::numeric
			/count(*) * 100, 2
			) as team2_win_pct
from matches m
group by m."team1_name", m."team2_name"
having count(*) >= 1
order by total_matches desc;

select column_name
from information_schema.columns
where table_name = 'matches';

21) Venue & Toss Impact AAnalysis

select 
      m."venue",
	  m."team1_name",
	  m."team2_name",
	  count(*) as total_matches,
	  sum(case when m."status" ilike '%' || m."team1_name" || '%' then 1 else 0 end) as team1_wins,
	  sum(case when m."status" ilike '%' || m."team2_name" || '%' then 1 else 0 end) as team2_wins 
from matches m
group by m."venue", m."team1_name", m."team2_name"
order by total_matches desc;

	 
22) Player Form & Consistency Analysis

select 
    p."playerName",
	count(*) as innings_played,
	round(avg(p.runs)::numeric, 2) as avg_runs,
	coalesce(round(stddev(p.runs)::numeric, 2), 0)as consistency_score
from players p
join matches m 
    on p."matchId" = m."matchId"
where p.balls >=10
group by p."playerName"
having count(*) >=1
order by consistency_score asc;

23) player Consistency & Performance Metrics

select distinct 
       p."playerName",
	   count(*) over (partition by p."playerName") as innings_played,
	   round(
            avg(p.runs) over (partition by p."playerName")::numeric, 2
	   ) as avg_runs,
	   coalesce(
          round(
               stddev(p.runs) over (partition by p."playerName")::numeric, 2
		  ), 0
	   ) as consistency_score
from players p
where p.balls >=10
order by consistency_score asc;


24) Top Consistant players (Using CTE)

with player_stats as ( 
    select
	    p."playerName",
		count(*) as innings_played,
		Round(avg(p.runs)::numeric, 2)as avg_runs,
		coalesce(round(stddev(p.runs)::numeric, 2), 0)as  consistency_score
from players p 
where p.balls >= 10
group by p."playerName"
)
select * 
from player_stats
where innings_played >=1
order by consistency_score asc;
           