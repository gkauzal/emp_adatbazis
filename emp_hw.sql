use employees;

-- 1. feladat
select case
  when gender = 'M' then 'Male'
  else 'Female'
end
as `Gender`, dept_name as `Department`, avg(salary) as `Avarage salary`from salaries
join employees using(emp_no)
join dept_emp using(emp_no)
join departments using (dept_no)
group by gender, dept_no;

-- 2. feladat
select min(dept_no), max(dept_no) from dept_emp;

-- 3. feladat
select emp_no as `Employee number`, min(dept_no) as `Min dept number`,
case when emp_no <=10020 then 110022  
	 when emp_no between 10021 and 10040 then 110039 end as `Manager`
from dept_emp 
group by emp_no
having emp_no<10040
order by emp_no ASC;

-- 4. feladat
select first_name, last_name, hire_date from employees where hire_date>= "2000-01-01" and hire_date<="2000-12-31" ;

-- 5. feladat
select first_name, last_name, title from titles
join employees using(emp_no)
where title like "engineer"
limit 10;
select first_name, last_name, title from titles
join employees using(emp_no)
where title like "senior engineer"
limit 10;

-- 6. feladat
drop procedure if exists last_dept;
delimiter $$
create procedure last_dept(in p_emp_no integer)
begin select dept_no from dept_emp where emp_no = p_emp_no order by from_date desc limit 1;
end$$
delimiter ;

call last_dept(10010);

-- 7. feladat
select count(emp_no) from salaries where to_date-from_date>365 and salary>100000;

-- 8. feladat
use employees;
drop trigger if exists before_employee_insert;
delimiter $$
create trigger before_employee_insert 
before insert on employees
for each row
begin
	if new.hire_date > curdate() then
		set new.hire_date = date_format(curdate(), '%Y-%m-%d');
	end if;
end$$

delimiter  ;

-- 9. feladat_a

use employees;
drop function if exists f_emp_max_salary;
delimiter $$

create function f_emp_max_salary(p_emp_no integer) returns integer
begin
	declare max_salary integer;
	select max(salaries.salary) into max_salary
	from salaries
    join employees using(emp_no)
	where emp_no = p_emp_no;
	return max_salary;
end$$
delimiter ;

select employees.f_emp_max_salary(11356);

-- 9. feladat_b

use employees;
drop function if exists f_emp_min_salary;
delimiter $$

create function f_emp_min_salary(p_emp_no integer) returns integer
begin
	declare min_salary integer;
	select min(salaries.salary) into min_salary
	from salaries
    join employees using(emp_no)
	where emp_no = p_emp_no;
	return min_salary;
end$$
delimiter ;

select employees.f_emp_min_salary(11356);

-- 10. feladat
use employees;

drop function if exists salary_from_char;
delimiter $$

create function salary_from_char(p_emp_no integer, sel_type char(3)) returns integer
begin
declare sal integer;
	if sel_type like 'min' then
		select employees.f_emp_min_salary(11356) into sal;
	elseif sel_type like 'max' then
		select employees.f_emp_max_salary(11356) into sal; 
	else
		select employees.f_emp_max_salary(11356)-employees.f_emp_min_salary(11356) into sal;
	end if;
return sal;
end$$
delimiter ;

select employees.salary_from_char(11356, 'min');