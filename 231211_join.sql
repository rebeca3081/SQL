-- ����(join) �ڡڡڡڡ�
select  department_id, department_name
from    departments;

select  *
from    departments; -- 27��

-- cartesian product => ����
select  last_name,  department_name
from    employees, departments;

-- ����Ŭ ����
-- ���� ���� Equi Join
select  e.employee_id, e.last_name, e.department_id,
        d.department_id, d.location_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id;

-- ������ �ణ ������
select  employee_id, last_name, e.department_id,
        d.department_id, location_id, department_name
from    employees e, departments d
where   e.department_id = d.department_id;

-- department_id ������ ���ؼ� ����
select  employee_id, last_name, department_id,
        d.department_id, location_id, department_name
from    employees e, departments d
where   e.department_id = d.department_id;

select d.department_id, d.department_name,
        d.location_id, l.city
from    departments d, locations l
where   d.location_id = l.location_id;

select  d.department_id, d.department_name,
        d.location_id, l.city
from    departments d, locations l
where   d.location_id = l.location_id
and     d.department_id in (20, 50);  -- �߰� ���� ������ and�� ���

-- �񵿵� ���� Non-equi Join
select * from job_grades;

select  e.last_name, e.salary, j.grade_level
from    employees e, job_grades j
where   e.salary
        between j.lowest_sal and j.highest_sal;

-- Outer join : join���� ���� ������ ������� ��� ���
-- Right Outer Join
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id(+) = d.department_id;

-- Left outer Join
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id(+);

-- Self Join
select  employee_id, last_name, manager_id
from    employees;

select  worker.last_name || ' works for '
        || manager.last_name
from    employees worker, employees manager
where   worker.manager_id = manager.employee_id;

-- ANSI ����(Join)
select  last_name, department_name
from    employees cross join departments;

desc    departments;
desc    locations;
-- natural join : ���� �̸��� �÷��� ���� ������ Ÿ���� ��� ���
select  department_id, department_name,
        location_id, city
from    departments natural join locations;

-- join using
select  employee_id, last_name,
        location_id, department_id
from    employees join departments
                    using (department_id);

select  l.city, d.department_name
from    locations l join departments d
                    using (location_id)
where   location_id = 1400;
-- ���� : where�� alias ���̸� �ȉ�
select  l.city, d.department_name
from    locations l join departments d
                    using (location_id)
where   d.location_id = 1400;

-- on��
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id);
-- ����Ŭ �������� �ٲ㺸��
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id);
            
-- 3�� ����
select  employee_id, city, department_name
from    employees e
            join departments d
                on d.department_id = e.department_id
            join locations l
                on d.location_id = l.location_id;
--  ����Ŭ ����
select  employee_id, city, department_name
from    employees e,departments d, locations l
where   d.department_id = e.department_id
and     d.location_id = l.location_id;

-- left outer join
-- ANSI
select  e.last_name, e.department_id, d.department_name
from    employees e left outer join departments d
            on (e.department_id = d.department_id);
-- ����Ŭ
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id(+);

-- right outer join
-- ANSI
select  e.last_name, e.department_id, d.department_name
from    employees e right outer join departments d
            on (e.department_id = d.department_id);
-- ����Ŭ
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id(+) = d.department_id;

-- right outer join
-- ANSI
select  e.last_name, e.department_id, d.department_name
from    employees e full outer join departments d
            on (e.department_id = d.department_id);
-- ����Ŭ : full outer join ���� (X)
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id(+) = d.department_id(+);

-- �߰�����
-- and ���
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id)
and     e.manager_id = 149;
-- where ���
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id)
where   e.manager_id = 149;


-- ����Ǯ�� part6.
-- 1.
desc countries;
-- oracle
select  c.country_id, l.country_id,
        l.city, l.state_province, c.country_name
from    locations l, countries c
where   l.country_id = c.country_id;
-- ANSI
select  c.country_id, l.country_id,
        l.city, l.state_province, c.country_name
from    locations l join countries c
                        on (l.country_id = c.country_id);

-- 2.
-- oracle
select  e.last_name, d.department_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id;
-- ANSI
select  e.last_name, d.department_id, d_department_name
from    employees e join departments d
                        on (e.department_id = d.department_id);

-- 3.
-- oracle
select  last_name, job_id, d.department_id, d.department_name
from    employees e, departments d, locations l
where   d.department_id = e.department_id
and     d.location_id = l.location_id
and     lower(l.city) in ('toronto');
-- ANSI
select  last_name, job_id, d.department_id, d.department_name
from    employees e join departments d
                        on d.department_id = e.department_id
                    join locations l
                        on d.location_id = l.location_id
where   l.city in ('Toronto');

-- 4. slef-join
-- oracle
select  w.last_name as "Employee", 
        w.employee_id as "Emp#",
        m.last_name as "Manager", 
        w.manager_id as "Mgr#"
from    employees w, employees m
where   w.manager_id = m.employee_id; 
-- => w ���̺� �ִ� manager_id�� �θ����̺�, m ���̺��� employee_id�� �ڽ����̺�
-- ANSI
select  w.last_name as "Employee", 
        w.employee_id as "Emp#",
        m.last_name as "Manager", 
        w.manager_id as "Mgr#"
from    employees w join employees m
                        on (w.manager_id = m.employee_id);

-- 5.
-- oracle
select  w.last_name as "Employee", 
        w.employee_id as "Emp#",
        m.last_name as "Manager", 
        w.manager_id as "Mgr#"
from    employees w, employees m
where   w.manager_id = m.employee_id(+)
order by 2; -- (+)������ ������ ��(����������X -> m ���̺��� �������̵� ����)�� ǥ��
-- ANSI
select  w.last_name as "Employee", 
        w.employee_id as "Emp#",
        m.last_name as "Manager", 
        w.manager_id as "Mgr#"
from    employees w left outer join employees m
                        on (w.manager_id = m.employee_id)
order by 2;

-- 6.
-- oracle
select  e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
from    employees e, departments d, job_grades j
where   e.department_id = d.department_id
and     e.salary between j.lowest_sal and j.highest_sal;
-- ANSI
select  e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
from    employees e join departments d
                        on (e.department_id = d.department_id)
                    join job_grades j
                        on (e.salary between j.lowest_sal and j.highest_sal);