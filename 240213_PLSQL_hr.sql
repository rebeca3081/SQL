-- System.out.println의 역할 프로시저 on
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, World!');
END;
/

-- 기본 PL/SQL 골격
DECLARE
    -- 선언부 : 정의 및 선언
    -- 변수명, 데이터타입
    v_annual NUMBER(9,2) := &연봉; -- 치환변수(complie하기 전이라 한글도 가능)
    v_sal v_annual%TYPE;

BEGIN
    -- 실행부 : 명령어들의 실행(SQL문, PL/SQL문)
    v_sal := v_annual/12; -- 할당 연산자
    DBMS_OUTPUT.PUT_LINE('The monthly salary is ' || TO_CHAR(v_sal));
END;
/

DECLARE
    v_sal NUMBER(7,2) := 60000;
    v_comm v_sal%TYPE := v_sal * .20;
    v_message VARCHAR2(255) := ' eligible for commission';
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal); -- v_sal 60000
    DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm); -- v_comm 12000
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- v_message eligible for commission
    DBMS_OUTPUT.PUT_LINE('================================');
    DECLARE 
        v_sal NUMBER(7,2) := 50000;
        v_comm v_sal%TYPE := 0;
        v_total_comp NUMBER(7,2) := v_sal + v_comm;
    BEGIN -- 현재시점에는 변수가 6개 메모리에 있음
        DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal); -- v_sal 50000
        DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm); -- v_comm 0
        DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- v_message eligible for commission
        DBMS_OUTPUT.PUT_LINE('v_total_comp ' || v_total_comp); -- v_total_comp 50000
        DBMS_OUTPUT.PUT_LINE('================================');
        v_message := 'CLERK not ' || v_message; -- 상위 블록의 v_message를 조회해서 변화시킬 것 같음
        v_comm := v_sal * .30;
    END;
    DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal); -- v_sal 60000
    DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm); -- v_comm 12000
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- v_message CLERK not eligible for commission
    DBMS_OUTPUT.PUT_LINE('================================');
    v_message := 'SALESMAN ' || v_message;
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message); -- v_message SALESMAN CLERK not eligible for commission
END;
/

/*
v_sal 60000
v_comm 12000
v_message  eligible for commission
================================
v_sal 50000
v_comm 0
v_message  eligible for commission
v_total_comp 50000
================================
v_sal 60000
v_comm 12000
v_message CLERK not  eligible for commission
v_message SALESMAN CLERK not  eligible for commission
*/

-- chapter 04.
DECLARE
    v_eid   employees.employee_id%TYPE;
    v_ename VARCHAR2(100); -- 컬럼의 데이터를 받을 수 있는 최대로 설정하면 됨
BEGIN
    SELECT  employee_id, last_name
    INTO    v_eid, v_ename -- 딱 컬럼 수 만큼 변수가 있어야 함!
    FROM    employees
    WHERE   employee_id = &사원번호; 
    -- 쿼리의 결과가
    -- 0개 : no data found
    -- 2개 이상이면 : too many rows...
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
END;
/