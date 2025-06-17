--primírní tabulka
CREATE TABLE t_roman_simik_project_sql_primary_final AS
	SELECT
		cpay.payroll_year AS pay_year, 
		ROUND(AVG(cpay.value)::NUMERIC, 2) AS avg_payroll,
		cpib.name AS branch_name, 
		NULL AS avg_price,
		NULL AS cat_name,
		'payroll' AS category -- flag payroll
	FROM czechia_payroll cpay 
	LEFT JOIN czechia_payroll_industry_branch cpib 
		ON cpay.industry_branch_code = cpib.code
		WHERE cpay.value_type_code = 5958
		AND cpay.unit_code = 200
		AND cpay.calculation_code = 200
		AND cpay.industry_branch_code IS NOT NULL 
		AND cpay.payroll_year BETWEEN 2006 AND 2018
	GROUP BY pay_year, cpib.name
	
	UNION
	
	SELECT
		EXTRACT(YEAR FROM cprc.date_from) AS pay_year,
		NULL AS avg_payroll,
		NULL AS branch_name,
		ROUND(AVG(cprc.value)::NUMERIC, 2) AS avg_price,
		cpcg.name AS cat_name,
		'food_category' AS category --flag food_category
	FROM czechia_price cprc
	LEFT JOIN czechia_price_category cpcg 
		ON cprc.category_code = cpcg.code
	GROUP BY EXTRACT(YEAR FROM cprc.date_from), cpcg.name
	;

--sekundární tabulka
CREATE TABLE t_roman_simik_project_sql_secondary_final AS
	SELECT 
		e.country,
		e.year,
		e.GDP,
		e.population,
		e.gini
	FROM economies e 
	WHERE e.year BETWEEN 2006 AND 2018
		AND e.country IN (
			SELECT c.country
			FROM countries c 
			WHERE c.continent = 'Europe'
				AND c.continent IS NOT NULL 
		)
	ORDER BY e.country, e.year;


