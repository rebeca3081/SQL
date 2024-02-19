SET SERVEROUTPUT ON;

/* 커서 FOR LOOP */
DECLARE
    CURSOR  emp_cursor IS
    SELECT  employee_id, last_name
    FROM    employees;
    -- WHERE   employee_id = 0; -- 커서에 데이터가 없는 경우 출력이 X
BEGIN
    --  FOR {record} IN {cursor} LOOP
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('NO. ' || emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(', 사원번호 : ' || emp_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', 사원이름 : ' || emp_record.last_name);
    END LOOP; -- CLOSE CURSOR와 같은 의미
    
    -- 실제 데이터 유무를 체크하고자 할때 오류! 예)총 갯수
    -- DBMS_OUTPUT.PUT('Total : ' || emp_cursor%ROWCOUNT);
    
    -- 서브쿼리를 활용한 FOR LOOP => 데이터 확인용 
    FOR dept_info IN ( SELECT *
                       FROM   departments ) LOOP
        DBMS_OUTPUT.PUT('부서번호 : ' || dept_info.department_id);
        DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || dept_info.department_name);                   
    END LOOP;
    
END;
/

/* 문제1.
-- 1)SQL문
SELECT employee_id, last_name, department_name
FROM   employees e
       LEFT OUTER JOIN departments d
       ON e.department_id = d.department_id;
 */

DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, department_name
        FROM   employees e
               LEFT OUTER JOIN departments d
               ON e.department_id = d.department_id;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('사원번호 : ' || emp_record.employee_id);
        DBMS_OUTPUT.PUT(', 이름 : ' || emp_record.last_name);
        DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || emp_record.department_name);
    END LOOP;
END;
/

/* 문제2
1) SQL문
SELECT  last_name, salary, commission_pct
FROM    employees
WHERE   department_id IN (50, 80);

연봉 -> (salary * 12) + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)
*/

SELECT  last_name, salary, commission_pct
FROM    employees
WHERE   department_id IN (50, 80);

DECLARE
    CURSOR emp_deptno_cursor IS
        SELECT  last_name, salary, commission_pct
        FROM    employees
        WHERE   department_id IN (50, 80);
        
    v_annual    NUMBER(10,0);
BEGIN
    FOR v_emps_info IN emp_deptno_cursor LOOP       
        v_annual := ((v_emps_info.salary * 12) + (NVL(v_emps_info.salary, 0) * NVL(v_emps_info.commission_pct, 0) * 12));        
        DBMS_OUTPUT.PUT('사원이름 : ' || v_emps_info.last_name || ', ');
        DBMS_OUTPUT.PUT('급여: ' || v_emps_info.salary || ', ');
        DBMS_OUTPUT.PUT_LINE('연봉: ' || v_annual);
    END LOOP;
END;
/

/* 매개변수 사용 CURSOR */

