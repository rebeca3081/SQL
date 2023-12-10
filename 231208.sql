-- ORDER BY ��
select last_name, job_id, department_id, hire_date
from employees
order by hire_date; -- �⺻ ��������

select last_name, job_id, department_id, hire_date
from employees
order by hire_date desc; -- ��������

select employee_id, last_name, salary * 12 annsal
from employees
order by annsal; -- alias ���� ����

select  last_name, job_id, department_id, hire_date
from    employees
order by 3; -- 3��° �÷� �������� ��������

select  employee_id, last_name, salary
from    employees
order by department_id, salary desc; -- �����÷� ����:1�� ����, 2�� ����

select  employee_id, salary
from    employees
order by hire_date; -- select �÷��� ��� order by �÷��� �������� ���İ���

-- ġȯ���� & : ���� '&�̸�' <-���ڿ�
select  employee_id, last_name, salary, department_id
from    employees
where   employee_id = &employee_num; -- �ݺ��ؼ� ���� Ȯ�� �ϰ� ���� ��� ��� : �ѹ� ���� ������

select  employee_id, last_name, job_id, &column_name
from    employees
where   &condition
order by &order_column;

-- && : �޸𸮿� ��������, �����ϱ� ������
select  employee_id, last_name, job_id, &&column_name
from    employees
order by &column_name;

select  employee_id, salary
from    employees
order by &column_name;

undefine column_name; -- �޸𸮿��� ���� (�����ϴ� ��)


-- ����(set)������
select * from job_history;

-- union
select  employee_id, job_id --�÷� 2���� �ѽ����� ������
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

select  employee_id, job_id -- ��� ����
from    job_history
intersect
select  employee_id, job_id
from    employees;

-- minus : �÷��� ���� ����� �ٸ�
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

-- �����Լ�_1
select 'The job id for '|| upper(last_name)||' is '
        || lower(job_id) as "EMPLOYEE DETAILS"
from    employees;

select  employee_id, last_name, department_id 
from    employees
where   lower(last_name) = 'higgins'; -- ���� ���� ���

-- ���� ����
-- substr(�÷�, �ڸ���ȣ, ����)
select  last_name, substr(last_name, 2, 2)
from    employees
where   department_id = 90;

select  last_name, substr(last_name, -3, 2) -- �ڿ��� �ڸ���ȣ
from    employees
where   department_id = 90;

select employee_id, concat(first_name, last_name) name,
        job_id, length (last_name),
        instr(last_name, 'a') "Contains 'a'?"
from    employees
where   substr(job_id, 4) = 'REP';

-- rtrim, ltrim ���ֻ����
select  ltrim('yyedaymy', 'yea')
from    dual;

select  rtrim('yyedaymy', 'yea')
from    dual;


-- ���� �Լ�
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

-- ���� Ǯ�� part_1
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

-- ��¥
select  sysdate
from    dual;

select  last_name, (sysdate-hire_date) / 7 as weeks -- �ٹ��� �� ��
from    employees
where   department_id = 90;

-- ��¥ �Լ�
select  employee_id, hire_date,
        months_between (sysdate, hire_date) tenure, -- �ٹ��� ���� ��
        add_months (hire_date, 6) review, -- �Ի��� 6���� ��
        next_day (hire_date, '��'), -- ���ƿ��� ù �ݿ��� ��¥
        last_day (hire_date) -- �� ���� ������ ��¥
from    employees;

select  round(sysdate, 'YEAR'), -- ���� ����� �������� �ݿø� 07/01 �� 12��
        round(sysdate, 'MONTH'), -- ����: 16�� �� 12��
        round(sysdate, 'DAY'), -- ������ �� 12��
        round(sysdate, 'DD') -- �� 12��
from    dual;

select  trunc(sysdate, 'YEAR'),
        trunc(sysdate, 'MONTH'),
        trunc(sysdate, 'DAY'),
        trunc(sysdate, 'DD')
from    dual;

-- ������ ��ȯ
-- ���� ��ȯ(�Ͻ��� ������ ���� ��ȯ)
select  *
from    employees
where   employee_id = '101';

