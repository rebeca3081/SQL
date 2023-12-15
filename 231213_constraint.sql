-- 제약조건
-- NOT NULL : 컬럼레벨에서만 가능
create table emp_test (
empid       number(5),
empname     varchar2(10) not null,
duty        varchar2(9),
sal         number(7, 2),
bonus       number(7, 2),
mgr         number(5),
hire_date   date,
deptid      number(2));

insert into emp_test(empid, empname)
values (10, null);

insert into emp_test(empid, empname)
values (10, 'YD');

select  *
from    emp_test;

-- UNIQUE : 중복 X
create table dept_test(
deptid  number(2),
dname   varchar2(14),
loc     varchar2(13),
unique (dname));

insert into dept_test(deptid, dname)
values (10, null);

insert into dept_test(deptid, dname)
values (20, 'YD');

select  *
from    dept_test;

-- ★★★ PRIMARY KEY = UNIQUE + NOT NULL, 고유식별, 테이블 당 하나
drop table dept_test;

create table dept_test(
deptid  number(2) primary key,
dname   varchar2(14),
loc     varchar2(13),
unique (dname));

insert into dept_test
values (10, 'YD', 'Daegu');

insert into dept_test
values (20, 'YD1', 'Daegu');

-- 오류 : unique constraint
insert into dept_test
values (20, 'YD2', 'Daegu');

-- 오류 : cannot insert NULL into
insert into dept_test
values (null, 'YD3', 'Daegu');

select  *
from    dept_test;

-- FOREIGN KEY : 외래키
drop table dept_test;
drop table emp_test;

create table emp_test (
empid       number(5),
empname     varchar2(10) not null,
duty        varchar2(9),
sal         number(7, 2),
bonus       number(7, 2),
mgr         number(5),
hire_date   date,
deptid      number(2), --컬럼 레벨 : references dept_test (deptid),
foreign key (deptid) references dept_test (deptid) on delete set null); -- 테이블 레벨
-- ON DELETE SET NULL : 부모테이블 삭제 시 자식테이블 종속값에 null로 바뀜
-- ON DELETE CASCADE : 부모테이블 삭제 시 자식테이블 종속행 삭제


insert into emp_test(empid, empname, deptid)
values (100, 'YD1', 10);

insert into emp_test(empid, empname, deptid)
values (200, 'YD2', null);

-- 오류 : integrity constraint - parent key not found
insert into emp_test(empid, empname, deptid)
values (300, 'YD3', 30);

select  *
from    emp_test;

drop table emp_test;

delete  dept_test
where   deptid = 10;

select  *
from    dept_test;

-- CHECK : 나머지 조건으로 제한 하고자 할 때 사용
drop table emp_test;

create table emp_test (
empid       number(5),
empname     varchar2(10) not null,
duty        varchar2(9),
sal         number(7, 2),
bonus       number(7, 2),
mgr         number(5),
hire_date   date,
deptid      number(2) check (deptid between 10 and 99), -- 컬럼레벨
foreign key (deptid) references dept_test (deptid));

select  *
from    emp_test;

-- 제약조건 수정 및 보기
-- ALTER ADD : 테이블 레벨
alter table emp_test
add         primary key(empid); -- 기본키 추가

alter table emp_test
add         foreign key(mgr) references emp_test(empid);
-- ALTER MODIFY : 컬럼 레벨
alter table emp_test
modify (duty not null); -- 데이터 타입 생략가능(Oracle)

-- ALTER DROP : 제약조건 삭제
alter table emp_test
drop  constraint SYS_C007024;

-- 제약조건 이름 확인
desc    user_cons_columns;

select  constraint_name, table_name, column_name
from    user_cons_columns
where   table_name = 'EMP_TEST';

select  constraint_name, column_name
from    user_cons_columns;

-- DISABLE / ENABLE 제약조건 비활성화, 활성화