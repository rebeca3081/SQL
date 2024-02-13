-- 6번
CREATE TABLE department (
    deptid      NUMBER(10),
    deptname    VARCHAR2(10),
    location    VARCHAR2(10),
    tel         VARCHAR2(15),
    CONSTRAINT dept_deptid_pk PRIMARY KEY (deptid)
);

CREATE TABLE employee (
    empid       NUMBER(10) PRIMARY KEY,
    empname     VARCHAR2(10),
    hiredate    DATE,
    addr        VARCHAR2(12),
    tel         VARCHAR2(15),
    deptid      NUMBER(10),
    CONSTRAINT  emp_dept_deptid_fk FOREIGN KEY (deptid) REFERENCES department(deptid)
);

DROP TABLE employee;
DROP TABLE department;

-- 7번
ALTER TABLE employee
ADD birthday DATE;

DESC employee;
DESC department;

-- 8번
-- department table
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
            , '본101호'
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
            , '본102호'
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
            , '영업팀'
            , '본103호'
            , '053-222-3333'
            );
            
-- employee table
INSERT INTO employee
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            )
            VALUES
            (
            20121945
            , '박민수'
            , TO_DATE('12/03/02', 'YY/MM/DD')
            , '대구'
            , '010-1111-1234'
            , 1001
            );
            
INSERT INTO employee
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            )
            VALUES
            (
            20101917
            , '박준식'
            , TO_DATE('10/09/01', 'YY/MM/DD')
            , '경산'
            , '010-2222-1234'
            , 1003
            );

INSERT INTO employee
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            )
            VALUES
            (
            20122245
            , '선아라'
            , TO_DATE('12/03/02', 'YY/MM/DD')
            , '대구'
            , '010-3333-1222'
            , 1002
            );
            
INSERT INTO employee
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            )
            VALUES
            (
            20121729
            , '이범수'
            , TO_DATE('11/03/02', 'YY/MM/DD')
            , '서울'
            , '010-3333-4444'
            , 1001
            );
            
INSERT INTO employee
            (
            empid
            , empname
            , hiredate
            , addr
            , tel
            , deptid
            )
            VALUES
            (
            20121646
            , '이융희'
            , TO_DATE('12/09/01', 'YY/MM/DD')
            , '부산'
            , '010-1234-2222'
            , 1003
            );
            
-- 9번.
ALTER TABLE employee
MODIFY empname NOT NULL;

-- 10번.
SELECT  e.empname, e.hiredate, d.deptname
FROM    employee e
        INNER JOIN department d
        ON (e.deptid = d.deptid)
WHERE   d.deptname = '총무팀';

-- 11번.
DELETE
FROM    employee
WHERE   addr = '대구';

-- 12번.
UPDATE  employee
SET     deptid = (
                  SELECT deptid
                  FROM   department
                  WHERE  deptname = '회계팀'
                  )
WHERE   deptid = (
                  SELECT deptid
                  FROM   department
                  WHERE  deptname = '영업팀'
                  );
                  
-- 13번.
SELECT  e.empid
        , e.empname
        , e.birthday
        , d.deptname
FROM    employee e
        INNER JOIN department d
        ON (e.deptid = d.deptid)
WHERE   e.hiredate > (
                      SELECT hiredate
                      FROM   employee
                      where  empid = 20121729
                      );

-- 14번.
CREATE OR REPLACE VIEW emp_vu
AS
    SELECT  e.empname ename
            , e.addr eaddr
            , d.deptname dname
    FROM    employee e
            JOIN department d
            ON (e.deptid = d.deptid)
    WHERE   d.deptname = '총무팀';
    
-- view 확인
SELECT  ename
        , eaddr
        , dname
FROM    emp_vu;

-- 15번. paging
SELECT main.*
FROM   (SELECT ROWNUM rnum, sub.*
        FROM   (SELECT  employee_id
                        , first_name
                        , department_id
                FROM     employees
                ORDER BY first_name
                ) sub
        ) main
WHERE rn BETWEEN 1 and 10;