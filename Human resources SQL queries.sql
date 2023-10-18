CREATE DATABASE pproject1;

USE pproject1;

SELECT * FROM hr;

#data cleaning portion

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

SELECT birthdate
FROM hr;

UPDATE hr
SET birthdate = CASE
  WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
  ELSE NULL
  END;
  
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT *
FROM hr;

UPDATE hr
SET hire_date = CASE
  WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
  WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
  ELSE NULL
  END;
  
UPDATE hr
SET termdate = date_format(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'), '%Y-%m-%d')
WHERE termdate != '';

SELECT termdate
FROM hr;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

UPDATE hr
SET termdate = 0000-00-00
WHERE termdate = NULL;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

ALTER TABLE hr ADD COLUMN age INT;

SELECT * FROM hr;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr;

-- Questions 

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*) as count
FROM hr
WHERE age >= 18 and termdate is null
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) as count
FROM hr 
WHERE age >= 18 and termdate is null
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
  min(age) as youngest,
  max(age) as oldest
FROM hr
WHERE age >= 18 and termdate is null;

SELECT 
  CASE
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
  END AS age_group, 
   count(*) as count
FROM hr
WHERE age >= 18 and termdate is null
GROUP BY age_group
ORDER BY age_group;

-- 4. How many employees work in headquarters versus remote locations? 
SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18 and termdate is null
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr
WHERE termdate <= CURDATE() AND age >= 18;

-- 6. How does the gender distribution vary across departments?
SELECT department, gender, COUNT(*) as count
FROM hr
WHERE age >= 18 and termdate is null
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18 and termdate is null
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department,
  total_count,
  terminated_count,
  terminated_count/total_count as termination_rate
FROM (
  SELECT department, 
    COUNT(*) AS total_count,
    SUM(CASE WHEN termdate is not null AND termdate <= curdate() THEN 1 ELSE 0 END) as terminated_count
  FROM hr
  WHERE age >= 18 
  GROUP BY department
  ) as subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18 and termdate is null
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT
  year,
  hires,
  terminations,
  hires - terminations AS net_change,
  round((hires - terminations)/hires * 100,2) net_change_percent
FROM (
	SELECT 
		YEAR(hire_date) as year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate is not null and termdate <= curdate() THEN 1 ELSE 0 END) as terminations
	FROM hr
    WHERE age >= 18
    GROUP BY year
    ) as subquery 
ORDER BY year; 

-- 11. What is the tenure distribution for each department?
SELECT department, ROUND(AVG(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() and termdate is not null and age >= 18
GROUP BY department;
