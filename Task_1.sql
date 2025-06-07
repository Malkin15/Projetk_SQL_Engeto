-- Q 1: Rostou v průběhu let mzdy ve všech odvětvích nebo v některých klesají?

SELECT 
    a.branch_name,
    a.pay_year AS year_from,
    b.pay_year AS year_to,
    a.avg_payroll AS payroll_previous,
    b.avg_payroll AS payroll_current
FROM t_roman_simik_project_sql_primary_final a
JOIN t_roman_simik_project_sql_primary_final b
    ON a.branch_name = b.branch_name 
    AND b.pay_year = a.pay_year + 1
WHERE a.category = 'payroll'
  AND b.category = 'payroll'
  AND b.avg_payroll < a.avg_payroll
ORDER BY a.branch_name, a.pay_year;