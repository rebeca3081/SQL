-- ������ ���۾�(DML)
-- INSERT INTO VALUES
insert into departments(department_id, department_name,
                        manager_id, location_id)
values (370, 'Public Relations' ,100, 1700);

select  *
from    departments;

-- ��� �÷��� �����͸� �Է��� ��� : �÷��� ��������
insert into departments
values (371, 'Public Relations' ,100, 1700);

-- Ư�� �÷����� �����͸� �Է��� ��� : �ݵ�� �÷��� �ʿ�
insert into departments (department_id, department_name)
values (330, 'Purchasing'); -- �Ͻ������� NULL���� ����

-- ����� NULL �� �ֱ�
insert into departments
values (400, 'Finance', null, null);

-- �����Ϳ� �Լ���밡��
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
values (100, 'Finance', '', ''); -- ���ڿ��� ''���� nullǥ��

select  *
from    departments;

-- ġȯ���� & ����ؼ� �Է°� �Է¹ޱ�
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
    where   job_id like '%REP%'; -- ���� ����� ���̺� �����ϱ�
    
insert into copy_emp
    select  *
    from    employees;
    
-- ����1: cannot insert NULL into
insert into departments (department_name)
values ('Yedam'); -- primary key �÷����� �Է°� ������ ������

-- ����2: unique constraint
insert into departments (department_id ,department_name)
values (10, 'Yedam');

insert into departments (department_id ,department_name)
values (120, 'Yedam');

-- ����1: cannot insert NULL into -> NOT NULL ���������� �ɷ�����
insert into departments (department_id)
values (130);

-- ����3: integrity constraint ���Ἲ �������� -> FK�̱� ������ �θ����̺� �ִ� ���� �־����
insert into departments (department_id, department_name, manager_id)
values (130, 'YD', 1);

insert into departments (department_id, department_name, manager_id)
values (130, 'YD', 1);

select  *
from    departments;

-- UPDATE ���� : ������ �ٴ� where�� �߿�!
-- NULL�� ������ = null ���
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

ROLLBACK; -- DML�۾� ���� ���

select  *
from    copy_emp;

-- DELETE : ������ ����
insert into copy_emp
    select  *
    from    employees;
    
select  *
from    copy_emp;

commit;

-- where�� ������ ���̺��� ��� ���� ������ ����!
delete copy_emp; -- DDL �� rollback (X) truncate

rollback;

-- Ư�� row ����
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

-- DDL �� rollback (X) truncate
truncate table copy_emp;

rollback;


-- ����Ǯ�� part 8.
-- 1. �����ϱ�
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

-- ġȯ���� �Ẹ��


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