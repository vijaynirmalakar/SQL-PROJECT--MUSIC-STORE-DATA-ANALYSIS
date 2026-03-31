use music_store;


                        --  Question Set 1 - Easy 

-- 1. Who is the senior most employee based on job title? 
-- Ans:
select * from employee
order by levels desc
limit 1;

-- 2. Which countries have the most Invoices? 
-- Ans:
select billing_country, count(*) as total_invices from invoice
group by billing_country 
order by count(*) desc;

-- 3. What are top 3 values of total invoice? 
-- Ans:
select total from invoice
order by total desc
limit 3;


-- 4. Which city has the best customers? We would like to throw a promotional Music 
-- Festival in the city we made the most money. Write a query that returns one city that 
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice 
-- totals 
-- Ans: -
select billing_city, sum(total) as total_invoice
from invoice
group by billing_city
order by total_invoice desc
limit 1;

-- 5. Who is the best customer? The customer who has spent the most money will be 
-- declared the best customer. Write a query that returns the person who has spent the 
-- most money 
-- Ans: -
select customer.first_name, last_name, round(sum(invoice.total),2) as total_invoice
from customer
join invoice 
using(customer_id)
group by customer.first_name, last_name
order by total_invoice desc
limit 1;

                        -- Question Set 2 – Moderate 

-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music 
-- listeners. Return your list ordered alphabetically by email starting with A 
-- Ams: 
select distinct customer.first_name, customer.last_name, customer.email, genre.name
from customer
join invoice using(customer_id)
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
order by customer.email asc;

-- 2. Let's invite the artists who have written the most rock music in our dataset. Write a 
-- query that returns the Artist name and total track count of the top 10 rock bands 
-- Ans:-

select artist.name, count(track.track_id) as count_track
from artist
join album using(artist_id)
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.name
order by count_track desc
limit 10;

-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first
-- Ans:-
 select name, milliseconds from track
 where milliseconds > (select avg(milliseconds) as avg_track_len
 from track)
 order by milliseconds desc;
 
							-- Question Set 3 – Advance 
 
-- 1. Find how much amount spent by each customer on artists? Write a query to return 
-- customer name, artist name and total spent 
-- Ans:-
with best_selling_artist as (
    select artist.artist_id, artist.name as artist_name,
    ROUND(SUM(invoice_line.unit_price * invoice_line.quantity), 2) as total_sales
    from artist
    join album on artist.artist_id = album.artist_id
    join track on album.album_id = track.album_id
    join invoice_line on track.track_id = invoice_line.track_id
    group by artist.artist_id, artist.name
    order by total_sales desc
    limit 1
)
select 
    customer.first_name, 
    customer.last_name,
    best_selling_artist.artist_name,
    ROUND(SUM(invoice_line.unit_price * invoice_line.quantity), 2) as total_spent
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join best_selling_artist on album.artist_id = best_selling_artist.artist_id
group by customer.first_name, customer.last_name, best_selling_artist.artist_name
order by total_spent desc;

-- 2. We want to find out the most popular music Genre for each country. We determine the 
-- most popular genre as the genre with the highest amount of purchases. Write a query 
-- that returns each country along with the top Genre. For countries where the maximum 
-- number of purchases is shared return all Genres 
-- Ans:-
WITH country_genre_purchases AS (
    -- Step 1: Count purchases per genre per country
    SELECT 
        invoice.billing_country AS country,
        genre.name AS genre_name,
        COUNT(invoice_line.quantity) AS total_purchases
    FROM invoice
    JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
    JOIN track ON invoice_line.track_id = track.track_id
    JOIN genre ON track.genre_id = genre.genre_id
    GROUP BY invoice.billing_country, genre.name
),
max_purchases_per_country AS (
    -- Step 2: Find the max purchases for each country
    SELECT country, MAX(total_purchases) AS max_purchases
    FROM country_genre_purchases
    GROUP BY country
)

-- Step 3: Match genres that equal the max (handles ties too)
SELECT 
    cgp.country,
    cgp.genre_name,
    cgp.total_purchases
FROM country_genre_purchases cgp
JOIN max_purchases_per_country mpc 
    ON cgp.country = mpc.country 
    AND cgp.total_purchases = mpc.max_purchases
ORDER BY cgp.country ASC;
 
 
-- 3. Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how 
-- much they spent. For countries where the top amount spent is shared, provide all 
-- customers who spent this amount  
-- Ans:-
with customer_spending as (
    -- Step 1: Calculate total spending per customer per country
    select 
        customer.first_name,
        customer.last_name,
        invoice.billing_country as country,
        ROUND(SUM(invoice.total), 2) as total_spent
    from customer
    join invoice on customer.customer_id = invoice.customer_id
    group by customer.first_name, customer.last_name, invoice.billing_country
),

max_spending_per_country as (
    -- Step 2: Find max spending per country
    select country, MAX(total_spent) as max_spent
    from customer_spending
    group by country
)
-- Step 3: Match customers who equal the max (handles ties!)
select 
    cs.country,
    cs.first_name,
    cs.last_name,
    cs.total_spent
from customer_spending cs
join max_spending_per_country msc
    on cs.country = msc.country
    and cs.total_spent = msc.max_spent
order by cs.country asc;