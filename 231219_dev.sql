-- 회원 테이블
create table members(
    member_no	    varchar2(6) 	primary key,
    member_name	    varchar2(10)	not null,
    member_phone	varchar2(10),
    join_date		date 		    default sysdate,
    grade		    varchar2(50)	default '신규회원',
    approval		varchar2(20)	default '미승인'
);

-- default '신규회원' -> default '준회원'으로 변경함
alter table members
modify grade varchar2(50) default '준회원';

-- 데이터 입력
insert into members 
values ('Z001', '장효은', '010-1111' ,'22/06/01', '회장', '승인');

insert into members 
values ('Z002', '김영민', '010-0202' ,'22/07/07', '정회원', '승인');

insert into members 
values ('Z003', '장세은', '010-0303' ,'22/08/25', '정회원', '승인');

insert into members 
values ('Z004', '강서아', '010-0404' ,'23/10/05', '준회원', '승인');

insert into members 
values ('Z005', '고길동', '010-0505' ,'23/10/10', '준회원', '승인');

insert into members (member_no, member_name, member_phone)
values ('Z015', '박세리', '010-1515');
insert into members (member_no, member_name, member_phone)
values ('Z016', '이도현', '010-1616');


-- 조회
select * from members;
select * from members order by 1;

-- 수정
-- <가입기간으로 부터 2개월이 지난 사람 조회해서 변경>
update  members
set     grade = '정회원'
where   trunc(months_between(sysdate, join_date)) >= 2
and     grade = '준회원';


-- <회원번호으로 조회 -> 회원전화번호 수정>
update  members
set     member_phone = '010-1234'
where   member_no = 'Z002';

-- <회원번호으로 조회 -> 승인여부 수정>
update  members
set     approval = '승인'
where   member_no = 'Z015';

-- 삭제
delete  from  members
where   member_no = 'Z004';

alter table members
modify member_name varchar2(20);


----------------------------------------------------------
-- 공지글 테이블
create table boards(
    board_no	    number(5)	    primary key,  
    board_content	varchar2(1000),
    board_wirter	varchar2(15)	default '장효은',
    board_date	    date 		    default sysdate
);

-- 데이터 입력
insert into boards 
values (001, '회비납부하세요~~', '장효은' ,'22/07/10');
insert into boards 
values (002, '오늘은 동아볼링장으로 번개갑니다.', '장효은' ,'22/07/15');
insert into boards (board_no, board_content)
values (003, '정기전 시간 변경합니다 23일-> 27일');

-- 조회
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

-- 수정
-- <글번호로 조회 -> 글 삭제>
update  boards
set     board_content = '수정'
where   board_no = '2';

-- 삭제
delete  from boards
where   board_no = '1';


commit;
------------------------------------------------------------
-- 볼링점수 테이블
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

-- 데이터 입력
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


-- 조회
select * from scores;

select  s.*
from    users u, members m, scores s
where   u.user_no = m.member_no
and     m.member_no = s.score_no
and     u.user_id ='kim'
and     u.user_pw = 222;

-- 에버리지 추가
select  game_no,
        score_1g, score_2g, score_3g,
        round((score_1g + score_2g + score_3g)/3) as AVG,
        bowling_date
from    scores
where   extract(month from bowling_date) = '10'
and     score_no = 'Z002';

-- 수정
update  scores
set     score_1g = 105, score_2g = 120, score_3g = 140
where   game_no = '22-1001';

-- 삭제
delete  from scores
where   score_no = 'Z002';

commit;
---------------------------------------------------------------
-- 댓글 테이블
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



-- 데이터 입력
insert into comments 
values (001, 002, '금방낼게요!', '김영민', '22/07/15');
insert into comments 
values (001, 005, '저 이미 냈습니다~', '장세은', '22/07/16');
insert into comments 
values (002, 001, '저 같이 가고싶어요~', '김영민', '22/07/15');
insert into comments 
values (003, 003, '알겠습니다!', '장세은', '23/12/19');

-- 조회
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
where comment_writer = '장세은';

select  lpad(board_no, 3 ,'0') as Borad_no,
        lpad(comment_no, 3 ,'0') as no,
        comment_content,
        comment_writer,
        wirter_date
from    comments
order by 1;

-- 수정
update  comments
set     comment_content = 'OK'
where   comment_no = '7';

-- 삭제
delete from comments
where comment_no = '7';

commit;


-----------------------------------
-- 사용자 테이블
create table users(
user_id		varchar2(20),
user_pw		number(20),
user_no		varchar2(6),
rights		varchar2(10),

foreign key (user_no)
references members (member_no)
on delete cascade
);

-- 입력
insert into users
values ('jang', 111, 'Z001', 'president');

insert into users
values ('kim', 222, 'Z002', 'member');

insert into users
values ('eun', 333, 'Z003', 'member');

insert into users
values ('lee', 16, 'Z016', 'member');

-- 조회
select  *
from    users;
select  *
from    members;

select   m.*, u.*
from    users u, members m 
where   u.user_no = m.member_no 
and     u.user_id ='lee'
and     u.user_pw = 16;

-- id, pw조회
select  user_id, user_pw
from    users
where   user_id = 'kim'
and     user_pw = 222
and     rights = 'president';

-- 회원 번호로 회원이름 조회하기
select  m.member_name as name
from    users u, members m
where   u.user_no = m.member_no
and     u.user_id = 'jang';
