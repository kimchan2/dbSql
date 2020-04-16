/*
특정 칼럼에 대해서만 조회 : SELECT 칼럼1, 칼럼2 ....
prod_id, prod_name 컬럼만 prod 테이블에서 조회
*/

-- 연습문제
SELECT prod_id, prod_name FROM prod;
SELECT * FROM lprod;
SELECT buyer_id, buyer_name FROM buyer;
SELECT * FROM cart;
SELECT mem_id, mem_pass, mem_name FROM member;

/*
SQL 연산 : JAVA와 다르게 대입 x, 일반적인 사칙연산
SQL 데이터 타입 : 주로 문자, 숫자, 날짜(date)
*/

/*
테이블이 (4/14 만들어 놓음)존재
USERS 테이블의 모든 데이터를 조회;
*/

날짜 타입에 대한 연산 : 날짜는 +, - 연산 가능
date type + 정수 : date에서 정수날짜 만큼 미래 날짜로 이동
date type - 정수 : date에서 정수날짜 만큼 과거 날짜로 이동

SELECT userid , reg_dt, reg_dt + 5 as after_5days , reg_dt -5 as "before 5days"
FROM users;

컬럼 별칭 : 기존 컬럼명을 변경 하고 싶을 때
syntax : 기존 컬럼명 [as] 별칭명칭
별칭 명칭에 공백이 표현되어야 할 경우 더블 쿼테이션으로 묶는다
또한 오라클에서는 객체명을 대문자 처리 하기 때문에 소문자로 별칭을 지정하기 위해서도 더블 쿼테이션을 사용한다

SELECT userid as id, userid "아 이 디"
FROM users;

--실습
SELECT prod_id as id, prod_name as name
FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

SELECT buyer_id as 바이어아이디, buyer_name as 이름
FROM buyer;

문자열 연산 : || (문자열 결합은 + 연산자가 아니다)
SQL에서는 ' '이 문자열, 자바는 " "
SELECT '경 ' || userid || ' 축', reg_dt + 5, 'test', 15 -- 실제 존재하는 컬럼이 아니지만 사용자가 SELECT하면서 추가가능
FROM users;

SELECT CONCAT(userid, usernm) as concat_id_name, userid || usernm as id_name
FROM users;

--실습
SELECT *
FROM user_tables; -- oracle 에서 관리하는 테이블 정보를 담고 있는 테이블(view) ==> data dictionary

SELECT 'SELECT * FROM ' || table_name || ';' as QUERY
FROM user_tables;

테이블의 구성 칼럼을 확인
1. tool(sql developer)을 통해 확인
2. SELECT *
   FROM 테이블 , 일단 전체 조회 -> 모든 컬럼이 표시
3. DESC 테이블명
4. data dictionary : user_tab_columns

DESC emp;

SELECT *
FROM user_tab_columns;

지금까지 배운 SELECT 구문
조회하고자 하는 컬럼 기술 : SELECT
조회할 테이블 기술 : FROM
조회할 행을 제한하는 조건을 기술 : WHERE
WHERE 절에 기술한 조건이 참(TRUE)일 때 결과를 조회

java의 비교 연산 : a변수와 b변수의 값이 같은지 비교 ==
sql의 비교 연산 : = , sql은 대입 연산이 없다
int a = 5;
int b = 2;
if(a == b){
}

SELECT *
FROM users
WHERE 1 = 2;

emp테이블에서 컬럼과 데이터 타입을 확인
DESC emp;

emp : employee, empno : 사번, ename : 사원 이름, job : 담당업무(직책), MGR : 담당자(관리자)
HIREDATE : 입사일, SAL : 급여, COMM : 성과급, DEPTNO : 부서번호 

SELECT * FROM dept;

emp 테이블에서 직원이 속한 부서번호가 30번보다 큰 부서에 속한 직원을 조회
SELECT *
FROM emp
WHERE deptno >= 30;

!= 다를때
users 테이블에서 사용자 아이디가 userid brown이 아닌 사용자를 조회
SELECT *
FROM users
WHERE userid != 'brown';

1982년 1월 1일 이후에 입사한 직원만 조회
직원의 입사일자 : hiredate 컬럼
emp 테이블의 직원 : 14명
1982년 1월 1일 이후 입사자 3명
1982년 1월 1일 이전 입사자가 11명
SELECT *
FROM emp
WHERE hiredate < TO_DATE('19820101', 'YYYYMMDD');
-- WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');  / 무시가능
-- WHERE hiredate >= TO_DATE('1982.01.01', 'YYYY.MM.DD');

SQL 리터럴
숫자 : .... 20, 30.5
문자 : 싱클 쿼테디션 : 'hello world'
날짜 : TO_DATE('날짜 문자열', '날짜 문자열의 형식')



