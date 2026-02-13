select count(*) from video_game_sales_cleaned;

# 1. which region genrates the most game sales?

select
     sum("NA_Sales") as North_America,
	 sum("EU_Sales") as Europe,
	 sum("JP_Sales") as Japan,
	 sum("Other_Sales") as Other_Regions
from video_game_sales_cleaned;

# 2. Best - selling platforms

 select
      "Platform",
	  sum("Global_Sales") as Total_Global_Sales
	from video_game_sales_cleaned
	group by "Platform"
	order by  Total_Global_Sales desc;

# 3. Trend of game releases & sales over years

select 
     "Year",
	 count(*) as Total_Games,
	 sum("Global_Sales") as Total_Sales
from video_game_sales_cleaned
group by "Year"
order by "Year";

# 4. Top Publishers by sales

select
    "Publisher",
	sum("Global_Sales") as Total_Global_Sales
from video_game_sales_cleaned
group by "Publisher"
order by Total_Global_Sales desc
limit 10;

# 5. Top 10 best - selling games globally

select
    "Name",
	"Platform",
	"Global_Sales"
from video_game_sales_cleaned
order by "Global_Sales" desc
limit 10;

# 6. Regional sales by platforms

select 
    "Platform",
	sum("NA_Sales") as NA,
	sum("EU_Sales") as EU,
	sum("JP_Sales") as JP
from video_game_sales_cleaned
group by "Platform";

# 7. Market Evolution by Platform over

select 
    "Year",
	"Platform",
	sum("Global_Sales") as Total_Sales
from video_game_sales_cleaned
group by "Year", "Platform"
order by "Year";

# 8. Regional genre preferences
 select 
      "Genre",
	  sum("NA_Sales") as NA,
	  sum("EU_Sales") as EU,
	  sum("JP_Sales") as JP
from video_game_sales_cleaned
group by "Genre";

# 9. Yearly sales change per region

select 
    "Year",
	sum("NA_Sales") as NA,
	sum("EU_Sales") as EU,
	Sum("JP_Sales") as JP
from video_game_sales_cleaned
group by "Year"
order by "Year";

# 10. Average sales per Publisher

select
    "Publisher",
	avg("Global_Sales") as Avg_Global_Sales
from video_game_sales_cleaned
group by "Publisher"
order by Avg_Global_Sales desc;

# 11.Top 5 games per platform (ADVANCED - very good for interview)

 select *
  from( 
     select
	    "Platform",
		"Name",
		"Global_Sales",
		rank() over (
            partition by "Platform"
			order by "Global_Sales" desc
			) as rnk
		from video_game_sales_cleaned
	) t
	where rnk <= 5;