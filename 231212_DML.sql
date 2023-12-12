-- 데이터 조작어(DML)
-- INSERT INTO VALUES
insert into departments(department_id, department_name,
                        manager_id, location_id)
values (370, 'Public Relations' ,100, 1700);

select  *
from    departments;

-- 모든 컬럼에 데이터를 입력할 경우 : 컬럼명 생략가능
insert into departments
values (371, 'Public Relations' ,100, 1700);

-- 특정 컬럼에만 데이터를 입력할 경우 : 반드시 컬럼명 필요
insert into departments (department_id, department_name)
values (330, 'Purchasing'); -- 암시적으로 NULL값을 넣음

-- 명시적 NULL 값 넣기
insert into departments
values (400, 'Finance', null, null);

-- 데이터에 함수사용가능
insert into employees
values (113, 'Louis', 'Popp', 'LPOPP', '515.124.4567',
        sysdate, 'AC_ACCOUNT', 6900, null, 205, 110);
        
select  *
from    employees;

insert into employees
values (114, 'Den', 'Raphealy', 'DRAPHEALY', '515.127.4561',
        to_date('FEB 3, 1999', 'MON DD, YYYY'),
        'SA_REP', 11000, 0.2, 100, 60);
        
insert into departments
values (100, 'Finance', '', ''); -- 문자열은 ''으로 null표시

select  *
from    departments;

-- 치환변수 & 사용해서 입력값 입력받기
insert into departments
            (department_id, department_name, location_id)
values (&department_id, '&department_name', &location_id);

-- subquery
select  * 
from    sales_reps;

select  *
from    copy_emp;

insert into sales_reps
    select  employee_id, last_name, salary, commission_pct
    from    employees
    where   job_id like '%REP%'; -- 쿼리 결과를 테이블에 삽입하기
    
insert into copy_emp
    select  *
    from    employees;
    
-- 오류1: cannot insert NULL into
insert into departments (department_name)
values ('Yedam'); -- primary key 컬럼에는 입력값 무조건 들어가야함

-- 오류2: unique constraint
insert into departments (department_id ,department_name)
values (10, 'Yedam');

insert into departments (department_id ,department_name)
values (120, 'Yedam');

-- 오류1: cannot insert NULL into -> NOT NULL 제약조건이 걸려있음
insert into departments (department_id)
values (130);

-- 오류3: integrity constraint 무결성 제약조건 -> FK이기 때문에 부모테이블에 있는 값만 넣어야함
insert into departments (department_id, department_name, manager_id)
values (130, 'YD', 1);

insert into departments (department_id, department_name, manager_id)
values (130, 'YD', 1);

select  *
from    departments;

-- UPDATE 구문 : 조건을 다는 where절 중요!
-- NULL로 수정은 = null 사용
update  employees
set     department_id = 50
where   department_id = 113;

select  *
from    employees;

update  copy_emp
set     department_id = 110;

select  *
from    copy_emp;

update  employees
set     job_id = 'IT_PROG', commission_pct = null
where   employee_id = 114;

ROLLBACK; -- DML작업 전부 취소

select  *
from    copy_emp;

-- DELETE : 데이터 삭제
insert into copy_emp
    select  *
    from    employees;
    
select  *
from    copy_emp;

commit;

-- where절 생략시 테이블의 모든 행이 삭제됨 주의!
delete copy_emp; -- DDL 은 rollback (X) truncate

rollback;

-- 특정 row 삭제
delete from departments
where   department_name = 'Finance';

select  *
from    departments;

delete from departments
where   department_id in (30, 40);

rollback;

select  *
from    copy_emp;

delete  copy_emp;

rollback;

-- DDL 은 rollback (X) truncate
truncate table copy_emp;

rollback;


-- 문제풀이 part 8.
-- 1. 생성하기
CREATE TABLE my_employee
  (id         NUMBER(4) NOT NULL,
   last_name  VARCHAR2(25),
   first_name VARCHAR2(25),
   userid     VARCHAR2(8),
   salary     NUMBER(9,2));
   
select  *
from my_employee;

-- 2.
desc my_employee;

-- 3.
insert into my_employee
values (1, 'Patel', 'Ralph', 'Rpatel', 895);
insert into my_employee
values (1, 'Dancs', 'Betty', 'Bdancs', 860);
insert into my_employee
values (1, 'Biri', 'Ben', 'Bbiri', 1100);

-- 치환변수 써보기


-- 3.
select  *
from    my_employee;

-- 6.
update  my_employee
set     last_name = 'Drexler'
where   user_id = 3;

-- 7.
update  my_employee
set     salary = 1000
where   salary < 900;

-- 8.
delete  from my_employee
where   user_id = 3;
select  *
from    my_employee;

-- 11.
delete  my_employee;
select  *
from    my_employee;