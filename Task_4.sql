--Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH prices AS (
  SELECT pay_year,
         AVG(CASE WHEN category = 'food_category' THEN avg_price::NUMERIC END) AS avg_food_price,
         AVG(CASE WHEN category = 'payroll' THEN avg_payroll::NUMERIC END) AS avg_payroll
  FROM t_roman_simik_project_sql_primary_final
  WHERE (category = 'food_category' AND avg_price IS NOT NULL)
     OR (category = 'payroll' AND avg_payroll IS NOT NULL)
  GROUP BY pay_year
),
growth AS (
  SELECT p1.pay_year,
         ((p1.avg_food_price - p0.avg_food_price) / p0.avg_food_price) * 100 AS avg_price_rise,
         ((p1.avg_payroll - p0.avg_payroll) / p0.avg_payroll) * 100 AS avg_pay_rise,
         (((p1.avg_food_price - p0.avg_food_price) / p0.avg_food_price) * 100
         - ((p1.avg_payroll - p0.avg_payroll) / p0.avg_payroll) * 100) AS difference
  FROM prices p1
  JOIN prices p0 ON p1.pay_year = p0.pay_year + 1
)
SELECT 
  pay_year,
  ROUND(avg_pay_rise, 2) AS avg_pay_rise,
  ROUND(avg_price_rise, 2) AS avg_price_rise,
  ROUND(difference, 2) AS difference
FROM growth
ORDER BY pay_year;
