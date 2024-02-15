SET SERVEROUTPUT ON;

-- 문제2. 구구단 출력
/*
입력 : 치환변수사용 -> 숫자받기 -> 구구단수 숫자

연산 : 1) 변수선언
        - 입력받는 숫자, 
          증가되는 줄 수 (1~9: 1씩증가), => LOOP문 반복되는 부분 
          두 수를 곱한 결과
      2) 두 수 곱하기
      
출력 : => 문자열 연결 '||' + 반복문 LOOP
2 * 1 = 2 -> 입력받은 수 * 첫번째 줄 = 연산한 결과 
2 * 2 = 4 -> 입력받은 수 * 두번째 줄 = 연산한 결과
...
2 * 9 = 4 -> 입력받은 수 * 두번째 줄 = 연산한 결과
*/

-- 1) 기본 LOOP
DECLARE
    v_input CONSTANT NUMBER(2,0) := &단입력; -- 치환변수로 단 입력받기 => 상수
    v_num NUMBER(2,0) := 1; -- 증가하는 줄 수
    v_result NUMBER (2,0); -- 두 수를 곱한 결과
BEGIN
    LOOP
        v_result := v_input * v_num; -- 두 수를 곱한 결과를 담기
        DBMS_OUTPUT.PUT_LINE(v_input || ' * ' || v_num || ' = ' || v_result);
        -- 결과를 변수에 담지 않고 바로 연산하기!
        -- DBMS_OUTPUT.PUT_LINE(v_input || ' * ' || v_num || ' = ' || (v_input * v_num));
        v_num := v_num + 1; -- 1씩 증가하는 줄 수
        
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/

-- 2) WHILE LOOP => 조건과 관련된 변수
DECLARE
    v_input CONSTANT NUMBER(2, 0) := &단입력;
    v_num NUMBER(2,0) := 1; -- 범위 : 1 ~ 9, 정수 모두
BEGIN
    WHILE v_num <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_input || ' * ' || v_num || ' = ' || (v_input * v_num));
        v_num := v_num + 1; -- 범위의 수 1씩 증가
    END LOOP;
END;
/

-- 3) FOR LOOP => 변수를 요구하지 않음
DECLARE
    v_input CONSTANT NUMBER(2, 0) := &입력값;
BEGIN
    FOR i IN 1..9 LOOP -- 특정 범위에 존재하는 정수 값을 내부 변수
        DBMS_OUTPUT.PUT_LINE(v_input || ' * ' || i || ' = ' || (v_input * i));
    END LOOP;
END;
/

-- 문제3. 구구단 출력 2~9단 까지 출력되도록 하시오.
/*
2중 LOOP문 사용하기
1) 범위: 2 ~ 9단 => 바깥 LOOP => 범위 수 변수 v_dan => 1씩 증가
2) 범위: 1 ~ 9 곱하는 수 => 안쪽 LOOP => v_num => 1씩 증가
출력
2 * 1 = 2
...
3 * 1 = 3
...
...
9 * 1 = 9
*/

-- 1) 기본 LOOP
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP -- 바깥 LOOP
        v_num := 1; -- 다시 초기화
        LOOP -- 안쪽 LOOP
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP;
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- 2) FOR LOOP
BEGIN
    FOR dan IN 2..9 LOOP -- 단
        FOR num IN 1..9 LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
        END LOOP;
    END LOOP;
END;
/
-- 2-1) 가로 한줄 Ver.
BEGIN
    FOR dan IN 2..9 LOOP -- 단
        FOR num IN 1..9 LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT(dan || ' * ' || num || ' = ' || (dan * num) || ' ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 2-2) 가로세로 Ver.
BEGIN
    FOR num IN 1..9 LOOP -- 단
        FOR dan IN 2..9 LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT(dan || ' * ' || num || ' = ' || (dan * num) || ' ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 3) WHILE LOOP => 반복조건과 관련된 변수
DECLARE
    v_dan NUMBER(2,0) := 2; -- 2 ~ 9 => 반복조건
    v_num NUMBER(2,0) := 1; -- 1 ~ 9 => 반복조건
BEGIN
    WHILE v_dan <= 9 LOOP -- 단
        v_num := 1; -- 초기화 : 안쪽 LOOP문을 돌기 전에 v_num을 다시 셋팅해줘야 함
        WHILE v_num <= 9 LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            v_num := v_num + 1;
        END LOOP;
        v_dan := v_dan + 1;
    END LOOP;
END;
/

-- 3-1) WHILE LOOP 가로로 해보기


-- 문제4. 구구단 1~9단까지 출력되도록 하시오. (단, 홀수단만 출력)
/*
MOD(실제값, 나누는 값) : 나머지
(1) 범위 단: 1 ~ 9 까지 1씩 증가 
    => 홀수단 만 출력 MOD(단수, 2) = 0이면 짝수 아니면 홀수 <>(!=) 0 -> 홀수
*/
-- 1) FOR LOOP문 + IF문
BEGIN
    FOR dan IN 1..9 LOOP -- 단
        FOR num IN 1..9 LOOP -- 곱하는 수
            IF MOD(dan, 2) <> 0 THEN -- 홀수 단에서만 동작하도록
                DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 1-1) FOR LOOP문 + IF문 => CONTINE;사용
