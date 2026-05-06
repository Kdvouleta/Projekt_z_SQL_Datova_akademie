
-- otázka č. 4 - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH wages_unique AS (
SELECT DISTINCT
year,
    industry_branch_code,
    industry_name,
    avg_wage
FROM t_katerina_dvouleta_project_sql_primary_final
),
    prices_unique AS (
SELECT DISTINCT
year,
    category_code,
    category_name,
    avg_price
FROM t_katerina_dvouleta_project_sql_primary_final
),
    yearly_wages AS (
SELECT
year,
    ROUND(AVG(avg_wage), 2) AS avg_year_wage
FROM wages_unique
GROUP BY year
),
    yearly_prices AS (
SELECT
year,
    ROUND(AVG(avg_price)::numeric, 2) AS avg_year_price
FROM prices_unique
GROUP BY year
),
    wage_growth AS (
SELECT
year,
    avg_year_wage,
    LAG(avg_year_wage) OVER (ORDER BY year) AS prev_year_wage
FROM yearly_wages
),
    price_growth AS (
SELECT
year,
    avg_year_price,
    LAG(avg_year_price) OVER (ORDER BY year) AS prev_year_price
FROM yearly_prices
),
    growth_comparison AS (
SELECT
    p.year,
    ROUND(((p.avg_year_price - p.prev_year_price) / p.prev_year_price * 100)::numeric, 2) AS food_growth_pct,
    ROUND(((w.avg_year_wage - w.prev_year_wage) / w.prev_year_wage * 100)::numeric, 2) AS wage_growth_pct
FROM price_growth p
JOIN wage_growth w
    ON p.year = w.year
WHERE p.prev_year_price IS NOT NULL
AND w.prev_year_wage IS NOT NULL
)
SELECT
    year,
    food_growth_pct,
    wage_growth_pct,
    ROUND((food_growth_pct - wage_growth_pct)::numeric, 2) AS difference_pct
FROM growth_comparison
WHERE (food_growth_pct - wage_growth_pct) > 10
ORDER BY year;

-- odpověd na otázku č. 4 - Ve sledovaném období nebyl nalezen žádný rok, ve kterém by meziroční nárůst cen potravin převýšil růst mezd 
-- o více než 10 %. Z toho plyne, že i když ceny potravin v některých letech rostly rychleji než mzdy, rozdíl nikdy nepřekročil hranici 10 %.




