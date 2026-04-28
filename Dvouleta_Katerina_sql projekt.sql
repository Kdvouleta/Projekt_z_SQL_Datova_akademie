
SELECT * FROM czechia_payroll LIMIT 10;
SELECT * FROM czechia_payroll_calculation;
SELECT * FROM czechia_payroll_industry_branch LIMIT 10;
SELECT * FROM czechia_payroll_unit LIMIT 10;
SELECT * FROM czechia_payroll_value_type LIMIT 10;
SELECT * FROM czechia_price LIMIT 10;
SELECT * FROM czechia_price_category LIMIT 10;
SELECT * FROM countries;
SELECT * FROM economies LIMIT 10;

-- prohlédla jsem si tabulky a zjistila jsem jaké mám roky, mzdy po letech či kvartálech, 
--jaké kódy značí průměrnou mzdu, jak jsou vedeny ceny potravin


-- dále jsme zjistila společné období mezi cenami a mzdami
WITH payroll_years AS (
    SELECT DISTINCT payroll_year AS year
    FROM czechia_payroll
    WHERE value IS NOT NULL
      AND value_type_code = 5958
      AND unit_code = 200
      AND calculation_code = 200
),
price_years AS (
    SELECT DISTINCT EXTRACT(YEAR FROM date_from) AS year
    FROM czechia_price
    WHERE value IS NOT NULL
      AND region_code IS NULL
)
SELECT p.year
FROM payroll_years p
JOIN price_years c
    ON p.year = c.year
ORDER BY p.year;

-- v dalším kroku jsem spočítala roční průměr mezd podle odvětví

SELECT
    cp.payroll_year AS year,
    cp.industry_branch_code,
    ib.name AS industry_name,
    ROUND(AVG(cp.value), 2) AS avg_wage
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch ib
    ON cp.industry_branch_code = ib.code
WHERE cp.value IS NOT NULL
  AND cp.value_type_code = 5958
  AND cp.unit_code = 200
  AND cp.calculation_code = 200
GROUP BY
    cp.payroll_year,
    cp.industry_branch_code,
    ib.name
ORDER BY year, industry_name;

-- následně jsem zjistila roční průměr cen potravin v ČR

SELECT
    EXTRACT(YEAR FROM cp.date_from) AS year,
    cp.category_code,
    cpc.name AS category_name,
    cpc.price_value,
    cpc.price_unit,
    ROUND(AVG(cp.value)::numeric, 2) AS avg_price
FROM czechia_price cp
JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
WHERE cp.value IS NOT NULL
  AND cp.region_code IS NULL
GROUP BY
    EXTRACT(YEAR FROM cp.date_from),
    cp.category_code,
    cpc.name,
    cpc.price_value,
    cpc.price_unit
ORDER BY year, category_name;

-- zde jsem spojila roční mzdy a roční ceny přes společný slopuec "year"

WITH payroll_yearly AS (
SELECT
cp.payroll_year AS year,
cp.industry_branch_code,
ib.name AS industry_name,
ROUND(AVG(cp.value), 2) AS avg_wage
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch ib
ON cp.industry_branch_code = ib.code
WHERE cp.value IS NOT NULL
AND cp.value_type_code = 5958
AND cp.unit_code = 200
AND cp.calculation_code = 200
AND cp.payroll_year BETWEEN 2006 AND 2018
GROUP BY
cp.payroll_year,
cp.industry_branch_code,
ib.name
),
price_yearly AS (
SELECT
EXTRACT(YEAR FROM cp.date_from) AS year,
cp.category_code,
cpc.name AS category_name,
cpc.price_value,
cpc.price_unit,
ROUND(AVG(cp.value)::numeric, 2) AS avg_price
FROM czechia_price cp
JOIN czechia_price_category cpc
ON cp.category_code = cpc.code
WHERE cp.value IS NOT NULL
AND cp.region_code IS NULL
AND EXTRACT(YEAR FROM cp.date_from) BETWEEN 2006 AND 2018
GROUP BY
EXTRACT(YEAR FROM cp.date_from),
cp.category_code,
cpc.name,
cpc.price_value,
cpc.price_unit
)
SELECT
p.year,
p.industry_branch_code,
p.industry_name,
p.avg_wage,
c.category_code,
c.category_name,
c.price_value,
c.price_unit,
c.avg_price
FROM payroll_yearly p
JOIN price_yearly c
ON p.year = c.year
ORDER BY
p.year,
p.industry_name,
c.category_name;

-- vytvořila jsem tabulku primary_final dle zadání

DROP TABLE IF EXISTS t_katerina_dvouleta_project_sql_primary_final;

CREATE TABLE t_katerina_dvouleta_project_sql_primary_final AS
WITH payroll_yearly AS (
SELECT
cp.payroll_year AS year,
cp.industry_branch_code,
ib.name AS industry_name,
ROUND(AVG(cp.value), 2) AS avg_wage
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch ib
ON cp.industry_branch_code = ib.code
WHERE cp.value IS NOT NULL
AND cp.value_type_code = 5958
AND cp.unit_code = 200
AND cp.calculation_code = 200
AND cp.payroll_year BETWEEN 2006 AND 2018
GROUP BY
cp.payroll_year,
cp.industry_branch_code,
ib.name
),
price_yearly AS (
SELECT
EXTRACT(YEAR FROM cp.date_from) AS year,
cp.category_code,
cpc.name AS category_name,
cpc.price_value,
cpc.price_unit,
ROUND(AVG(cp.value)::numeric, 2) AS avg_price
FROM czechia_price cp
JOIN czechia_price_category cpc
ON cp.category_code = cpc.code
WHERE cp.value IS NOT NULL
AND cp.region_code IS NULL
AND EXTRACT(YEAR FROM cp.date_from) BETWEEN 2006 AND 2018
GROUP BY
EXTRACT(YEAR FROM cp.date_from),
cp.category_code,
cpc.name,
cpc.price_value,
cpc.price_unit
)
SELECT
p.year,
p.industry_branch_code,
p.industry_name,
p.avg_wage,
c.category_code,
c.category_name,
c.price_value,
c.price_unit,
c.avg_price
FROM payroll_yearly p
JOIN price_yearly c
ON p.year = c.year;

SELECT *
FROM t_katerina_dvouleta_project_sql_primary_final
LIMIT 20;

SELECT COUNT(*)
FROM t_katerina_dvouleta_project_sql_primary_final;

-- zkontrolovala jsem data pro secondary_final, zjistila jsem, že se to bude týkat roků 2006 - 2018

SELECT
c.country,
c.continent,
e.year,
e.gdp,
e.gini,
e.population
FROM countries c
JOIN economies e
ON c.country = e.country
WHERE c.continent = 'Europe'
AND e.year BETWEEN 2006 AND 2018
ORDER BY c.country, e.year;

-- vytvorila jsem tabulku secondary_final

DROP TABLE IF EXISTS t_katerina_dvouleta_project_sql_secondary_final;

CREATE TABLE t_katerina_dvouleta_project_sql_secondary_final AS
SELECT
c.country,
c.continent,
e.year,
e.gdp,
e.gini,
e.population
FROM countries c
JOIN economies e
ON c.country = e.country
WHERE c.continent = 'Europe'
AND e.year BETWEEN 2006 AND 2018;

SELECT *
FROM t_katerina_dvouleta_project_sql_secondary_final
LIMIT 20;



