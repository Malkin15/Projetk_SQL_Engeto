/* Q 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné 
 období v dostupných datech cen a mezd? */

SELECT
	a.pay_year,
	a.branch_name,
	a.avg_payroll,
	b.cat_name,
	b.avg_price,
	ROUND(a.avg_payroll / (b.avg_price::numeric), 0) AS buy_power
FROM t_roman_simik_project_sql_primary_final a
JOIN t_roman_simik_project_sql_primary_final b
	ON a.pay_year = b.pay_year
WHERE b.cat_name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
	AND a.branch_name IS NOT NULL
	AND
	(a.pay_year = (
	SELECT MIN(pay_year)
	FROM t_roman_simik_project_sql_primary_final)
		OR a.pay_year = (
	SELECT MAX(pay_year)
	FROM t_roman_simik_project_sql_primary_final)
	)
ORDER BY a.pay_year;

