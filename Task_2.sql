/* Q 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné 
 období v dostupných datech cen a mezd? */

SELECT
  b.pay_year AS year,
  b.cat_name AS product,
  ROUND(AVG(b.avg_price), 2) AS avg_price_value,
  CASE 
    WHEN b.cat_name = 'Chléb konzumní kmínový' THEN 'kg'
    WHEN b.cat_name = 'Mléko polotučné pasterované' THEN 'l'
    ELSE ''
  END AS price_unit,
  ROUND(AVG(a.avg_payroll / b.avg_price), 2) AS avg_buy_power
FROM t_roman_simik_project_sql_primary_final a
JOIN t_roman_simik_project_sql_primary_final b
  ON a.pay_year = b.pay_year
WHERE b.cat_name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
  AND a.branch_name IS NOT NULL
  AND a.pay_year IN (2006, 2018)
GROUP BY b.pay_year, b.cat_name
ORDER BY b.pay_year, b.cat_name;
