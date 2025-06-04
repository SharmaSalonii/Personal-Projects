Create Database Jobs;
Use Jobs;
select * from ai_jobs;

DESCRIBE ai_jobs;
ALTER TABLE ai_jobs
MODIFY COLUMN posting_date date;

SET SQL_SAFE_UPDATES = 0;
UPDATE ai_jobs
SET posting_date = STR_TO_DATE(posting_date, '%d-%m-%Y');

ALTER TABLE ai_jobs
MODIFY COLUMN posting_date DATE;

SET SQL_SAFE_UPDATES = 0;
UPDATE ai_jobs
SET application_deadline= STR_TO_DATE(application_deadline, '%d-%m-%Y');

ALTER TABLE ai_jobs
MODIFY COLUMN application_deadline DATE;


SET SQL_SAFE_UPDATES = 0;

update ai_jobs
set job_type = case
when remote_ratio = 0 then "On site"
when remote_ratio = 50 then "Hybrid"
when remote_ratio = 100 then "Remote"
else "Unknown"
end;

         /* 1. General Job Market Analysis */
/*What are the top 10 most common AI job titles?*/

SELECT job_title, COUNT(*) AS job_count
FROM ai_jobs
GROUP BY job_title
ORDER BY job_count DESC
LIMIT 10;

/*What is the average salary for AI jobs globally?*/

select ROUND(avg(salary_usd),2) as average_salary
 from ai_jobs;

/*Which countries offer the highest average salaries for AI roles?*/

SELECT company_location, ROUND(AVG(salary_usd), 2) AS avg_salary
FROM ai_jobs
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 10;

/*What is the distribution of employment types (e.g., contract, full-time) in AI roles?*/

select count(*) as job_count , employment_type 
from ai_jobs
group by employment_type
order by job_count desc;

/*How does remote work impact salary in AI roles?*/

select count(*),avg(salary_usd) ,job_type
from ai_jobs
group by job_type;

           /*2. Skill and Role Demand */
/* What are the top 10 most in-demand skills in AI job postings? */

select required_skills , count(*) as job_count
from ai_jobs
order by job_count desc
limit 10;

/* Which skills are associated with higher salaries? */

select avg(salary_usd) as average_salary,required_skills
from ai_jobs
group by required_skills
order by average_salary desc;

/* How do required skills differ between entry-level and senior-level positions? */

select experience_level, required_skills,count(*) as count
from ai_jobs
where experience_level IN ("EN","SE") 
group by experience_level,required_skills
order by experience_level,count desc;


         /*3. Education and Experience*/
/* What level of education is most commonly required for AI roles? */

select count(*) as count,education_required
from ai_jobs
group by job_title,education_required
order by count desc;

/*How does the required education level correlate with salary? */

select avg(salary_usd) as average_salary , education_required as education_level
from ai_jobs
group by education_level 
order by average_salary desc;

/* What is the average required experience for AI jobs by job title? */

select job_title,ROUND(avg(years_experience),2) as avg_experience 
from ai_jobs
group by job_title;

/* Is there a relationship between years of experience and benefits score? */

SELECT years_experience, ROUND(AVG(benefits_score), 2) AS avg_benefits_score
FROM ai_jobs
GROUP BY years_experience
ORDER BY years_experience;

             /* 4. Company & Location Insights*/
/* Which companies are hiring the most for AI roles? */

select count(*) as job_count,company_name
from ai_jobs
group by company_name 
order by job_count desc;

/* Which countries or cities are hotspots for AI job openings? */

select company_location,count(*) as job_count 
from ai_jobs
group by company_location
order by job_count desc;

/* How does company size relate to salary and benefits? */

select company_size,round(avg(salary_usd),2) as average_salary,round(avg(benefits_score),2) as avg_benefits_score
from ai_jobs
group by company_size
order by average_salary desc;

/* Do smaller or larger companies offer more remote opportunities? */

select company_size,count(job_type) as remote_jobs
from ai_jobs
where job_type="Remote"
group by company_size;

                 /* 5. Salary & Benefits Deep Dive */
/* What are the top 10 highest-paying AI roles? */

select avg(salary_usd) as average_salary , job_title
from ai_jobs 
group by job_title
order by average_salary desc
limit 10;

/* How does salary vary by industry (e.g., media vs automotive)? */

select avg(salary_usd) as average_salary,industry
from ai_jobs
group by industry
order by average_salary desc;

/* Do remote-friendly jobs offer higher or lower benefits scores? */

select round(avg(benefits_score),2) as avg_benefit , job_type
from ai_jobs
group by job_type
order by job_type desc;

select * from ai_jobs;

/* What are the trends in job postings over time (based on posting_date)? */

select year(posting_date) as job_posting_year, count(*) as job_count
from ai_jobs
group by job_posting_year
order by job_count desc;



