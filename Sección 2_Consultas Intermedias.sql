--1. **Selección única:**
    -- Selecciona todos los nombres únicos de películas.
SELECT DISTINCT title
FROM film f;

--2. **Filtros combinados con duración:**
    -- Encuentra las películas que son comedias y tienen una duración mayor a 180 minutos.
SELECT f.title,
	c."name",
	f.length 
FROM film f 
	INNER JOIN film_category fc 
	ON f.film_id =fc.film_id 
	INNER JOIN category c 
	ON fc.category_id=c.category_id 
WHERE c."name" LIKE 'Comedy' AND f.length >180;

--3. **Promedio por categoría:**
    -- Encuentra las categorías de películas con un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio.
SELECT c.name,
	AVG(f.length)	
FROM category c 
	INNER JOIN film_category fc 
	ON 	c.category_id =fc.category_id
	INNER JOIN film f 
	ON fc.film_id =f.film_id
GROUP BY c."name" 
HAVING AVG(f.length)>110;

--4. **Duración media de alquiler:**
    -- ¿Cuál es la media de duración del alquiler de las películas?
--Usando la tabla peliculas
SELECT AVG(rental_duration) AS medium_duration_rental
FROM film;

--Usando la tabla alquileres
SELECT AVG(return_date-rental_date) AS medium_duration_rental
FROM rental r;

--5. **Concatenación de nombres:**
    -- Crea una columna con el nombre completo (nombre y apellidos) de los actores y actrices.
SELECT CONCAT(first_name,' ',last_name) AS actor_name
FROM actor a ;

--6. **Conteo de alquileres por día:**
    -- Muestra los números de alquileres por día, ordenados de forma descendente.
SELECT TO_CHAR(rental_date, 'DD-MM-YYYY') AS "day",
	COUNT(rental_date) 
FROM rental r
GROUP BY TO_CHAR(rental_date, 'DD-MM-YYYY')
ORDER BY COUNT(rental_date) desc;


--7. **Películas sobre el promedio:**
    -- Encuentra las películas con una duración superior al promedio.
SELECT f.title,
	f.length
FROM film f 
WHERE f.length > (SELECT avg(f1.length)
				FROM film f1)
ORDER BY length;


--8. **Conteo mensual:**
    -- Averigua el número de alquileres registrados por mes.
SELECT to_char(rental_date, 'MM') AS MONTH,
	count(rental_date) AS num_rentals
FROM rental r
GROUP BY to_char(rental_date, 'MM')
ORDER BY count(rental_date);

--9. **Estadísticas de pagos:**
    -- Encuentra el promedio, la desviación estándar y la varianza del total pagado.
SELECT avg(amount) AS average,
	stddev(amount) AS Standard_deviation,
	variance(amount) AS	variance
FROM payment p;

--10. **Películas caras:**
    -- ¿Qué películas se alquilan por encima del precio medio?
SELECT title,
	rental_rate
FROM film f 
WHERE rental_rate > (
	SELECT avg(f2.rental_rate) 
	FROM film f2
	);

--11. **Actores en muchas películas:**
    -- Muestra el ID de los actores que hayan participado en más de 40 películas.
SELECT actor_id, 
	count(actor_id) AS number_of_movies
FROM film_actor fa 
GROUP BY actor_id
HAVING count(actor_id) > 40;

--12. **Disponibilidad en inventario:**
    -- Obtén todas las películas y, si están disponibles en el inventario, muestra la cantidad disponible.
SELECT title,
	count(i.film_id) AS availability_stock
FROM film f 
	LEFT JOIN inventory i 
	ON f.film_id =i.film_id
GROUP BY f.film_id
ORDER BY count(i.film_id);

--13. **Número de películas por actor:**
    -- Obtén los actores y el número de películas en las que han actuado.
SELECT concat(a.first_name,' ',a.last_name) AS actor_name,
	count(fa.actor_id) AS number_movies
FROM actor a 
	LEFT JOIN film_actor fa 
	ON a.actor_id =fa.actor_id
GROUP BY concat(a.first_name,' ',a.last_name)
ORDER BY count(fa.actor_id);

--14. **Relaciones actor-película:**
    -- Obtén todas las películas con sus actores asociados, incluso si algunas no tienen actores.
SELECT f.title,
	concat(a.first_name,' ', a.last_name) AS actor_name
FROM film f 
LEFT JOIN film_actor fa
	ON f.film_id =fa.film_id 
LEFT JOIN actor a 
	ON fa.actor_id =a.actor_id
ORDER BY f.film_id; 


--15. **Clientes destacados:**
    -- Encuentra los 5 clientes que más dinero han gastado.
SELECT concat(c.first_name, ' ', c.last_name) AS customer_name,
	sum(p.amount) AS total_spent
FROM customer c 
	INNER JOIN rental r 
	ON c.customer_id =r.customer_id 
	INNER JOIN payment p 
	ON	r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY sum(p.amount) DESC 
LIMIT 5;