select count(*)
from video_game;

# 1.top 10 highest Rated Games

select "Title", "Rating"
from video_game
order by "Rating" desc
limit 10;

# 2. Best Developrs (Teams)

select "Team", avg("Rating") as avg_rating
from video_game
group by "Team"
order by avg_rating desc;

# 3.Most Common Genres

select "Genres", count(*) as total
from video_game
group by "Genres"
order by total desc;

# 4.Baklog vs Wishlist

select 
    "Title",
	"Backlogs",
	"Wishlist",
	(
      COALESCE(NULLIF(regexp_replace("Backlogs", '[^0-9.]','', 'g'), '')::numeric, 0)
	 *
	 Case
	  WHEN "Backlogs" ILIKE '%k' THEN 1000
	  WHEN "Backlogs" ILIKE '%m' THEN 1000000
	  ELSE 1
	 END
	 -
	 COALESCE(NULLIF(regexp_replace("Wishlist", '[^0-9.]','', 'g'), '')::numeric, 0)
	 *
	 CASE
	   WHEN "Wishlist" ILIKE '%k' THEN 1000
	   WHEN "Wishlist" ILIKE '%m' THEN 1000000
	   ELSE 1
	  END
	  ) AS diff
	 FROM video_game
	 order by diff desc
	 limit 10;

select column_name, data_type
from information_schema.columns
where table_name = 'video_game';

# 5.Release Trend (Year-wise)

select substring("Release Date",1,4)as year, 
       count(*) as total
from video_game
group by year
order by year;

#6.Rating Distribution

select round("Rating") as rating_group, count(*) as total
from video_game
group by rating_group
order by rating_group;

# 7.Top 10 Wishlisted

select "Title", 
       "Wishlist",
	   (
        COALESCE(NULLIF(regexp_replace("Wishlist", '[^0-9.]', '', 'g'), '')::numeric, 0)
		*
		CASE
		    WHEN "Wishlist" ILIKE '%k' THEN 1000
			WHEN "Wishlist" ILIKE '%m' THEN 1000000
			ELSE 1
		  END
		  ) AS wishlist_num
		 FROM video_game
		 ORDER BY wishlist_num DESC
		 limit 10;

# 8.AVG Plays Game 

select 
   "Genres",
   AVG(
   COALESCE(
     NULLIF(regexp_replace("Plays", '[^0-9.]', '', 'g'), '')::numeric
	 *
	 CASE
	    WHEN "Plays" ILIKE '%k' THEN 1000
		WHEN "Plays" ILIKE '%m' THEN 1000000
		ELSE 1
	 END,
   0)
   ) AS avg_plays
   from video_game
   group by "Genres"
   order by avg_plays desc;

# 9.Most Productive Developers

select "Team", count(*) as games_count,avg("Rating") as avg_rating
from video_game
group by "Team"
order by games_count desc;





	   

