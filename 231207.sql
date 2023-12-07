select *
from tab;

select * from employees;

desc departments;

select *
from departments;

select *
from employees;

select department_id, location_id
from departments;

select location_id, department_id --나열된 순서대로 출력됨
from departments;

select department_id, department_id
from departments;

select last_name, salary, salary + 300 --산술식 사용가능
from employees;

select last_name, salary, 12 * salary + 100
from employees;

select last_name, salary, 12 * (salary + 100)
from employees;

-- null
select last_name, job_id, salary, commission_pct
from employees;

select last_name, 12 * salary * commission_pct
from employees;

select last_name, 12 * salary * NVL(commission_pct, 1) --중요
from employees;

select last_name as name, commission_pct comm
from employees;

select last_name as "Name", commission_pct "Annual Salary" --"" : 대소문자 공백등
from employees;

select last_name as 이름, commission_pct 보너스 --한글도 가능
from employees;

select last_name || job_id as "Employees" --연결
from employees;

select  last_name || ' is a ' || job_id --연결
        as "Employees Details"
from    employees;

select  department_id
from    employees;

select  distinct department_id
from    employees;

select  distinct department_id, job_id
from    employees;

-- 문제풀기
-- 1.
desc    departments;

select  *
from    departments;

-- 2.
desc    employees;

select  employee_id, last_name, job_id,
        hire_date as startdate
from    employees;

-- 3.
select  distinct job_id
from    employees;

-- 4.
desc    employees;

select  employee_id as "Emp #",
        last_name as "Employee",
        job_id as "Job",
        hire_date as "Hire Date"
from    employees;

-- 5.
select  job_id || ', ' || last_name
        as "Employee and Title"
from    employees;

-- where절
select  employee_id, last_name, job_id, department_id
from    employees
where   department_id = 90;

select  last_name, job_id, department_id
from    employees
where   last_name = 'Whalen';

select  last_name
from    employees
where   hire_date = '05/10/10';

select  last_name, salary
from    employees
where   salary <= 3000;

-- 문제풀기 part 1
select  last_name, hire_date
from    employees
where   hire_date <= '04/12/31';

-- between A and B
select  last_name, salary
from    employees
where   salary between 2500 and 3500;

-- in
select  employee_id, last_name, salary, manager_id
from    employees
where   manager_id in (100, 101, 201);

-- like
select  first_name
from    employees
where   first_name like 'S%'; -- 0개이상의 문자와 대치

select  last_name
from    employees
where   last_name like '%s';

select  last_name, hire_date
from    employees
where   hire_date like '05%';

select  last_name
from    employees
where   last_name like '_o%';

select  employee_id, last_name, job_id
from    employees
where   job_id like '%SA_%'; --SA로 찾음

select  employee_id, last_name, job_id
from    employees
where   job_id like '%SA\_%' escape '\'; --escape ' ' 

select  employee_id, last_name, job_id
from    employees
where   job_id like '%_M%';

select  employee_id, last_name, job_id
from    employees
where   job_id like '%\_M%' escape '\';

-- is null
select  *
from    employees
where   commission_pct is null;

-- 논리 연산자 and
select  employee_id, last_name, job_id, salary
from    employees
where   salary >= 10000
and     job_id like '%MAN%';

-- or
select  employee_id, last_name, job_id, salary
from    employees
where   salary >= 10000
or     job_id like '%MAN%';

-- not (in, between, like, is not null)
select  last_name, job_id
from    employees
where   job_id
not in  ('IT_PROG', 'ST_CLERK', 'SA_REP');

-- 우선순위
select  last_name, job_id, salary
from    employees
where   job_id = 'SA_REP'
or      job_id = 'AD_PRES'
and     salary > 15000;

select  last_name, job_id, salary
from    employees
where   (job_id = 'SA_REP'
or      job_id = 'AD_PRES')
and     salary > 15000;


-- 문제풀기 part 2
-- 1.
select  last_name, salary
from    employees
where   salary > 12000;

-- 2.
select  last_name, department_id
from    employees
where   employee_id = 176;

-- 3.
select  last_name, salary
from    employees
where   salary not between 5000 and 12000;

-- 6.
select  last_name as "Employee", salary as "Salary"
from    employees
where   salary not between 5000 and 12000
and     department_id in (20, 50);

-- 7.
select last_name, hire_date
from employees
where hire_date like '14%'; -- 14년도 입사자 없음! 01년도 ~ 08년도까지만 있음...

-- 8.
select last_name, job_id
from employees
where manager_id is null;

-- 10.
select last_name
from employees
where last_name like '__a%';

-- 11.
select last_name
from employees
where last_name like '%a%' -- a가 포함된 값
or last_name like 'A%' -- A로 시작하는 값
or last_name like '%e%'
or last_name like 'E%';

-- 12.
select last_name, job_id, salary
from employees
where job_id in ('SA_REP', 'ST_CLERK')
and salary not in (2500, 3500, 7000);

-- 13.
select last_name, salary, commission_pct
from employees
where commission_pct = 0.2;
