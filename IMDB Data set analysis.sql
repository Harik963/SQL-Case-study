USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*) AS Number_of_rows FROM director_mapping;

SELECT count(*) AS Number_of_rows FROM  genre;

SELECT count(*) AS Number_of_rows FROM  movie;

SELECT count(*) AS Number_of_rows FROM  names;

SELECT count(*) AS Number_of_rows FROM  ratings;

SELECT count(*) AS Number_of_rows FROM role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT count(*) AS Null_values FROM movie
WHERE id IS NULL;
-- 0 null values

SELECT count(*) AS Null_values FROM movie
WHERE duration is null;
-- 0 null values

SELECT count(*) as Null_values
from movie
WHERE title is null;
-- 0 null values

SELECT count(*) as Null_values
 from movie
WHERE date_published is null;
-- 0 null values

SELECT count(*) as Null_values from movie
WHERE year is null;
-- 0 null values

SELECT count(*) as Null_values from movie
WHERE country is null;
-- 20 null values

SELECT count(*) as Null_values from movie
WHERE worlwide_gross_income is null;
-- 3724 null values

SELECT count(*) AS Null_values
FROM movie
WHERE languages is null;
-- 194 null values

SELECT count(*) AS Null_values 
FROM movie
WHERE production_company is null;
-- 528 null values

-- SUMMARY
-- id, title, year, date_published, duration have no null values.
-- country, worldwide_gross_income, languages, production_company has null values present.


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year AS Year, 
count(title) AS number_of_movies
FROM movie
GROUP BY year;

/*
Movies produced each year
2017--3052
2018--2944
2019--2001
*/

SELECT month(date_published) AS month_num, count(title) AS number_of_movies
FROM movie
GROUP BY month(date_published)
ORDER BY month(date_published);

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
WITH count_movies AS
(
SELECT *
FROM movie
WHERE year=2019 
)
SELECT count(*) AS movies_produced_US_or_Ind 
FROM count_movies
WHERE country LIKE "%India%"OR
country LIKE "%USA%";

-- Output 1059


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT count(distinct genre) AS unique_genres
FROM genre;

-- 13 unique genre identified
 
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT distinct genre, count(movie_id) AS Movies_P
FROM genre
GROUP BY  genre
ORDER BY  count(movie_id) DESC
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count AS
(
SELECT movie_id , count(genre) AS Total_count
FROM genre
GROUP BY  movie_id
)
SELECT COUNT(movie_id) AS movie_count
FROM 
genre_count
WHERE Total_count = 1;

-- 3289 Movies belongs to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre AS Genre, 
round(avg(m.duration),2) AS Avg_Duration
FROM
movie AS m
INNER JOIN
genre AS g
ON m.id=g.movie_id
GROUP BY  Genre
ORDER BY 
Avg_Duration desc;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_sum AS
(SELECT genre, 
count(movie_id) AS movie_count,
RANK() OVER (
ORDER BY  count(movie_id) DESC
) AS genre_rank
FROM genre
GROUP BY  genre
)
SELECT * 
FROM 
genre_sum
WHERE genre="thriller";

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT max(avg_rating) as max_avg_rating,
min(avg_rating) as min_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
FROM
ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, 
avg_rating,
RANK() OVER(
ORDER BY  avg_rating DESC
) AS movie_rank
FROM 
movie AS m
INNER JOIN
ratings AS r
ON m.id=r.movie_id
limit 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
count(movie_id) AS movie_count
FROM
ratings
GROUP BY  median_rating
ORDER BY median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH Prod_comp_rank AS 
(
SELECT m.production_company,
count(m.id) AS movie_count,
RANK() OVER(
ORDER BY count(m.id) DESC
) as prod_company_rank
FROM
ratings AS r
INNER JOIN
movie as m
ON m.id=r.movie_id
WHERE avg_rating>8 AND
production_company IS NOT NULL
GROUP BY  m.production_company
)SELECT * 
FROM
Prod_comp_rank
WHERE prod_company_rank=1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
COUNT(g.movie_id) AS movie_count 
FROM
genre AS g 
INNER JOIN
movie AS m 
ON g.movie_id = m.id 
INNER JOIN
ratings AS r 
ON m.id = r.movie_id 
WHERE
year = 2017 
AND MONTH(date_published) = 3 
AND country LIKE '%USA%' 
AND total_votes > 1000 
GROUP BY
genre 
ORDER BY
movie_count DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
USE imdb;

