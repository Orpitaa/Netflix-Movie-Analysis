SELECT * From movies;
----1.Checking the type of content
SELECT DISTINCT (type)
FROM movies;

---2.Count the number of movies vs tv shows
SELECT 
count(type)AS total_content
from
movies
GROUP BY type;

---3.most common rating for movies and tv shows
SELECT 
type,
rating 
from 
(SELECT
type,
rating,
COUNT(*),
RANK()OVER(PARTITION BY  type ORDER BY count(*) desc) AS ranking 
from movies
GROUP BY 1,2)AS ranking_table
WHERE ranking = 1;

---------- 4.All movies released in 2020
SELECT*
FROM movies 
WHERE type =  'Movie' AND release_year = 2020;

--5.Find the top 5 countries with the most content on netflix
-- to split the country column in. a list in postgresql , the function :string_to_array
-- this function take 2 arguments one is the column name and the delemeter 
SELECT
TRIM(UNNEST(STRING_TO_ARRAY(country,','))) As country_new,--Using trim to shape data
COUNT(show_id)
from movies
GROUP BY country_new
order by COUNT(show_id) DESC 
LIMIT 5 

--- 6.Identify the largest movie
SELECT 
    MAX(CAST(regexp_replace(duration, '[^0-9]', '', 'g') AS INTEGER)) AS longest_duration
FROM 
    movies;

---- 7. content added in last 5 years
SELECT *
FROM movies
WHERE date_added >= CURRENT_DATE - INTERVAL '5 years'

--- 7 Find all movies or tv shows by Rajiv Chilaka

SELECT*
FROM movies
WHERE director ILIKE '%Rajiv Chilaka%'

--8 find all the tv shows with more tahn 5 seasons
SELECT*
FROM  movies 
WHERE 
type ILIKE 'Tv Show' 
AND
SPLIT_PART(duration,' ',1)::numeric > 5 ;

--9.Count the number of content items in each genre
SELECT
COUNT(show_id),
TRIM(UNNEST(STRING_TO_ARRAY(listed_in,',')))AS genre
FROM movies
GROUP BY genre;


---10. find each year and the average numbers of content realese by uk in movies
-- return top 5 year with highest average content realese

SELECT
EXTRACT(year from date_added)as year,
count(*),
round(count(*)::numeric/(select count(*)from movies where country ilike 'united kingdom')::numeric*100,2)as avg_of_content
FROM movies 
WHERE country ILIKE 'united kingdom'
GROUP BY year

--11.SElECT all movies that are documentary
SELECT
type,
listed_in
FROM 
movies 
WHERE 
type ILIKE 'Movie'AND
listed_in ILIKE 'Documentaries'
---12 find all content without director
SELECT*
FROM movies 
WHERE director IS NULL
--13.how many film was done by Salman khan in last 10 years
SELECT*
FROM movies 
WHERE "cast" ILIKE '%Salman khan%'
AND 
release_year>EXTRACT(year from current_date)-10


