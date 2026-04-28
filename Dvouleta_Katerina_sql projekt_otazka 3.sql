
-- otázka č. 3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

WITH prices_unique AS (
SELECT DISTINCT
year,
category_code,
category_name,
avg_price
FROM t_katerina_dvouleta_project_sql_primary_final
),
price_growth AS (
SELECT
year,
category_code,
category_name,
avg_price,
LAG(avg_price) OVER (
PARTITION BY category_code
ORDER BY year
) AS prev_year_price
FROM prices_unique
),
growth_calculated AS (
SELECT
year,
category_code,
category_name,
avg_price,
prev_year_price,
ROUND(
((avg_price - prev_year_price) / prev_year_price * 100)::numeric,
2
) AS pct_growth
FROM price_growth
WHERE prev_year_price IS NOT NULL
)
SELECT
category_code,
category_name,
ROUND(AVG(pct_growth), 2) AS avg_pct_growth
FROM growth_calculated
GROUP BY
category_code,
category_name
ORDER BY avg_pct_growth;

-- odpověď na otázku č. 3 - Nejpomaleji zdražovalo zboží Cukr krystalový (118101), u které vyšel průměrný meziroční procentní růst -1,92%. Jeho cena v průměru meziročně klesala
-- Mezi další velmi pomalu rostoucí nebo klesající položky patřila rajská jablka červená kulatá.




