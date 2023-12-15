-- ºä(view)
-- ºä »ý¼º : CREATE VIEW
create view empvu80
    as  select  employee_id, last_name, salary
        from    employees
        where   department_id = 80;
    
select  *
from    empvu80;

create view salvu50
as  select  employee_id ID_NUMBER, last_name NAME,
            salary * 12 ANN_SALARY
    from    employees
    where   department_id = 50;
    
select  *
from    salvu50;

create or replace view empvu80
    (id_number, name, sal, department_id)
as  select  employee_id, first_name || ' '
            || last_name, salary, department_id
    from    employees
    where   department_id = 80;
    
select  *
from    empvu80;

create or replace view dept_sum_vu
    (name, minsal, maxsal, avgsal)
as  select  d.department_name, min(e.salary),
            max(e.salary), avg(e.salary)
    from    employees e join departments d
                        on   (e.department_id = d.department_id)
    group by d.department_name;
    
select  *
from    dept_sum_vu;

select  rownum, employee_id
from    employees;

commit;

select  *
from    empvu80;

delete  empvu80
where   id_number = 176;

select  *
from    employees;

select  *
from    dept_sum_vu;

-- ¿À·ù : data manipulation operation not legal on this view
delete  dept_sum_vu
where   name = 'IT';

create view test_vu
as
    select  department_name
    from    departments;
    
select  *
from    test_vu;

-- ¿À·ù : cannot insert NULL into
insert into test_vu
values ('YD');