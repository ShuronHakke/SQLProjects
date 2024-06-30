-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
group by company
order by 2 desc;

SELECT min(`date`),max(`date`)
FROM layoffs_staging2;

SELECT country, sum(total_laid_off)
FROM layoffs_staging2
group by country
order by 2 desc;

SELECT *
FROM layoffs_staging2;

SELECT year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by year(`date`)
order by 1 desc;

SELECT stage, sum(total_laid_off)
FROM layoffs_staging2
group by stage
order by 2  desc;

-- Rolling Sum
SELECT SUBSTRING(`DATE`,1,7) AS month, sum(total_laid_off)
FROM layoffs_staging2
where SUBSTRING(`DATE`,1,7) IS NOT NULL
group by month
order by 1 asc;

WITH Rolling_total as
(
SELECT SUBSTRING(`date`,1,7) AS `month`, sum(total_laid_off) as total_off
FROM layoffs_staging2
where SUBSTRING(`date`,1,7) IS NOT NULL
group by `month`
order by 1 asc
)
SELECT `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
FROM Rolling_total;

-- How many layoffs in each company baed out of year and their ranking
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company,YEAR(`date`)
order by 3 desc;
-- Their Rankings
with company_year(company,years,total_laid_off) as
(
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company,YEAR(`date`)
),company_year_rank as 
(
select *, DENSE_RANK() OVER(PARTITION BY years order by total_laid_off DESC) as ranking
from company_year
where years is not NULL
)
select * 
from company_year_rank
where ranking <=5;