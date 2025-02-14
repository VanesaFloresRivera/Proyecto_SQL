--1. **Alquileres totales:**
    -- Calcula el número total de alquileres realizados por cada cliente.
WITH cte_num_total_rents AS (
	SELECT concat(c.first_name,' ',c.last_name) AS customer_name,
		count(r.customer_id) AS num_rents
	FROM customer c 
		INNER JOIN rental r 
		ON c.customer_id = r.customer_id
	GROUP BY c.customer_id
	)
SELECT *
FROM cte_num_total_rents;

--2. **Duración total por categoría:**
    -- Calcula la duración total de las películas en la categoría `Action`.
WITH cte_total_duration_by_category AS (
	SELECT c.name AS category_name,
		sum(f.length) AS total_length
	FROM film f 
		INNER JOIN film_category fc 
		ON f.film_id = fc.film_id
		INNER JOIN category c 
		ON fc.category_id= c.category_id
	GROUP BY c.name
	)
SELECT *
FROM cte_total_duration_by_category
WHERE category_name = 'Action';

--3. **Clientes destacados:**
    -- Encuentra los clientes que alquilaron al menos 7 películas distintas.
WITH cte_number_different_rented_films AS (
	SELECT concat(c.first_name, ' ', c.last_name) AS customer_name,
		count(DISTINCT f.film_id) AS num_films
	FROM customer c 
		INNER JOIN rental r 
		ON c.customer_id= r.customer_id
		INNER JOIN	inventory i 
		ON r.inventory_id=i.inventory_id
		INNER JOIN film f 
		ON i.film_id = f.film_id
	GROUP BY c.customer_id
	ORDER BY c.customer_id
	)
SELECT *
FROM cte_number_different_rented_films
WHERE num_films >= 7;

--4. **Categorías destacadas:**
    -- Encuentra la cantidad total de películas alquiladas por categoría.
-- Cálculo de las peliculas diferentes alquiladas:
WITH cte_number_total_rental_films_by_category_distintas  AS (
	SELECT c.name AS category_name,
		count(DISTINCT r.inventory_id) AS num_films_rentals_distinct
	FROM film f
	INNER JOIN film_category fc ON f.film_id = fc.film_id
	INNER JOIN category c ON fc.category_id=c.category_id
	INNER JOIN inventory i ON f.film_id = i.film_id 
	INNER JOIN rental r ON i.inventory_id =r.inventory_id 
	GROUP BY c.name
	)
SELECT *
FROM cte_number_total_rental_films_by_category_distintas

-- Peliculas totales alquiladas, incluyendo repeticiones:
WITH cte_number_total_rental_films_by_category_total  AS (
	SELECT c.name AS category_name,
		count(r.inventory_id) AS num_films_rentals
	FROM film f
	INNER JOIN film_category fc ON f.film_id = fc.film_id
	INNER JOIN category c ON fc.category_id=c.category_id
	INNER JOIN inventory i ON f.film_id = i.film_id 
	INNER JOIN rental r ON i.inventory_id =r.inventory_id 
	GROUP BY c.name
	)
SELECT *
FROM cte_number_total_rental_films_by_category_total

--5. **Nuevas columnas:**
    -- Renombra las columnas `first_name` como `Nombre` y `last_name` como `Apellido`.
--Lo hago solo de la tabla staff para que no me afecta al resto de consultas que he realizado. 
ALTER TABLE staff RENAME COLUMN first_name TO Nombre
ALTER TABLE staff RENAME COLUMN last_name TO Apellido
SELECT *
FROM staff;

--6. **Tablas temporales:**
    -- Crea una tabla temporal llamada `cliente_rentas_temporal` para almacenar el total de alquileres por cliente.
WITH cte_cliente_rentas_temporal AS (
	SELECT concat(c.first_name,' ',c.last_name) AS customer_full_name,
		count(r.customer_id)
	FROM customer c 
	INNER JOIN rental r ON c.customer_id=r.customer_id
	GROUP BY c.customer_id
	)
SELECT *
FROM cte_cliente_rentas_temporal;

    -- Crea otra tabla temporal llamada `peliculas_alquiladas` para almacenar películas alquiladas al menos 10 veces.
WITH cte_peliculas_alquiladas AS (
	SELECT f.title,
		count(r.inventory_id) AS num_rentals
	FROM film f 
		INNER JOIN inventory i ON f.film_id=i.film_id
		INNER JOIN rental r ON i.inventory_id=r.inventory_id
	GROUP BY f.film_id
)
SELECT *
FROM cte_peliculas_alquiladas
WHERE num_rentals >=10;

--7. **Clientes frecuentes:**
    -- Encuentra los nombres de los clientes que más gastaron y sus películas asociadas. Cojo los 10 primero clientes que más gastaron.
SELECT DISTINCT
	concat(c.first_name,' ', c.last_name) AS full_name_customer,
	f.title
FROM customer c 
	INNER JOIN payment p ON c.customer_id =p.customer_id
	INNER JOIN rental r ON c.customer_id =r.customer_id
	INNER JOIN  inventory i ON r.inventory_id =i.inventory_id 
	INNER JOIN film f ON i.film_id =f.film_id 
WHERE c.customer_id IN (SELECT c.customer_id 
						FROM customer c 
							INNER JOIN payment p ON c.customer_id =p.customer_id
						GROUP BY c.customer_id
						ORDER BY sum(p.amount) DESC
						LIMIT 10 )
ORDER BY concat(c.first_name,' ', c.last_name);


--8. **Actores en Sci-Fi:**
    -- Encuentra los actores que actuaron en películas de la categoría `Sci-Fi`.
WITH cte_actor_category AS (
	SELECT concat(a.first_name,' ',a.last_name) AS full_actor_name,
		c."name" AS category
	FROM actor a 
		INNER JOIN film_actor fa ON a.actor_id =fa.actor_id 
		INNER JOIN film f ON fa.film_id =f.film_id 
		INNER JOIN film_category fc ON f.film_id =fc.film_id 
		INNER JOIN category c ON fc.category_id =c.category_id
		)
SELECT *
FROM cte_actor_category
WHERE category = 'Sci-Fi';
