-- ��������
-- NOT NULL : �÷����������� ����
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

-- UNIQUE : �ߺ� X
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

-- �ڡڡ� PRIMARY KEY = UNIQUE + NOT NULL, �����ĺ�, ���̺� �� �ϳ�
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

-- ���� : unique constraint
insert into dept_test
values (20, 'YD2', 'Daegu');

-- ���� : cannot insert NULL into
insert into dept_test
values (null, 'YD3', 'Daegu');

select  *
from    dept_test;

-- FOREIGN KEY : �ܷ�Ű
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
deptid      number(2), --�÷� ���� : references dept_test (deptid),
foreign key (deptid) references dept_test (deptid) on delete set null); -- ���̺� ����
-- ON DELETE SET NULL : �θ����̺� ���� �� �ڽ����̺� ���Ӱ��� null�� �ٲ�
-- ON DELETE CASCADE : �θ����̺� ���� �� �ڽ����̺� ������ ����


insert into emp_test(empid, empname, deptid)
values (100, 'YD1', 10);

insert into emp_test(empid, empname, deptid)
values (200, 'YD2', null);

-- ���� : integrity constraint - parent key not found
insert into emp_test(empid, empname, deptid)
values (300, 'YD3', 30);

select  *
from    emp_test;

drop table emp_test;

delete  dept_test
where   deptid = 10;

select  *
from    dept_test;

-- CHECK : ������ �������� ���� �ϰ��� �� �� ���
drop table emp_test;

create table emp_test (
empid       number(5),
empname     varchar2(10) not null,
duty        varchar2(9),
sal         number(7, 2),
bonus       number(7, 2),
mgr         number(5),
hire_date   date,
deptid      number(2) check (deptid between 10 and 99), -- �÷�����
foreign key (deptid) references dept_test (deptid));

select  *
from    emp_test;

-- �������� ���� �� ����
-- ALTER ADD : ���̺� ����
alter table emp_test
add         primary key(empid); -- �⺻Ű �߰�

alter table emp_test
add         foreign key(mgr) references emp_test(empid);
-- ALTER MODIFY : �÷� ����
alter table emp_test
modify (duty not null); -- ������ Ÿ�� ��������(Oracle)

-- ALTER DROP : �������� ����
alter table emp_test
drop  constraint SYS_C007024;

-- �������� �̸� Ȯ��
desc    user_cons_columns;

select  constraint_name, table_name, column_name
from    user_cons_columns
where   table_name = 'EMP_TEST';

select  constraint_name, column_name
from    user_cons_columns;

-- DISABLE / ENABLE �������� ��Ȱ��ȭ, Ȱ��ȭ