alter session set
nls_date_language = american; -- �̱��� ��¥�� ����, ���� ���ǿ�����

-- ���ĸ� + ��ȯ
-- ��¥ -> to_char
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

-- ���� -> TO_CHAR
select to_char(salary, '$99,999.00') SALARY
from employees;

select to_char(salary, '$9,999.00') SALARY
from employees; -- ���� ū �ڸ� ���� ��������� �ƴ� #���� ��µ�


-- ���� -> ����(TO_NUMBER)
select to_number('$3,400', '$99,999')
from dual;

-- ���� -> ��¥(TO_DATE) �ڡڡ�
select to_date('2010��, 02��', 'YYYY"��", MM"��"')
from dual;

select  last_name, hire_date
from    employees
where   hire_date > 
        to_date('2005�� 07�� 01��', 'YYYY"��" MM"��" DD"��"');

select  last_name, hire_date
from    employees
where   hire_date > 
        to_date('05/07/01', 'YY-MM-DD');
        
select  last_name, hire_date
from    employees
where   hire_date > 
        to_date('05/07/01', 'fxYY-MM-DD'); --fx : ������ ��Ȯ�ϰ� ����� ��
        

-- �Ϲ��Լ�
-- NVL (exep1, exep2) : exep1-> null���� ��, exep2-> �ٲ� �� �ڡڡڡڡ�
select  last_name, salary, NVL(commission_pct, 0),
        (salary * 12) + (salary * 12 * NVL(commission_pct, 0)) as AN_SAL
from    employees;

select  last_name, salary,
        NVL(to_char(commission_pct), '���ʽ� ����') -- ����Ÿ������ �����ؾ���
from    employees;

-- NVL2 (exep1, exep2, exep3)
-- exep1 -> null ���� �÷� exep2 -> null�ƴϸ� ����� ��, exep3 -> null�̸� ����� ��
select  last_name, salary, commission_pct,
        NVL2(commission_pct, 'SAL+COMN', 'SAL') income
from    employees;

-- NULLIF (exep1, exep2) : exep1�� exep2�� ��
-- �ٸ��� exep1 ��ȯ
-- ������ -> null ��ȯ
select  first_name, length(first_name) "expr1",
        last_name, length(last_name) "expr2",
        nullif(length(first_name), length(last_name)) result
from    employees;

-- ����ǥ����
-- case when-then-else ����
select  last_name, job_id, salary,
        case job_id when 'IT_PROG' then 1.10 * salary -- 10%�λ�
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

-- decode �Լ�
select  last_name, job_id, salary,
        decode (job_id, 'IT_PROG',  1.10 * salary,
                        'ST_CLERK', 1.15 * salary,
                        'SA_REP',   1.20 * salary,
                                    salary)
        REVISED_SALARY
from    employees;

-- ��ø �Լ� : ���� ���ʺ��� �ٱ������� ����~

-- ���� Ǯ�� part_2
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
        to_char(next_day(add_months(hire_date, 6), '��'), 'yyyy.MM.dd" "DAY')
            as REVIEW
from    employees;

-- 3.
select      last_name, hire_date, to_char(hire_date, 'DAY') as day
from        employees
order by    to_char(hire_date - 1, 'D'); -- D�� ������ ���ڷ� ��Ÿ��. �Ͽ����� 1�ε� -1�� ���� �������� 1�� ��.

-- 4.
select  last_name, 
        NVL(to_char(commission_pct), 'No Commission') as comn
from    employees;

-- 5.
-- decode �Լ� ���
select  last_name, job_id,
        decode (job_id, 'AD_PRES',  'A',
                    'ST_MAN',   'B',
                    'IT_PROG',  'C',
                    'ST_REP',   'D',
                    'ST_CLERK', 'E',
                                '0')
        as grade
from    employees;

-- case ���� ���
select  last_name, job_id, 
        case    when job_id = 'AD_PRES'  then 'A'
                when job_id = 'ST_MAN'   then 'B'
                when job_id = 'IT_PROG'  then 'C'
                when job_id = 'ST_REP'   then 'D'
                when job_id = 'ST_CLERK' then 'E'
                else '0'
        end as grade
from    employees;
