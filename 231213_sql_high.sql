-- ������ ����
-- Top-down ���
select level, employee_id, last_name, manager_id
from   employees
start with manager_id is null
connect by prior employee_id = manager_id;
-- =connect by manager_id = prior employee_id;

-- Bottom up
select level, employee_id, last_name, manager_id
from   employees
start with manager_id is null
connect by prior manager_id = employee_id;

select level, employee_id, last_name, manager_id
from   employees
start with employee_id = 174
connect by prior manager_id = employee_id;

-- ���� �� �Ѵ��� ���̵��� �� ����
select  level,
        lpad(' ', 4*(level-1))||employee_id employee,
        last_name, manager_id
from    employees
start with manager_id is null
connect by prior employee_id = manager_id;