DECLARE
    CURSOR emp_cursor
        ( p_mgr employees.manager_id%TYPE )IS
            SELECT  *
            FROM    employees
            WHERE   manager_id = p_mgr; -- 미완성
            
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    -- 기본
    OPEN emp_cursor(100); -- OPEN 하면서 비어있는(미완성) 변수에 p_mgr := 100 담음
    
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.last_name);
        
    END LOOP;
    
    CLOSE emp_cursor;
    
    -- 커서 FOR LOOP
    FOR v_emp_info IN emp_cursor(149) LOOP
        DBMS_OUTPUT.PUT('사번 : ' ||v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE('이름 : ' || v_emp_info.last_name);
    END LOOP;
END;
/

/* 문제1. */
CREATE TABLE test01
AS
    SELECT employee_id, first_name, hire_date
    FROM   employees
    WHERE  employee_id = 0;
    
CREATE TABLE test02
AS
    SELECT employee_id, first_name, hire_date
    FROM   employees
    WHERE  employee_id = 0;
/*
사원번호, 이름, 입사연도
입사연도 2015년(포함) 이전 -> test01 입력(insert)
입사연도 2015년 이후 -> test02 입력(insert)

1) SQL문
 (1)조회 => select문 => 다중행 => CURSOR 사용
SELECT employee_id, first_name, hire_date
FROM employees
WHERE hire_date < TO_DATE('15/01/01', 'YY/MM/DD');

(2) 이전 이면, 이후 이면 => if문
=>  IF hire_date < TO_DATE('15/01/01', 'YY/MM/DD') THEN
    TEST01 테이블에 입력 => insert문 값을 하나씩 받아서 입력?????
        INSERT INTO test01
            VALUSE(eid, ename, ehdate);
    END IF;
*/
SELECT employee_id, first_name, hire_date
FROM employees
WHERE hire_date <= TO_DATE('15/12/31', 'YY/MM/DD');
-- (2) PL/SQL 블록 : 기본 LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, hire_date
        FROM employees;
        
    emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- TO_CHAR(emp_info.hire_date, 'YYYY') <= 2015
        IF emp_info.hire_date <= TO_DATE('15/12/31', 'YY/MM/DD') THEN
            INSERT INTO test01 (employee_id, first_name, hire_date)
            VALUES(emp_info.employee_id, emp_info.first_name, emp_info.hire_date);
        ELSE
            INSERT INTO test02
            VALUES emp_info; -- 레코드 타입과 데이블의 타입이 같고, 순서가 같을 경우 가능!
        END IF;
        
    END LOOP;
    
    CLOSE emp_cursor;
END;
/

-- (3) PL/SQL 블록: CURSOR FOR LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, hire_date
        FROM employees;
        
    emp_info emp_cursor%ROWTYPE;
BEGIN
    FOR emp_info IN emp_cursor LOOP
    
        IF TO_CHAR(emp_info.hire_date, 'YYYY') <= 2015 THEN
            INSERT INTO test01 (employee_id, first_name, hire_date)
            VALUES(emp_info.employee_id, emp_info.first_name, emp_info.hire_date);
        ELSE
            INSERT INTO test02
            VALUES emp_info; -- 레코드 타입과 데이블의 타입이 같고, 순서가 같을 경우 가능!
        END IF;
        
    END LOOP;
END;
/

SELECT  *
FROM    test01;

SELECT  *
FROM    test02;

/* 문제2.
부서번호를 입력할 경우(&부서번호)
사원테이블 ->  이름, 입사일자, 부서명(부서테이블)
다중행 => cursor 사용!
*/
-- (1) SQL문
SELECT  last_name, hire_date, department_name
FROM    employees e
        JOIN departments d
        ON e.department_id = d.department_id
WHERE   e.department_id = &부서번호;

-- (2) PL/SQL 블록 - 기본 LOOP
DECLARE
    CURSOR dept_emp_cursor IS
        SELECT  last_name, hire_date, department_name
        FROM    employees e
                JOIN departments d
                ON e.department_id = d.department_id
        WHERE   e.department_id = &부서번호;
        
    v_record dept_emp_cursor%ROWTYPE;
BEGIN
    OPEN dept_emp_cursor;
    
    LOOP
        FETCH dept_emp_cursor INTO v_record;
        EXIT WHEN dept_emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('이름 : ' || v_record.last_name);
        DBMS_OUTPUT.PUT(', 입사일 : ' || v_record.hire_date);
        DBMS_OUTPUT.PUT_LINE(', 부서명 : ' || v_record.department_name);
        
    END LOOP;
    
    CLOSE dept_emp_cursor;
END;
/

-- 치환변수 x -> 부서정보 들고오기, 소속된 직원 없는 경우 메세지 넣기
DECLARE
    CURSOR dept_cursor IS
        SELECT  *
        FROM    departments;

    CURSOR dept_emp_cursor 
        (p_dept_id departments.department_id%TYPE) IS -- 매개변수 사용
        SELECT  last_name, hire_date, department_name
        FROM    employees e
                JOIN departments d
                ON e.department_id = d.department_id
        WHERE   e.department_id = p_dept_id; -- 치환변수 -> 동적인 변수로 사용
        
    v_record dept_emp_cursor%ROWTYPE;
BEGIN
    FOR dept_info IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=======현재 부서 정보 : ' || dept_info.department_name);
        
        OPEN dept_emp_cursor(dept_info.department_id);
        
        LOOP
            FETCH dept_emp_cursor INTO v_record;
            EXIT WHEN dept_emp_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT('이름 : ' || v_record.last_name);
            DBMS_OUTPUT.PUT(', 입사일 : ' || v_record.hire_date);
            DBMS_OUTPUT.PUT_LINE(', 부서명 : ' || v_record.department_name);
            
        END LOOP;
        
        IF dept_emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('현재 소속된 직원이 없습니다.');
        END IF;
        
        CLOSE dept_emp_cursor;
    
    END LOOP; -- 바깥 LOOP
END;
/

/* EXCEPTION 예외처리 */
-- 1) Oracle이 관리하고 있고, 이름이 존재하는 경우 (약 20개)
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);

