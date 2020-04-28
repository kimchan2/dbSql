-- 실습 join8

SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT a.region_id, b.region_name, a.country_name
FROM countries a, regions b
WHERE a.region_id = b.region_id AND a.region_id = 1;

-- 실습 join9
SELECT a.region_id, b.region_name, a.country_name, c.city
FROM countries a, regions b, locations c
WHERE a.region_id = b.region_id AND a.region_id = 1 AND a.country_id = c.country_id;

-- 실습 join10
SELECT a.region_id, b.region_name, a.country_name, c.city, d. department_name
FROM countries a, regions b, locations c, departments d
WHERE a.region_id = b.region_id AND a.region_id = 1 AND a.country_id = c.country_id AND c.location_id = d.location_id;

-- 실습 join11
SELECT a.region_id, b.region_name, a.country_name, c.city, d. department_name, e.first_name || e.last_name as NAME
FROM countries a, regions b, locations c, departments d, employees e
WHERE a.region_id = b.region_id AND a.region_id = 1
                                AND a.country_id = c.country_id
                                AND c.location_id = d.location_id
                                AND d.department_id = e.department_id;

-- 실습 join12
SELECT a.employee_id, a.first_name || a.last_name as NAME, a.job_id, b.job_title
FROM employees a, jobs b
WHERE a.job_id = b.job_id;

-- 실습 join13
SELECT *
FROM jobs;

SELECT c.MGR_ID, c.employee_id, c.MGR_NAME, c.job_id, jobs.job_title
FROM(SELECT b.manager_id as MGR_ID, a.first_name || a.last_name as MGR_NAME, b.employee_id, b.first_name || b.last_name as NAME, b.job_id
     FROM employees a, employees b
     WHERE a.employee_id = b.manager_id
     ORDER BY MGR_ID ASC, b.employee_id ASC) c, jobs
WHERE jobs.job_id = c.job_id;


SELECT * 
     FROM employees a, employees b
     WHERE a.employee_id = b.manager_id;

     
SELECT b.manager_id as MGR_ID, a.first_name || a.last_name as MGR_NAME, b.employee_id, b.first_name || b.last_name as NAME, b.job_id
FROM employees a, employees b
WHERE a.employee_id = b.manager_id
ORDER BY MGR_ID ASC, b.employee_id;



