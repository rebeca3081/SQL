-- �������� : ��������
select  last_name, salary
from    employees
where   salary in  (select   max(salary)
                    from    employees
                    group by department_id);
                    
select  max(salary)
from    employees
group by department_id;

-- ���� �� ��������
select last_name, salary
from    employees
where   salary >   (select    salary
                    from    employees
                    where   last_name = 'Abel');
                    
select  employee_id, last_name, job_id
from    employees
where   job_id =  (select   job_id
                    from    employees
                    where   employee_id = 141);

select  employee_id, last_name, job_id
from    employees
where   job_id =  (select   job_id
                    from    employees
                    where   employee_id = 141)
and     employee_id != 141;

select  last_name, job_id, salary
from    employees
where   job_id = (select  job_id
                  from    employees
                  where   last_name = 'Abel')
and     salary > (select  salary
                  from    employees
                  where   last_name = 'Abel');
                    
select  * 
from    employees
where   last_name = 'Taylor';

--------------------20231212-----------------------
-- ���� �� �������� : ���� �� �� ������
select  last_name, job_id, salary
from    employees
where   salary = (select   min(salary)
                  from     employees);
                  
select   department_id, min(salary)
from     employees
group by department_id
having   min(salary) > (select   min(salary)
                        from    employees
                        where   department_id = 50);
                        
-- ���� �� �������� : ���� �� �� ������
-- IN / ANY / ALL / SOME
select  employee_id, last_name, job_id, salary
from    employees
where   salary < any (select salary
                      from  employees
                      where job_id = 'IT_PROG')
and     job_id <> 'IT_PROG'; -- != ���� �ʴ�

select  employee_id, last_name, job_id, salary
from    employees
where   salary < all (select salary
                      from  employees
                      where job_id = 'IT_PROG')
and     job_id <> 'IT_PROG';

-- ���� �� ��������: IN�� ���� �����
-- �ֺ�(Pairwise)
select  employee_id, manager_id, department_id
from    empl_demo
where   (manager_id, department_id) in
                                    (select manager_id, department_id
                                     from    empl_demo
                                     where   first_name = 'John')
and     first_name <> 'John';

-- ��ֺ�(Nonpairwise) : ����� ���� �� ������
select  employee_id, manager_id, department_id
from    empl_demo
where   (manager_id) in     (select  manager_id
                             from    empl_demo
                             where   first_name = 'John')
and    (department_id) in   (select  department_id
                             from    empl_demo
                             where   first_name = 'John')                   
and     first_name <> 'John';


-- ���� Ǯ�� part 7
-- 1.
select  last_name, hire_date
from    employees
where   department_id = (select department_id
                         from   employees
                         where  lower(last_name) = 'zlotkey')
and     lower(last_name) <> 'zlotkey';

-- 2.
select   employee_id, last_name
from     employees
where    salary > (select avg(salary)
                  from   employees)
order by salary;

-- 3.
select  employee_id, last_name
from    employees
where   department_id in (select department_id
                          from   employees
                          where  lower(last_name) like '%u%');

-- 4.
select  last_name, department_id, job_id
from    employees
where   department_id in (select department_id
                          from   departments
                          where  location_id = 1700);
                             
-- 5.
select  last_name, salary
from    employees
where   manager_id = (select employee_id
                      from   employees
                      where  lower(last_name) = 'king');
                      
-- 6.
select  department_id, last_name, salary
from    employees
where   department_id = (select department_id
                         from   departments
                         where  lower(department_name) = 'executive');
                         
-- 7.
select  employee_id, last_name, salary
from    employees
where   department_id in (select department_id
                          from   employees
                          where  lower(last_name) like '%u%')
and     salary >         (select avg(salary)
                          from   employees);