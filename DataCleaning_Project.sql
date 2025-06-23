-- Data Cleaning

-- 1. Remove Duplicates 
-- 2. Standarize the Data 
-- 3. Null Values or blank values 
-- 4. Remove any columns

 
SELECT * 
FROM world_layoffs;

# Creating staging table 
CREATE TABLE world_layoffs_staging
LIKE world_layoffs; 

SELECT * 
FROM world_layoffs_staging;

INSERT world_layoffs_staging 
SELECT * 
FROM world_layoffs;

-- 1. Remove Duplicates
SELECT * , ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM world_layoffs_staging;

# delete when row number is > 1 or 2 
WITH duplicate_cte AS
(
SELECT * , 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;


# Creating a new column and adding row numbers in.
CREATE TABLE `world_layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM world_layoffs_staging2
WHERE row_num > 1;

INSERT INTO world_layoffs_staging2
SELECT * , 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs_staging;

# Deleting where row numbers are over 2 then deleting column.
DELETE 
FROM world_layoffs_staging2
WHERE row_num >= 2;


-- 2. Standardizing data
SELECT company, TRIM(company) 
FROM world_layoffs_staging2;

UPDATE world_layoffs_staging2 
SET company = TRIM(company);

SELECT * 
FROM world_layoffs_staging2;

SELECT *
FROM world_layoffs_staging2 
WHERE industry = "CryptoCurrency";

UPDATE world_layoffs_staging2 
SET industry = "Crypto" 
WHERE industry LIKE "Crypto%";

SELECT DISTINCT industry 
FROM world_layoffs_staging2;

# Fixing "United States. " (one has period at the end) 
SELECT DISTINCT country , TRIM(TRAILING "." FROM country) 
FROM world_layoffs_staging2
ORDER BY 1; 

UPDATE world_layoffs_staging2
SET country = TRIM(TRAILING "." FROM country) 
WHERE country LIKE "United States%";

# Changing date 
SELECT `date`, STR_TO_DATE(`date`, "%m/%d/%Y")
FROM world_layoffs_staging2;

UPDATE world_layoffs_staging2
SET `date` = CASE 
	WHEN `date` LIKE "%/%/%" THEN STR_TO_DATE(`date`, "%m/%d/%Y")
    ELSE `date`
END;

SELECT `date`
FROM world_layoffs_staging2;

SELECT * 
FROM world_layoffs_staging2
WHERE total_laid_off = "NULL" AND percentage_laid_off = "NULL";

-- 3. NULL/blank values
SELECT * 
FROM world_layoffs_staging2;

UPDATE world_layoffs_staging2
SET industry = "NULL"
WHERE industry IS NULL;

SELECT *
FROM world_layoffs_staging2 
WHERE industry = "NULL" OR industry = "";

# Updating the empty (industry) airbnb with "Travel".
SELECT * 
FROM world_layoffs_staging2 
WHERE company = "Airbnb";

SELECT t1.industry, t2.industry
FROM world_layoffs_staging2 AS t1
JOIN world_layoffs_staging2 AS t2 
	ON t1.company = t2.company 
WHERE (t1.industry = "NULL" OR t1.industry = "") AND t2.industry <> "NULL";

UPDATE world_layoffs_staging2 AS t1 
JOIN world_layoffs_staging2 AS t2 
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry = "NULL" AND t2.industry <> "NULL";

-- 4. Removing columns 
SELECT * 
FROM world_layoffs_staging2
WHERE total_laid_off = "NULL" AND percentage_laid_off = "NULL";

DELETE 
FROM world_layoffs_staging2 
WHERE total_laid_off = "NULL" AND percentage_laid_off = "NULL";

SELECT * 
FROM world_layoffs_staging2;

ALTER TABLE world_layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM world_layoffs_staging;















