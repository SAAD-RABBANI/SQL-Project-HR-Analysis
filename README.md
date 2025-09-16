# SQL Project HR Analysis
## Introduction
This project involves analyzing HR data to uncover insights about employee distribution, salaries, job titles, and trends over time. Using PostgreSQL, I executed several SQL queries to answer key questions regarding the HR dataset.

## Background
The goal of this project is to leverage SQL queries to gain a better understanding of various HR metrics. By analyzing employee data, salary distributions, department compositions, and trends over time, this project provides actionable insights for HR management.

## SQL Queries Addressed
### 1. Top 10 Employees with the Highest Salaries
To find the top earners within the company, I queried the data to list the top 10 employees based on their salaries.
```sql
SELECT
    emp.id,
    emp.first_name,
    emp.last_name,
    sal.salary
FROM
    employees AS emp
INNER JOIN salaries AS sal ON emp.id = sal.employee_id
ORDER BY
    sal.salary DESC
LIMIT 10;
```
| ID   | First Name   | Last Name  | Salary (Rs) |
|------|--------------|------------|-------------|
| 1406 | John         | Miller     | 99985       |
| 799  | Jane         | Lee        | 99968       |
| 1661 | John         | Brown      | 99922       |
| 1230 | Christopher  | Lee        | 99915       |
| 95   | Sophia       | Doe        | 99907       |
| 482  | Olivia       | Brown      | 99878       |
| 1241 | Daniel       | Johnson    | 99854       |
| 771  | Robert       | Lee        | 99809       |
| 502  | Emily        | Brown      | 99802       |
| 1103 | Michael      | Hall       | 99735       |

### 2. Employee Distribution by Department
To understand how employees are distributed across different departments, I calculated the employee count for each department.
```sql
SELECT
    dep.name,
    COUNT(emp.id) AS employees_count
FROM
    departments AS dep
INNER JOIN employees AS emp ON dep.id = emp.department_id
GROUP BY dep.name
ORDER BY COUNT(emp.id) DESC;
```
| Department                | Count |
|---------------------------|-------|
| Sales                     | 219   |
| Legal                     | 215   |
| Human Resources           | 210   |
| Customer Service          | 206   |
| Finance                   | 203   |
| Research and Development  | 200   |
| Marketing                 | 197   |
| IT                        | 187   |
| Administration            | 184   |
| Operations                | 179   |

### 3. Average Salary by Department
This query calculates the average salary for each department to identify departments with higher average compensation.
```sql
SELECT
    dep.name,
    ROUND(AVG(sal.salary), 0) AS avg_salary
FROM
    departments AS dep
INNER JOIN employees AS emp ON emp.department_id = dep.id
INNER JOIN salaries AS sal ON sal.employee_id = emp.id
GROUP BY dep.name
ORDER BY AVG(sal.salary) DESC;
```
| Department                | Avg Salary (Rs) |
|---------------------------|-----------------|
| Marketing                 | 76494           |
| Research and Development  | 76457           |
| Sales                     | 76171           |
| IT                        | 76090           |
| Customer Service          | 75044           |
| Operations                | 75034           |
| Legal                     | 74841           |
| Finance                   | 74412           |
| Human Resources           | 74342           |
| Administration            | 72407           |

### 4. Employees with Multiple Salaries
To identify employees who have been assigned multiple salaries, I used this query.
```sql
SELECT
    emp.id,
    emp.first_name,
    emp.last_name,
    sal.salary
FROM
    employees AS emp
INNER JOIN salaries AS sal ON emp.id = sal.employee_id
WHERE emp.id IN (
    SELECT employee_id
    FROM salaries
    GROUP BY employee_id
    HAVING COUNT(*) > 1
);
```
| ID  | First Name   | Last Name  | Salary (Rs) |
|-----|--------------|------------|-------------|
| 1   | Samantha     | Miller     | 60000       |
| 1   | Samantha     | Miller     | 54693       |
| 20  | Christopher  | Smith      | 55000       |
| 20  | Christopher  | Smith      | 50699       |
| 54  | Robert       | Smith      | 70000       |
| 54  | Robert       | Smith      | 67251       |

### 5. Employee Count by Job Title
This query provides the count of employees for each job title to understand job distribution within the company.
```sql
SELECT
    ti.name,
    COUNT(emp.id) AS employee_by_dep
FROM
    titles AS ti
INNER JOIN employees AS emp ON ti.id = emp.title_id
GROUP BY ti.name
ORDER BY COUNT(emp.id) DESC;
```
| Job Title          | Emp by Dept |
|--------------------|-------------|
| IT Consultant      | 216         |
| QA Tester          | 209         |
| UI/UX Designer     | 204         |
| Software Engineer  | 203         |
| Project Manager    | 200         |
| Network Engineer   | 200         |
| Business Analyst   | 197         |
| Database Admin     | 196         |
| System Analyst     | 195         |
| Data Analyst       | 180         |

