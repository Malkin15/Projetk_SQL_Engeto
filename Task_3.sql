--Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH food_prices AS (
    SELECT 
        cat_name,
        pay_year,
        ROUND(AVG(avg_price::numeric), 2) AS avg_price
    FROM t_roman_simik_project_SQL_primary_final
    WHERE category = 'food_category'
        AND pay_year IN (2006, 2018)
        AND avg_price IS NOT NULL
    GROUP BY cat_name, pay_year
),
prices_2006 AS (
    SELECT cat_name, avg_price AS price_2006
    FROM food_prices
    WHERE pay_year = 2006
),
prices_2018 AS (
    SELECT cat_name, avg_price AS price_2018
    FROM food_prices
    WHERE pay_year = 2018
),
price_change AS (
    SELECT 
        p2006.cat_name,
        p2006.price_2006,
        p2018.price_2018,
        ROUND(((p2018.price_2018 - p2006.price_2006) / p2006.price_2006) * 100, 1) AS percent_change
    FROM prices_2006 p2006
    JOIN prices_2018 p2018 ON p2006.cat_name = p2018.cat_name
)
SELECT *
FROM price_change
ORDER BY percent_change ASC;

--Položka "Jakostní víno bílé" nelze plně srovnávat, jelikož jsou pro ni data dostupná pouze za období 2015-2018.