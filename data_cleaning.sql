use unicorncompanies;

SELECT *
FROM unicorncompanies.unicorn_info
ORDER BY 1 ASC;

SELECT *
FROM UnicornCompanies.unicorn_finance
ORDER BY 1 ASC;

------------------------------------------------------------------------------------------


-- Check duplicate company name

SELECT Company, COUNT(Company)
FROM UnicornCompanies.unicorn_info
GROUP BY Company
HAVING COUNT(Company) > 1;

SELECT Company, COUNT(Company)
FROM UnicornCompanies.unicorn_finance
GROUP BY Company
HAVING COUNT(Company) > 1;

-- > Bolt and Fabric appear twice in both data sets. Anyway, they are in different cities / countries. 
-- > Therefore, we will keep those data.


--------------------------------------------------------------------------------------------------------

-- Rename columns

ALTER TABLE unicorn_info
RENAME COLUMN `Year Founded` TO YearFounded;

ALTER TABLE unicorn_info
RENAME COLUMN `Date Joined` TO DateJoined;

ALTER TABLE unicorn_info
RENAME COLUMN `Select Investors` TO SelectInvestors;

ALTER TABLE unicorn_finance
RENAME COLUMN `Select Investors` TO SelectInvestors;

SELECT *
FROM UnicornCompanies.unicorn_finance;

SELECT *
FROM UnicornCompanies.unicorn_info;
--------------------------------------------------------------------------------------------------------

-- Standardize date joined format & break out date joined into individual columns (Year, Month, Day)
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE unicorn_finance
ADD COLUMN DateJoinedConverted DATE;
UPDATE unicorn_finance
SET DateJoinedConverted = STR_TO_DATE(`Date Joined`, '%Y-%m-%d');


ALTER TABLE UnicornCompanies.unicorn_finance
ADD Year INT;
UPDATE UnicornCompanies.unicorn_finance
SET Year = YEAR(DateJoinedConverted);

ALTER TABLE UnicornCompanies.unicorn_finance
ADD Month INT;
UPDATE UnicornCompanies.unicorn_finance
SET Month = MONTH(DateJoinedConverted);

ALTER TABLE UnicornCompanies.unicorn_finance
ADD Day INT;
UPDATE UnicornCompanies.unicorn_finance
SET Day = DAY(DateJoinedConverted);


SELECT *
FROM UnicornCompanies.unicorn_finance;

--------------------------------------------------------------------------------------------------------

-- Drop rows where Funding column contain 0 or Unknown

DELETE FROM UnicornCompanies.unicorn_finance 
WHERE Funding IN ('$0M', 'Unknown');

SELECT DISTINCT Funding
FROM UnicornCompanies.unicorn_finance
ORDER BY Funding DESC;


--------------------------------------------------------------------------------------------------------

-- Reformat currency value

-- "Valuation" and "Funding" columns

UPDATE UnicornCompanies.unicorn_finance
SET Valuation = SUBSTRING(Valuation, 2);
UPDATE UnicornCompanies.unicorn_finance
SET Valuation = REPLACE(REPLACE(Valuation, 'B','000000000'), 'M', '000000');

UPDATE UnicornCompanies.unicorn_finance
SET Funding = SUBSTRING(Funding, 2);
UPDATE UnicornCompanies.unicorn_finance
SET Funding = REPLACE(REPLACE(Funding, 'B','000000000'), 'M', '000000');


SELECT *
FROM UnicornCompanies.unicorn_finance;

--------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

ALTER TABLE UnicornCompanies.unicorn_finance
DROP COLUMN `Date Joined`;

ALTER TABLE UnicornCompanies.unicorn_finance
RENAME COLUMN DateJoinedConverted TO DateJoined;

SELECT *
FROM UnicornCompanies.unicorn_finance;

SELECT *
FROM UnicornCompanies.unicorn_info;
















