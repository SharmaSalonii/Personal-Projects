create database project_hr;
use  project_hr;
select * from hr_data;

alter table hr_data
drop EmployeeCount;

#Total number of employees:
SELECT COUNT(DISTINCT EmployeeNumber) AS total_employees
FROM hr_data;

#Distribution of employees by department:
SELECT Department, COUNT(DISTINCT EmployeeNumber) AS employee_count
FROM hr_data
GROUP BY Department;

#Gender distribution across departments and job roles:
SELECT Department, JobRole, Gender, COUNT(DISTINCT EmployeeNumber) AS employee_count
FROM hr_data
GROUP BY Department, JobRole, Gender;

#Distribution of education level and job levels across the organization:
SELECT Education, JobLevel, COUNT(DISTINCT EmployeeNumber) AS employee_count
FROM hr_data
GROUP BY Education, JobLevel;

#Overall attrition rate:
SELECT (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
FROM hr_data;

#Departments with the highest attrition rates:
SELECT Department, (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
FROM hr_data
GROUP BY Department
ORDER BY attrition_rate DESC;

#Gender-wise and age-wise attrition rate:
SELECT Gender, age, (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
FROM hr_data
GROUP BY Gender, age;

#Job roles or levels more prone to attrition:
SELECT 
    JobRole,
    JobLevel,
    (SUM(CASE
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END) / COUNT(*)) * 100 AS attrition_rate
FROM
    hr_data
GROUP BY JobRole , JobLevel
ORDER BY attrition_rate DESC;

#Average tenure of employees who left vs. those who stayed:
SELECT Attrition, AVG(YearsAtCompany) AS average_tenure
FROM hr_data
GROUP BY Attrition;

#Correlation between monthly income or salary hike and attrition:
SELECT Attrition, AVG(MonthlyIncome) AS average_monthly_income, AVG(PercentSalaryHike) AS average_salary_hike
FROM hr_data
GROUP BY Attrition;

#Distribution of performance ratings
SELECT PerformanceRating, COUNT(DISTINCT EmployeeNumber) AS employee_count
FROM hr_data
GROUP BY PerformanceRating;

#Relationship between performance rating and attrition
SELECT PerformanceRating, (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
FROM hr_data
GROUP BY PerformanceRating;

#Frequency of promotions:
SELECT AVG(YearsSinceLastPromotion) AS average_years_since_last_promotion
FROM hr_data;

#Retention and promotion of high performers:
SELECT PerformanceRating, AVG(YearsSinceLastPromotion) AS average_years_since_last_promotion, (SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS retention_rate
FROM hr_data
GROUP BY PerformanceRating;

#Correlation of promotions with job satisfaction or years at company:
SELECT AVG(YearsSinceLastPromotion) AS average_years_since_last_promotion, AVG(JobSatisfaction) AS average_job_satisfaction, AVG(YearsAtCompany) AS average_years_at_company
FROM hr_data;

#Relation between income level and employee attrition:
SELECT MonthlyIncome, (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
FROM hr_data
GROUP BY MonthlyIncome
ORDER BY MonthlyIncome;

#Retention of employees with higher stock options or bonuses:
SELECT StockOptionLevel, (SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS retention_rate
FROM hr_data
GROUP BY StockOptionLevel;

#Average income variation by department, gender, and education level
SELECT Department, Gender, Education, AVG(MonthlyIncome) AS average_monthly_income
FROM hr_data
GROUP BY Department, Gender, Education;