# Itunes  Apple Music Analysis.

        1.Customer Analytics.

Q1. which customers have spent the most money on music?

select 
     c.customer_id,
	 c.first_name,
	 c.last_name,
     Round(sum(i.total), 2) as total_spent
from customer c
join invoice i 
    on c.customer_id = i.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_spent desc;

Q2. What is the avarage customer lifetime value?

select
     Round(avg(total_spent), 2)as avg_customer_lifetime_value
from (
    select
	    customer_id,
		sum(total) as total_spent
	from invoice
	group by customer_id
) sub;

Q3. How many customers made repeat purchases vs one-time purchases?

select
    case
	   when invoice_count = 1 then 'one-time Purchase'
	   else 'Repeat Purchase'
	end as purchase_type,
	count(*) as customer_count
 from (
      select
	      customer_id,
		  count(invoice_id) as invoice_count
		from invoice
        group by customer_id
) sub
group by purchase_type;

Q4. which country genrates the most revenue per customer?

select
     billing_country,
	 Round(sum(total) / count(distinct customer_id), 2)as revenue_per_customer
from invoice
group by billing_country
order by revenue_per_customer desc
limit 1;

Q5.which customers havent made a purchase in the last 6 months?

select
     c.customer_id,
	 c.first_name,
	 c.last_name
from customer c
left join invoice i
    on c.customer_id = i.customer_id
group by c.customer_id, c.first_name, c.last_name
having max(i.invoice_date::date) < (
    select max(invoice_date::date) - INTERVAL '6 months'
	from invoice
);


          2.Sales & Revenue Analysis

# Q1. what are the monthly Revenue trends for the last two years?

Select 
     date_trunc('month', invoice_date::date)as month,
	 round(sum(total), 2) as monthly_revenue
from invoice
where invoice_date::date >= (
    select max(invoice_date::date) - interval '2 years'
	from invoice
)
group by month
order by month;


#Q2. What is the average value of an invoive?

select 
     Round(avg(total), 2)as avg_invoice_value
from invoice;

# Q3. Monthly Revenue Trends?
select 
     DATE_TRUNC('month', invoice_date::timestamp)as month,
     Round(sum(total), 2) as monthly_revenue
from Invoice
group by month
order by month;

#Q4. How much revenue does each sales reprentative contribute?
 select
     e.employee_id,
	 e.first_name,
	 e.last_name,
	 round(sum(i.total), 2)as total_revenue
from employee e
join customer c
    on e.employee_id = c.support_rep_id
join invoice i
    on c.customer_id = i.customer_id
group by e.employee_id, e.first_name, e.last_name
order by total_revenue desc;

# Q5.which months or quarters have peak music sales?

select 
    date_trunc('month', invoice_date::timestamp)as month,
	round(sum(total), 2) as monthly_revenue
from invoice
group by month
order by monthly_revenue desc
limit 1;


    3.Product And Content analysis

Q1. Which track genrated the most revenue?

select
     t.track_id,
	 t.name as track_name,
	 round(sum(il.unit_price * il.quantity), 2)as total_revenue
from invoice_line il
join track t
   on il.track_id = t.track_id
group by t.track_id, t.name
order by total_revenue desc
limit 10;

Q2. which albums are the most frequently included in purchases?

select 
     a.album_id,
	 a.title as album_name,
	 count(il.invoice_line_id) as purchase_count
from invoice_line il
join track t
    on il.track_id = t.track_id
join album a
    on t.album_id = a.album_id
group by a.album_id, a.title
order by purchase_count desc
limit 10;

Q3.Are there any tracks that have never been purchased?

select
    t.track_id,
	t.name as track_name
from track t
left join invoice_line il
   on t.track_id = il.track_id
where il.track_id is null
order by t.track_id;

Q4. what is average price per track across differnt genres?

select 
     g.name as genre_name,
	 round(avg(t.unit_price), 2)as avg_price
from track t 
join genre g
     on t.genre_id = g.genre_id
group by g.name
order by avg_price desc;

 Q5. how many tracks does the store have per genre and how does it correlate with sales?

 select 
     g.name as genre_name,
	 count(distinct t.track_id)as total_tracks,
	 round(sum(il.unit_price * il.quantity), 2) as total_sales
