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

select location_id, department_id --������ ������� ��µ�
from departments;

select department_id, department_id
from departments;

select last_name, salary, salary + 300 --����� ��밡��
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

select last_name, 12 * salary * NVL(commission_pct, 1) --�߿�
from employees;

select last_name as name, commission_pct comm
from employees;

select last_name as "Name", commission_pct "Annual Salary" --"" : ��ҹ��� �����
from employees;

select last_name as �̸�, commission_pct ���ʽ� --�ѱ۵� ����
from employees;

select last_name || job_id as "Employees" --����
from employees;

select  last_name || ' is a ' || job_id --����
        as "Employees Details"
from    employees;

select  department_id
from    employees;

select  distinct department_id
from    employees;

select  distinct department_id, job_id
from    employees;

-- ����Ǯ��
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

-- where��
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

-- ����
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
where   first_name like 'S%'; -- 0���̻��� ���ڿ� ��ġ

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
where   job_id like '%SA_%'; --SA�� ã��

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

-- �� ������ and
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

-- �켱����
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


-- ����Ǯ�� part 2
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
where hire_date like '14%';
