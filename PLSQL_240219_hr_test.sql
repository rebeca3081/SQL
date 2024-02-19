-- 문제 2)
/*
입력 : 사원번호 -> 치환변수
출력 : department_name, job_id, salary, (salary*12+(NVL(salary, 0)*NVL(commission_pct, 0)*12)) as annual_sal => 단건
=> 급여나, 커미션이 NULL이어도 값이 출력되도록

-- SQL
SELECT  d.department_name, e.job_id, e.salary, (NVL(salary,0)*12+(NVL(salary,0)*NVL(commission_pct,0)*12)) as annual_sal
FROM    departments d
        JOIN employees e
        ON (d.department_id = e.department_id)
WHERE employee_id = &사원번호;
*/

DECLARE
    v_dname departments.department_name%TYPE;
    v_job_id employees.job_id%TYPE;
    v_sal employees.salary%TYPE;
    v_annual NUMBER(10, 0);
    
BEGIN
    SELECT  d.department_name, e.job_id, e.salary, (NVL(salary,0)*12+(NVL(salary,0)*NVL(commission_pct,0)*12)) as annual_sal
    INTO    v_dname, v_job_id, v_sal, v_annual
    FROM    departments d
            JOIN employees e
            ON (d.department_id = e.department_id)
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT('부서이름 : ' || v_dname);
    DBMS_OUTPUT.PUT(', JOB_ID : ' || v_job_id);
    DBMS_OUTPUT.PUT(', 급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE(', 연간 총 수입 : ' || v_annual);
END;
/

-- 문제 3)
/*
입력 : 사원번호 -> 치환변수
출력 : IF 입사년도 >= TO_CHAR('2015', 'YYYY') THEN
        'New employee'
      ELSE THEN
        'Career employee'
      END IF;
*/
DECLARE
    v_ehdate employees.hire_date%TYPE;
    v_result VARCHAR2(50);
BEGIN
    SELECT  hire_date
    INTO    v_ehdate
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    IF TO_CHAR(v_ehdate, 'yyyy') >= '2015' THEN 
        v_result := 'New employee';
    ELSE
        v_result := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- 문제 4)
/*
1단 ~ 9단 구구단 출력 => 반복문 => FOR IN LOOP문 사용
범위: 
단 -> 1 ~ 9 -> 1씩 증가
곱하는 수 -> 1 ~ 9 -> 1씩 증가  
출력 : 홀수단만 출력 => 조건문으로 제한
*/

BEGIN
    FOR dan IN 1..9 LOOP
        FOR num IN 1..9 LOOP
            IF MOD(dan, 2) <> 0 THEN
                DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
            END IF;
        END LOOP;
    END LOOP;
END;
/

-- 문제 5)
/*
CURSOR사용
입력 : 부서번호
출력 : 모든 사원의 사번, 이름, 급여

-- SQL
SELECT  employee_id, last_name, salary
FROM    employees
WHERE   department_id = &부서번호;
*/

DECLARE
    CURSOR emp_cursor IS
        SELECT  employee_id, last_name, salary
        FROM    employees
        WHERE   department_id = &부서번호;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('사번 : ' || emp_record.employee_id);
        DBMS_OUTPUT.PUT(', 이름 : ' || emp_record.last_name);
        DBMS_OUTPUT.PUT_LINE(', 급여 : ' || emp_record.salary);
    END LOOP;
END;
/

-- 문제 6)
/*
프로시저 사용
입력: 사번, 급여증가치(비율)
갱신 : 급여를 갱신
*/

CREATE OR REPLACE PROCEDURE y_update
(p_eid IN employees.employee_id%TYPE,
p_emp_increment IN NUMBER)
IS
    e_no_emp EXCEPTION;
BEGIN
    UPDATE employees
    SET salary = salary * (1 + (p_emp_increment / 100))
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;

EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

SELECT salary
FROM employees
WHERE employee_id = 174;

EXECUTE y_update(174, 20);
EXECUTE y_update(0, 10);

