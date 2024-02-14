SET SERVEROUTPUT ON;

DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm   employees.commission_pct%TYPE := .1;   
BEGIN
    SELECT  department_id
    INTO    v_deptno
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);
    
    UPDATE  employees
    SET     salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE   employee_id = 1000;
END;
/

ROLLBACK;

SELECT  *
FROM    employees
WHERE   employee_id = 1000;


BEGIN
    DELETE FROM employees
    WHERE  employee_id = 1000; -- SQL%ROWCOUNT = 1
    
    /*
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = 0; -- SQL%ROWCOUNT = 0
    */
    
    IF SQL%ROWCOUNT = 0 THEN -- 바로 직전의 SQL문이 적용된 행의 개수를 반환
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되지 않았습니다.');
    END IF;
END;
/
-- SQL문 부터 작성 -> PL/SQL블록 들어가기!!
-- 문제1.
DECLARE
    v_id employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT  employee_id, last_name, department_name
    INTO    v_id, v_name, v_deptname
    FROM    employees
            JOIN departments
            ON (employees.department_id = departments.department_id)
    WHERE   employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_id);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_deptname);
END;
/
-- PL/SQL라서 가능한 방법: SELECT 문가능
-- 문제1-1.
DECLARE
    v_id employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_deptid employees.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT  employee_id, last_name, department_id
    INTO    v_id, v_name, v_deptid
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    SELECT  department_name
    INTO    v_deptname
    FROM    departments
    WHERE   department_id = v_deptid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_id);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_deptname);
END;
/

-- 문제2.
-- 사원번호를 입력 할 경우, 사원이름, 급여, 연봉->(salary*12+(NVL(salary, 0)*NVL(commission_pct, 0)*12)를 출력
-- 1) SQL문 작성
SELECT  last_name, salary, (salary*12+(NVL(salary, 0)*NVL(commission_pct, 0)*12)) as annual_sal
FROM    employees
WHERE   employee_id = &사원번호;

-- 2) PL/SQL 블록 작성
DECLARE
    v_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_annual v_sal%TYPE; -- 이미 선언된 대상에 대해서 타입 참조가능
BEGIN
    SELECT  last_name, salary, (salary*12+(NVL(salary, 0)*NVL(commission_pct, 0)*12)) as annual_sal
    INTO    v_name, v_sal, v_annual
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);
END;
/

-- 문제 2-2.
-- PL/SQL라서 가능한 방법: 별도연산
DECLARE
    v_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_annual v_sal%TYPE; -- 이미 선언된 대상에 대해서 타입 참조가능
    v_comm employees.commission_pct%TYPE;
BEGIN
    SELECT  last_name, salary, commission_pct
    INTO    v_name, v_sal, v_comm -- 커미션을 따로 변수로 선언
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    v_annual := (v_sal*12+(NVL(v_sal, 0)*NVL(v_comm, 0)*12)); -- v_annual 변수에다가 연산을 따로 뺌
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);
END;
/

CREATE TABLE test_employees
AS
    SELECT *
    FROM employees;

SELECT *
FROM test_employees;

ROLLBACK;

/* IF문 */
-- 기본 IF문
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요');
    END IF;
END;
/

-- IF ~ ELSE 문 : 하나의 조건식, 결과는 참과 거짓 각각
DECLARE
    v_result NUMBER(4,0);
BEGIN
    SELECT COUNT(employee_id) -- 그룹함수 COUNT()는 NULL을 세기 때문에 중요★
    INTO v_result
    FROM employees
    WHERE manager_id = &사원번호;
    
    IF v_result = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('팀장입니다.');
    END IF;
END;
/

SELECT  employee_id
FROM    employees
WHERE   manager_id = 100;

-- IF ~ ELSIF ~ ELSE 문 : 다중 조건식이 필요, 각각 결과처리
-- 연차를 구하는 공식(TRUNC(대상-날짜 or 숫자, 자리수-0,1,-1) : 버림, ROUND() : 올림)
SELECT employee_id, TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12, 0) -- MONTHS_BETWEEN-개월수
FROM employees;

DECLARE
    v_hyear NUMBER(2,0);
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hyear
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hyear < 5 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 5년 미만입니다.');
    ELSIF v_hyear < 10 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 5년 이상 10년 미만입니다.');
    ELSIF v_hyear < 15 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 10년 이상 15년 미만입니다.');
    ELSIF v_hyear < 20 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 15년 이상 20년 미만입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('입사한 지 20년 이상입니다.');
    END IF;
END;
/

-- 문제3-1.
-- 1) SQL문 작성
SELECT  hire_date
FROM    employees
WHERE   employee_id = &사원번호;

-- 2) PL/SQL 블록 작성
DECLARE
    v_edate employees.hire_date%TYPE;
BEGIN
    SELECT  hire_date
    INTO    v_edate
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    IF v_edate >= TO_DATE('15/01/01','YY/MM/DD') THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/

-- 문제3-2.
-- DBMS_OUTPUT.PUT_LINE ~ 한번만 사용하기
DECLARE
    v_edate employees.hire_date%TYPE;
    v_result VARCHAR2(1000); -- := 'Career employee';
BEGIN
    SELECT  hire_date
    INTO    v_edate
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    -- IF v_edate > TO_DATE('2014-12-31','yyyy-MM-dd') THEN
    IF TO_CHAR(v_edate, 'yyyy') >= '2015' THEN -- 연도만 잘라내서 문자화 시켜서 비교하기
        v_result := 'New employee';
    ELSE
        v_result := 'Career employee';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- RR vs YY