BEGIN
    FOR dan IN 1..9 LOOP -- 단
        IF MOD(dan, 2) = 0 THEN -- 짝수단이면 진행하지 않겠다
            CONTINUE;
        END IF;
        
        FOR num IN 1..9 LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 2) 기본 LOOP + IF문 => 감싸야하는 범위를 명확하게 알기!
DECLARE
    v_dan NUMBER(2,0) := 1;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP -- 바깥 LOOP
        IF MOD(v_dan, 2) <> 0 THEN -- 홀수 단에서만 동작하도록
            v_num := 1; -- 다시 초기화
            LOOP -- 안쪽 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
                v_num := v_num + 1;
                EXIT WHEN v_num > 9;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

/* ★RECORD - 논리적인 단위 묶음*/
DECLARE
    -- 1)정의 : 사용자 정의
    TYPE emp_record_type IS RECORD
        ( empno  NUMBER(6,0)
        , ename employees.last_name%TYPE
        , sal   employees.salary%TYPE := 0 );
    
    -- 2)변수선언 : 변수를 통해 실제적으로 사용
    v_emp_info   emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    SELECT  employee_id, first_name, salary -- 들어오는 TYPE을 RECORD TYPE과 같게!!
    INTO    v_emp_info -- RECORD에 SELECT 컬럼 수 만큼 있어야 함.
    FROM    employees
    WHERE   employee_id = &사원번호;

    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.empno); -- 레코드명.필드명으로 개별적 접근하기
    DBMS_OUTPUT.PUT(', 사원 이름 : ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', 급여 : ' || v_emp_info.sal);
END;
/


-- RECORD : %ROWTYPE (행 타입을 통째로 들고 옴) - 물리적 TABLE, VIEW
DECLARE
    -- 별도의 정의 없이 선언만!
    v_emp_info employees%ROWTYPE;
BEGIN
    SELECT  *
    INTO    v_emp_info
    FROM    employees
    WHERE   employee_id = &사원번호;
    
    -- %ROWTYPE사용시에는 레코드명.테이블의 '컬럼명' 으로 접근하기
    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
    DBMS_OUTPUT.PUT_LINE(', 업무 : ' || v_emp_info.job_id);
END;
/


/* PL/SQL TABLE */
DECLARE
    -- 1) 정의
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
        
    -- 2) 변수 선언
    v_num_info num_table_type;
BEGIN
    -- 변수의 값을 할당하기 전에 호출하면 ERORR : no data found
    -- DBMS_OUTPUT.PUT_LINE('현재 인덱스 -1000 : ' || v_num_info(-1000)); 
    
    v_num_info(-1000) := 10000; -- 변수(인덱스), 지정된 인덱스의 값을 부여
    
    DBMS_OUTPUT.PUT_LINE('현재 인덱스 -1000 : ' || v_num_info(-1000));
END;
/

-- 2의 배수 10개를 담는 예제 : 2, 4, 6, 8, 10, 12, 14, ...
DECLARE
    -- 1)정의
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
    -- 2) 변수선언
    v_num_ary num_table_type;
    
    v_result NUMBER(4,0) := 0;
BEGIN
    FOR idx IN 1..10 LOOP
        v_num_ary(idx * 5) := idx * 2;
    END LOOP;
    
    FOR i IN v_num_ary.FIRST .. v_num_ary.LAST LOOP
        IF v_num_ary.EXISTS(i) THEN -- ★데이터를 들고 있는 경우에만 출력되도록 확인 필요
            DBMS_OUTPUT.PUT(i || ' : ');
            DBMS_OUTPUT.PUT_LINE(v_num_ary(i)); -- 2, 4, 6, ... , 20
            v_result := v_result + v_num_ary(i); -- 누적 합 구하기
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('총 갯수 : ' || v_num_ary.COUNT); -- COUNT: 현재 포함하고 있는 요소 수
    DBMS_OUTPUT.PUT_LINE('누적합 : ' || v_result);
