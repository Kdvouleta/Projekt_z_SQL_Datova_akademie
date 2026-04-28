
-- otázka č. 2 - Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- našla jsem kod pro chléb a mléko a dále pokračovala analýzou průměrné mzdy v roce, průměrné ceny potravin

SELECT *
FROM czechia_price_category
WHERE name ILIKE '%mléko%'
OR name ILIKE '%chléb%';

WITH wages_unique AS (
SELECT DISTINCT
year,
industry_branch_code,
industry_name,
avg_wage
FROM t_katerina_dvouleta_project_sql_primary_final
),
yearly_wages AS (
SELECT
year,
ROUND(AVG(avg_wage), 2) AS avg_year_wage
FROM wages_unique
GROUP BY year
),
selected_foods AS (
SELECT DISTINCT
year,
category_code,
category_name,
avg_price
FROM t_katerina_dvouleta_project_sql_primary_final
WHERE category_code IN (114201, 111301)
),
first_last_years AS (
SELECT MIN(year) AS first_year, MAX(year) AS last_year
FROM t_katerina_dvouleta_project_sql_primary_final
)
SELECT
sf.year,
sf.category_name,
yw.avg_year_wage,
sf.avg_price,
ROUND(yw.avg_year_wage / sf.avg_price, 2) AS amount_can_buy
FROM selected_foods sf
JOIN yearly_wages yw
ON sf.year = yw.year
JOIN first_last_years fly
ON sf.year IN (fly.first_year, fly.last_year)
ORDER BY sf.year, sf.category_name;

-- Odpověď na otázku č. 2- V prvním srovnatelném období 2006 bylo možné za průměrnou mzdu koupit přibližně 1312,98 kg chleba a 1465,73 l mléka
-- v posledním srovnatelném období (2018) bylo možné koupit cca 1365,16 kg chleba a 1669,6 l mléka 
-- z toho plyne, že kupní síla mezi sledovanými obdobími se s ohledem na obě sledované potraviny zvýšila 
-- výrazněji u mléka než u chleba



