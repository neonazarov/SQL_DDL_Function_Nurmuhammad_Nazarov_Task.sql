This consolidated SQL script comprises three key components designed for a film rental database:

1. **View - `sales_revenue_by_category_qtr`**: This view calculates the total sales revenue for each film category in the current quarter. It includes only those categories with at least one sale during this period. The view dynamically determines the current quarter based on the current date and sums up the sales amount grouped by film category.

2. **Function - `get_sales_revenue_by_category_qtr`**: This function allows users to query the total sales revenue by category for a given quarter. It accepts a date parameter to specify the current quarter and returns a table with categories and their corresponding total revenue. This function replicates the logic of the view but with the flexibility of accepting a variable quarter input.

3. **Procedure - `new_movie`**: This procedure adds a new movie to the film table. It generates a unique film ID and sets predefined values for rental rate, rental duration, replacement cost, and release year. The movie's language is set to 'Klingon', with a validation step to ensure this language exists in the database. This function is designed to streamline the process of adding new movies to the database while maintaining data integrity and consistency.

Each of these components is designed to enhance the functionality of a film rental database, facilitating efficient data retrieval and management. The script adheres to SQL standards and is meant for execution in a PostgreSQL environment.
