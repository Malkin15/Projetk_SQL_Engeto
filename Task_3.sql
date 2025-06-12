--Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH yearly_changes AS (
  SELECT
    cat_name,
    pay_year,
    avg_price,
    LAG(avg_price) OVER (PARTITION BY cat_name ORDER BY pay_year) AS prev_price
  FROM t_roman_simik_project_SQL_primary_final
  WHERE pay_year BETWEEN 2006 AND 2018
    AND avg_price IS NOT NULL
)
SELECT
  cat_name,
  ROUND(AVG((avg_price - prev_price) / prev_price * 100), 2) AS avg_annual_percent_change
FROM yearly_changes
WHERE prev_price IS NOT NULL
GROUP BY cat_name
ORDER BY avg_annual_percent_change ASC;

--Položka "Jakostní víno bílé" nelze plně srovnávat, jelikož jsou pro ni data dostupná pouze za období 2015-2018.
