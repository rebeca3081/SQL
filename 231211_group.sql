-- �׷��Լ�
select  avg(salary), max(salary),
        min(salary), sum(salary)
from    employees
where   job_id like '%REP%';

-- ��¥, ���� : min(),max() ����
select  min(hire_date), max(hire_date)
from    employees;

select  min(last_name), max(last_name)
from    employees;

-- count
select  count(*)
from    employees;

select  count(*)
from    departments;

select  count(*)
from    employees
where   department_id = 50;

select  count(commission_pct)
from    employees
where   department_id = 80; -- null �� ����

select  count(distinct department_id),
        count(department_id)
from    employees;

select  department_id
from    employees;

select  distinct department_id
from    employees;

-- avg ���� null �����ϱ�
select  avg(nvl(commission_pct, 0)),
        avg(commission_pct)
from    employees;


-- GROUP BY ��
select  department_id, avg(salary)
from    employees
group by department_id; -- �ڡڡ�

select  avg(salary)
from    employees
group by department_id;

select  department_id, job_id, sum(salary), count(salary)
from    employees
group by department_id, job_id
order by job_id;

select  department_id, job_id, sum(salary), count(salary)
from    employees
where   department_id > 40
group by department_id, job_id
order by department_id;

-- HAVING ��
select  department_id, max(salary)
from    employees
group by department_id
having  max(salary) > 10000;

select      job_id, sum(salary) payroll
from        employees
where       job_id not like '%REP%'
group by    job_id
having      sum(salary) > 13000
order by    sum(salary);

-- �׷��Լ� ��ø�� �ι������� ����
select  max(avg(salary))
from    employees
group by department_id;

-- ����: �׷��Լ� ��ø�� �Ϲ��÷� �� �� ����!
select  department_id, max(avg(salary))
from    employees
group by department_id;

-- ����Ǯ�� part_5
-- 4.
select  round(max(salary)) as "Maximum",
        round(min(salary)) as "Minimum",
        round(sum(salary)) as "Sum",
        round(avg(salary)) as "Average"
from    employees;

-- 5.
select  job_id,
        round(max(salary)) as "Maximum",
        round(min(salary)) as "Minimum",
        round(sum(salary)) as "Sum",
        round(avg(salary)) as "Average"
from    employees
group by job_id;

-- 6.
select  job_id,
        count(employee_id)
from    employees
group by job_id;

-- 7. �ߺ�����~
select  count(distinct manager_id) as "Number of Managers"
from    employees;

-- 8.
select  max(salary) - min(salary) as differnce
from    employees;

-- 9.
select      manager_id, min(salary)
from        employees
where       manager_id is not null
group by    manager_id
having      min(salary) >= 6000
order by    min(salary) desc;