SELECT m.title,
r.avg_rating,
g.genre
FROM
ratings as r
INNER JOIN
movie as m
on m.id=r.movie_id
INNER JOIN
genre as g
on m.id=g.movie_id
where title like "The%" AND
avg_rating>8
ORDER BY  genre;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(m.title) AS NUMBER_OF_MOVIES
FROM
movie as m
INNER JOIN
ratings as r
on m.id=r.movie_id
where date(m.date_published) between "2018-4-1" and "2019-4-1"
AND
r.median_rating=8
order by m.date_published;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT sum(r.total_votes) AS Votes_Germany
FROM
ratings AS r
INNER JOIN
movie AS m
ON m.id=r.movie_id
WHERE country LIKE "%Germany%";
-- movie count divided by votes
SELECT sum(r.total_votes) AS Votes_Italy
FROM
ratings AS r
INNER JOIN
movie AS m
ON m.id=r.movie_id
WHERE country LIKE "%Italy%";



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(CASE WHEN name IS NULL then ID END) as name_nulls, 
	COUNT(CASE WHEN height IS NULL THEN ID END) as height_nulls, 
	COUNT(CASE WHEN date_of_birth IS NULL THEN ID END) as date_of_birth_nulls, 
	COUNT(CASE WHEN known_for_movies IS NULL THEN ID END) as known_for_movies_nulls 
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH genre_summary AS 
(
SELECT g.genre AS genre,count(m.id)
FROM
movie AS m
INNER JOIN
genre AS g
ON g.movie_id=m.id
INNER JOIN
ratings AS r
ON r.movie_id=m.id
WHERE r.avg_rating>8
GROUP BY  genre
ORDER BY  count(m.id) DESC 
LIMIT 3
)
SELECT N.NAME as Director_name,count(m.id) AS Movie_count
FROM
names AS n
INNER JOIN
director_mapping as dm
on dm.name_id=n.id
INNER JOIN
movie AS m
ON dm.movie_id=m.id
INNER JOIN
ratings AS r
ON r.movie_id=m.id
INNER JOIN
genre AS g
ON g.movie_id=m.id
where avg_rating>8 AND
g.genre in (
SELECT distinct genre
FROM genre_summary)
GROUP BY N.NAME
ORDER BY  count(m.id) DESC
limit 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name as actor_name,
count(rm.movie_id) as movie_count
FROM
names AS n
INNER JOIN
role_mapping AS rm
ON rm.name_id=n.id
INNER JOIN
ratings AS r
ON r.movie_id=rm.movie_id
WHERE median_rating>=8
GROUP BY  N.NAME
ORDER BY  movie_count desc
limit 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company AS production_company,
sum(r.total_votes) as vote_count,
rank() OVER
(ORDER BY sum(r.total_votes) desc)
 as prod_comp_rank
FROM
movie AS m
INNER JOIN
ratings as r
on m.id=r.movie_id
GROUP BY  m.production_company
ORDER BY  3
limit 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
 
 WITH actor_sum AS 
 (
SELECT 
n.name as actor_name, 
sum(r.total_votes) AS total_votes,
count(r.movie_id) AS movie_count,
SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes) AS actor_avg_rating,
r.movie_id
FROM
names AS n
INNER JOIN
role_mapping AS ro
ON ro.name_id = n.id
INNER JOIN
ratings AS r
ON r.movie_id=ro.movie_id
WHERE ro.category="Actor"
GROUP BY n.name
)
SELECT 
asum.actor_name, 
asum.total_votes,
asum.movie_count,
asum.actor_avg_rating,
dense_rank() OVER(
ORDER BY (asum.actor_avg_rating) DESC
) AS actor_rank
FROM
actor_sum AS asum
INNER JOIN
movie AS m
ON asum.movie_id=m.id
WHERE country="India"
AND 
movie_count>=5
;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_tab AS
(
SELECT 
n.name AS actress_name, 
r.total_votes,
count(r.movie_id) AS movie_count,
SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes) AS actress_avg_rating,
r.movie_id
FROM
names AS n
INNER JOIN
role_mapping AS ro
ON ro.name_id = n.id
INNER JOIN
ratings AS r
ON r.movie_id=ro.movie_id
INNER JOIN
movie AS m
ON m.id=r.movie_id
WHERE 
category= "actress"
AND country LIKE "%India%"
AND languages LIKE "%Hindi%"
GROUP BY n.name
)
SELECT 
atab.actress_name, 
atab.total_votes,
atab.movie_count,
round((atab.actress_avg_rating),2) AS actress_avg_rating ,
dense_rank() OVER(
ORDER BY (atab.actress_avg_rating) DESC
) AS actress_rank
FROM actress_tab AS atab
WHERE atab.movie_count>=3;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,r.avg_rating,
CASE 
WHEN 
r.avg_rating>8
THEN 
"superhit"
WHEN 
r.avg_rating BETWEEN 7 AND 8
THEN 
"Hit movies"
WHEN 
r.avg_rating BETWEEN 5 AND 7
THEN 
"One-time-watch movies"
WHEN 
r.avg_rating<5
THEN 
"Flop movies"
END 
AS movie_type
FROM
movie AS m
INNER JOIN
ratings AS r
ON m.id=r.movie_id
INNER JOIN
genre AS g
ON g.movie_id=m.id
WHERE genre="thriller";


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_duration AS 
(
SELECT
g.genre,
ROUND(AVG(m.duration), 2) AS avg_duration 
FROM
genre AS g 
LEFT JOIN
movie AS m 
ON g.movie_id = m.id 
GROUP BY
g.genre 
)
SELECT
*,
SUM(avg_duration) OVER (
ORDER BY
genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
AVG(avg_duration) OVER (
ORDER BY
genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration 
FROM
genre_duration;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genre AS
(
SELECT g.genre AS genre
FROM
genre AS g
LEFT JOIN
movie AS m
ON m.id=g.movie_id
GROUP BY g.genre
ORDER BY count(m.id) DESC
LIMIT 3
),
top_movies AS
(
SELECT g.genre AS genre,
m.year AS year,
m.title AS movie_name,
m.worlwide_gross_income AS income,
row_number() OVER(
PARTITION BY m.year
ORDER BY 
CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""),UNSIGNED INT) DESC
) AS movie_rank
FROM
movie AS m
INNER JOIN
genre AS g
ON m.id=g.movie_id
WHERE genre IN
( SELECT DISTINCT(genre)
FROM
top_genre)
 )
