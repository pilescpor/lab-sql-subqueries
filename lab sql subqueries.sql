USE sakila;
/*## Challenge

Write SQL queries to perform the following tasks using the Sakila database:

1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.*/

SELECT COUNT(*) AS number_of_films, title
FROM film
JOIN inventory USING (film_id)
WHERE title = "Hunchback Impossible" 
;

/*2. List all films whose length is longer than the average length of all the films in the Sakila database.*/

SELECT title
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY title
;

/*3. Use a subquery to display all actors who appear in the film "Alone Trip".*/

SELECT CONCAT(first_name, " ", last_name) AS actor_name
FROM actor
JOIN film_actor USING (actor_id)
WHERE film_id = (SELECT film_id FROM film WHERE title = "Alone Trip");

/***Bonus**:

4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films. */

SELECT title
FROM film
JOIN film_category USING (film_id)
WHERE category_id = (SELECT category_id FROM category WHERE name = "Family")
;
/*5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.*/

SELECT CONCAT(first_name, " ", last_name) AS actor_name, email
FROM customer
JOIN address USING (address_id)
JOIN city USING (city_id)
WHERE country_id = (SELECT country_id FROM country WHERE country = "Canada")
;

/*6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.*/

SELECT title
FROM film_actor
JOIN film USING (film_id)
JOIN actor USING (actor_id)
WHERE actor_id = (SELECT actor_id FROM film_actor GROUP BY actor_id ORDER BY (COUNT(film_id)) DESC LIMIT 1)
ORDER BY title;

/*7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.*/

SELECT title
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE customer_id = (SELECT customer_id FROM payment GROUP BY customer_id ORDER BY (SUM(amount)) DESC LIMIT 1)
ORDER BY title;

/*8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.*/

SELECT customer_id, SUM(amount) AS total_amount_spend
FROM customer 
JOIN payment USING (customer_id)
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_spend) 
	FROM (SELECT SUM(amount) AS total_spend FROM customer JOIN payment USING (customer_id) GROUP BY customer_id) AS avg_spent)
;

