## **Úvod do projektu**

Na našem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jsme se dohodli, že se pokusíme odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti.
Kolegové již vydefinovali základní otázky, na které se pokusím odpovědět a poskytnout tuto informaci tiskovému oddělení.
Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.
Potřebují k tomu od nás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
Jako dodatečný materiál připravíme i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

### Datové sady, které jsme mohli použít pro získání vhodného datového podkladu
**Primární tabulky:**
1. *czechia_payroll* – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR
2. *czechia_payroll_calculation* – Číselník kalkulací v tabulce mezd
3. *czechia_payroll_industry_branch* – Číselník odvětví v tabulce mezd
4. *czechia_payroll_unit* – Číselník jednotek hodnot v tabulce mezd
5. *czechia_payroll_value_type* – Číselník typů hodnot v tabulce mezd
6. *czechia_price* – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR
7. *czechia_price_category* – Číselník kategorií potravin, které se vyskytují v našem přehledu

**Číselníky sdílených informací o ČR:**
1. *czechia_region* – Číselník krajů České republiky dle normy CZ-NUTS 2
2. *czechia_district* – Číselník okresů České republiky dle normy LAU

**Dodatečné tabulky:**
1. *countries* - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace
2. *economies* - HDP, GINI, daňová zátěž, atd. pro daný stát a rok

### Nadefinované výzkumné otázky ### 
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?


### Následně jsem postupovala při analýze dat následovně: ### 

Prohlédla jsem si data a zjistila strukturu tabulek. Našla společné období mezi mzdami a cenami, připravila si očištěný přehled mezd, očištěný přehled cen potravin a spojila obě části do tabulky "primary final". Dále jsem si připravila tabulku "secondary final" z countries a economies.

Postupnými dotazy jsem mohla odpovědět na zadané otázky, které uvádím níže.

**Otázka č. 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

Ve sledovaném období 2006 - 2018 mzdy ve všech sledovaných odvětvích celkově vzrostly, protože ve všech odvětvích byla mzda v roce 2018 vyšší než v roce 2006. Růst ale nebyl plynulý. V 16 z 19 odvětví se aslespoň 1x objevil meziroční pokles mzdy. Nejvíce poklesů bylo zaznamenáno v odvětví Těžba a dobývání, dále ve Výrobě a rozvodu elektřiny. Největší rozdíl ve výši mzdy mezi roky 2006 a 2018 bylo u odvětví Informační a komunikační činnosti.

**Otázka č. 2 - Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

V prvním srovnatelném období, v roce 2006, bylo možné si za průměrnou mzdu koupit přibližně 1312,98 kg chleba nebo 1465,73 l mléka.
V posledním srovnatelném období, v roce 2018, bylo možné si koupit za průměrnou mzdu přibližně 1365,16 kg chleba nebo 1669,6 l mléka.
Z toho plyne, že kupní síla mezi sledovanými obdobími se s ohledem na obě sledované potraviny zvýšila výrazněji u mléka než u chleba.

**Otázka č. 3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

Nejpomaleji zdražovalo zboží Cukr krystalový (s kódem 118101), u kterého vyšel průměrný meziroční procentní růst -1,92 %. To znamená, že jeho cena v průměru meziročně klesala.

**Otázka č. 4 - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

Ve sledovaném období jsem nenalezla žádný rok, ve kterém by meziroční nárůst cen potravin převýšil růst mezd o více než 10 %.
Z toho plyne, že i když ceny potravin v některých letech rostly rychleji než mzdy, rozdíl nikdy nepřekročil hranici 10 %.

**Otázka č. 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**

Na základě jednoduchého meziročního porovnání nelze prokázat přímý vliv HDP na mzdy a ceny potravin.
Data naznačují, že růst HDP je častěji doprovázen růstem mezd, ale vztah není jednoznačný.
U cen potravin je souvislost ještě méně patrná a přímá vazba na HDP není tak dobře patrná..

### Závěr ### 

Jako analytické oddělení jsme tiskovému oddělení pro prezentaci na konferenci poskytli všechny datové podklady, dle ktrerých lze vidět porovnání dostupnosti potravin na základě průměrných příjmů za období 2006 - 2018. Současně přikládáme jednotlivé SQL soubory, kde je analýza s jednotlivými dotazy zřejmá.
