-- ORDER BY 절
select last_name, job_id, department_id, hire_date
from employees
order by hire_date; -- 기본 오름차순

select last_name, job_id, department_id, hire_date
from employees
order by hire_date desc; -- 내림차순

select employee_id, last_name, salary * 12 annsal
from employees
order by annsal; -- alias 기준 정렬

select  last_name, job_id, department_id, hire_date
from    employees
order by 3; -- 3번째 컬럼 기준으로 오름차순

select  employee_id, last_name, salary
from    employees
order by department_id, salary desc; -- 여러컬럼 정렬:1차 정렬, 2차 정렬

select  employee_id, salary
from    employees
order by hire_date; -- select 컬럼명에 없어도 order by 컬럼을 기준으로 정렬가능

-- 치환변수 & : 단일 '&이름' <-문자열
select  employee_id, last_name, salary, department_id
from    employees
where   employee_id = &employee_num; -- 반복해서 값을 확인 하고 싶을 경우 사용 : 한번 쓰고 버려짐

select  employee_id, last_name, job_id, &column_name
from    employees
where   &condition
order by &order_column;

-- && : 메모리에 영구저장, 삭제하기 전까지
select  employee_id, last_name, job_id, &&column_name
from    employees
order by &column_name;

select  employee_id, salary
from    employees
order by &column_name;

undefine column_name; -- 메모리에서 해제 (삭제하는 법)


-- 집합(set)연산자
select * from job_history;

-- union
select  employee_id, job_id --컬럼 2개를 한쌍으로 생각함
from    employees
union
select  employee_id, job_id
from    job_history;

-- union all
select  employee_id, job_id
from    employees
union all
select  employee_id, job_id
from    job_history
order by employee_id;

-- intersect
select  employee_id, job_id
from    employees
intersect
select  employee_id, job_id
from    job_history;

select  employee_id, job_id -- 결과 동일
from    job_history
intersect
select  employee_id, job_id
from    employees;

-- minus : 컬럼에 따라 결과가 다름
select  employee_id, job_id
from    employees
minus
select  employee_id, job_id
from    job_history;

select  employee_id, job_id
from    job_history
minus
select  employee_id, job_id
from    employees;


-- dual
desc    dual;

select  * 
from    dual;

select  sysdate
from    dual;

-- 문자함수_1
select 'The job id for '|| upper(last_name)||' is '
        || lower(job_id) as "EMPLOYEE DETAILS"
from    employees;

select  employee_id, last_name, department_id 
from    employees
where   lower(last_name) = 'higgins'; -- 많이 쓰는 방법

-- 문자 조작
-- substr(컬럼, 자리번호, 개수)
select  last_name, substr(last_name, 2, 2)
from    employees
where   department_id = 90;

select  last_name, substr(last_name, -3, 2) -- 뒤에서 자리번호
from    employees
where   department_id = 90;

select employee_id, concat(first_name, last_name) name,
        job_id, length (last_name),
        instr(last_name, 'a') "Contains 'a'?"
from    employees
where   substr(job_id, 4) = 'REP';

-- rtrim, ltrim 자주사용함
select  ltrim('yyedaymy', 'yea')
from    dual;

select  rtrim('yyedaymy', 'yea')
from    dual;


-- 숫자 함수
-- round
select  round(345.678) as round1,
        round(345.678, 0) as round2,
        round(345.678, 1) as round3,
        round(345.678, -1) as round4
from    dual;

-- trunc
select  trunc(345.678) as round1,
        trunc(345.678, 0) as round2,
        trunc(345.678, 1) as round3,
        trunc(345.678, -1) as round4
from    dual;

-- mod
select  last_name, salary, mod(salary, 5000)
from    employees;

-- 문제 풀기 part_1
-- 1.
select  sysdate as "Date"
from    dual;

-- 2.
select  employee_id, last_name, salary,
        round (salary * 1.15) as "New Salary"
from    employees;

-- 3.
select  employee_id, last_name, salary,
        round (salary * 1.15) as "New Salary",
        (salary * 1.15) - salary as "Increase"
from    employees;

-- 4.
select  upper (last_name) as name,
        length (last_name) as name_length
from    employees
where   upper (substr(last_name, 1, 1)) in ('J', 'A', 'M')
order by 1;

-- 날짜
select  sysdate
from    dual;

select  last_name, (sysdate-hire_date) / 7 as weeks -- 근무한 주 수
from    employees
where   department_id = 90;

-- 날짜 함수
select  employee_id, hire_date,
        months_between (sysdate, hire_date) tenure, -- 근무한 개월 수
        add_months (hire_date, 6) review, -- 입사후 6개월 후
        next_day (hire_date, '금'), -- 돌아오는 첫 금요일 날짜
        last_day (hire_date) -- 그 달의 마지막 날짜
from    employees;

select  round(sysdate, 'YEAR'), -- 년의 가운데가 기준으로 반올림 07/01 밤 12시
        round(sysdate, 'MONTH'), -- 기준: 16일 밤 12시
        round(sysdate, 'DAY'), -- 수요일 낮 12시
        round(sysdate, 'DD') -- 낮 12시
from    dual;

select  trunc(sysdate, 'YEAR'),
        trunc(sysdate, 'MONTH'),
        trunc(sysdate, 'DAY'),
        trunc(sysdate, 'DD')
from    dual;

-- 데이터 변환
-- 유형 변환(암시적 데이터 유형 변환)
select  *
from    employees
where   employee_id = '101';

alter session set
nls_date_language = american; -- 미국식 날짜로 변경, 현재 세션에서만

