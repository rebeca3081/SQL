-- DDL
-- ����� ���� ���̺� Ȯ��
select  table_name
from    user_tables;
-- ����� ���� ��ü ���� Ȯ��
select  distinct object_type
from    user_objects;
-- ����� ���� īŻ�α�(���̺�, ��, ���Ǿ�, ������ ����)
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
        deptne  number(2), --deptno�� �����ؾ���
        dname   varchar2(14),
        loc     varchar2(13),
        create_date date default sysdate);
        
desc    dept;

-- ���̺� Ȯ��
select  table_name
from    user_tables;

--��������
create table dept80
as
    select  employee_id, last_name,
            salary * 12 ANNSAL,
            hire_date
    from    employees
    where   department_id = 80;
    
select  *
from    dept80;


-- ������ ���Ǿ� DDL - ��ü����
-- ALTER TABLE
-- ADD : �� �÷� �߰�
alter table dept80
add         (job_id varchar2(9));

select  *
from    dept80;

-- �߿��ϰ� �˾Ƶ־��� Tip : �ʱ� default ���߿� modify
alter table dept80
add         (hdate date default sysdate);

-- MODIFY : ���� �÷� ����
alter table dept80
modify      (last_name varchar2(10)); -- ���� ���� X/ ���� ���� ������ ���� ������ ����

alter table dept80
modify      (job_id number(10));

-- ���� : 
alter table dept80
modify      (last_name number(15));


-- �� ����
--ALTER DROP
alter table dept80
drop        (job_id);

select  *
from    dept80;

-- SET UNUSED : blind ó��
alter table dept80
set   unused (last_name);

-- DROP UNUSED : unused �� �÷��� ���� ����
alter table dept80
drop  unused columns;

-- ��Ÿ DDL
-- DROP (����)
-- DROP TABLE
drop table dept80;

-- flashback table ������ ���
select  object_name, original_name, type
from    user_recyclebin;

flashback table dept80 to before drop;

select  *
from    dept80;

-- ���� ���� (PURGE)
drop table dept80 purge;


-- ��ü �̸� ���� (RENAME)
rename  dept to dept80;

select  *
from    dept;
select  *
from    dept80;

-- ������ ���� ���� (TRUNCATE)
truncate table dept80;
