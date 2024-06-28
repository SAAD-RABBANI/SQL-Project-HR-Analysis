-- Question 1: Who are the top 10 persons with the highest saleries?
Select emp.id, emp.first_name, emp.last_name, sal.salary
	from employees as emp
		inner join salaries as sal
			on emp.id = sal.employee_id
		order by sal.salary desc
	limit 10 

-- Question 2: How are the employees distributed in the department i.e What is the employee count of each department?
Select dep.name, count(emp.id) as employees_count
	from departments as dep
	inner join employees as emp
		on dep.id = emp.department_id
	group by dep.name
	order by count(emp.id) desc

-- Question 3: What is the average salary by department?
Select dep.name, avg(sal.salary)
	from departments as dep
	inner join employees as emp
		on emp.department_id = dep.id
	inner join salaries as sal
		on sal.employee_id = emp.id
	group by dep.name
	order by avg(sal.salary) desc 

-- Question 4: Show employees with miltiple saleries.
Select emp.id, emp.first_name, emp.last_name, sal.salary
	from employees as emp
	inner join salaries as sal
		on emp.id = sal.employee_id
where emp.id in(
	select employee_id from salaries 
		group by employee_id
		having count(*) > 1
)

-- Question 5: What is the employee count by job title?
Select ti.name, count(emp.id) as employee_by_dep
	from titles as ti
	inner join employees as emp
		on ti.id = emp.title_id
	group by ti.name
	order by count(emp.id) desc

-- Question 6: What is the average salary by job title?
Select t.name, avg(sal.salary)
	from titles as t 
		inner join employees as emp
			on t.id = emp.title_id
		inner join salaries as sal
			on emp.id = sal.employee_id
	group by t.name
	order by avg(sal.salary) desc

-- Question 7: How has the average salary changed over time, and are there any notable trands?
Select extract(year from start_date) as start_year, 
	avg(salary)
from salaries
	group by start_year
	order by Start_year 

















