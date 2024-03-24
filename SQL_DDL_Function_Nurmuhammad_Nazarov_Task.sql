-- Create the database for the DVD rental system
CREATE DATABASE dvd_rental;

-- Define the Schema
CREATE TABLE language (
    language_id SERIAL PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL
);


CREATE TABLE film (
    film_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    rental_rate DECIMAL(4,2) NOT NULL,
    rental_duration INTEGER NOT NULL,
    replacement_cost DECIMAL(5,2) NOT NULL,
    release_year INTEGER NOT NULL,
    language_id INTEGER NOT NULL REFERENCES language(language_id)
);


CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);


CREATE TABLE film_category (
    film_id INTEGER NOT NULL REFERENCES film(film_id),
    category_id INTEGER NOT NULL REFERENCES category(category_id),
    PRIMARY KEY (film_id, category_id)
);


CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL REFERENCES film(film_id),
    amount DECIMAL(5,2) NOT NULL,
    sale_date DATE NOT NULL
);


INSERT INTO language (name) VALUES ('Klingon') ON CONFLICT (name) DO NOTHING;


-- Create a view to show total sales revenue by film category for the current quarter
CREATE OR REPLACE VIEW sales_revenue_by_category_qtr AS
SELECT c.name AS category, SUM(s.amount) AS total_sales_revenue
FROM sales s
JOIN film_category fc ON s.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE DATE_PART('quarter', s.sale_date) = DATE_PART('quarter', CURRENT_DATE)
AND DATE_PART('year', s.sale_date) = DATE_PART('year', CURRENT_DATE)
GROUP BY c.name
HAVING SUM(s.amount) > 0;


-- Define a function to retrieve sales revenue by category for a specified quarter
CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(qtr INTEGER) 
RETURNS TABLE(category VARCHAR, total_sales_revenue NUMERIC) AS $$
BEGIN
RETURN QUERY
SELECT c.name, SUM(s.amount)
FROM sales s
JOIN film_category fc ON s.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE DATE_PART('quarter', s.sale_date) = qtr
AND DATE_PART('year', s.sale_date) = DATE_PART('year', CURRENT_DATE)
GROUP BY c.name
HAVING SUM(s.amount) > 0;
END;
$$ LANGUAGE plpgsql;


-- Create a Function to Add a New Movie
CREATE OR REPLACE FUNCTION new_movie(movie_title VARCHAR) 
RETURNS VOID AS $$
DECLARE
    lang_id INT;
BEGIN
    SELECT INTO lang_id language_id FROM language WHERE name = 'Klingon';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Language not found.';
    END IF;
    
    INSERT INTO film (title, rental_rate, rental_duration, replacement_cost, release_year, language_id)
    VALUES (movie_title, 4.99, 3, 19.99, EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER, lang_id);
END;
$$ LANGUAGE plpgsql;
