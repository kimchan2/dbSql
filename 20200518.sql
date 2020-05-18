sub_a2]
DROP TABLE dept_test;

SELECT *
FROM dept;

DELETE dept
WHERE deptno NOT IN (10, 20, 30, 40);

COMMIT;

CREATE TABLE dept_test as
    SELECT *
    FROM dept;
    
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES(99, 'it1', 'daejeon');
INSERT INTO dept_test VALUES(99, 'it1', 'daejeon');

SELECT *
FROM emp;

DELETE dept_test
WHERE deptno NOT IN ( SELECT deptno FROM emp );

DELETE dept_test
WHERE NOT EXISTS(SELECT 'X'
                 FROM emp
                 WHERE emp.deptno = dept_test.deptno);

SELECT *
FROM dept_test;


sub_a3]

SELECT *
FROM emp_test;

SELECT *
FROM emp_test a
WHERE sal < ( SELECT AVG(sal)
              FROM emp_test b
              WHERE a.deptno = b.deptno
              GROUP BY deptno);
              
SELECT deptno, AVG(sal)
FROM emp_test
GROUP BY deptno;


UPDATE emp_test a SET sal = sal + 200
WHERE sal < ( SELECT AVG(sal)
              FROM emp_test b
              WHERE a.deptno = b.deptno
              GROUP BY deptno);

업데이트 전에 SELECT를 해보자!

SELECT *
FROM emp_test;


공식 용어는 아니지만, 검색-도서에 자주 나오는 표현
서브쿼리의 사용된 방법
1. 확인자 : 상호연관 서브쿼리 (EXISTS)
           ==> 메인 쿼리 부터 실행 ==> 서브쿼리 실행, 순서가 뒤바뀔 수 없음 
2. 공급자 : 서브쿼리가 먼저 실행돼서 메인쿼리에 값을 공급 해주는 역할
13건 : 매니저가 존재하는 직원을 조회
SELECT *
FROM emp
WHERE mgr IN (SELECT empno
              FROM emp);

부서별 급여평균이 전체 급여평균보다 큰 부서의 부서번호, 부서별 급여 평균

부서별 평균 급여 (소수점 둘째 자리까지 결과 만들기)
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;

전체 급여 평균
SELECT ROUND(AVG(sal), 2)
FROM emp;


일반적인 서브쿼리 형태
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal), 2) > (SELECT ROUND(AVG(sal), 2)
                             FROM emp);


WITH 절 : SQL에서 반복적으로 나오는 QUERY BLOCK(SUBQUERY)을 별도로 선언하여
          SQL 실행시 한번만 메모리에 로딩을 하고 반복적으로 사용할 때 메모리 공간의 데이터를
          활용하여 속도 개선을 할 수 있는 KEYWORD
          단, 하나의 SQL에서 반복적인 SQL 블럭이 나오는 것은 잘못 작성한 SQL일 가능성이 높기 때문에
          다른 형태로 변경할수 있는지를 검토 해보는 것을 추천.
WITH emp_avg_sal AS( SELECT ROUND(AVG(sal), 2)
                     FROM emp)
SELECT deptno, ROUND(AVG(sal), 2), (SELECT * FROM emp_avg_sal)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal), 2) > (SELECT * FROM emp_avg_sal);



CONNECT BY LEVEL : 행을 반복하고 싶은 수만큼 복제를 해주는 기능
위치 : FROM(WHERE)절 다음에 기술
DUAL 테이블과 많이 사용

테이블에 행이 한건, 메모리에서 복제
SELECT dual.*, LEVEL
FROM dual
CONNECT BY LEVEL <= 5;

위의 쿼리 말고도 이미 배운 KEYWORD를 이용하여 작성 가능
5행 이상이 존재하는 테이블을 갖고 행을 제한
만약에 우리가 복제할 데이터가 10000건이면 10000건에 대한 DISK I/O가 발생
SELECT ROWNUM
FROM emp
WHERE ROWNUM < 6;



1. 우리에게 주어진 문자열 년월 : 202005
   주어진 년월의 일수를 구하여 일수만큼 행을 생성 ==> 31


달력의 컬럼은 7개 - 컬럼의 기준은 요일 : 특정일자는 하나의 요일에 포함
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');


SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt, 7개 컬럼을 추가로 생성
      일요일이면 dt 컬럼, 월요일이면 dt컬럼, 화요일이면 dt 컬럼, 토요일 이면 dt컬럼
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');


아래 방식으로 SQL을 작성해도 쿼리를 완성하는게 가능하나
가독성 측면에서 너무 복잡하여 인라인뷰를 이용하여 쿼리를 단순하게 만든다
SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt,
       DECODE(TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'd'), '1', TO_DATE(202005, 'YYYYMM') + LEVEL-1) mon -- 일요일1 ~ 토요일7
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');
 
 
컬럼을 간소화 하여 표현
SELECT TO_DATE(202005, 'YYYYMM') ==> dt;

SELECT dt, dt가 월 dt, dt가 화 dt, .... 7개의 컬럼중에 딱 하나의 컬럼에만 dt 값이 표현된다
FROM
(SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt  
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd'));


- 오라클에서는 월~일까지가 같은 주차임
SELECT TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');


-- 어떤 그룹함수를 사용해도 문제 없지만 min을 사용하는게 성능상 제일 좋다고 한다.
SELECT DECODE(d, 1, iw+1, iw) "iw", -- 일요일이면 주차를 + 1
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) thu,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt,
        TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'd') d,
        TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'iw') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);



-- 바인드 변수적용
SELECT DECODE(d, 1, iw+1, iw) "iw", -- 일요일이면 주차를 + 1
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) thu,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1 dt,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'd') d,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'iw') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


SELECT
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) thu,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1 dt,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'd') d,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'iw') iw,
        TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) - TO_CHAR( TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'd' ) + 1 f_sun
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'dd'))
GROUP BY f_sun
ORDER BY f_sun;



create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;


SELECT *
FROM SALES;

SELECT DECODE(MONTH, 01, sum) JAN,
       DECODE(MONTH, 02, sum) FEB,
       DECODE(MONTH, 03, sum) MAR,
       DECODE(MONTH, 04, sum) APR,
       DECODE(MONTH, 05, sum) MAY,
       DECODE(MONTH, 06, sum) JUN
FROM
(SELECT TO_CHAR(DT, 'MM') MONTH, SUM(sales) sum
 FROM sales
 GROUP BY TO_CHAR(DT, 'MM'))
GROUP BY ;


SELECT TO_CHAR(DT, 'MM') m, sales
FROM sales;

SELECT MIN(DECODE(MONTH, 01, SUM(sales))) JAN,
       MIN(DECODE(MONTH, 02, SUM(sales))) FEB,
       MIN(DECODE(MONTH, 03, SUM(sales))) MAR,
       MIN(DECODE(MONTH, 04, SUM(sales))) APR,
       MIN(DECODE(MONTH, 05, SUM(sales))) MAY,
       MIN(DECODE(MONTH, 06, SUM(sales))) JUN
FROM
(SELECT TO_CHAR(DT, 'MM') MONTH, sales
 FROM sales)
GROUP BY MONTH;

실습2
첫번째 일요일과 마지막토요일을 구하는법?
5월 1일로 부터 4월 28일


