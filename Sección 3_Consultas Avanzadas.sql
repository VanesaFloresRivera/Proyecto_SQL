--1. **ID extremos:**
    -- Encuentra el ID del actor más bajo y más alto.
SELECT min(actor_id) AS min_id,
	max(actor_id)AS max_id
FROM actor a;

--2. **Conteo total de actores:**
    -- Cuenta cuántos actores hay en la tabla `actor`.
SELECT count(actor_id) AS number_actors
FROM actor a;

--3. **Ordenación por apellido:**
    -- Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT first_name,
	last_name 
FROM actor a 
ORDER BY last_name ASC;

--4. **Películas iniciales:**
    -- Selecciona las primeras 5 películas de la tabla `film`.
SELECT title
FROM film f 
LIMIT 5;

--5. **Agrupación por nombres:**
    -- Agrupa los actores por nombre y cuenta cuántos tienen el mismo nombre.
SELECT first_name AS name,
	count(first_name)
FROM actor a 
GROUP BY first_name
ORDER BY count(first_name);

--6. **Alquileres y clientes:**
    -- Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r.rental_id,
	f.title AS title_rental,
	concat(c.first_name, ' ', c.last_name) AS full_name_customer
FROM rental r 
	LEFT JOIN customer c 
	ON r.customer_id = c.customer_id
	LEFT JOIN inventory i 
	ON r.inventory_id =i.inventory_id 
	LEFT JOIN film f 
	ON i.film_id =f.film_id
ORDER BY r.rental_id;

--7. **Relación cliente-alquiler:**
    -- Muestra todos los clientes y sus alquileres, incluyendo los que no tienen.
SELECT concat(c.first_name, ' ', c.last_name) AS full_name_customer,
	r.rental_id,
	f.title AS title_rental
FROM customer c 
	LEFT JOIN rental r
	ON c.customer_id = r.customer_id
	LEFT JOIN inventory i 
	ON r.inventory_id =i.inventory_id 
	LEFT JOIN film f 
	ON i.film_id =f.film_id
ORDER BY c.customer_id;

--8. **CROSS JOIN:**
    -- Realiza un CROSS JOIN entre las tablas `film` y `category`. Analiza su valor.
SELECT*
FROM film f 	
	CROSS JOIN category c;
	-- Lo que hace es multiplicar cada fila de la tabla film  por cada una de las 16 filas de la tabla category

--9. **Actores en categorías específicas:**
    -- Encuentra los actores que han participado en películas de la categoría ‘Action’.
SELECT concat(a.first_name, ' ', a.last_name) AS actor_name,
	c.name AS category_name	
FROM actor a 
	INNER JOIN film_actor fa 
	ON a.actor_id =fa.actor_id 
	INNER JOIN film f 
	ON fa.film_id =f.film_id 
	INNER JOIN film_category fc 
	ON f.film_id =fc.film_id 
	INNER JOIN category c 
	ON fc.category_id =c.category_id 
WHERE c."name" ='Action';

--10. **Actores sin películas:**
    -- Encuentra todos los actores que no han participado en películas.
SELECT concat(a.first_name, ' ', a.last_name) AS actor_name,
	count(fa.film_id) AS number_movies
FROM actor a 
	LEFT JOIN film_actor fa 
	ON a.actor_id =fa.actor_id
GROUP BY concat(a.first_name, ' ', a.last_name)
HAVING count(fa.film_id) = 0;

	
--11. **Crear vistas:**
    -- Crea una vista llamada `actor_num_peliculas` que muestre los nombres de los actores y el número de películas en las que han actuado.
CREATE VIEW "actor_num_peliculas" AS 
	SELECT concat(a.first_name,' ', a.last_name) AS actor_name,
		count(fa.film_id) AS num_films
	FROM actor a 
		INNER JOIN film_actor fa 
		ON a.actor_id=fa.actor_id
	GROUP BY concat(a.first_name,' ', a.last_name);

SELECT *
FROM actor_num_peliculas anp 

