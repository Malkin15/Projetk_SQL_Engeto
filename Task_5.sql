/*Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v
jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?*/

WITH annual_avgs AS (
  SELECT
    a.pay_year,
    AVG(CASE WHEN a.category = 'food_category' THEN a.avg_price::NUMERIC END) AS avg_food_price,
    AVG(CASE WHEN a.category = 'payroll' THEN a.avg_payroll::NUMERIC END) AS avg_payroll
  FROM t_roman_simik_project_sql_primary_final a
  WHERE (a.category = 'food_category' AND a.avg_price IS NOT NULL)
     OR (a.category = 'payroll' AND a.avg_payroll IS NOT NULL)
  GROUP BY a.pay_year
),
gdp_cz AS (
  SELECT
    year AS pay_year,
    gdp::NUMERIC AS cz_gdp
  FROM t_roman_simik_project_sql_secondary_final
  WHERE country = 'Czech Republic'
),
all_years AS (
  SELECT
    aa.pay_year,
    aa.avg_food_price,
    aa.avg_payroll,
    g.cz_gdp
  FROM annual_avgs aa
  JOIN gdp_cz g ON g.pay_year = aa.pay_year
),
growths AS (
  SELECT
    y1.pay_year,
    ((y1.avg_food_price - y0.avg_food_price) / NULLIF(y0.avg_food_price,0)) * 100 AS avg_price_rise,
    ((y1.avg_payroll - y0.avg_payroll) / NULLIF(y0.avg_payroll,0)) * 100 AS avg_pay_rise,
    ((y1.cz_gdp - y0.cz_gdp) / NULLIF(y0.cz_gdp,0)) * 100 AS cz_gdp_rise
  FROM all_years y1
  JOIN all_years y0 ON y1.pay_year = y0.pay_year + 1
)
-- 1. Výstup: změny ve stejném roce
SELECT
  pay_year,
  ROUND(cz_gdp_rise, 2) AS cz_gdp_rise,
  ROUND(avg_pay_rise, 2) AS avg_pay_rise,
  ROUND(avg_price_rise, 2) AS avg_price_rise,
  ROUND(avg_pay_rise - cz_gdp_rise, 2) AS diff_pay_gdp,
  ROUND(avg_price_rise - cz_gdp_rise, 2) AS diff_price_gdp
FROM growths
ORDER BY pay_year;

-- 2. Výstup: vliv HDP s ročním zpožděním
-- (HDP z předchozího roku vs. mzdy a ceny v aktuálním roce)
WITH annual_avgs AS (
  SELECT
    a.pay_year,
    AVG(CASE WHEN a.category = 'food_category' THEN a.avg_price::NUMERIC END) AS avg_food_price,
    AVG(CASE WHEN a.category = 'payroll' THEN a.avg_payroll::NUMERIC END) AS avg_payroll
  FROM t_roman_simik_project_sql_primary_final a
  WHERE (a.category = 'food_category' AND a.avg_price IS NOT NULL)
     OR (a.category = 'payroll' AND a.avg_payroll IS NOT NULL)
  GROUP BY a.pay_year
),
gdp_cz AS (
  SELECT
    year AS pay_year,
    gdp::NUMERIC AS cz_gdp
  FROM t_roman_simik_project_sql_secondary_final
  WHERE country = 'Czech Republic'
),
all_years AS (
  SELECT
    aa.pay_year,
    aa.avg_food_price,
    aa.avg_payroll,
    g.cz_gdp
  FROM annual_avgs aa
  JOIN gdp_cz g ON g.pay_year = aa.pay_year
),
growths AS (
  SELECT
    y1.pay_year,
    ((y1.avg_food_price - y0.avg_food_price) / NULLIF(y0.avg_food_price,0)) * 100 AS avg_price_rise,
    ((y1.avg_payroll - y0.avg_payroll) / NULLIF(y0.avg_payroll,0)) * 100 AS avg_pay_rise,
    ((y1.cz_gdp - y0.cz_gdp) / NULLIF(y0.cz_gdp,0)) * 100 AS cz_gdp_rise
  FROM all_years y1
  JOIN all_years y0 ON y1.pay_year = y0.pay_year + 1
)
SELECT
  y1.pay_year,
  ROUND(y0.cz_gdp_rise, 2) AS prev_cz_gdp_rise,
  ROUND(y1.avg_pay_rise, 2) AS avg_pay_rise,
  ROUND(y1.avg_price_rise, 2) AS avg_price_rise,
  ROUND(y1.avg_pay_rise - y0.cz_gdp_rise, 2) AS diff_pay_gdp,
  ROUND(y1.avg_price_rise - y0.cz_gdp_rise, 2) AS diff_price_gdp
FROM growths y1
JOIN growths y0 ON y1.pay_year = y0.pay_year + 1
ORDER BY y1.pay_year;