EXCEPTION -- ERORR 처리가 목표, 다시 돌아가지 않음
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당부서에는 여러명의 사원이 존재합니다.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 근무하는 사원이 존재하지 않습니다.');
    WHEN OTHERS THEN -- 위에서 특정하지 않은 기타 예외에 대한 처리(단독사용 불가)
        DBMS_OUTPUT.PUT_LINE('기타 예외가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('EXCEPTION 절이 실행되었습니다.'); -- OTHERS 처리시 실행됨
END;
/
-- 2) Oracle이 관리하고 있고, 이름이 존재하지 않는 경우
DECLARE
    e_emps_remaining EXCEPTION; --다른변수와 구분하기 위해서 e_를 붙임
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
    
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;

EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('다른 테이블에서 사용하고 있습니다.');
END;
/

-- 3) 사용자 정의 예외사항 : Oracle이 관리 하지않고, 이름이 존재하지 않는 경우
DECLARE
    e_emp_del_fail EXCEPTION;
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_del_fail;
    END IF;
    
EXCEPTION
    WHEN e_emp_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
END;
/

/* 예외 트랩 함수 */
DECLARE
    e_too_many EXCEPTION;
    
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
    emp_info employees%ROWTYPE;
    
BEGIN
    SELECT  *
    INTO    emp_info
    FROM    employees
    WHERE   department_id = &부서번호;
    
    IF emp_info.salary < (emp_info.salary * emp_info.commission_pct + 10000) THEN
        RAISE e_too_many;
    END IF;
    
EXCEPTION
    WHEN e_too_many THEN
        DBMS_OUTPUT.PUT_LINE('사용자 정의 예외 발생!');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('ORA ' || v_ex_code);
        DBMS_OUTPUT.PUT_LINE(' - ' || v_ex_msg);
END;
/

/* 문제 1. 사용자 정의 예외 복습 */
-- 코드 진행이 멈춰야 할 경우(강하게 예외를 처리 해야할 경우) 주로 사용
DECLARE
    e_no_eid EXCEPTION;
BEGIN

    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_eid;
    END IF;
    
EXCEPTION
    WHEN e_no_eid THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
END;
/

/* PROCEDURE(프로시저) */
-- 실행하면 -> 프로시저로 등록됨 "~~ 이(가) 컴파일되었습니다."
CREATE PROCEDURE test_pro
IS
-- 선언부 : 내부에서 사용하는 변수, 커서, 타입, 예외 등 처리가능
-- DECLARE를 명시하지 않고 암시적으로 존재함
    v_msg VARCHAR2(1000) := 'Execute Procedure';
BEGIN
    DELETE FROM test_employees
    WHERE department_id = 50; -- 치환변수 사용 금지

    DBMS_OUTPUT.PUT_LINE(v_msg);
EXCEPTION
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('사용할 수 없는 커서입니다.');
END;
/
DROP PROCEDURE test_pro;

-- PROCEDURE(프로시저) 실행 방법 1) - PL/SQL 블록 내부에서 실행
BEGIN
    test_pro;
END;
/
-- PROCEDURE(프로시저) 실행 방법 2) - EXECUTE 단축어 실행
EXECUTE test_pro;


-- IN MODE : PROCEDURE 내부에서 상수로 인식
DROP PROCEDURE raise_salary;

CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE) -- 매개변수
IS

