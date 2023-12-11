-- 그룹함수
select  avg(salary), max(salary),
        min(salary), sum(salary)
from    employees
where   job_id like '%REP%';

-- 날짜, 문자 : min(),max() 가능
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
where   department_id = 80; -- null 값 제외

select  count(distinct department_id),
        count(department_id)
from    employees;

select  department_id
from    employees;

select  distinct department_id
from    employees;

-- avg 사용시 null 생각하기
select  avg(nvl(commission_pct, 0)),
        avg(commission_pct)
from    employees;


-- GROUP BY 절
select  department_id, avg(salary)
from    employees
group by department_id; -- ★★★

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

-- HAVING 절
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

-- 그룹함수 중첩은 두번까지만 가능
select  max(avg(salary))
from    employees
group by department_id;

-- 오류: 그룹함수 중첩시 일반컬럼 올 수 없음!
select  department_id, max(avg(salary))
from    employees
group by department_id;

-- 문제풀기 part_5
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

-- 7. 중복제거~
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
