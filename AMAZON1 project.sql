use Capstoneproject;

Create table amazoncreate (
invoice_id varchar(30) ,
Branch varchar(5) ,
City varchar(30) ,
customer_type varchar(30) ,
Gender varchar(10) ,
quantity Decimal ,
VAT INT ,
total Decimal(10,2) ,
date DATE ,
time TIMESTAMP ,
payment_method Varchar(30) ,
cogs Decimal(10,2) ,
gross_margin_percentage Decimal(10,2) ,
Rating Decimal(3,1)
);

select * from amazon;

select count(*) from amazon;

select sum(total) as total_sales from amazon;

select max(rating) from amazon;

select Branch, sum(total) as branch_sales
from amazon
group by Branch;

# 1.) WHAT  IS THE COUNT OF DISTINCT CITITES IN THE DATADSET?

select count(Distinct city)As No_of_cities
from amazon;

 # 2.) for each  branch is the corresponding  city ?
 select distinct branch, city
 from amazon
 order by branch asc;

# 3.) what is the count of distinct citites?

select  count(distinct 'product line')as distinct_product_lines
from amazon;

# 4.) which payment method ocurss most frequently ?

select payment, count(*) as frequency
from amazon
group by payment
order by frequency;

#5.) which product line has the highest sales?

select `product_line`, 
	 sum(`unit_price` * `quantity`) as total_sales
from amazon
group by `product_line`
order by total_sales desc;

# 6.) how much revenue genrated each month ?
select  date_format ('date', '%y-%m') as month , sum('Unit price' * 'quantity') as revenue
from amazon
group by month
order by revenue asc;

# 7.)  ? in which did the cost of goods sold reach its peak?

select date_format ('date', '% Y -%M') as month, sum('cogs') as total_cogs
from amazon
group by month
order by total_cogs desc limit 1;

# 8.) which product line genrated the highest revenue?
select 'product line', sum('unit price' * 'quantity') as total_revenue
from amazon
group by 'product line'
order by total_revenue desc limit 1;

describe amazon;

# 9.) in which city was the highest revenue recorded?
select city, sum('total')as total_revenue
from amazon
group by city
order by total_revenue asc limit 1;

# which product line incured the highest value added tax?

select 'product_line', sum('total 5%')as total_tax
from amazon 
group by 'Product_line'
Order by total_tax desc;

select `product line`, `unit price`, `quantity`, `total`
from amazon
limit 10;

# YOU CAN CHECK NULL VALUES OR MIN & MAX PRICE MIN & MAX QUANTITY?

select
sum(case when `unit_price` is null or `quantity` is null  then 1 else 0 end) as null_count,
min(`unit_price`) as min_proce, max(`unit_price`) as max_price,
min(quantity) as min_qty, max(quantity) as max_qty
from amazon;

# USING ALTER CHANGE COLUMNS

alter table amazon
   change `product line` product_line text,
   change `unit price` unit_price double;

describe amazon;

# TOTAL SALES PER CITY (GROUP/ORDER)

select product_line,
sum(unit_price * quantity)as total_revenue
from amazon
group by product_line
order by total_revenue desc
limit 1;


# CHECK MIN /MAX AND NULLL COUNTS

select sum(case when unit_price is null or quantity is null then  1 else 0 end) as null_count,
       min(unit_price) as min_price,
       max(unit_price) as max_price,
       min(quantity) as min_qty,
       max(quantity) as max_qty
from amazon;


# 10.)WHICH PRODUCT LINE INCURED THE HIGHEST VALUE ADDED TAX?
select `product_line`, sum('total5%') as total_tax
from amazon
group by `product_line`
order by total_tax desc;

# 11.) for each product line ,add a column indexing "good" if its sales above  average otherwise "bad"?
select 
`product_line`,
sum(total)as total_sales,
case when 
     sum(total)> (select avg(total_sales)
     from
     (select
     `product_line`, sum(total) as 
     total_sales
     from amazon
     group by `product_line`)as subquery)
     then 'good'
     else 'bad'
     end as sales_status from amazon
     group by `product_line`
     order by total_sales desc;
     
# 12.) IDENTITY THE BRANCH THAT EXEDED THE AVERAGE NUMBER OF PRODUCT SOLD?
 select branch, sum(quantity)as total_quantity_sold
 from amazon
 group by branch 
 having sum(quantity)>(select avg (total_quantity)
 from (select branch, sum(Quantity) as total_quantity
 from amazon
 group by branch) as subquery);
 
 # 13.) which product line is most frequently associated with each gender?
 
 select gender, `product_line`
 from(
 select gender, `product_line`, count(*) as total_count,
 rank() over(partition by gender
 order by count(*) desc) as row_num
 from amazon
 group by gender, `product_line`)as ranked_data where row_num =1;
 
 # 14.)CALCULATE THE AVERAGE RATING FOR EACH ORODUCT LINE?
 
 select `product_line`,avg(rating) as
 average_rating
 from amazon
 group by `product_line`;
 
 # 15.)COUNT THE SALES OCCURENCES FOR EACH TIME OF DAY ON EVERY WEEKDAY ?
  
  select dayname(date)as weekday, hour(time)as hair_of_day, count(*) as sales_count
  from amazon
  group by weekday, hair_of_day
  order by weekday, hair_of_day;
  
  # 16.) IDENTITY THE CUSTOMER TYPE COTRIBUTING THE HIGHEST REVENUE?
  select 'customer_type', sum(total) as total_revenue
  from amazon
  group by 'customer_type'
  order by total_revenue desc;
  
  # 17.) DETERMINE THE CITY WITH THE HIGHEST VAT PERCENTAGE.?
  select city, max('tax 5%')as highest_vat_percentage
  from amazon
  group by city
  order by highest_vat_percentage;
  
  # 18.) IDENTITY THE CUSTOMER TYPE WITH THE HIGHEST VAT PERCENTAGE.? 
  select'customer_type', max('tax 5%')as 'Highest_vat_percentage'
  from amazon
  group by 'customer_type'
  order by 'Highest_vat_percentage' desc;
  
  # 19.) WHAT IS THE COUNT DISTINCT PAYMENT METHODS IN THE DATASET.?
  select count(distinct 'customer_type') as distinct_customer_types
  from amazon;
  
  # 20.) what is the count of distinct customer type of in the dataset .?
  select count(distinct 'customer-type')as distinct_customer_types
  from amazon;
 
 
 #21.)WHICH CUSOMER OCCURS MOST FREQUENTLY.?
 
 select 'customer', count(*) as frequency
 from amazon 
 group by 'customer '
 order by frequency desc
 limit 1;

