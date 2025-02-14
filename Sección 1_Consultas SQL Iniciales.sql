--2. **Consultas básicas de selección:**
   -- Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
select title as Name,
	rating
from film f 
where rating = 'R';

--3. **Rangos de identificación:**
    -- Encuentra los nombres de los actores con `actor_id` entre 30 y 40.
select actor_id,
	first_name as Actor_name
from actor a 
where actor_id between 30 and 40;

-- 4. **Filtrar por idioma:**
    -- Obtén las películas cuyo idioma coincide con el idioma original.
select title,
	language_id,
	original_language_id 
from film
where language_id = original_language_id;

--5. **Clasificación por duración:**
    -- Ordena las películas por duración de forma ascendente.
select title,
	length 
from film f 
order by length;

--6. **Filtro por apellido:**
    -- Encuentra el nombre y apellido de los actores con ‘Allen’ en su apellido.
select concat(first_name,' ', last_name) as fullName
from actor a 
where last_name ilike '%Allen%';

--7. **Conteo de películas por clasificación:**
    -- Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.
select rating,
	count(rating) as count
from film f
group by rating; 

--8. **Filtro combinado:**
    -- Encuentra el título de todas las películas que son ‘PG13’ o tienen una duración mayor a 3 horas.
select title,
	rating,
	length 
from film f
where rating = 'PG-13' and length >180;

--9. **Análisis de costos:**
    -- Encuentra la variabilidad de lo que costaría reemplazar las películas.
select variance(replacement_cost) as "variance_cost_movies"
from film f;

--10. **Duraciones extremas:**
    -- Encuentra la mayor y menor duración de una película en la base de datos.
select 	min(length) as "min_duration",
		max(length) as "max_duration"
from film f;

--11. **Costo del alquiler:**
    -- Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select r.rental_id,
	p.amount 
from rental r
	inner join payment p on r.rental_id=p.rental_id 
order by rental_date desc
limit 1
offset 2;

--12. **Exclusión de clasificaciones:**
    -- Encuentra el título de las películas que no sean ni ‘NC-17’ ni ‘G’ en cuanto a clasificación.
select title, 
	rating 
from film f
where rating not in ('NC-17', 'G');

--13. **Promedios de duración por clasificación:**
    -- Encuentra el promedio de duración de las películas para cada clasificación y muestra la clasificación junto con el promedio.
select	rating,
	avg(length) 
from film f
group by rating;

--14. **Películas largas:**
    -- Encuentra el título de todas las películas con una duración mayor a 180 minutos.
select title,
	length 
from film f
where length >180;

--15. **Ingresos totales:**
    -- ¿Cuánto dinero ha generado en total la empresa?
select sum(amount) as "total_income"
from payment p;

--16. **Clientes con ID alto:**
    -- Muestra los 10 clientes con mayor valor de ID.
select customer_id,
	concat(first_name,' ',last_name) as customer_name
from customer c
order by customer_id desc
limit 10;

--17. **Película específica:**
    -- Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
select f.title,
	concat(a.first_name,' ',a.last_name) as actor_name
from film f 
	inner join film_actor fa on f.film_id =fa.film_id 
	inner join actor a on fa.actor_id =a.actor_id 
where f.title ilike 'Egg Igby';


