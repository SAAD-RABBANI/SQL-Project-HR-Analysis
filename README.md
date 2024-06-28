# SQL Project HR Analysis
## Introduction
This project involves analyzing HR data to uncover insights about employee distribution, salaries, job titles, and trends over time. Using PostgreSQL, I executed several SQL queries to answer key questions regarding the HR dataset.

## Background
The goal of this project is to leverage SQL queries to gain a better understanding of various HR metrics. By analyzing employee data, salary distributions, department compositions, and trends over time, this project provides actionable insights for HR management.

## SQL Queries Addressed
### 1. Top 10 Employees with the Highest Salaries
To find the top earners within the company, I queried the data to list the top 10 employees based on their salaries.
```sql
SELECT emp.id, emp.first_name, emp.last_name, sal.salary
FROM employees AS emp
INNER JOIN salaries AS sal ON emp.id = sal.employee_id
ORDER BY sal.salary DESC
LIMIT 10;
```
### 2. Employee Distribution by Department
To understand how employees are distributed across different departments, I calculated the employee count for each department.
```sql
SELECT dep.name, COUNT(emp.id) AS employees_count
FROM departments AS dep
INNER JOIN employees AS emp ON dep.id = emp.department_id
GROUP BY dep.name
ORDER BY COUNT(emp.id) DESC;
```
### 3. Average Salary by Department
This query calculates the average salary for each department to identify departments with higher average compensation.
```sql
SELECT dep.name, AVG(sal.salary)
FROM departments AS dep
INNER JOIN employees AS emp ON emp.department_id = dep.id
INNER JOIN salaries AS sal ON sal.employee_id = emp.id
GROUP BY dep.name
ORDER BY AVG(sal.salary) DESC;
```
### 4. Employees with Multiple Salaries
To identify employees who have been assigned multiple salaries, I used this query.
```sql
SELECT emp.id, emp.first_name, emp.last_name, sal.salary
FROM employees AS emp
INNER JOIN salaries AS sal ON emp.id = sal.employee_id
WHERE emp.id IN (
    SELECT employee_id
    FROM salaries
    GROUP BY employee_id
    HAVING COUNT(*) > 1
);
```
### 5. Employee Count by Job Title
This query provides the count of employees for each job title to understand job distribution within the company.
```sql
SELECT ti.name, COUNT(emp.id) AS employee_by_dep
FROM titles AS ti
INNER JOIN employees AS emp ON ti.id = emp.title_id
GROUP BY ti.name
ORDER BY COUNT(emp.id) DESC;
```
### 6. Average Salary by Job Title
To find out which job titles have the highest average salaries, I calculated the average salary for each job title.
```sql
SELECT t.name, AVG(sal.salary)
FROM titles AS t
INNER JOIN employees AS emp ON t.id = emp.title_id
INNER JOIN salaries AS sal ON emp.id = sal.employee_id
GROUP BY t.name
ORDER BY AVG(sal.salary) DESC;
```
### 7. Salary Trends Over Time
To analyze how salaries have changed over time, I examined the average salary for each year.
```sql
SELECT EXTRACT(YEAR FROM start_date) AS start_year, AVG(salary)
FROM salaries
GROUP BY start_year
ORDER BY start_year;
```
## Tools Used
- **PostgreSQL:** Utilized for executing the SQL queries and managing the database.
- **SQL:** The primary language used for querying the data and extracting insights.
## What I Learned
Through this project, I gained a deeper understanding of HR analytics and how to use SQL for data analysis. I learned to perform complex joins, aggregations, and subqueries to answer specific business questions related to employee data.

## Conclusion
This HR analysis project provided valuable insights into the employee structure and salary trends within an organization. The findings can help HR departments make informed decisions about salary distributions, department management, and workforce planning.















