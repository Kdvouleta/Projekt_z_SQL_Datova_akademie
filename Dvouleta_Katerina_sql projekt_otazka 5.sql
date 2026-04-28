
-- otázka č. 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste 
--výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- pro každý rok jsem potřebovala průměrnou mzdu, průměrnou cenu potravin a HDP v ČR
-- pak jsem spočítala meziroční změnu HDP, mezd a cen potravin

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
czech_gdp AS (
SELECT
year,
gdp
FROM t_katerina_dvouleta_project_sql_secondary_final
WHERE country IN ('Czech Republic', 'Czechia')
),
combined AS (
SELECT
w.year,
g.gdp,
w.avg_year_wage,
p.avg_year_price
FROM yearly_wages w
JOIN yearly_prices p
ON w.year = p.year
JOIN czech_gdp g
ON w.year = g.year
),
growths AS (
SELECT
year,
gdp,
avg_year_wage,
avg_year_price,
LAG(gdp) OVER (ORDER BY year) AS prev_gdp,
LAG(avg_year_wage) OVER (ORDER BY year) AS prev_wage,
LAG(avg_year_price) OVER (ORDER BY year) AS prev_price
FROM combined
)
SELECT
year,
ROUND(((gdp - prev_gdp) / prev_gdp * 100)::numeric, 2) AS gdp_growth_pct,
ROUND(((avg_year_wage - prev_wage) / prev_wage * 100)::numeric, 2) AS wage_growth_pct,
ROUND(((avg_year_price - prev_price) / prev_price * 100)::numeric, 2) AS food_price_growth_pct
FROM growths
WHERE prev_gdp IS NOT NULL
AND prev_wage IS NOT NULL
AND prev_price IS NOT NULL
ORDER BY year;

-- odpověď 5 - z tabulky je videt, že ve většině let, kdy HDB rostlo, rostly také mzdy
-- růst mezd byl poměrně stabilní i v letech, kdy bylo tempo růstu HDP nižší 
-- u cen potravin je vývoj výrazně kolísavější a přímá vazba na HDP není tak dobře patrná
-- Vliv HDP na mzdy je dle dat viditelnější než vliv HDP na ceny potravin 
-- Při růstu HDP většinou rostly také mzdy, ale neplatí to jako přesná nebo okamžitá závislost pro každý rok. 
-- U cen potravin je vztah k HDP ještě slabší, protože jejich vývoj je zjevně ovlivněn i dalšími faktory. 

-- Odpověď na otázku č. 5 - Na základě jednoduchého meziročního porovnání nelze prokázat přímý vliv HDP na mzdy a ceny potravin. 
-- Data naznačují, že růst HDP je častěji doprovázen růstem mezd, ale vztah není jednoznačný. 
-- U cen potravin je souvislost ještě méně patrná.

-- růst HDP v ČR byl ve sledovaném období častěji doprovázen růstem mezd. Tato souvislost je patrnější než u cen potravin.
-- u cen potravin se přímý vztah k HDP nepotvrdil jednoznačně, protože jejich meziroční vývoj byl výrazně kolísavější. 
-- lze tedy říci, že HDP má na mzdy pravděpodobně silnější vazbu než na ceny potravin, avšak se nejedná o zcela přímou závislost.