SELECT  TO_CHAR(TO_DATE('50/01/01', 'rr/MM/dd'), 'yyyy-MM-dd'),
        TO_CHAR(TO_DATE('99/01/01', 'yy/MM/dd'), 'yyyy-MM-dd')
FROM dual;

-- 문제3-3.
/* 문제 해석
출력 -> SELECT 사원이름, 급여, 인상된급여-> 급여+(급여*인상%)연산이 들어가야 함 
                                        인상%는 조건에 따라 다르게 들어옴 -> 변수로 선언 
        FROM 사원테이블
        WHERE 사원번호 = &사원번호;

IF 급여 <= 5000 THEN
    인상된 급여 := .2;
ELSIF 급여 <= 10000 THEN
    인상된 급여 := .15;
ELSIF 급여 <= 15000 THEN
    인상된 급여 := .1;
ELSE
    인상된 급여 := 1;
END IF;

입력: 사원번호
연산:    1) SELECT 문 employees => 사원이름, 급여

        2) IF문을 이용해서 비율을 결정 => 인상된 급여
        -> 조건식 : 기준, 급여
출력(결과): 사원이름, 급여, 인상된급여


*/
-- 1) SQL문
SELECT last_name, salary, NVL(salary,0)+(NVL(salary,0)*0.1)
FROM    employees
WHERE   employee_id = &사원번호;
-- 2) PL/SQL 블록
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal   employees.salary%TYPE;
    v_increase NUMBER(10,1);
    v_result v_sal%TYPE;
BEGIN
    SELECT  last_name, NVL(salary, 0)
    INTO    v_ename, v_sal
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    IF v_sal <= 5000 THEN
        v_increase := 20;
    ELSIF v_sal <= 10000 THEN
        v_increase := 15;
    ELSIF v_sal <= 15000 THEN
        v_increase := 10;
    ELSE
        v_increase := 0;
    END IF;
    
    v_result := v_sal + (v_sal * v_increase/100); -- 사용자는 정수값을 입력함
    -- v_result := v_sal + (v_sal * v_increase);

    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('인상된 급여 : ' || v_result);
END;
/

/* 반목문 LOOP */
-- 기본 LOOP
DECLARE
    v_num NUMBER(38) := 0;
BEGIN
    LOOP
        v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE(v_num);
        EXIT WHEN v_num >= 10; -- 필수: 종료조건(변수가 변경되는 코드가 꼭 존재 해야함)
    END LOOP;

END;
/

-- WHILE LOOP문
DECLARE
    v_num NUMBER(38, 0) := 10;   
BEGIN
    WHILE v_num < 5 LOOP -- 반복조건
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

/* 기본 LOOP vs WHILE LOOP 정반대의 개념임 */
-- 예제 : 1에서 10까지 정수값의 합
-- 1) 기본 LOOP
DECLARE
    v_sum NUMBER(2,0) := 0;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- 2) WHILE LOOP
DECLARE
    v_sum NUMBER(2,0) := 0;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_num <= 10 LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- FOR LOOP
-- 기본
BEGIN
    FOR idx IN -10 .. 5 LOOP
        IF MOD(idx,2)<> 0 THEN -- MOD(값, 나눈 나머지) : 나머지 연산함수 / <> : != 논리부정연산자
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/
-- 주의사항 1) 범위지정
BEGIN
    FOR idx IN REVERSE -10 .. 5 LOOP
        IF MOD(idx,2)<> 0 THEN -- MOD(값, 나눈 나머지) : 나머지 연산함수 / <> : != 논리부정연산자
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/
-- 주의사항 2) 카운터(counter) : cannot be used as an assignment target(할당대상으로 사용하면 안됨)
DECLARE
    v_num NUMBER(2,0) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_num); -- 0
    v_num := v_num * 2;
    DBMS_OUTPUT.PUT_LINE(v_num);
    DBMS_OUTPUT.PUT_LINE('=======================');
    FOR v_num IN 1 .. 10 LOOP
        -- v_num := v_num * 2; -- ERROR
        DBMS_OUTPUT.PUT_LINE(v_num * 2); -- 1 ~ 10
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_num); -- 0
END;
/

-- 문제 : 1에서 10까지 정수값의 합
-- 3) FOR LOOP
DECLARE
    -- 정수값 : 1 ~ 10 => FOR LOOP의 카운터로 처리
    -- 합계
    v_total NUMBER(2,0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
        v_total := v_total + num;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

/*
과제 1. 다음과 같이 출력되도록 하시오.

*
**
***
****
*****
=> 별의 갯수 : 1, 2, 3, 4, 5 1씩 증가
=> 변수(v_star)에 '*' 담기 1씩 증가할 때 마다 '*' 더하기
=> 증가 숫자를 제어하는 변수가 있어야함
*/
-- 1) 기본 LOOP
DECLARE
    v_star VARCHAR2(10) := '';
    v_num NUMBER(10) := 0;
BEGIN
    LOOP
        v_num := v_num + 1; -- 1, 2, 3, 4, 5까지증가
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
        EXIT WHEN v_num >= 5; -- 5일때 반복 종료
    END LOOP;
END;
/

-- 2) WHILE LOOP
DECLARE
    v_star VARCHAR2(10) := '';
    v_num NUMBER(10) := 0;
BEGIN
    WHILE v_num < 5 LOOP
        v_num := v_num + 1; -- 1, 2, 3, 4, 5까지증가
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/

-- 3) FOR LOOP
DECLARE
    v_star VARCHAR2(10) := '';
BEGIN
    FOR idx IN 1 .. 5 LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/