-- 문제 7)
/*
입력 : 주민등록번호(0211023234567)
연산 : 
-만 나이계산 : 현재 날짜(sysdate)기준 - 생년월일(021102) TO_DATE(SUBSTR(주민등록번호, 1, 6), 'YY/MM/DD')해서 연산
단, 생일이 지나지 않은 경우, 한살 더 더하기

- 성별 : 주민등록번호 7번째 자리 숫자로 반별 SUBSTR(주민등록번호, 7, 1)
    2000년생 이후 3은 남자, 4는 여자
    이전 1은 남자, 2는 여자
출력 : 만 나이, 성별
*/

SELECT TRUNC((sysdate - TO_DATE(SUBSTR('0211023234567', 1, 6), 'YY/MM/DD'))/365)
FROM dual;

CREATE OR REPLACE PROCEDURE y_user_age
(p_jumin IN VARCHAR2)
IS
    v_age NUMBER(3, 0) := 0;
    v_num NUMBER(1, 0);
    v_gender VARCHAR2(5);
BEGIN
    v_age := TRUNC((SYSDATE - TO_DATE(SUBSTR(p_jumin, 1, 6), 'YY/MM/DD'))/365);
    
    IF SYSDATE > TO_DATE(SUBSTR(p_jumin, 1, 6), 'YY/MM/DD') THEN
        v_age := v_age + 1; -- 생일이 지나지 않은 경우, 한살 더 더하기
    END IF;
    
    v_num := TO_NUMBER(SUBSTR(p_jumin, 7, 1), 9);
    
    DBMS_OUTPUT.PUT_LINE(v_age);
    
    IF v_num = 3 THEN
        v_gender := '남';
    ELSIF v_num = 1 THEN
        v_gender := '남';
    ELSE
        v_gender:= '여';
    END IF;
    
    DBMS_OUTPUT.PUT('만 나이 : ' || v_age);
    DBMS_OUTPUT.PUT_LINE(', 성별: ' || v_gender);
END;
/

EXECUTE y_user_age('0211023234567');

-- 문제 8)
/*
=> 함수
입력 : 사원번호
연산 : 
    - 근무년수 : TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12, 0)
    -> 근무개월수 제외....
출력 : 사원의 근무기간, 근무년수
*/

SELECT employee_id, TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12, 0)
FROM employees;


CREATE OR REPLACE FUNCTION y_work_days
(p_eid employees.employee_id%TYPE)
RETURN NUMBER 
IS
    v_hyear NUMBER(2,0);
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hyear
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN v_hyear;
END;
/

SELECT employee_id, y_work_days(employee_id)
FROM employees;

-- 문제 9)
/*
함수
SQL -> 서브쿼리
입력 : 부서이름
출력 : 책임자의 이름(employee_id -> last_name)
*/

SELECT DISTINCT d.manager_id
FROM departments d
    JOIN employees e
    ON (e.department_id = d.department_id)
WHERE d.department_name = 'IT';

SELECT  m.last_name
FROM    employees e
        JOIN employees m
        ON (e.manager_id = m.employee_id)
        WHERE   e.employee_id = 103;

SELECT  last_name
FROM    employees 
WHERE  employee_id = (  SELECT DISTINCT d.manager_id
                        FROM departments d
                            JOIN employees e
                            ON (e.department_id = d.department_id)
                        WHERE d.department_name = 'IT');
                                    
CREATE OR REPLACE FUNCTION get_mgr
(p_dname departments.department_name%TYPE)
RETURN VARCHAR2
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    SELECT  last_name
    INTO    v_mgr_name
    FROM    employees 
    WHERE  employee_id = (  SELECT DISTINCT d.manager_id
                            FROM departments d
                                JOIN employees e
                                ON (e.department_id = d.department_id)
                            WHERE d.department_name = p_dname);
    RETURN v_mgr_name;
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(get_mgr('IT'));

-- 문제 10)
SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY');

-- 문제 11)
/*
반복문 사용
범위 : 
    줄수 1 ~ 9 -> 1씩 증가
    '*' 가 기준 1 ~ 9 -> 1씩 증가 :v_star
    '-'는 총 10자리 중에 나머지를 채우도록
    LPAD(변하는 별의 수, 10, '-') -> LPAD('*', 10, '-')
*/
DECLARE
    v_star VARCHAR2(40) := '*';
BEGIN
    FOR row IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(LPAD(v_star, 10, '-'));
        v_star := v_star || '*';
    END LOOP;
END;
/