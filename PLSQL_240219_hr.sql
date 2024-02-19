SET SERVEROUTPUT ON;

/* FUNCTION 함수 */
-- 함수 기본 틀
CREATE FUNCTION test_fun
(p_msg IN VARCHAR2)
RETURN VARCHAR2 -- RETURN 구분 반드시!
IS
    -- 선언부
    
BEGIN
    RETURN p_msg; -- RETURN 구분 반드시!
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '데이터가 존재하지 않습니다.'; -- RETURN 구분 반드시!
END;
/

-- 호출 1) PL/SQL블록 내에서 사용: 함수의 리턴 값을 변수에 담아줘야 함
DECLARE
    v_result VARCHAR2(1000); 
BEGIN
    -- test_fun('데스트');
    v_result := test_fun('데스트'); -- 함수의 리턴 값을 변수에 담아줘야 함
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- 호출 2) SQL문에서 사용
SELECT test_fun('SELECT문에서 호출')
FROM dual;

-- GUI 환경 X, 명령어 기반의 조회에 사용
SELECT  *
FROM    user_source -- HR계정이 가지고 있는 객체를 확인 할 수 있음
WHERE   type IN ('PROCEDURE');

-- 더하기 함수 : 반복되는 연산을 함수로
CREATE FUNCTION y_sum
(p_x IN NUMBER,
p_y IN NUMBER)
RETURN NUMBER
IS
    v_result NUMBER;
BEGIN
    v_result := p_x + p_y;
    RETURN v_result;
END;
/

SELECT y_sum(100, 200)
FROM dual;

-- 사원번호를 기준으로 직속상사 이름을 출력 => SELF JOIN
SELECT  m.last_name
FROM    employees e
        JOIN employees m
        ON (e.manager_id = m.employee_id)
WHERE   e.employee_id = 149;

-- 함수
CREATE OR REPLACE FUNCTION get_mgr
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    SELECT  m.last_name
    INTO    v_mgr_name
    FROM    employees e
            JOIN employees m
            ON (e.manager_id = m.employee_id)
    WHERE   e.employee_id = p_eid;
    
    RETURN v_mgr_name;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '직속 상사가 존재하지 않습니다.'; -- 데이터 타입에 맞게 RETURN 하기
END;
/

SELECT employee_id, last_name, get_mgr(employee_id) as manager
FROM employees
ORDER BY 3;

/* 문제 1.
입력: 사원번호 y_yedam(174) 함수의 매개변수로 들어옴

연산 : last_name || first_name => 문자열 결합

출력: last_name + first_name
=> 함수 y_yedam

*/

-- 1) SQL문
SELECT last_name || ' ' || first_name
FROM employees
WHERE employee_id = 174;

-- 2) 함수
CREATE OR REPLACE FUNCTION y_yedam
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_full_name employees.last_name%TYPE;
BEGIN
    SELECT last_name || ' ' || first_name
    INTO v_full_name
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN v_full_name;
END;
/
-- 실행1 : 간단한 체크
EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174));

-- 실행2
SELECT employee_id, y_yedam(employee_id)
FROM   employees;

/* 문제2 
ydinc 함수 생성
입력 : 사원번호
출력 : 인상된 급여
*/
-- SQL문
SELECT CASE
        WHEN salary <= 5000 THEN
            salary * (1 + 20 / 100)
        WHEN salary <= 10000 THEN
            salary * (1 + 15 / 100)
        WHEN salary <= 20000 THEN
            salary * (1 + 10 / 100)
        ELSE
            salary
        END as "new sal"
FROM    employees;

-- 함수
CREATE OR REPLACE FUNCTION ydinc
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_sal   employees.salary%TYPE;
    v_increase NUMBER(10,1);
    v_result v_sal%TYPE;
BEGIN
    -- 1) SELECT => salary
    SELECT  NVL(salary, 0)
    INTO    v_sal
    FROM    employees
    WHERE   employee_id = p_eid;
    
    -- 2) salary 에 따라 비율을 다르게 적용
    IF v_sal <= 5000 THEN -- 0 ~ 5000
        v_increase := 20;
    ELSIF v_sal <= 10000 THEN -- 5001 ~ 10000
        v_increase := 15;
    ELSIF v_sal <= 20000 THEN -- 10001 ~ 20000
        v_increase := 10;
    ELSE
        v_increase := 0; -- 20001 부터
    END IF;
    
    v_result := (v_sal * (1 + (v_increase/100))); -- 사용자는 정수값을 입력함
    
    RETURN v_result;
END;
/

-- 함수 실행
SELECT last_name, salary, YDINC(employee_id)
FROM   employees;

/* 문제 3
함수 => yd_func
입력 : 사원번호
출력 : 사원의 연봉 출력
*/
CREATE OR REPLACE FUNCTION yd_func
(f_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_annual NUMBER;
BEGIN
    SELECT  (salary + (NVL(salary, 0) * NVL(commission_pct, 0)))*12
    INTO    v_annual
    FROM    employees
    WHERE   employee_id = f_eid;
                 
    RETURN v_annual;
END;
/

-- 함수 실행
SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;

/* 문제4.
subname 함수
입력 : last_name
연산 : v_result := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*');
출력 : last_name 첫글자 + '*' 채운 나머지
*/

-- 단순 포멧 변경 함수
CREATE OR REPLACE FUNCTION subname
(p_ename employees.last_name%TYPE)
RETURN VARCHAR2
IS

BEGIN    
    RETURN RPAD(SUBSTR(p_ename, 1, 1), LENGTH(p_ename), '*');
END;
/

-- 함수 실행
SELECT last_name, subname(last_name)
FROM   employees;