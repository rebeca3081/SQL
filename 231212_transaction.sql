commit;

update  employees
set     salary = 99999
where   employee_id = 176;

select  *
from    employees
where   employee_id = 176;

rollback;

commit;

truncate table aa; -- DDL은 하나가 트랜젝션임(오류여부와 상관x)


---computer 2(다른 사용자)
commit;

select  *
from    employees
where   employee_id = 176;

update  employees
set     salary = 77777
where   employee_id = 176;

commit;