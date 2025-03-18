/* 
--------------------------------------------------------------------------------------------------------
Queries for Data Visualization
--------------------------------------------------------------------------------------------------------
*/


USE UnicornCompanies;


-- Table 1

-- Total Unicorn Companies

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin 
		ON inf.ID = fin.ID)
SELECT COUNT(1) AS Unicorn
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;


-- Total Countries

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin 
		ON inf.ID = fin.ID)
SELECT COUNT(DISTINCT Country) AS Country
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;



-- Table 2 


WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin 
		ON inf.ID = fin.ID)
SELECT Company, Country
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;

-- Table 3


SELECT Company, (Valuation-Funding) / Funding AS Roi
FROM UnicornCompanies.unicorn_finance
ORDER BY Roi DESC
Limit 10;




-- Table 4



WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin 
		ON inf.ID = fin.ID)
SELECT Company, (Year - YearFounded) AS UnicornYear
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;


WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin 
		ON inf.ID = fin.ID)
SELECT (Year - YearFounded) AS UnicornYear, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY (Year - YearFounded)
ORDER BY COUNT(1) DESC;

-- Table 5

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin 
		ON inf.ID = fin.ID)
SELECT Industry, 
       COUNT(1) AS Frequency, 
       CAST(COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom) AS UNSIGNED) AS Percentage
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Industry
ORDER BY COUNT(1) DESC;

-- Table 6


WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin
		ON inf.ID = fin.ID)
SELECT Country,
       COUNT(1) AS Frequency,
       CAST(COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom) AS UNSIGNED) AS `Percentage`
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Country
ORDER BY Frequency DESC;



-- Table 7

-- Step 1: Create a derived numbers table with values from 1 to 4
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 4
)

-- Step 2: Split the SelectInvestors column into individual investors
SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(SelectInvestors, ',', numbers.n), ',', -1)) AS Investor,
    COUNT(*) AS UnicornsInvested
FROM
    UnicornCompanies.unicorn_finance
JOIN
    numbers ON CHAR_LENGTH(SelectInvestors)
             - CHAR_LENGTH(REPLACE(SelectInvestors, ',', '')) >= numbers.n - 1
GROUP BY
    Investor
ORDER BY
    UnicornsInvested DESC;


