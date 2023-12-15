-- Sequence ������ -> Oracle�� ����
create sequence dept_deptid_seq
                increment by 10
                start with 120
                maxvalue 9999
                nocache
                nocycle;
                
insert into departments(department_id,
            department_name, location_id)
values      (dept_deptid_seq.nextval,
            'Support', 2500);
            
select  *
from    departments;

rollback; -- gap������ �߻���

select  dept_deptid_seq.currval
from    dual;

-- ������ ���� : alter sequence (start ����)
-- ������ ���� : drop

-------------------------------------------
-- Synonyn ���Ǿ�
-- ����
create  synonym d_sum
for     dept_sum_vu;

select  *
from    d_sum;

select  *
from    dept_sum_vu;

-- ���� drop synonym 

