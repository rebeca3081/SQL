-- Sequence 시퀀스 -> Oracle에 있음
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

rollback; -- gap공백이 발생함

select  dept_deptid_seq.currval
from    dual;

-- 시퀀스 수정 : alter sequence (start 제외)
-- 시퀀스 삭제 : drop

-------------------------------------------
-- Synonyn 동의어
-- 생성
create  synonym d_sum
for     dept_sum_vu;

select  *
from    d_sum;

select  *
from    dept_sum_vu;

-- 삭제 drop synonym 

