USE sakila;
--  Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

-- Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title, rating
FROM film
WHERE rating = 'PG-13';

-- Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description 
FROM film
WHERE description LIKE '%amazing%';

-- Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length
FROM film 
WHERE length > 120;

-- Recupera los nombres de todos los actores.
SELECT first_name
FROM actor;

-- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

-- Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating
FROM film
WHERE rating NOT IN ('PG-13', 'R');

-- Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT rating, COUNT(film_id) AS total_peliculas
FROM film
GROUP BY rating;

-- Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT*FROM customer;
SELECT*FROM rental;

SELECT c.customer_id, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT*FROM rental;
SELECT*FROM category;
SELECT*FROM inventory;
SELECT*FROM film_category;

SELECT c.name AS 'Nombre categoría', COUNT(r.rental_id) AS total_alquileres
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN inventory i ON fc.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating, AVG(length) AS duracion_promedio
FROM film
GROUP BY rating;

-- Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT*FROM film;
SELECT*FROM actor;
SELECT*FROM film_actor;

SELECT a.first_name AS nombre, a.last_name AS apellido, f.title AS titulo
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'Indian Love';

-- Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor
SELECT*FROM film_actor;
SELECT*FROM actor;

SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title AS titulo, release_year AS 'Año de lanzamiento'
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT*FROM category;
SELECT*FROM film;
SELECT*FROM film_category;

SELECT f.title, c.name
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Family';

-- Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name AS Nombre, a.last_name AS Apellido, COUNT(fa.actor_id) AS numero_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING numero_peliculas > 10;

-- Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film
SELECT title, rating, length
FROM film
WHERE RATING = 'R' AND length > 120;

-- Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT*FROM film;
SELECT*FROM film_category;
SELECT*FROM category;

SELECT c.name AS Categoría, AVG(f.length) AS duracion_promedio
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING duracion_promedio > 120;

-- Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT*FROM actor;
SELECT*FROM film_actor;

SELECT a.first_name AS Nombre, a.last_name AS Apellido, COUNT(fa.film_id) AS Numero_Películas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING Numero_Películas >= 5;

/*Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/
SELECT*FROM rental;
SELECT*FROM film;
SELECT*FROM inventory;

SELECT DISTINCT f.title AS Título
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IN (
	SELECT r.inventory_id
    FROM rental r
    WHERE DATEDIFF(r.return_date, r.rental_Date) > 5
);

/*Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
SELECT*FROM actor;
SELECT*FROM category;
SELECT*FROM film_category;
SELECT*FROM film_actor;

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
	FROM film_actor fa
	INNER JOIN film_category fc ON fa.film_id = fc.film_id
	INNER JOIN category c ON fc.category_id = c.category_id
	WHERE c.name = 'Horror'
);
-- Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film
SELECT*FROM film;
SELECT*FROM category;
SELECT*FROM film_category;

SELECT f.title AS Título, c.name AS Categoría, f.length AS Duración
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;
 
 

