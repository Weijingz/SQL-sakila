USE sakila;
-- 1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor.
SELECT first_name, last_name 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(first_name, '  ', last_name) AS 'Actor Name'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name='JOE';

-- 2b. Find all actors whose last name contain the letters GEN
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';


-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT *
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(20) AFTER first_name;
SELECT * FROM actor;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;
SELECT * FROM actor;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;
SELECT * FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(*) AS 'Count'
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'Count'
FROM actor 
GROUP BY last_name
HAVING Count>=2;
--
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name='HARPO'
WHERE first_name ='GROUCHO' AND  last_name=' WILLIAMS';
SELECT last_name, first_name
FROM actor
WHERE first_name='HARPO';
--
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = CASE
         WHEN first_name = "HARPO" THEN "GROUCHO"
         ELSE "MUCHO GROUCHO"
       END
 WHERE last_name='WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM  staff s LEFT JOIN address a ON s.address_id=a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, SUM(p.amount) AS Amount
FROM staff s 
JOIN payment p 
ON s.staff_id=p.staff_id
WHERE payment_date BETWEEN  '2005-08-01' AND '2005-08-31'
GROUP BY first_name,last_name;


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.film_id,  f.title, COUNT(a.actor_id) AS 'TOTAL'
FROM film f  JOIN film_actor a ON f.film_id=a.film_id
GROUP BY film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(*)
FROM film f
JOIN inventory i
ON f.film_id=i.film_id
WHERE title='Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.customer_id,c.first_name, c.last_name, SUM(p.amount) AS 'Total amount paid'
FROM customer c
JOIN payment p
ON  c.customer_id=p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.title, l.name
FROM film f
JOIN language l
ON  f.language_id=l.language_id
WHERE name='English' AND (title LIKE 'Q%' OR title LIKE 'K%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT  a.first_name, a.last_name
FROM actor a
JOIN film_actor fa
ON a.actor_id=fa.actor_id
JOIN film f
ON fa.film_id=f.film_id
WHERE title= 'Alone Trip';

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name,c.last_name, c.email, country.country
FROM customer c
JOIN address a
ON c.address_id=a.address_id
JOIN city 
ON a.city_id=city.city_id
JOIN country
ON city.country_id=country.country_id
WHERE country='canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT f.title, c.name 
FROM film f
JOIN film_category fc
ON f.film_id=fc.film_id
JOIN category c
ON fc.category_id=c.category_id
WHERE c.name='family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT  f.title, COUNT(r.inventory_id) AS rental_count 
FROM film f
JOIN inventory i
ON f.film_id=i.film_id
JOIN rental r
ON i.inventory_id=r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount) AS ' Total Sales '
FROM store s 
JOIN customer c
ON s.store_id=c.store_id
JOIN payment p
ON p.customer_id=c.customer_id
GROUP BY store_id
ORDER BY 'Total Sales ' desc;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, city, country
FROM store s
JOIN address a
ON s.address_id=a.address_id
JOIN city
ON a.city_id=city.city_id
JOIN country
ON city.country_id=country.country_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name,SUM(amount) AS 'Total Sales'
FROM category
JOIN film_category
USING (category_id)
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
JOIN payment
USING (rental_id)
GROUP BY name
ORDER BY' Total Sales 'desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
DROP VIEW if exists top_five_genres;
CREATE VIEW top_five_genres (category, Total_Sales) AS
SELECT name,SUM(amount) AS Total_Sales
FROM category
JOIN film_category
USING (category_id)
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
JOIN payment
USING (rental_id)
GROUP BY name
ORDER BY Total_Sales desc
limit 5;

-- 8b. How would you display the view that you created in 8a?
select * from top_five_genres;


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genres;