### 6. Average Salary by Job Title
To find out which job titles have the highest average salaries, I calculated the average salary for each job title.
```sql
SELECT t.name, ROUND(AVG(sal.salary), 0) AS avg_salary
FROM titles AS t
INNER JOIN employees AS emp ON t.id = emp.title_id
INNER JOIN salaries AS sal ON emp.id = sal.employee_id
GROUP BY t.name
ORDER BY AVG(sal.salary) DESC;
```
| Job Title          | Avg Salary (Rs) |
|--------------------|-----------------|
| Network Engineer   | 76731           |
| System Analyst     | 76050           |
| Data Analyst       | 75315           |
| UI/UX Designer     | 75157           |
| Database Admin     | 74921           | 
| Software Engineer  | 74848           |
| IT Consultant      | 74772           |
| QA Tester          | 74707           |
| Business Analyst   | 74685           |
| Project Manager    | 74354           |

### 7. Salary Trends Over Time
To analyze how salaries have changed over time, I examined the average salary for each year.
```sql
SELECT
    EXTRACT(YEAR FROM start_date) AS start_year,
    ROUND(AVG(salary), 0) AS avg_salary
FROM
    salaries
GROUP BY start_year
ORDER BY start_year;
```
| Start Year | Avg Salary (Rs) |
|------------|-----------------|
| 2018       | 76224           |
| 2019       | 76387           |
| 2020       | 75804           |
| 2021       | 74341           |
| 2022       | 74334           |
| 2023       | 74601           |

### 8. Identify Departments with Above-Average Salaries (Using CTE)
This query uses a CTE (Common Table Expression) to first calculate the average salary across all departments, then compares each department’s average salary against the overall average. This helps quickly identify which departments are paying above market average.
```sql
WITH overall_avg AS (
    SELECT ROUND(AVG(sal.salary), 0) AS avg_salary
    FROM salaries AS sal
)
SELECT
    dep.name,
    ROUND(AVG(sal.salary), 0) AS dept_avg_salary
FROM
    departments AS dep
INNER JOIN employees AS emp ON emp.department_id = dep.id
INNER JOIN salaries AS sal ON sal.employee_id = emp.id
GROUP BY dep.name
HAVING ROUND(AVG(sal.salary), 0) > (SELECT avg_salary FROM overall_avg)
ORDER BY dept_avg_salary DESC;
```
| Department               | Dept Avg Salary (Rs) |
| ------------------------ | -------------------- |
| Marketing                | 76494                |
| Research and Development | 76457                |
| Sales                    | 76171                |
| IT                       | 76090                |

### 9. Rank Employees by Salary Within Their Department (Using Window Function)
This query uses the RANK() window function to assign a rank to employees based on their salary within each department. This is useful to identify the top performers or highest earners per department.
```sql
SELECT 
    dep.name AS department,
    emp.first_name,
    emp.last_name,
    sal.salary,
    RANK() OVER (PARTITION BY dep.name ORDER BY sal.salary DESC) AS salary_rank
FROM
    employees AS emp
INNER JOIN salaries AS sal ON emp.id = sal.employee_id
INNER JOIN departments AS dep ON emp.department_id = dep.id
ORDER BY dep.name, salary_rank;
```
| Department | First Name | Last Name | Salary (Rs) | Salary Rank |
| ---------- | ---------- | --------- | ----------- | ----------- |
| IT         | John       | Miller    | 99985       | 1           |
| IT         | Emily      | Brown     | 99802       | 2           |
| IT         | Robert     | Lee       | 99809       | 3           |
| Sales      | Jane       | Lee       | 99968       | 1           |
| Sales      | Daniel     | Johnson   | 99854       | 2           |

## Tools Used
- **PostgreSQL:** Utilized for executing the SQL queries and managing the database.
- **SQL:** The primary language for querying the data and extracting insights.
## What I Learned
Through this project, I gained a deeper understanding of HR analytics and how to use SQL for data analysis. I learned to perform complex joins, aggregations, and subqueries to answer specific business questions related to employee data.

## Conclusion
This HR analysis project provided valuable insights into the employee structure and salary trends within an organization. The findings can help HR departments make informed decisions about salary distributions, department management, and workforce planning.















