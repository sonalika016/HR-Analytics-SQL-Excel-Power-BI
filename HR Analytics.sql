CREATE TABLE hrdata (
    emp_no BIGINT PRIMARY KEY,
    gender VARCHAR(50) NOT NULL,
    marital_status VARCHAR(50),
    age_band VARCHAR(50),
    age BIGINT,
    department VARCHAR(50),
    education VARCHAR(50),
    education_field VARCHAR(50),
    job_role VARCHAR(50),
    business_travel VARCHAR(50),
    employee_count BIGINT,
    attrition VARCHAR(50),
    attrition_label VARCHAR(50),
    job_satisfaction BIGINT,
    active_employee BIGINT
);

--Key Performance Indicators (KPIs)

----1. Total Employees

SELECT SUM(employee_count) AS total_employees
FROM hrdata;

----2. Attrition Count

SELECT COUNT(*) AS attrition_count
FROM hrdata
WHERE attrition = 'Yes';

----3. Attrition Rate

SELECT ROUND(
    COUNT(*) * 100.0 /
    (SELECT SUM(employee_count) FROM hrdata),
    2
) AS attrition_rate
FROM hrdata
WHERE attrition = 'Yes';

----4. Active Employees

SELECT
    SUM(employee_count) -
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END)
    AS active_employees
FROM hrdata;

----5. Average Employee Age

SELECT ROUND(AVG(age),0) AS avg_age
FROM hrdata;

--Employee Attrition Analysis

----Attrition by Gender

SELECT
    gender,
    COUNT(*) AS attrition_count
FROM hrdata
WHERE attrition='Yes'
GROUP BY gender
ORDER BY attrition_count DESC;

---------Insight : Male employees show higher attrition compared to female employees.

----Department-wise Attrition
 
WITH age_attrition AS (
    SELECT
        age_band,
        COUNT(*) AS attrition_count
    FROM hrdata
    WHERE attrition = 'Yes'
    GROUP BY age_band
)

SELECT
    age_band,
    attrition_count,
    ROUND(attrition_count * 100.0 /SUM(attrition_count) OVER (),2) 
	AS attrition_percentage
FROM age_attrition;

-------Insight : Research & Development and Sales departments contribute the largest share of employee attrition.

----Attrition by Education Field

SELECT
    education_field,
    COUNT(*) AS attrition_count
FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field
ORDER BY attrition_count DESC;

-------Insight : Employees from Life Sciences and Medical backgrounds exhibit higher turnover.

----Attrition by Age Group & Gender

WITH age_attrition AS (
    SELECT
        age_band,
        COUNT(*) AS attrition_count
    FROM hrdata
    WHERE attrition = 'Yes'
    GROUP BY age_band
)

SELECT
    age_band,
    attrition_count,
    ROUND(attrition_count * 100.0 /SUM(attrition_count) OVER (),2) 
	AS attrition_percentage
FROM age_attrition;

--------Insight : Younger employees tend to have a higher attrition rate than senior age groups.

--Workforce Demographics

----Employee Distribution by Age

SELECT
    age,
    COUNT(*) AS employee_count
FROM hrdata
GROUP BY age
ORDER BY age;

----Job Satisfaction Analysis (Pivot Analysis)

CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT *
FROM crosstab(
$$
SELECT
    job_role,
    job_satisfaction,
    COUNT(*)
FROM hrdata
GROUP BY job_role, job_satisfaction
ORDER BY job_role, job_satisfaction
$$
)
AS ct(
    job_role VARCHAR(50),
    rating_1 BIGINT,
    rating_2 BIGINT,
    rating_3 BIGINT,
    rating_4 BIGINT
)
ORDER BY job_role;

-------Insight : Employees with lower satisfaction ratings show greater likelihood of attrition.