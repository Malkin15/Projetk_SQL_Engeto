--Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH yearly_avg_prices AS (
    SELECT 
        pay_year,
        ROUND(AVG(avg_price::NUMERIC), 2) AS avg_food_price
    FROM t_roman_simik_project_sql_primary_final
    WHERE category = 'food_category'
        AND avg_price IS NOT NULL
    GROUP BY pay_year
),
yearly_avg_payrolls AS (
    SELECT 
        pay_year,
        ROUND(AVG(avg_payroll::NUMERIC), 2) AS avg_payroll
    FROM t_roman_simik_project_sql_primary_final
    WHERE category = 'payroll'
        AND avg_payroll IS NOT NULL
    GROUP BY pay_year
),
price_growth AS (
    SELECT 
        curr.pay_year,
        ROUND(((curr.avg_food_price - prev.avg_food_price) / prev.avg_food_price) * 100, 2) AS food_price_growth
    FROM yearly_avg_prices curr
    JOIN yearly_avg_prices prev 
        ON curr.pay_year = prev.pay_year + 1
),
payroll_growth AS (
    SELECT 
        curr.pay_year,
        ROUND(((curr.avg_payroll - prev.avg_payroll) / prev.avg_payroll) * 100, 2) AS payroll_growth
    FROM yearly_avg_payrolls curr
    JOIN yearly_avg_payrolls prev 
        ON curr.pay_year = prev.pay_year + 1
)
SELECT 
    p.pay_year,
    p.food_price_growth,
    pr.payroll_growth,
    ROUND(p.food_price_growth - pr.payroll_growth, 2) AS growth_diff
FROM price_growth p
JOIN payroll_growth pr 
    ON p.pay_year = pr.pay_year
ORDER BY ABS(p.food_price_growth - pr.payroll_growth) DESC;


--kdy rostly ceny nejvíc oproti mzdám
--kdy rostly mzdy víc než ceny
--kde byl největší nepoměr