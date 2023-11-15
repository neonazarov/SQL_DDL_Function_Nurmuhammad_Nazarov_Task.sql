-- Creating the View: sales_revenue_by_category_qtr
CREATE OR REPLACE VIEW sales_revenue_by_category_qtr AS
SELECT 
    fc.category,
    SUM(s.amount) AS total_revenue
FROM 
    sales s
JOIN 
    film_category fc ON s.film_id = fc.film_id
WHERE 
    s.sale_date >= DATE_TRUNC('quarter', CURRENT_DATE)
GROUP BY 
    fc.category
HAVING 
    SUM(s.amount) > 0;

-- Creating the Query Language Function: get_sales_revenue_by_category_qtr
CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(current_quarter DATE)
RETURNS TABLE(category VARCHAR, total_revenue DECIMAL) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        fc.category,
        SUM(s.amount) AS total_revenue
    FROM 
        sales s
    JOIN 
        film_category fc ON s.film_id = fc.film_id
    WHERE 
        s.sale_date >= DATE_TRUNC('quarter', current_quarter)
    GROUP BY 
        fc.category
    HAVING 
        SUM(s.amount) > 0;
END;
$$ LANGUAGE plpgsql;

-- Creating the Procedure Language Function: new_movie
CREATE OR REPLACE FUNCTION new_movie(title VARCHAR)
RETURNS VOID AS $$
DECLARE
    new_film_id INT;
    current_year INT := EXTRACT(YEAR FROM CURRENT_DATE);
    klingon_id INT;
BEGIN
    -- Check if Klingon language exists
    SELECT language_id INTO klingon_id FROM language WHERE name = 'Klingon';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Language Klingon not found in language table';
    END IF;

    -- Generate new unique film ID
    SELECT MAX(film_id) + 1 INTO new_film_id FROM film;

    -- Insert new movie
    INSERT INTO film (film_id, title, rental_rate, rental_duration, replacement_cost, release_year, language_id)
    VALUES (new_film_id, title, 4.99, 3, 19.99, current_year, klingon_id);
END;
$$ LANGUAGE plpgsql;
