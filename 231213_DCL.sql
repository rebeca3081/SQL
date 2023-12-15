-- DCL
select  *
from    system_privilege_map;

-- 사용자 계정 생성 -> 관리자 계정에서 함!-------------------------
create user skj -- 계정 이름
identified by test; -- 계정 비번

grant create session
to skj;

-- 권한부여 : GRANT 권한 TO 계정
-- 권한삭제 : revoke 권한 from 계정
revoke create table, create view
from skj;

-- 비밀번호 수정
alter user skj
identified by lion;

create user yedam
identified by  yedam
default tablespace users
temporary tablespace temp;

grant connect, dba --오라클에서 미리 만들어 놓은 '롤'
to    yedam;
--------yedam 계정--------
create table aaa(
    aa number(2));

insert into aaa
values (1);

insert into aaa
values (2);

commit;

grant select
on aaa
to skj;
----------------------------

