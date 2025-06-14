-- Meziroční průměrný procentuální růst cen potravin za všechny produkty
WITH food_rise AS (
    SELECT
        pay_year AS year,
        cat_name,
        avg_price,
        LAG(avg_price, 1) OVER (PARTITION BY cat_name ORDER BY pay_year) AS prev_price
    FROM t_roman_simik_project_sql_primary_final
    WHERE category = 'food_category'
),
food_rise_pct AS (
    SELECT
        year,
        cat_name,
        ROUND((avg_price - prev_price) / NULLIF(prev_price, 0) * 100, 2) AS perc_narust_price
    FROM food_rise
    WHERE prev_price IS NOT NULL
),
avg_price_rise AS (
    SELECT
        year,
        ROUND(AVG(perc_narust_price), 2) AS avg_price_rise
    FROM food_rise_pct
    GROUP BY year
)
-- Meziroční průměrný procentuální růst mezd za všechna odvětví
, payroll_rise AS (
    SELECT
        pay_year AS year,
        branch_name,
        avg_payroll,
        LAG(avg_payroll, 1) OVER (PARTITION BY branch_name ORDER BY pay_year) AS prev_pay
    FROM t_roman_simik_project_sql_primary_final
    WHERE category = 'payroll'
),
payroll_rise_pct AS (
    SELECT
        year,
        branch_name,
        ROUND((avg_payroll - prev_pay) / NULLIF(prev_pay, 0) * 100, 2) AS perc_narust_pay
    FROM payroll_rise
    WHERE prev_pay IS NOT NULL
),
avg_pay_rise AS (
    SELECT
        year,
        ROUND(AVG(perc_narust_pay), 2) AS avg_pay_rise
    FROM payroll_rise_pct
    GROUP BY year
)
-- Výsledek: rok, průměrný růst mezd, průměrný růst cen potravin, rozdíl
SELECT
    apy.year,
    apy.avg_pay_rise,
    api.avg_price_rise,
    ABS(apy.avg_pay_rise - api.avg_price_rise) AS difference
FROM avg_pay_rise apy
JOIN avg_price_rise api ON api.year = apy.year
ORDER BY apy.year;