BEGIN
    -- p_eid := 100; -- IN 모드에선 매개변수는 상수이기 때문에 변경시 컴파일 에러!!
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_first NUMBER(3,0) := 100;
    v_second CONSTANT NUMBER(3,0) := 149;
BEGIN
    raise_salary(103);
    raise_salary((v_first+10)); -- 130
    raise_salary(v_second); -- 149
    raise_salary(v_first); -- 100
END;
/

SELECT  employee_id, salary
FROM    employees;


-- OUT MODE : PROCEDURE 내부에서 초기화되지 않은 변수
CREATE PROCEDURE test_p_out
    (p_num IN NUMBER,
    p_result OUT NUMBER)
IS
    v_sum NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_result);
    
    v_sum := p_num + p_result; -- p_result은 어떠한 경우에도 값을 가질 수 없음
    p_result := v_sum;
END;
/
DROP PROCEDURE test_p_out;

DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) result: ' || v_result);
    test_p_out(1000, v_result); -- 외부 -> 내부 프로시저로 값을 담기만 가능
    DBMS_OUTPUT.PUT_LINE('2) result: ' || v_result);
END;
/

-- OUT MODE 실제 사용
CREATE PROCEDURE select_emp
(p_eid IN employees.employee_id%TYPE,
p_ename OUT employees.last_name%TYPE,
p_sal OUT employees.salary%TYPE,
p_comm OUT employees.commission_pct%TYPE)
IS
BEGIN
    SELECT last_name, salary, NVL(commission_pct, 0)
    INTO p_ename, p_sal, p_comm
    FROM employees
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_name VARCHAR2(100 char);
    v_comm NUMBER;
    v_sal NUMBER;
    
    v_eid NUMBER := &사원번호;
BEGIN
    select_emp(v_eid, v_name, v_sal, v_comm);

    DBMS_OUTPUT.PUT('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT(', 이름 : ' || v_name);
    DBMS_OUTPUT.PUT(', 급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE(', 커미션 : ' || v_comm);
END;
/

-- IN OUT 매개변수 MODE
-- '01012341234' => '010-1234-1234' : 포맷변환
CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS

BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1, 3) -- SUBSTR(문자, 위치, 갯수) : 문자열자르기
                  || '-' || SUBSTR(p_phone_no, 4, 4)
                  || '-' || SUBSTR(p_phone_no, 8);
END;
/

DECLARE
    v_ph_no VARCHAR2(100) := '01012341234';
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) ' || v_ph_no);
    format_phone(v_ph_no); -- IN OUT 원데이터 보존이 안됌
    DBMS_OUTPUT.PUT_LINE('2) ' || v_ph_no);
END;
/

SELECT NVL(MAX(employee_id),0) + 1
FROM employees;


-- 예제
CREATE TABLE var_pk_tbl
(
    no VARCHAR2(1000) PRIMARY KEY,
    name VARCHAR2(4000) DEFAULT 'anony'
);

-- 'TEMP240215101' -- TEMP + yyMMdd + 숫자(3자리)
SELECT no, name
FROM var_pk_tbl;

INSERT INTO var_pk_tbl(no, name)
VALUES ('TEMP240215101', '상품01');


SELECT 'TEMP' || TO_CHAR(sysdate, 'yyMMdd') || LPAD(NVL(MAX(SUBSTR(no, -3)), 0)+1,3,'0')
FROM var_pk_tbl
WHERE SUBSTR(no, 5, 6) = TO_CHAR(sysdate, 'yyMMdd');
-- 예제 끝.

----------- PROCEDURE 문제
/* 문제1. 프로시저 작성 
입력: 주민번호
출력: 950101-1******
=> 프로시저 사용(yedam_ju)
=> 프로시저 실행
EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)
*/
-- 프로시저, IN 매개변수 하나
CREATE OR REPLACE PROCEDURE yedam_ju
(p_jumin_no IN VARCHAR2)
IS
-- 선언부
    v_result VARCHAR2(100);
