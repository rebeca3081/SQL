-- DCL
select  *
from    system_privilege_map;

-- ����� ���� ���� -> ������ �������� ��!-------------------------
create user skj -- ���� �̸�
identified by test; -- ���� ���

grant create session
to skj;

-- ���Ѻο� : GRANT ���� TO ����
-- ���ѻ��� : revoke ���� from ����
revoke create table, create view
from skj;

-- ��й�ȣ ����
alter user skj
identified by lion;

create user yedam
identified by  yedam
default tablespace users
temporary tablespace temp;

grant connect, dba --����Ŭ���� �̸� ����� ���� '��'
to    yedam;
--------yedam ����--------
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