SELECT *
FROM
top_movies
WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_rank AS
(
SELECT m.production_company,
count(m.id) AS movie_count,
RANK() OVER(
ORDER BY count(m.id) DESC
) AS prod_comp_rank
FROM 
movie AS m
INNER JOIN
ratings AS r
ON r.movie_id=m.id
WHERE r.median_rating>=8 AND 
m.languages LIKE "%,%"
AND production_company IS NOT NULL 
GROUP BY m.production_company
ORDER BY count(m.id) DESC
)
SELECT * 
FROM
prod_rank
WHERE prod_comp_rank<=2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_list AS 
(
SELECT n.name AS actress_name,
count(m.id) AS movie_count,
m.id AS movie_id
FROM
names AS n
INNER JOIN
role_mapping AS rm
ON rm.name_id=n.id
INNER JOIN
movie AS m
ON rm.movie_id=m.id
WHERE rm.category="actress"
GROUP BY n.name
ORDER BY count(m.id) desc
),
Actress_rating AS
(SELECT actress_name,
sum(r.total_votes) AS total_votes,
movie_count,
ROUND( SUM(r.avg_rating*r.total_votes) / SUM(r.total_votes) , 2) AS actress_avg_rating,
row_number() OVER (
ORDER BY movie_count DESC) AS
actress_rank
FROM
actress_list AS al
INNER JOIN
genre AS g
ON g.movie_id=al.movie_id
inner join
ratings AS r
ON r.movie_id=g.movie_id
WHERE g.genre="Drama"
AND
r.avg_rating>8
GROUP BY actress_name
)
SELECT *
FROM
Actress_rating
WHERE actress_rank<=3
GROUP BY actress_name;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH directors_list AS 
(SELECT
n.id as director_id,
n.name as director_name,
COUNT(m.id) AS movie_count,
RANK() OVER (
ORDER BY
COUNT(m.id) DESC) AS director_rank 
FROM
names AS n 
INNER JOIN
director_mapping AS d 
ON n.id = d.name_id 
INNER JOIN
movie AS m 
ON d.movie_id = m.id 
GROUP BY
n.id 
)
,
movie_summary AS 
(
SELECT
n.id AS director_id,
n.name AS director_name,
m.id AS movie_id,
m.date_published,
r.avg_rating,
r.total_votes,
m.duration,
LEAD(date_published) OVER (PARTITION BY n.id 
ORDER BY m.date_published) AS next_date_published,
DATEDIFF(LEAD(date_published) OVER (PARTITION BY n.id 
ORDER BY
m.date_published), date_published) AS inter_movie_days 
FROM
names AS n 
INNER JOIN
director_mapping AS d 
ON n.id = d.name_id 
INNER JOIN
movie AS m 
ON d.movie_id = m.id 
INNER JOIN
ratings AS r 
ON m.id = r.movie_id 
WHERE
n.id IN 
(
SELECT
director_id 
FROM
directors_list 
WHERE
director_rank <= 9
)
)
SELECT
   director_id,
   director_name,
   COUNT(DISTINCT movie_id) AS number_of_movies,
   ROUND(AVG(inter_movie_days), 0) AS avg_inter_movie_days,
   ROUND( SUM(avg_rating*total_votes) / SUM(total_votes) , 2) AS avg_rating,
   SUM(total_votes) AS total_votes,
   MIN(avg_rating) AS min_rating,
   MAX(avg_rating) AS max_rating,
   SUM(duration) AS total_duration 
FROM
   movie_summary 
GROUP BY
   director_id 
ORDER BY
   number_of_movies DESC;







