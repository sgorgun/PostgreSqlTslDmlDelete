--Remove a previously inserted film from the inventory and all corresponding rental records
DO $$
DECLARE
    v_film_id INT;
BEGIN
    SELECT film_id INTO v_film_id
    FROM film
    WHERE title = UPPER('The Matrix');

    DELETE FROM film_actor
    WHERE film_id = v_film_id;

    DELETE FROM actor
    WHERE actor_id IN (
        SELECT actor_id
        FROM actor a
        WHERE NOT EXISTS (
            SELECT 1
            FROM film_actor fa
            WHERE fa.actor_id = a.actor_id
        )
    );

    DELETE FROM rental
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM inventory
        WHERE film_id = v_film_id
    );

    DELETE FROM inventory
    WHERE film_id = v_film_id;

    DELETE FROM film
    WHERE film_id = v_film_id;
END $$;

--Remove any records related to you (as a customer) from all tables except "Customer" and "Inventory"
DO $$
DECLARE
    v_customer_id INT;
BEGIN
    SELECT customer_id INTO v_customer_id
    FROM customer
    WHERE first_name = UPPER('Sergei') AND last_name = UPPER('Gorgun');

    DELETE FROM payment
    WHERE customer_id = v_customer_id;

	    DELETE FROM rental
    WHERE customer_id = v_customer_id;

END $$;


--The code below is to check if the rows were added to the database correctly.

-- SELECT * FROM public.film
-- ORDER BY film_id DESC LIMIT 10;

-- SELECT * FROM public.actor
-- ORDER BY actor_id DESC LIMIT 10;

-- SELECT * FROM public.film_actor
-- ORDER BY actor_id DESC, film_id DESC LIMIT 10;

-- SELECT * FROM public.inventory
-- ORDER BY inventory_id DESC LIMIT 10;