END;
/

/* TABLE + RECORD */
SELECT  *
FROM    employees;

DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
        
    v_emps      emp_table_type;
    v_emp_info  employees%ROWTYPE;
BEGIN
    FOR eid IN 100..104 LOOP
        SELECT  *
        INTO    v_emp_info
        FROM    employees
        WHERE   employee_id = eid;
        
        v_emps(eid) := v_emp_info;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총 개수 : ' || v_emps.COUNT);
    DBMS_OUTPUT.PUT_LINE(v_emps(100).last_name);
END;
/

-- 총 20건 담기
DECLARE
    v_min employees.employee_id%TYPE; -- 최소 사원번호
    v_max employees.employee_id%TYPE; -- 최대 사원번호
    v_result NUMBER(1,0);             -- 사원의 존재유무를 확인
    v_emp_record employees%ROWTYPE;     -- Employees 테이블의 한 행에 대응
    
    TYPE emp_table_type IS TABLE OF v_emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    v_emp_table emp_table_type;
BEGIN
    -- 최소 사원번호, 최대 사원번호
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN -- 정수값을 기준으로 데이터 하나씩 존재여부 확인
            CONTINUE; -- 건너뛰기
        END IF;
        
        SELECT *
        INTO v_emp_record
        FROM employees
        WHERE employee_id = eid;
        
        v_emp_table(eid) := v_emp_record;     
    END LOOP;
    
    FOR eid IN v_emp_table.FIRST .. v_emp_table.LAST LOOP
        IF v_emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(v_emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT(v_emp_table(eid).last_name || ', ');
            DBMS_OUTPUT.PUT_LINE(v_emp_table(eid).hire_date);
        END IF;
    END LOOP;    
END;
/


/* CURSOR */
DECLARE
    -- 커서를 선언 (SQL영역)
    CURSOR emp_cursor IS -- SELECT문에 이름을 붙이는 과정
        SELECT  employee_id, last_name
        FROM    employees;
        -- WHERE employee_id = 0; -- 커서는 데이터가 없어도 실행은 가능, 에러가 나지 않으니 주의★
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_cursor;
    
    -- FETCH는 한번에 한 행의 데이터만 로드 가능 => LOOP문이 필요함
    FETCH emp_cursor INTO v_eid, v_ename; -- 행을 통째로 받고 -> 필요한 부분 선정하기
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    
    CLOSE emp_cursor; -- 활성집합 해제

END;
/

-- CURSOR 사용 예시
DECLARE
    CURSOR emp_cursor IS
    SELECT employee_id, last_name, job_id
    FROM employees;
    
    v_emp_record emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record; -- FETCH는 시점을 잘 고려해야함
        EXIT WHEN emp_cursor%NOTFOUND; -- 전체 순환에 대한 종료조건 => %NOTFOUND
        
        -- 실제 연산 진행
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_record.last_name);
    
    END LOOP;
    
    /* 주의사항 1)
    FETCH emp_cursor INTO v_emp_record;
    DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
    DBMS_OUTPUT.PUT_LINE(v_emp_record.last_name); 
    */
    
    CLOSE emp_cursor;
    
    /* 주의사항 2) 커서 CLOSE 후 FETCH or 커서 속성 사용 금지 => invalid cursor ERORR
    FETCH emp_cursor INTO v_emp_record;
    DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
    */
END;
/