BEGIN
    v_result := SUBSTR(p_jumin_no, 1, 6)
                    || '-' || RPAD(SUBSTR(p_jumin_no, 7, 1), 7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

EXECUTE yedam_ju(9501011667777);
EXECUTE yedam_ju(1511013689977);

/* 문제2.
1) SQL문
DELETE  FROM test_employees
WHERE   employee_id = v_eid;
*/
-- 2) PL/SQL블록
CREATE OR REPLACE PROCEDURE TEST_PRO
(p_emp_no IN NUMBER)
IS
-- 선언부
BEGIN
    DELETE  FROM test_employees
    WHERE   employee_id = p_emp_no;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
    END IF;
END;
/

EXECUTE TEST_PRO(179);

/* 문제3.
yedam_emp 프로시저를 생성
=> 
입력 : 사원번호
연산 : LENGTH(이름) / 문자결합|| SUBSTR(원래이름, 1, 1) || /RPAD(이름, 자리수(LENGTH(이름)), '*')
출력 : 사원의 이름(last_name)의 첫번째 글자를 제외하고는 '*'가 출력 (TAYLOR -> T*****)
        (단, 이름크기만큼 별표)
-> DBMS_OUTPUT.PUT_LINE(처리된 사원의 이름);
1) SQL문
SELECT  last_name
FROM    employees
WHERE   employee_id = p_emp_id(외부에서 입력될 변수);
*/
-- 2) PL/SQL 블록
CREATE OR REPLACE PROCEDURE yedam_emp
(p_emp_id NUMBER)
IS
-- 선언부
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    SELECT  last_name
    INTO    v_ename
    FROM    employees
    WHERE   employee_id = p_emp_id;
    
    v_result := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*');
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ' -> ' || v_result);
END;
/

EXECUTE yedam_emp(176);
EXECUTE yedam_emp(200);
EXECUTE yedam_emp(119);

/* 문제 4.
get_emp 프로시저를 생성 + cursor 사용 (다중 행 SELECT문)
입력 : 부서번호
연산 : 
출력 : 해당 부서에 근무하는 사원의 employee_id, last_name
-> 단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)

-- 1) SQL문
SELECT  employee_id, last_name
FROM    employees
WHERE   department_id = p_dept_id;
*/

-- 2) PL/SQL 블록
CREATE OR REPLACE PROCEDURE get_emp
(p_dept_id NUMBER)
IS
-- 선언부
    -- CURSOR
    CURSOR emp_cursor IS
        SELECT  employee_id, last_name
        FROM    employees
        WHERE   department_id = p_dept_id;
        
    v_record emp_cursor%ROWTYPE;
    e_dept_no_fail EXCEPTION;
    
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('사원번호 : ' || v_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', 이름 : ' || v_record.last_name);
    END LOOP;
    
    IF emp_cursor%ROWCOUNT = 0 THEN -- LOOP문이 끝나고 해야함(커서에 데이터가 없는경우)
        RAISE e_dept_no_fail;
    END IF;
    
    CLOSE emp_cursor;
    
EXCEPTION 
    WHEN e_dept_no_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
END;
/


EXECUTE get_emp(80);

/* 문제5.
=> PROCEDURE y_update 생성, EXCEPTION
입력 : 사번(200), 급여증가치(10) 10퍼센트 -> 외부에서 입력받는 매개변수 2개
연산 : employees -> UPDATE 급여 (salary+salary*(10(급여증가치 매개변수)/100))
출력 : 입력한 사원이 없는 경우엔 ‘No search employee!!’메세지 예외처리

-- 1) SQL문
SELECT employee_id, salary, salary+salary*(10/100)
FROM employees
WHERE employee_id = 200;

UPDATE employees
SET salary = 4840(연산된 급여)
WHERE employee_id = 사번 매개변수(200);

*/

-- 2) PL/SQL 블록
CREATE OR REPLACE PROCEDURE y_update
(p_emp_id IN employees.employee_id%TYPE,
p_emp_increment IN NUMBER)
IS
     e_no_emp EXCEPTION;
BEGIN
    UPDATE employees
    -- SET salary = salary + salary * (p_raise/100)
    SET salary = salary * ( 1 + (p_emp_increment/100) )
    WHERE employee_id = p_emp_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;

EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

SELECT * FROM employees WHERE employee_id = 200;

EXECUTE y_update(0, 10);
EXECUTE y_update(200, 10);