from genre g 
left join track t
    on g.genre_id = t.genre_id 
left join invoice_line il
   on t. track_id = il.track_id
group by g.name
order by total_sales desc nulls last;

     1. Employee & Invoice Analysis
 
 Q1. who is the senior most employee based on job title?

 select first_name,
        last_name,
		title
from employee
order by levels desc
limit 1;

Q2. which countries have the most invoics?

select billing_country,
        count(invoice_id) as invoice_count
from invoice
group by billing_country
order by invoice_count desc;

Q3. what are the top 3 values of total invoice?

select total
from invoice
order by total desc
limit 3;
 
Q4. which city has the highest total invoice amount?

select billing_city,
       sum(total) as total_revenue
from invoice
group by billing_city
order by total_revenue desc
limit 1;

Q5. who is the best customer?

select c.customer_id,
       c.first_name,
	   c.last_name,
	   sum(i.total) as total_spent
from customer c
join invoice i on c.customer_id = i.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_spent desc
limit 1;


       2. Customer & Music Preference Analysis

Q6. write query to return email,first name, last name & genre of all Rock Music listeners.?

select distinct c.email,
       c.first_name,
	   c.last_name,
	   g.name as genre
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
where g.name = 'Rock'
order by c.email;

Q7. invite the artists who have written the most Rock music?(Top 10 Rock Artist)

select ar.name as artist_name,
       count(t.track_id) as rock_song_count
from track t
join genre g on t.genre_id = g.genre_id
join album al on t.album_id = al.album_id
join artist ar on al.artist_id = ar.artist_id
where g.name = 'Rock'
group by ar.name
order by rock_song_count desc
limit 10;

Q8. Return all track names that have a ssong length longer than the average song length?

select name,
       milliseconds
from track 
where milliseconds > (
     select avg(milliseconds)
	 from track
)
order by milliseconds desc;

Q9.Find how much amount spent by each customer on artist?

select c.customer_id,
       c.first_name,
	   c.last_name,
	   ar.name as artist_name,
	   sum(il.unit_price * il.quantity)as total_spent
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join album al on t.album_id = al.album_id
join artist ar on al.artist_id = ar.artist_id
group by c.customer_id, c.first_name, c.last_name, ar.name
order by total_spent desc;


Q10. Most Popular Genre for each Country?

select country,
       genre_name,
	   purchase_count
from(
   select c.country,
          g.name as genre_name,
		  count(il.invoice_line_id) as purchase_count,
		  Rank() over (
              partition by c.country 
			  order by count(il.invoice_line_id) desc
		  ) as rnk 
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
group by c.country, g.name
) sub
where rnk = 1
order by country;

          3. Adaavnced Popularity & Revenue Insights

Q11. Customer that has spent the most money in each country?

select country,
       first_name,
	   last_name
	   total_spent
from (
     select c.country,
	        c.first_name,
			c.last_name,
			sum(i.total) as total_spent,
			rank() over(
                partition by c.country
				order by sum(i.total) desc
			) as rnk
	from customer c
	join invoice i on c.customer_id = i.customer_id
	group by c.country, c.first_name, c.last_name
) sub 
where rnk = 1
order by country;

Q12. Who are the most popular artist?

 select ar.name as artist_name,
        count(il.invoice_line_id) as total_purchases
from invoice_line il
join track t on il.track_id = t.track_id
join album al on t.album_id = al.album_id
join artist ar on al.artist_id = ar.artist_id
group by ar.name
order by total_purchases desc;

Q13. Which is the most ppopular song?

select t.name as song_name,
        count(il.invoice_line_id) as total_purchases
from invoice_line il
join track t on il.track_id = t.track_id
group by t.name
order by total_purchases desc
limit 1;

Q14.what are the average prices of different types of music?

select g.name as genre_name,
       round(avg(t.unit_price), 2) as avg_price
from track t
join genre g on t.genre_id = g.genre_id
group by g.name
order by avg_price desc;

Q15. how does rack length affect purchase frequency?
select 
     t.name as track_name,
	 t.milliseconds,
	 count(il.invoice_line_id) as Purchse_count
from track t
left join invoice_line il
    on t.track_id = il.track_id
group by  t.track_id, t.name, t.milliseconds
order by Purchse_count desc;

