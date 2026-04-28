
-- otázka č. 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- zaměřila jsem se na vývoj mezd podle odvetvi a roku
-- porovnala jsem mzdy mezi jednotlivými roky v každém odvětví zlášť
-- zjistila jsem, jestli  mzda v odvětví dlouhodobě roste nebo v nějakém roce klesá

WITH wages_unique AS (
SELECT DISTINCT
year,
industry_branch_code,
industry_name,
avg_wage
FROM t_katerina_dvouleta_project_sql_primary_final
)
SELECT
year,
industry_branch_code,
industry_name,
avg_wage,
avg_wage - LAG(avg_wage) OVER (
PARTITION BY industry_branch_code
ORDER BY year
) AS wage_diff_prev_year
FROM wages_unique
ORDER BY industry_name, year;

-- Zjišťovala jsem odvětví, kde někdy doslo k meziročnímu poklesu mzdy
-- pokud bych měla prázdný výsledek - mzdy rostly ve všech odvětví každý rok 

 
WITH wages_unique AS (
SELECT DISTINCT
year,
industry_branch_code,
industry_name,
avg_wage
FROM t_katerina_dvouleta_project_sql_primary_final
),
wage_changes AS (
SELECT
year,
industry_branch_code,
industry_name,
avg_wage,
avg_wage - LAG(avg_wage) OVER (
PARTITION BY industry_branch_code
ORDER BY year
) AS wage_diff_prev_year
FROM wages_unique
)
SELECT
industry_branch_code,
industry_name,
COUNT(*) AS number_of_declines
FROM wage_changes
WHERE wage_diff_prev_year < 0
GROUP BY
industry_branch_code,
industry_name
ORDER BY number_of_declines DESC, industry_name;

-- Dále jsem porovnala první a poslední rok v jednotlivych odvětvíchch

WITH wages_unique AS (
SELECT DISTINCT
year,
industry_branch_code,
industry_name,
avg_wage
FROM t_katerina_dvouleta_project_sql_primary_final
),
first_last AS (
SELECT
industry_branch_code,
industry_name,
MIN(year) AS first_year,
MAX(year) AS last_year
FROM wages_unique
GROUP BY
industry_branch_code,
industry_name
)
SELECT
f.industry_branch_code,
f.industry_name,
f.first_year,
w1.avg_wage AS first_year_wage,
f.last_year,
w2.avg_wage AS last_year_wage,
w2.avg_wage - w1.avg_wage AS total_growth
FROM first_last f
JOIN wages_unique w1
ON f.industry_branch_code = w1.industry_branch_code
AND f.first_year = w1.year
JOIN wages_unique w2
ON f.industry_branch_code = w2.industry_branch_code
AND f.last_year = w2.year
ORDER BY total_growth;

--Odpověď na otázku č. 1
-- Ve sledovaném období 2006 - 2018 mzdy ve všech sledovaných odvětvích celkově vzrostly, protože ve všech odvětvích byla mzda v roce 2018 vyšší 
-- než v roce 2006. Růst ale nebyl plynulý. V 16 z 19 odvětví se aslespoň 1 objevil meziroční pokles mzdy. Nejvíce poklesů bylo 
-- zaznamenáno v odvětví Těžba a dobývání, dále ve Výrobě a rozvodu elektřiny. Největší rozdíl ve výši mzdy mezi roky 2006 a 2018 
-- bylo u odvětví Informační a komunikační činnosti.





