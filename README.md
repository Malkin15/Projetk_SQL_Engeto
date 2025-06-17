# Projetk_SQL_Engeto

Porovnávání dostupnosti běžných potravin na základě průměrných příjmů.

## Popis projektu

Tento projekt analyzuje životní úroveň občanů České republiky skrze dostupnost základních potravin v čase, a to na základě průměrných příjmů. Analýza odpovídá na několik výzkumných otázek, které se týkají nejen ČR, ale i evropského kontextu.

- **Datová sada pochází z Portálu otevřených dat ČR.**
- **Zadavatel projektu:** ENGETO

## Zadání projektu

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast. Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období. Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

## Použitá data

Dostupná data pro Českou republiku se pohybují v rozmezí let 2006–2018. Pro tyto účely používáme tabulku:
```
t_roman_simik_project_sql_primary_final
```
Pro doplňující data ze zbytku Evropy byla vytvořena sekundární tabulka:
```
t_roman_simik_project_sql_secondary_final
```
Skript pro tvorbu tabulek naleznete pod: `create_tables.sql`

SQL dotazy jsou zpracovány v databázi PostgreSQL (Postgres).

## Struktura projektu

Připravil jsem sestavu dotazů, které zodpovídají otázky v zadání projektu. Dotazy naleznete pod jednotlivými soubory:

- `Task_1.sql` – Vývoj mezd v jednotlivých odvětvích
- `Task_2.sql` – Kupní síla: kolik si lze koupit chleba/mléka za průměrnou mzdu
- `Task_3.sql` – Nejpomaleji/nejrychleji zdražující potraviny
- `Task_4.sql` – Porovnání růstu cen potravin a mezd v čase
- `Task_5.sql` – Vliv HDP na změny ve mzdách a cenách potravin

Odpovědi na výzkumné otázky naleznete v `Documentation.md`.

## Postup spuštění projektu

1. Otevřete PostgreSQL databázi.
2. Spusťte skript `create_tables.sql` pro vytvoření tabulek a naplnění dat.
3. Postupně spusťte jednotlivé SQL dotazy (`Task_1.sql` až `Task_5.sql`) dle potřeby.
4. Výsledky interpretujte podle popisu v souboru `Documentation.md`.

## Autor

Roman Šimík
