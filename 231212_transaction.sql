commit;

update  employees
set     salary = 99999
where   employee_id = 176;

select  *
from    employees
where   employee_id = 176;

rollback;

commit;

truncate table aa; -- DDL�� �ϳ��� Ʈ��������(�������ο� ���x)


---computer 2(�ٸ� �����)
commit;

select  *
from    employees
where   employee_id = 176;

update  employees
set     salary = 77777
where   employee_id = 176;

commit;