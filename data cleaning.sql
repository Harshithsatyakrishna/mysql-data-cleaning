-- Checking the main raw datatable ----
SELECT * 
FROM layoffs;

-- Created New table so that we can avoid mistakes making in the main dataset ---------------------------------- 
CREATE TABLE layoffs_new
LIKE layoffs;


SELECT * FROM layoffs_new;
INSERT layoffs_new 
SELECT * FROM layoffs;

-- 1. DELETING DUPLICATES----------------------------------------------------------------------------------------
-- Making row numbers to find out the duplicates ------
SELECT *, 
ROW_Number() OVER( 
partition BY company,industry, total_laid_off,`date`) AS row_num
FROM layoffs_new;


-- Made a CTE (Common Table Expression) to make the query easy to retrive further --------
WITH duplicate_cte AS (
SELECT *, 
ROW_Number() OVER( 
partition BY company,location,industry, total_laid_off,`date`, percentage_laid_off,stage,funds_raised,country,date_added) AS row_num
FROM layoffs_new
)


-- Checking row number more than 1 that is the duplicates ---
SELECT * 
FROM duplicate_cte
WHERE row_num>1;

-- just a check-----
SELECT * 
FROM layoffs_new
WHERE company = "Casper";

-- You cannot update an CTE to delete the rows
-- So we are making another table which includes the row number so we can delete by not using cte ----

CREATE TABLE `layoffs_new2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` text,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_new2
WHERE row_num>1;

-- Taking the values from layoff-new to layoff-new2------

Insert into layoffs_new2
SELECT *, 
ROW_Number() OVER( 
partition BY company,location,industry, total_laid_off,`date`, percentage_laid_off,stage,funds_raised,country,date_added
) AS row_num
FROM layoffs_new;

DELETE
FROM layoffs_new2
WHERE row_num > 1;
-- Duplicates are deleted --------------------------------------
SELECT * 
FROM layoffs_new2;

-- 2. STANDARDIZE THE DATA [FINDING ISSUES AND FIXING DATA]-----------------------------------------------------------------------------

SELECT company, TRIM(company)
FROM layoffs_new2;

UPDATE layoffs_new2 
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_new2;

SELECT DISTINCT country
FROM layoffs_new2
ORDER BY 1 ;
-- To change the text format of date to date format --------------------
SELECT `date`
FROM layoffs_new2;

UPDATE layoffs_new2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_new2
MODIFY COLUMN `date` DATE;

-- Check every column if it needs to trim, change format, any duplicates or any other other issues ----------
-- We fixed the data -------------------------------------------------
-- 3. Null Values or Blank Spaces-------------------------------------------------------------------------------------------

SELECT *
FROM layoffs_new2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_new2
SET industry = " "
WHERE industry = NULL;

SELECT * 
FROM layoffs_new2
WHERE industry IS NULL
OR industry = " ";

SELECT *
FROM layoffs_new2
WHERE company LIKE "Bally%";

SELECT *
FROM layoffs_new2
WHERE company LIKE "Airbnb";

SELECT t1.industry ,t2.industry
FROM layoffs_new2 t1
JOIN layoffs_new2 t2
	ON t1.company = t2.company
WHERE(t1.industry IS NULL or t1.industry = " ")
AND t2.industry is NOT NULL;

UPDATE layoffs_new2 t1
JOIN layoffs_new2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_new2