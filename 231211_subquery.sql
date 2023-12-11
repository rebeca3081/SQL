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
where   job_id =   (select    job_id
                    from    employees
                    where   last_name = 'Abel')
and     salary >    (select    salary
                    from    employees
                    where   last_name = 'Abel');
                    
select  * 
from    employees
where   last_name = 'Taylor';