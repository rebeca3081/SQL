-- DDL
-- 사용자 소유 테이블 확인
select  table_name
from    user_tables;
-- 사용자 소유 객체 유형 확인
select  distinct object_type
from    user_objects;
-- 사용자 소유 카탈로그(테이블, 뷰, 동의어, 시퀀스 정의)
select  *
from    user_catalog;

create  table hire_dates(
        id          number(8),
        hire_date   date default sysdate);
        

        
select  *
from    hire_dates;

insert into hire_dates (id)
values (35);

insert into hire_dates
values (45, null);

-- CREATE TABLE
create table dept(
        deptne  number(2), --deptno로 수정해야함
        dname   varchar2(14),
        loc     varchar2(13),
        create_date date default sysdate);
        
desc    dept;

-- 테이블 확인
select  table_name
from    user_tables;

--서브쿼리
create table dept80
as
    select  employee_id, last_name,
            salary * 12 ANNSAL,
            hire_date
    from    employees
    where   department_id = 80;
    
select  *
from    dept80;


-- 데이터 정의어 DDL - 객체수정
-- ALTER TABLE
-- ADD : 새 컬럼 추가
alter table dept80
add         (job_id varchar2(9));

select  *
from    dept80;

-- 중요하게 알아둬야할 Tip : 초기 default 나중에 modify
alter table dept80
add         (hdate date default sysdate);

-- MODIFY : 기존 컬럼 수정
alter table dept80
modify      (last_name varchar2(10)); -- 증가 제약 X/ 감소 기존 데이터 길이 까지만 가능

alter table dept80
modify      (job_id number(10));

-- 오류 : 
alter table dept80
modify      (last_name number(15));


-- 열 삭제
--ALTER DROP
alter table dept80
drop        (job_id);

select  *
from    dept80;

-- SET UNUSED : blind 처리
alter table dept80
set   unused (last_name);

-- DROP UNUSED : unused 된 컬럼을 완전 삭제
alter table dept80
drop  unused columns;

-- 기타 DDL
-- DROP (삭제)
-- DROP TABLE
drop table dept80;

-- flashback table 휴지통 기능
select  object_name, original_name, type
from    user_recyclebin;

flashback table dept80 to before drop;

select  *
from    dept80;

-- 완전 삭제 (PURGE)
drop table dept80 purge;


-- 객체 이름 변경 (RENAME)
rename  dept to dept80;

select  *
from    dept;
select  *
from    dept80;

-- 데이터 전부 삭제 (TRUNCATE)
truncate table dept80;
