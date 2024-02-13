-- 6번
CREATE TABLE department (
    deptid      NUMBER(10) PRIMARY KEY,
    deptname    VARCHAR2(10),
    location    VARCHAR2(10),
    tel         VARCHAR2(15)
);

CREATE TABLE employee (
    empid       NUMBER(10) PRIMARY KEY,
    empname     VARCHAR2(10),
    hiredate    DATE,
    addr        VARCHAR2(15),
    tel         VARCHAR2(15),
    deptid      NUMBER(10), --deptid NUMBER(10) REFERENCES department(deptid)
    CONSTRAINT fk_depid_emp FOREIGN KEY(deptid) REFERENCES department(deptid)
);

DESC department;

DESC employee;

-- 7번 (컬럼의 추가ADD, 수정MODIFY, 삭제DROP)
-- 제약조건은 수정 OR 삭제
ALTER   TABLE employee
ADD     birthday DATE;

-- 8번
INSERT INTO department 
            (
            deptid
            , deptname
            , location
            , tel
            )
            VALUES
            (
            1001
            , '총무팀'
            , '본 101호'
            , '053-777-8777'
            );
            
INSERT INTO department 
            (
            deptid
            , deptname
            , location
            , tel
            )
            VALUES
            (
            1002
            , '회계팀'
            , '본 102호'
            , '053-888-9999'
            );
            
INSERT INTO department 
            (
            deptid
            , deptname
            , location
            , tel
            )
            VALUES
            (
            1003
            , '회계팀'
            , '본 103호'
            , '053-222-3333'
            );
            


-- department 조회
SELECT  deptid
        , deptname
        , location
        , tel
FROM    department;

-- employee 조회
SELECT  empid
        , empname
        , hiredate
        , addr
        , tel
        , deptid
        , birthday
FROM    employee;

-- employss 데이터 넣기
INSERT INTO employee 
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            , birthday
            )
            values
            (
            20121945
            , '박민수'
            , TO_DATE('12/03/02', 'YY/MM/DD')
            , '대구'
            , '010-1111-1234'
            , 1001
            , null --널로 넣거나 컬럼에서 빼거나
            );
            
INSERT INTO employee 
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            , birthday
            )
            VALUES
            (
            20101817
            , '박준식'
            , TO_DATE('10/09/01', 'YY/MM/DD')
            , '경산'
            , '010-2222-1234'
            , 1003
            , null
            );
            
INSERT INTO employee 
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            , birthday
            )
            VALUES
            (
            20122245
            , '선아라'
            , TO_DATE('12/03/02', 'YY/MM/DD')
            , '대구'
            , '010-3333-1222'
            , 1002
            , null
            );
            
INSERT INTO employee 
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            , birthday
            )
            VALUES
            (
            20121729
            , '이범수'
            , TO_DATE('11/03/02', 'YY/MM/DD')
            , '서울'
            , '010-3333-4444'
            , 1001
            , null
            );
            
INSERT INTO employee 
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            , birthday
            )
            VALUES
            (
            10121646
            , '이융희'
            , TO_DATE('12/09/01', 'YY/MM/DD')
            , '부산'
            , '010-1234-2222'
            , 1003
            , null
            );
            
-- 9번: 기존에 NULL 값이 없어야 함!
ALTER TABLE employee
MODIFY empname NOT NULL;

DESC employee;

-- 10번
-- 둘 다 가능하다면, 성능상 조인 권장(서브쿼리X)
-- 집합: (INNER) JOIN-교집합/조건에 해당, OUTER JOIN-조건에 미해당
SELECT  e.empname
        , e.hiredate
        , d.deptname
FROM    employee e
        INNER JOIN department d
        ON (e.deptid = d.deptid)
WHERE   d.deptname = '총무팀';

-- 모든 부서의 부서정보 -> OUTER JOIN (LEFT, RIGHT, FULL-합집합)
SELECT  employee_id
        , first_name
        , department_name
FROM    employees e
        RIGHT OUTER JOIN departments d
        ON (e.department_id = d.department_id);

-- 11번
DELETE  FROM employee
WHERE   addr = '대구';

-- 12번 : 서브쿼리
UPDATE  employee
SET     deptid = (SELECT  deptid
                  FROM    department
                  WHERE   deptname = '회계팀')
WHERE   deptid = (SELECT  deptid
                  FROM    department
                  WHERE   deptname = '영업팀');

-- 13번 : 서브쿼리
SELECT  e.empid
        , e.empname
        , e.birthday
        , d.deptname
FROM    employee e
        JOIN department d
        ON (e.deptid = d.deptid)
WHERE   e.hiredate > (SELECT  hiredate
                      FROM    employee
                      WHERE   empid = 20121729); -- 여러값 비교가 필요하면 IN사용

-- 14번 : VIEW(복잡한 쿼리문의 결과를 보여줌), 삭제O, 수정X-덮어쓰기만 가능
-- 권한이 없는 경우 -> SYS에 가서
GRANT CREATE VIEW TO hr;

CREATE OR REPLACE VIEW view_emp --(name, address, departmentname)
AS
    SELECT  e.empname eid
            , e.addr eaddr
            , d.deptname dname
    FROM    employee e
            JOIN department d
            ON (e.deptid = d.deptid)
    WHERE   d.deptname = '총무팀';

SELECT  eid
        , eaddr
        , dname
FROM view_emp;

-- 15번 paging 해보기