-- feedback �ݿ�

-- 1.
select  employee_id, last_name, salary, department_id
from    employees
where   salary between 7000 and 12000
and     last_name like 'H%';

-- 1_1 : upper, lower �Լ� ����� �� ����
select  employee_id, last_name, salary, department_id
from    employees
where   salary between 7000 and 12000
and     lower(last_name) like 'h%';


-- 2. (õ���� ���� ��ȣ �߰�)
select  employee_id, last_name,
        to_char(hire_date, 'MM/dd/YYYY DAY'),
        to_char(salary*commission_pct, '$9,999.99') as "perSal"
from    employees
where   commission_pct is not null
order by 4 desc;

-- 3.
select  employee_id, last_name, job_id, salary, department_id
from    employees
where   salary > 5000
and     department_id in (50, 60);

-- 4.
select  e.employee_id, e.last_name, d.department_id,
        d.location_id, l.city,
        case  d.department_id   when 20 then 'Canada'
                                when 80 then 'UK'
                                        else  l.city 
        end as "����"
from    employees e, departments d, locations l
where   e.department_id = d.department_id
and     d.location_id = l.location_id;

-- 4-4. �ʹ� ������ / ���� �ʿ� X / employees ���̺� ����ϱ�
select employee_id, last_name, department_id,
        case department_id  when 20 then 'Canada'
                            when 80 then 'UK'
                                    else 'USA'
        end city
from employees;

-- 5.
select  e.employee_id, e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id(+);

-- 6. ��¥�� ���ڷ� ��ȯ�߰�
select  last_name, hire_date,
        case  when hire_date > to_date('04/12/31') then 'New employee'
                                                    else 'Career employee'
        end category
from    employees
where   employee_id = &employee_id;

-- 7.ġȯ����
select  last_name, salary,
        case    when   salary <= 5000 then salary*1.2
                when   salary <= 10000 then salary*1.15
                when   salary <= 15000 then salary*1.1
                when   salary >= 15001 then salary
                else   salary
        end
        as "�λ�� �޿�"
from    employees
where   department_id = &department_id;

-- 8.
select  d.department_id, d.department_name, l.city
from    departments d, locations l
where   d.location_id = l.location_id;

-- 9.
select  employee_id, last_name, job_id
from    employees
where   department_id = (select  department_id
                         from    departments
                         where   upper(department_name) = 'IT');
                         
-- 10. count(department_id) -> count(*) ������
-- count(*) : null ���� ������ ��ü �� ��ȯ
-- count(�÷���) : null ���� ������ ��ü �� ��ȯ
select  department_id, count(*), trunc(avg(salary))
from    employees
group by department_id;

-- 11.
create table prof(
    profno      number(4),
    name        varchar2(15) not null,
    id          varchar2(15) not null,
    hiredate    date,
    pay         number(4));
    
commit; -- DDL ���� �ڵ�Ŀ�Ե����� ���� Ŀ���� �� �ʿ䰡 ����

desc    prof;

select  *
from    prof;

-- 12. -- ��¥ ������ ��ȯ�Լ� ������
-- (1)
insert into prof
values (1001, 'Mark', 'm1001', to_date ('07/03/01', 'YY/MM/DD'), 800);

insert into prof
values (1003, 'Adam', 'a1003', to_date ('11/03/02', 'YY/MM/DD'), null);

commit;
-- (2)
update  prof
set     pay = 1200
where   profno = 1001;
-- (3)
delete  prof
where   profno = 1003;

select  *
from    prof;

-- 13.
-- (1)
alter table prof
add         constraint prof_no_pk primary key (profno);

desc prof;
-- (2)
alter table prof
add         (gender char(3));
-- (3)
alter table prof
modify      (name varchar2(20));

-- 14.
-- (1)
create view prof_vu (pno, pname, id)
as  select  profno, name, id
    from    prof;

select  *
from    prof_vu;
--(2)
create or replace view prof_vu (pno, pname, id, phiredate)
as  select  profno, name, id, hiredate
    from    prof;
    
-- 15.
--(1)
drop table prof; -- �Ϲ� ����
drop table prof purge; -- ���� ����
-- ��ųʸ� ����
select  *
from    user_objects;

select  object_name, original_name, type
from    user_recyclebin;

