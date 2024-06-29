# Data Amalysis Project using SQL 
# Stage 1 - Cleaning Data

# 4 Stages of Data Cleaning Project

#1. Remove Duplicates
#2. Standardize Data
#3. Null and Blank Values
#4. Remove any columns 

select *
from layoffs;

#1. REMOVING DUPLICATES

create table layoffs_staging
like layoffs;

insert into layoffs_staging
select * 
from layoffs;

select *,
row_number() over(partition by 
company,industry,total_laid_off,percentage_laid_off,`date` ) as row_num
from layoffs_staging;

with duplicate_cte as 
(
select *,
row_number() over(partition by 
company,location,industry,total_laid_off,percentage_laid_off,'date',stage, funds_raised_millions ) as row_num
from layoffs_staging
)
select * 
from duplicate_cte
where row_num>1;

select *
from layoffs_staging
where company = 'Oda';



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2;

insert into layoffs_staging2
select *,
row_number() over(partition by 
company,location,industry,total_laid_off,percentage_laid_off,'date',stage, funds_raised_millions ) as row_num
from layoffs_staging;

select *
from layoffs_staging2
where row_num = 2;

DELETE
from layoffs_staging2
where row_num >1;

SELECT *
from layoffs_staging2
;

# 2. STANDARDIZING DATA

select distinct trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select *
from layoffs_staging2
where industry LIKE 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select *
from layoffs_staging2;

select distinct industry
from layoffs_staging2
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
where country like 'United States%'
order by 1;

Update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

select `date`
from layoffs_staging2;

UPDATE layoffs_staging2
set `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

# 3. NULL VALUES AND BLANK VALUES

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE INDUSTRY IS NULL 
OR INDUSTRY = '';

update layoffs_staging2
set industry = NULL
where industry = '';

SELECT *
FROM layoffs_staging2
WHERE COMPANY like 'Bally%';

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is NULL or t1.industry ='')
and t2.industry is NOT NULL;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is NULL 
and t2.industry is NOT NULL;

# 4. REMOVE COLUMNS

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

delete 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

alter table layoffs_staging2
drop column row_num;