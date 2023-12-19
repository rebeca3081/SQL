-- ȸ�� ���̺�
create table members(
    member_no	    varchar2(6) 	primary key,
    member_name	    varchar2(10)	not null,
    member_phone	varchar2(10),
    join_date		date 		    default sysdate,
    grade		    varchar2(50)	default '�ű�ȸ��',
    approval		varchar2(20)	default '�̽���'
);

-- default '�ű�ȸ��' -> default '��ȸ��'���� ������
alter table members
modify grade varchar2(50) default '��ȸ��';

-- ������ �Է�
insert into members 
values ('Z001', '��ȿ��', '010-1111' ,'22/06/01', 'ȸ��', '����');

insert into members 
values ('Z002', '�迵��', '010-0202' ,'22/07/07', '��ȸ��', '����');

insert into members 
values ('Z003', '�弼��', '010-0303' ,'22/08/25', '��ȸ��', '����');

insert into members 
values ('Z004', '������', '010-0404' ,'23/10/05', '��ȸ��', '����');

insert into members 
values ('Z005', '��浿', '010-0505' ,'23/10/10', '��ȸ��', '����');

insert into members (member_no, member_name, member_phone)
values ('Z015', '�ڼ���', '010-1515');
insert into members (member_no, member_name, member_phone)
values ('Z016', '�̵���', '010-1616');


-- ��ȸ
select * from members;
select * from members order by 1;

-- ����
-- <���ԱⰣ���� ���� 2������ ���� ��� ��ȸ�ؼ� ����>
update  members
set     grade = '��ȸ��'
where   trunc(months_between(sysdate, join_date)) >= 2
and     grade = '��ȸ��';


-- <ȸ����ȣ���� ��ȸ -> ȸ����ȭ��ȣ ����>
update  members
set     member_phone = '010-1234'
where   member_no = 'Z002';

-- <ȸ����ȣ���� ��ȸ -> ���ο��� ����>
update  members
set     approval = '����'
where   member_no = 'Z015';

-- ����
delete  from  members
where   member_no = 'Z004';

alter table members
modify member_name varchar2(20);


----------------------------------------------------------
-- ������ ���̺�
create table boards(
    board_no	    number(5)	    primary key,  
    board_content	varchar2(1000),
    board_wirter	varchar2(15)	default '��ȿ��',
    board_date	    date 		    default sysdate
);

-- ������ �Է�
insert into boards 
values (001, 'ȸ�񳳺��ϼ���~~', '��ȿ��' ,'22/07/10');
insert into boards 
values (002, '������ ���ƺ��������� �������ϴ�.', '��ȿ��' ,'22/07/15');
insert into boards (board_no, board_content)
values (003, '������ �ð� �����մϴ� 23��-> 27��');

-- ��ȸ
select * from boards order by 1;
select  lpad(board_no, 3 ,'0') as no,
        board_content,
        board_wirter,
        board_date
from    boards
order by 1;

select  * 
from    boards 
where   board_no = 2;

-- ����
-- <�۹�ȣ�� ��ȸ -> �� ����>
update  boards
set     board_content = '����'
where   board_no = '2';

-- ����
delete  from boards
where   board_no = '1';


commit;
------------------------------------------------------------
-- �������� ���̺�
create table scores(
    game_no         varchar2(10)    primary key,
    score_no	    varchar2(6),
    score_1g		number(3),
    score_2g		number(3),
    score_3g		number(3),
    bowling_date	date,
    
    foreign key (score_no)
    references members (member_no)
);

-- ������ �Է�
insert into scores 
values ('22-1001-02', 'Z002', 150, 200, 250, '22/10/10');
insert into scores 
values ('22-1002-02', 'Z002', 220, 236, 190, '22/10/24');
insert into scores 
values ('22-1101-02', 'Z002', 180, 190, 240, '22/11/14');
insert into scores 
values ('22-1102-02', 'Z002', 192, 206, 258, '22/11/28');
insert into scores (game_no, score_1g, score_2g, score_3g, bowling_date)
values ('22-1201-02', 110, 106, 180, '22/12/05');

insert into scores 
values ('22-1001-03', 'Z003', 108, 160, 200, '22/10/10');


-- ��ȸ
select * from scores;

select  s.*
from    users u, members m, scores s
where   u.user_no = m.member_no
and     m.member_no = s.score_no
and     u.user_id ='kim'
and     u.user_pw = 222;

-- �������� �߰�
select  game_no,
        score_1g, score_2g, score_3g,
        round((score_1g + score_2g + score_3g)/3) as AVG,
        bowling_date
from    scores
where   extract(month from bowling_date) = '10'
and     score_no = 'Z002';

-- ����
update  scores
set     score_1g = 105, score_2g = 120, score_3g = 140
where   game_no = '22-1001';

-- ����
delete  from scores
where   score_no = 'Z002';

commit;
---------------------------------------------------------------
-- ��� ���̺�
create table comments(
    board_no	    number(5),
    comment_no	    number(10)	primary key,
    comment_content	varchar2(500),
    comment_writer	varchar2(10),
    wirter_date	    date 		default sysdate,
    
    foreign key (board_no)
    references boards (board_no)
    on delete cascade
);

alter table comments
drop constraint SYS_C007043;

alter table comments
add foreign key (board_no)
references boards (board_no)
on delete cascade;



-- ������ �Է�
insert into comments 
values (001, 002, '�ݹ泾�Կ�!', '�迵��', '22/07/15');
insert into comments 
values (001, 005, '�� �̹� �½��ϴ�~', '�弼��', '22/07/16');
insert into comments 
values (002, 001, '�� ���� ����;��~', '�迵��', '22/07/15');
insert into comments 
values (003, 003, '�˰ڽ��ϴ�!', '�弼��', '23/12/19');

-- ��ȸ
select * 
from comments
where board_no = '1';

select * 
from comments;

select * 
from comments
where board_no = '1';

select * 
from comments
where comment_writer = '�弼��';

select  lpad(board_no, 3 ,'0') as Borad_no,
        lpad(comment_no, 3 ,'0') as no,
        comment_content,
        comment_writer,
        wirter_date
from    comments
order by 1;

-- ����
update  comments
set     comment_content = 'OK'
where   comment_no = '7';

-- ����
delete from comments
where comment_no = '7';

commit;


-----------------------------------
-- ����� ���̺�
create table users(
user_id		varchar2(20),
user_pw		number(20),
user_no		varchar2(6),
rights		varchar2(10),

foreign key (user_no)
references members (member_no)
on delete cascade
);

-- �Է�
insert into users
values ('jang', 111, 'Z001', 'president');

insert into users
values ('kim', 222, 'Z002', 'member');

insert into users
values ('eun', 333, 'Z003', 'member');

insert into users
values ('lee', 16, 'Z016', 'member');

-- ��ȸ
select  *
from    users;
select  *
from    members;

select   m.*, u.*
from    users u, members m 
where   u.user_no = m.member_no 
and     u.user_id ='lee'
and     u.user_pw = 16;

-- id, pw��ȸ
select  user_id, user_pw
from    users
where   user_id = 'kim'
and     user_pw = 222
and     rights = 'president';

-- ȸ�� ��ȣ�� ȸ���̸� ��ȸ�ϱ�
select  m.member_name as name
from    users u, members m
where   u.user_no = m.member_no
and     u.user_id = 'jang';