/* CURSOR + TABLE => 여러번의 연산(SELECT 를 여러번 사용)하지 않아서 성능 향상 효과*/ 
DECLARE
    -- 커서
    CURSOR emp_cursor IS
        SELECT  *
        FROM    employees;
        
    v_emp_record employees%ROWTYPE;

    -- 테이블
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
        
    v_emp_table emp_table_type;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        v_emp_table(v_emp_record.employee_id) := v_emp_record; -- v_emp_table(v_emp_record%ROWCOUNT)
    END LOOP;
    
    CLOSE emp_cursor;
    
    -- 출력
    FOR eid IN v_emp_table.FIRST .. v_emp_table.LAST LOOP
        IF v_emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(v_emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT(v_emp_table(eid).last_name || ', ');
            DBMS_OUTPUT.PUT_LINE(v_emp_table(eid).hire_date);
        END IF;
    END LOOP;
END;
/

--
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT  employee_id, last_name, job_id
        FROM    employees
        WHERE   department_id = &부서번호;
        
    v_emp_info emp_dept_cursor%ROWTYPE;
BEGIN
    -- 1)해당 부서에 속한 사원의 정보를 출력
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        
        -- 첫번째 : => 몇번 째 행을 출력, %ROWCOUNT 변동 값
        DBMS_OUTPUT.PUT_LINE('첫번째 : ' || emp_dept_cursor%ROWCOUNT);
        
        DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT('사원이름 : ' || v_emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE('업무 : ' || v_emp_info.job_id);
    END LOOP;
    
    -- 두번째 : => 현재 커서의 데이터 총 갯수, 데이터가 없는 경우에도 나옴
    DBMS_OUTPUT.PUT_LINE('두번째 : ' || emp_dept_cursor%ROWCOUNT);
    -- 2)해당 부서에 속한 사원이 없는 경우 '해당 부서에 소속된 직원이 없습니다.' 라는 메세지 출력
    IF emp_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 소속된 직원이 없습니다.');
    END IF;
        
    CLOSE emp_dept_cursor;
    
END;
/

/* 문제1. 모든사원의 사원번호, 이름, 부서이름 출력
1)SQL문
SELECT  employee_id, last_name, department_name
FROM    employees e
        LEFT OUTER JOIN departments d
        ON e.department_id = d.department_id;
2)PL/SQL 블럭
다중 행 => CURSOR 사용 => 출력
*/
DECLARE
    -- 커서
    CURSOR emp_cursor IS
        SELECT  employee_id eid, last_name ename, department_name dept_name
        FROM    employees e
                LEFT OUTER JOIN departments d
                ON e.department_id = d.department_id;
    -- 쿼리 결과를 담을 변수 선언
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- 출력
        DBMS_OUTPUT.PUT('사원번호: ' || v_emp_info.eid || ', ');
        DBMS_OUTPUT.PUT('사원이름: ' || v_emp_info.ename || ', ');
        DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_emp_info.dept_name);
        
    END LOOP;
    
    CLOSE emp_cursor;
END;
/

/* 문제2. 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (salary * 12) + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)
1) SQL문 작성
SELECT  last_name, salary, ((salary * 12) + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) annual
FROM    employees
WHERE   department_id IN (50, 80);

** 연봉 연산 방법 2가지
    1-SELECT 문에서
    2-LOOP문에서
*/
DECLARE
    CURSOR emp_deptno_cursor IS
        SELECT  last_name
                , salary
                , ((salary * 12) + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) annual
        FROM    employees
        WHERE   department_id IN (50, 80);
        
    v_emps_info emp_deptno_cursor%ROWTYPE;
BEGIN
    OPEN emp_deptno_cursor;
    
    LOOP
        FETCH emp_deptno_cursor INTO v_emps_info;
        EXIT WHEN emp_deptno_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('사원이름 : ' || v_emps_info.last_name || ', ');
        DBMS_OUTPUT.PUT('급여: ' || v_emps_info.salary || ', ');
        DBMS_OUTPUT.PUT_LINE('연봉: ' || v_emps_info.annual);
    END LOOP;
    
    CLOSE emp_deptno_cursor;
    
END;
/

-- 두번째 방법 : 연봉 연산을 PL/SQL 내부에서 가능!
-- 1) SQL문 작성
SELECT  last_name, salary, commission_pct
FROM    employees
WHERE   department_id IN (50, 80);

DECLARE
    CURSOR emp_deptno_cursor IS
        SELECT  last_name, salary, commission_pct
        FROM    employees
        WHERE   department_id IN (50, 80);
        
    v_emps_info emp_deptno_cursor%ROWTYPE;
    v_annual    NUMBER(10,0);
BEGIN
    OPEN emp_deptno_cursor;
    
    LOOP
        FETCH emp_deptno_cursor INTO v_emps_info;
        EXIT WHEN emp_deptno_cursor%NOTFOUND;
        
        v_annual := ((v_emps_info.salary * 12) + (NVL(v_emps_info.salary, 0) * NVL(v_emps_info.commission_pct, 0) * 12));
        
        DBMS_OUTPUT.PUT('사원이름 : ' || v_emps_info.last_name || ', ');
        DBMS_OUTPUT.PUT('급여: ' || v_emps_info.salary || ', ');
        DBMS_OUTPUT.PUT_LINE('연봉: ' || v_annual);
    END LOOP;
    
    CLOSE emp_deptno_cursor;
    
END;
/