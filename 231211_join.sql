-- 조인(join) ★★★★★
select  department_id, department_name
from    departments;

select  *
from    departments; -- 27개

-- cartesian product => 오류
select  last_name,  department_name
from    employees, departments;

-- 오라클 조인
-- 동등 조인 Equi Join
select  e.employee_id, e.last_name, e.department_id,
        d.department_id, d.location_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id;

-- 성능이 약간 떨어짐
select  employee_id, last_name, e.department_id,
        d.department_id, location_id, department_name
from    employees e, departments d
where   e.department_id = d.department_id;

-- department_id 구분을 못해서 오류
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
and     d.department_id in (20, 50);  -- 추가 조건 있으면 and로 사용

-- 비동등 조인 Non-equi Join
select * from job_grades;

select  e.last_name, e.salary, j.grade_level
from    employees e, job_grades j
where   e.salary
        between j.lowest_sal and j.highest_sal;

-- Outer join : join되지 않은 값까지 보고싶을 경우 사용
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

-- ANSI 조인(Join)
select  last_name, department_name
from    employees cross join departments;

desc    departments;
desc    locations;
-- natural join : 같은 이름의 컬럼과 같은 데이터 타입일 경우 사용
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
-- 오류 : where절 alias 붙이면 안됌
select  l.city, d.department_name
from    locations l join departments d
                    using (location_id)
where   d.location_id = 1400;

-- on절
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id);
-- 오라클 형식으로 바꿔보기
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id);
            
-- 3개 조인
select  employee_id, city, department_name
from    employees e
            join departments d
                on d.department_id = e.department_id
            join locations l
                on d.location_id = l.location_id;
--  오라클 조인
select  employee_id, city, department_name
from    employees e,departments d, locations l
where   d.department_id = e.department_id
and     d.location_id = l.location_id;

-- left outer join
-- ANSI
select  e.last_name, e.department_id, d.department_name
from    employees e left outer join departments d
            on (e.department_id = d.department_id);
-- 오라클
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id(+);

-- right outer join
-- ANSI
select  e.last_name, e.department_id, d.department_name
from    employees e right outer join departments d
            on (e.department_id = d.department_id);
-- 오라클
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id(+) = d.department_id;

-- right outer join
-- ANSI
select  e.last_name, e.department_id, d.department_name
from    employees e full outer join departments d
            on (e.department_id = d.department_id);
-- 오라클 : full outer join 지원 (X)
select  e.last_name, e.department_id, d.department_name
from    employees e, departments d
where   e.department_id(+) = d.department_id(+);

-- 추가조건
-- and 사용
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id)
and     e.manager_id = 149;
-- where 사용
select  e.employee_id, e.last_name ,e.department_id,
        d.department_id, d.location_id
from    employees e join departments d
            on(e.department_id = d.department_id)
where   e.manager_id = 149;


-- 문제풀기 part6.
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
-- => w 테이블에 있는 manager_id가 부모테이블, m 테이블의 employee_id가 자식테이블
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
order by 2; -- (+)정보가 누락된 쪽(관리자지정X -> m 테이블의 직원아이디가 없음)에 표시
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