# DataCleaning_Project

This project demonstrates a full data cleaning process using SQL on a dataset containing information about global layoffs. The process includes removing duplicates, standardizing values, handling nulls, and dropping irrelevant data columns.

The dataset, stored in a table called world_layoffs, includes the following fields:
company
location
industry
total_laid_off
percentage_laid_off
date
stage
country
funds_raised_millions

Note: The original dataset was duplicated into staging tables to preserve the raw data.

Cleaning Steps:
1. Remove Duplicates
Created a staging table world_layoffs_staging.

Used ROW_NUMBER() to identify duplicates based on all key fields.

Created world_layoffs_staging2 and kept only the first occurrence of duplicates.

2. Standardize the Data
Trimmed whitespace from company names.

Standardized values in industry and country fields (e.g., "CryptoCurrency" → "Crypto", "United States." → "United States").

Reformatted the date column to a consistent SQL DATE format using STR_TO_DATE().

3. Handle Null or Blank Values
Replaced null/empty industries by inferring values from other records with the same company name.

Ensured consistent representation of missing values (e.g., "NULL" as string).

4. Remove Irrelevant Data
Deleted rows where both total_laid_off and percentage_laid_off were "NULL".

Dropped the column row_num used for deduplication.
