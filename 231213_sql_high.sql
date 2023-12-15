-- 계층적 질의
-- Top-down 방식
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

-- 조금 더 한눈에 보이도록 한 질의
select  level,
        lpad(' ', 4*(level-1))||employee_id employee,
        last_name, manager_id
from    employees
start with manager_id is null
connect by prior employee_id = manager_id;