-- 형식모델 + 변환
-- 날짜 -> to_char
select  employee_id, to_char(hire_date, 'MM/YY')
from    employees;

select  last_name,
        to_char(hire_date, 'DD Month YYYY')
from    employees;

select  last_name,
        to_char(hire_date, 'DD month YYYY')
from    employees;

select  last_name,
        to_char(hire_date, 'DD MONTH YYYY')
from    employees;

select  last_name,
        to_char(hire_date, 'fmDD Month YYYY')
from    employees;

select  last_name,
        to_char(hire_date, 'fmDdspth "of" Month YYYY fmHH:MI:SS AM')
from    employees;

-- 숫자 -> TO_CHAR
select to_char(salary, '$99,999.00') SALARY
from employees;

select to_char(salary, '$9,999.00') SALARY
from employees; -- 제일 큰 자리 수를 맞춰줘야함 아님 #으로 출력됨


-- 문자 -> 숫자(TO_NUMBER)
select to_number('$3,400', '$99,999')
from dual;

-- 문자 -> 날짜(TO_DATE) ★★★
select to_date('2010년, 02월', 'YYYY"년", MM"월"')
from dual;

select  last_name, hire_date
from    employees
where   hire_date > 
        to_date('2005년 07월 01일', 'YYYY"년" MM"월" DD"일"');

select  last_name, hire_date
from    employees
where   hire_date > 
        to_date('05/07/01', 'YY-MM-DD');
        
select  last_name, hire_date
from    employees
where   hire_date > 
        to_date('05/07/01', 'fxYY-MM-DD'); --fx : 형식을 정확하게 맞춰야 함
        

-- 일반함수
-- NVL (exep1, exep2) : exep1-> null포함 값, exep2-> 바꿀 값 ★★★★★
select  last_name, salary, NVL(commission_pct, 0),
        (salary * 12) + (salary * 12 * NVL(commission_pct, 0)) as AN_SAL
from    employees;

select  last_name, salary,
        NVL(to_char(commission_pct), '보너스 없음') -- 문자타입으로 통일해야함
from    employees;

-- NVL2 (exep1, exep2, exep3)
-- exep1 -> null 포함 컬럼 exep2 -> null아니면 변경될 값, exep3 -> null이면 변경될 값
select  last_name, salary, commission_pct,
        NVL2(commission_pct, 'SAL+COMN', 'SAL') income
from    employees;

-- NULLIF (exep1, exep2) : exep1와 exep2비교 후
-- 다르면 exep1 반환
-- 같으면 -> null 반환
select  first_name, length(first_name) "expr1",
        last_name, length(last_name) "expr2",
        nullif(length(first_name), length(last_name)) result
from    employees;

-- 조건표현식
-- case when-then-else 구문
select  last_name, job_id, salary,
        case job_id when 'IT_PROG' then 1.10 * salary -- 10%인상
                    when 'ST_CLERK' then 1.15 * salary
                    when 'SA_REP' then 1.20 * salary
                    else salary
        end "REVISED_SALARY" -- alias
from    employees;

select  last_name, salary,
        case when salary < 5000  then 'Low'
             when salary < 10000 then 'Medium'
             when salary < 20000 then 'Good'
                                 else 'Excellent'
             end qualified_salary 
from employees;

-- decode 함수
select  last_name, job_id, salary,
        decode (job_id, 'IT_PROG',  1.10 * salary,
                        'ST_CLERK', 1.15 * salary,
                        'SA_REP',   1.20 * salary,
                                    salary)
        REVISED_SALARY
from    employees;

-- 중첩 함수 : 가장 안쪽부터 바깥순으로 계산됨~

-- 문제 풀기 part_2
-- 5.
select  last_name, 
        round (months_between(sysdate, hire_date)) as "MONTHS_WORKED"
from    employees;

-- 6.
select  last_name,
        lpad(salary, 14, '#') as "SALARY"
from    employees;

-- 7.
select  last_name, round((sysdate - hire_date) / 7) as TENURE
from    employees
where   department_id = 90;

-- part_3
-- 1.
select  last_name || ' earns'
        || to_char(salary, '$99,999.00')
        || 'monthly but wants'
        || to_char(salary * 3, '$99,999.00')
from    employees;

-- 2.
select  last_name, hire_date,
        to_char(next_day(add_months(hire_date, 6), '월'), 'yyyy.MM.dd" "DAY')
            as REVIEW
from    employees;

-- 3.
select      last_name, hire_date, to_char(hire_date, 'DAY') as day
from        employees
order by    to_char(hire_date - 1, 'D'); -- D는 요일을 숫자로 나타냄. 일요일이 1인데 -1을 빼서 월요일을 1로 함.

-- 4.
select  last_name, 
        NVL(to_char(commission_pct), 'No Commission') as comn
from    employees;

-- 5.
-- decode 함수 사용
select  last_name, job_id,
        decode (job_id, 'AD_PRES',  'A',
                    'ST_MAN',   'B',
                    'IT_PROG',  'C',
                    'ST_REP',   'D',
                    'ST_CLERK', 'E',
                                '0')
        as grade
from    employees;

-- case 구문 사용
select  last_name, job_id, 
        case    when job_id = 'AD_PRES'  then 'A'
                when job_id = 'ST_MAN'   then 'B'
                when job_id = 'IT_PROG'  then 'C'
                when job_id = 'ST_REP'   then 'D'
                when job_id = 'ST_CLERK' then 'E'
                else '0'
        end as grade
from    employees;