#22.) IDENTIFY THE CUSTOMER TYPE WITH THE HIGHEST PURCHASE FREQUENCY.? 
select 'customer', count(*) as purchase_frequency 
from amazon
group by 'customer' 
order by purchase_frequency desc
limit 1;

# 23.) DETERMINE THE PREDMINANT GENDER AMONG CUSTOMERS.?
select 'gender', count(*)as 'gender_count'
from amazon
group by 'gender'
order by 'gender_count' desc;

#23.)SEE DISTINCT RAW VALUES (SHOWS LITERLY WHAT'S STORED)
select distinct gender, length(gender)as len, count(*) as cnt
from amazon
group by gender, length(gender)
order by cnt desc;

# SHOW THE FIRST 8 ROWS SO WE CAN INSPECT HEADERS/VALUES. 
select 'invoice id', gender
from amazon
limit 8;

#  DETECT INVISIBLE SPACES OR NON-PRINTABLE CHARCTERS .
select gender, count(*) as cnt,
concat('<', gender, '>')as shown,
length(gender) as len
from amazon
group by gender, length(gender)
order by cnt desc;

# IF YOU PREFER A ONE -LINE SAFE QUERY (HANDELS NULL/EMPTY/SPACES WITHOUT MODIFYING DATA)

select 
case 
when gender is null or trim(gender) ='' then 'unknown'
else trim(gender)
end as gender_clean,
count(*) as gender_count
from amazon 
group by gender_clean 
order by gender_count desc;

# 24.)Examine the distrbution of gender with each branch.?
select 'branch', gender, count(*) as 'gender_count'
from amazon 
group by 'branch', gender
order by 'branch','gender_count' desc;

# IF YOU WANT THE RESULT IN A CLEAN FORM LIKE.
select branch,
sum(case when gender = 'female' then 1 else 0 end)as female_count,
sum(case when gender = 'male' then 1 else 0 end) as male_count
from amazon
group by branch;

# 25.) identity the time of day when customers provide the most ratings.? 
select 
    case
       when hour(time) between 6 and 11 then 'morning'
	   when hour(time) between 12 and 16 then 'aternoon'
       when hour(time) between 17 and 20 then 'evening'
       else 'night'
	end as time_of_day,
    count(*) as rating_count
from amazon
group by time_of_day
order by rating_count desc;

# .26) DETERMINE  THE TIME OF  DAY WITH THE HIGHEST CUSTOMER RATINGS FOR EACH BRANCH.? 
select t.branch, t.hour_of_day, t.avg_rating
from(
select branch,
             hour(time) as hour_of_day,
             avg(Rating) as avg_rating,
             row_number() over (partition by branch order by avg(rating) desc) as rn
from amazon
group by branch, hour(time)
) t
where t.rn =1;

#27.) IDENTIFY THE DAY OF THE WEEK WITH THE HIGHEST AVERAGE RATINGS.?
# HIGHEST AVG RATING BY DAY OF WEEK. 
select dayname(date) as day_of_week,
       avg(Rating) as  avg_Rating
from amazon
group by day_of_week
order by avg_rating desc;
    
# 28 .) DETERMINE THE DAY OF THE WEEK WITH THE HIGHEST AVERAGE RATINGS FOR EACH BRANCH.? 
select branch, day_of_week, avg_rating
from(
select
'branch',
dayname('date') as day_of_week,
avg('rating') as avg_rating,
row_number() over (partition by 'branch' order by avg('rating') desc)as rn
from amazon
group by 'branch',dayname('date')
) t
where rn =1 
order by branch;

# CHECK YOUR DATE COLUMN FORMAT.
select 'date', length('date')
from amazon
limit 10;

# CONVERT THE DATE STRING INTO A REAL MY SQL DATE 
select str_to_date('date', '%d/%m/%y')as converted_date
from amazon
limit 10;

# USE CONVERTED DATE TO GET DAY OF WEEK.
select branch,
	   dayname(str_to_date('date', '%d/%m/%y')) as day_of_week,
       avg(rating) as avg_rating
from amazon
group by branch, day_of_week
order by branch, avg_rating desc;

# FIND THE HIGHEST - RATED DAY FOR EACH BRANCH.
select t.branch, t.day_of_week, t.avg_rating
from(
    select branch,
		   dayname(str_to_date('date', '%d/%m/%y'))as day_of_week,
           avg(rating)as avg_rating,
           row_number() over (partition by branch order by avg(rating) desc)as rn
   from amazon
   group by branch, day_of_week
   )t
   where t.rn = 1;
   
# ACTUAL  DATE FORMAT
select'date'
from amazon
limit 5;

 use capstoneproject;
 



