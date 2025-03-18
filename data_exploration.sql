/* 
--------------------------------------------------------------------------------------------------------
Data Exploration for Unicorn Companies Analytics Project
--------------------------------------------------------------------------------------------------------


Reesearch Questions
=======================================================================================================
- Which unicorn companies have had the biggest return on investment?
- How long does it usually take for a company to become a unicorn?
- Which industries have the most unicorns? 
- Which countries have the most unicorns? 
- Which investors have funded the most unicorns?
=======================================================================================================
*/


USE UnicornCompanies;

SELECT *
FROM UnicornCompanies.unicorn_info
ORDER BY 1 ASC;

SELECT *
FROM UnicornCompanies.unicorn_finance
ORDER BY 1 ASC;

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


--------------------------------------------------------------------------------------------------------

/*
- Which unicorn companies have had the biggest return on investment?
*/


SELECT Company, (Valuation-Funding) / Funding AS Roi
FROM UnicornCompanies.unicorn_finance
ORDER BY Roi DESC
Limit 10;

-- > 1.Zapier 2.Dunamu 3.Workhuman 4.CFGI 5.Manner 6.DJI Innovations 7.GalaxySpace 8.Canva 9.II Makiage 10.Revolution Precrafted


--------------------------------------------------------------------------------------------------------

/*
- How long does it usually take for a company to become a unicorn?
*/


-- Find average years to become a unicorn

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin 
		ON inf.ID = fin.ID)
SELECT AVG(Year - YearFounded) AS AverageYear
FROM UnicornCom;

-- > On average it takes 6 years to become a unicorn company


-- Details on how long it takes for the companies to become a unicorn

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
ORDER BY COUNT(1) DESC
LIMIT 10;
-- Mostly take from 4 to 7 years to become a unicorn


--------------------------------------------------------------------------------------------------------

/*
- Which industries have the most unicorns? 
*/


-- Number of unicorn companies within each industry

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin
		ON inf.ID = fin.ID)
SELECT Industry, COUNT(1) as Frequency
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Industry
ORDER BY COUNT(1) DESC;

-- > Fintech followed by Internet software and services and e-commerce.


-- Number of unicorn companies within each industry and their shares

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin
		ON inf.ID = fin.ID
)
SELECT Industry, Count(1) AS Frequency, (COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom)) AS 'Percentage'
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Industry
ORDER BY Count(1) DESC;


--------------------------------------------------------------------------------------------------------

/*
- Which countries have the most unicorns? 
*/


-- Number of unicorn companies within each country

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin
		ON inf.ID = fin.ID
)
SELECT Country, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Country
ORDER BY Count(1) DESC;

-- United States followed by China and India.


-- Number of unicorn companies within each country and their shares

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, Year, SelectInvestors) AS
	(SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, fin.Valuation, fin.Funding, inf.YearFounded, 
			fin.Year, fin.SelectInvestors
	FROM UnicornCompanies.unicorn_info AS inf
	INNER JOIN UnicornCompanies.unicorn_finance AS fin
		ON inf.ID = fin.ID
)
SELECT Country, COUNT(1) AS Frequency, (COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom)) AS 'Percentage'
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Country
ORDER BY Count(1) DESC
LIMIT 10;


--------------------------------------------------------------------------------------------------------

/*
- Which investors have funded the most unicorns?
*/


SELECT *
FROM UnicornCompanies.unicorn_finance
ORDER BY 1 ASC;


-- Replace ', ' with ',' before doing the split

UPDATE UnicornCompanies.unicorn_finance
SET SelectInvestors = REPLACE(SelectInvestors, ', ', ',');

-- Standardize the SelectInvestors column by removing spaces after commas
UPDATE UnicornCompanies.unicorn_finance
SET SelectInvestors = REPLACE(SelectInvestors, ', ', ',');

-- Create a temporary table to hold individual investor entries
CREATE TEMPORARY TABLE InvestorsTemp (
    ID INT,
    Investor VARCHAR(255)
);

-- Insert individual investors into the temporary table
INSERT INTO InvestorsTemp (ID, Investor)
SELECT ID, SUBSTRING_INDEX(SelectInvestors, ',', 1) AS Investor
FROM UnicornCompanies.unicorn_finance
WHERE SelectInvestors IS NOT NULL
UNION ALL
SELECT ID, SUBSTRING_INDEX(SUBSTRING_INDEX(SelectInvestors, ',', 2), ',', -1) AS Investor
FROM UnicornCompanies.unicorn_finance
WHERE SelectInvestors IS NOT NULL AND LENGTH(SelectInvestors) - LENGTH(REPLACE(SelectInvestors, ',', '')) >= 1
UNION ALL
SELECT ID, SUBSTRING_INDEX(SUBSTRING_INDEX(SelectInvestors, ',', 3), ',', -1) AS Investor
FROM UnicornCompanies.unicorn_finance
WHERE SelectInvestors IS NOT NULL AND LENGTH(SelectInvestors) - LENGTH(REPLACE(SelectInvestors, ',', '')) >= 2
UNION ALL
SELECT ID, SUBSTRING_INDEX(SUBSTRING_INDEX(SelectInvestors, ',', 4), ',', -1) AS Investor
FROM UnicornCompanies.unicorn_finance
WHERE SelectInvestors IS NOT NULL AND LENGTH(SelectInvestors) - LENGTH(REPLACE(SelectInvestors, ',', '')) >= 3;

-- Retrieve the top 10 investors based on the number of unique unicorns they've invested in
SELECT
    Investor,
    COUNT(DISTINCT ID) AS UnicornsInvested
FROM
    InvestorsTemp
GROUP BY
    Investor
ORDER BY
    UnicornsInvested DESC
LIMIT 10;


-- > Accel followed  by Tiger Glabal Management and Andreessen Horowitz

-- Drop the temporary table
DROP TEMPORARY TABLE IF EXISTS InvestorsTemp;