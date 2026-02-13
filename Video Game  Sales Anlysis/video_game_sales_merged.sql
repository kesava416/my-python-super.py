select count(*) from video_game_sales_merged_final;

# 1. Genres that genrate the most global sales
select
     genre,
	 sum(global_sales) as total_global_sales
from video_game_sales_merged_final
group by genre
order by total_global_sales desc;

# 2. impact of rating on global sales 
select
    "Rating",
	global_sales
from video_game_sales_merged_final
where "Rating" is not null
   and global_sales is not null;

# 3. platform with most highly rated games

select
    platform,
	count(*) as high_rated_games
from video_game_sales_merged_final
where "Rating" >= 4
group by platform;


# 4.Trend of releases & sales over time

 select
     Year,
	 count(*) as total_releases,
	 sum(global_sales) as total_sales
from video_game_sales_merged_final
group by Year
Order by Year;

# 5. do highly wishlisted games lead to more sales

select
     case
	    when"Wishlist" ILIKE '%K%' THEN
	         REPLACE("Wishlist", 'K', '')::numeric * 1000
		ELSE
		   "Wishlist"::numeric
	 END AS wishlist_count,
	 global_sales
from video_game_sales_merged_final
where "Wishlist" is not null
  and global_sales is not null;

 # 6.high engagemnt but low sales genres
 
 select
      genre,
	  global_sales,
	  "Rating",
	  "Wishlist",
	  "Backlogs",
	  "Number of Reviews"
from video_game_sales_merged_final;


# 7.wishlist/backlogs vs Rating 

select
     "Rating",
	 "Wishlist",
	 "Backlogs"
from video_game_sales_merged_final
where "Rating" is not null;

# 8 User engagement across genres

select
    genre,
	avg(
	 case
	    when "Number of Reviews" ILIKE '%K%'
	        THEN REPLACE("Number of Reviews", 'K','')::numeric * 1000
	     ELSE NULLIF("Number of Reviews",'')::numeric
		End
	) as avg_reviews,
	avg(
      case
	    when "Plays" ILIKE '%K%'
		    THEN REPLACE("Plays",'K','')::numeric * 1000
		ELSE NULLIF("Plays",'')::numeric
	END
	) AS avg_reviews,
	AVG(
      CASE
	     WHEN "Plays" ILIKE '%K%'
		    THEN REPLACE("Plays",'K','')::numeric * 1000
		ELSE NULLIF("Plays",'')::numeric
	END
	) AS avg_plays,
	AVG(
      CASE
	     WHEN "Wishlist" ILIKE '%K%'
		     THEN REPLACE("Wishlist",'K','')::numeric * 1000
		ELSE NULLIF("Wishlist",'')::numeric
	END
	) AS avg_wishlist
from video_game_sales_merged_final
group by genre;

# 9. top 10 global sales

select
     genre,
	 platform,
	 sum(global_sales) as total_global_sales
from video_game_sales_merged_final
where global_sales is not null
group by genre, platform
order by total_global_sales desc;

#10 regional sales hetmap by genre reveal

select
     genre,
	 sum(na_sales) as na_sales,
	 sum(eu_sales) as eu_sales,
	 sum(jp_sales) as jp_sales,
	 sum(other_sales) as other_sales
from video_game_sales_merged_final
group by genre;

