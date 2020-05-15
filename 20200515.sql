REPORT GROUP FUNCTION == > 확장된 GROUP BY
REPORT GROUP FUNCTION 을 사용 하지 않으면
여러개의 SQL 작성, UNION ALL을 통해서 하나의 결과로 합치는 과정이 필요함
== REPORT GROUP FUNCTION 을 사용해서 좀더 편하게~

ROLLUP : 서브그룹 생성 - 기술된 컬럼을 오른쪽에서부터 지워나가며 GROUP BY를 실행

아래 쿼리의 서브그룹
1. GROUP BY job, deptno
2. GROUP BY job
3. GROUP BY ==> 전체

ROLLUP 사용시 생성되는 서브그룹의 수는 : ROLLUP에 기술한 컬럼수 + 1;
SELECT NVL(job, '총계'), deptno,
       GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


ROLLUP 절에 기술되는 컬럼의 순서는 조회 결과에 영향을 미친다
(***** 서브 그룹을 기술된 컬럼의 오른쪽 부터 제거해 나가면서 생성)

GROUPING
소계 계산에 사용된 경우 1
소계 계산에 사용되지 않은 경우 0

-- group_ad2 CASE/END도 컬럼이다~
SELECT (CASE
            WHEN GROUPING(job) = 1 THEN '총계' -- 그룹핑 대상
            WHEN GROUPING(job) = 0 THEN job -- 그룹핑 대상x
        END) job,
        deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- group_ad2-1
SELECT (CASE
            WHEN GROUPING(job) = 1 THEN '총' -- 그룹핑 대상
            WHEN GROUPING(job) = 0 THEN job -- 그룹핑 대상x
        END) job,
        (CASE
            WHEN GROUPING(job) = 1 THEN '계' -- 그룹핑 대상
            WHEN GROUPING(deptno) = 1 THEN '소계' -- 그룹핑 대상
            WHEN GROUPING(deptno) = 0 THEN TO_CHAR(deptno) -- 그룹핑 대상x
        END) deptno,
        SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT DECODE(GROUPING(job), 1, '총', job) job,
       DECODE(GROUPING(job) + GROUPING(deptno), 2, '계', 1, '소계', 0, deptno) deptno,
       DECODE(GROUPING(job) || GROUPING(deptno), 11, '계', 01, '소계', 00, deptno) deptno,
       SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--group_ad3

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--group_ad4
SELECT dept.dname, a.job, a.sal
FROM dept,
    (SELECT deptno, job, SUM(sal) sal
     FROM emp
     GROUP BY ROLLUP (deptno, job)) a
WHERE a.deptno = dept.deptno(+);

SELECT dept.dname, emp.job, SUM(emp.sal)
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dept.dname, emp.job);

--group_ad5
SELECT NVL(dept.dname, '총합'), a.job, a.sal
FROM dept,
    (SELECT deptno, job, SUM(sal) sal
     FROM emp
     GROUP BY ROLLUP (deptno, job)) a
WHERE a.deptno = dept.deptno(+);


2. GROUPING SETS
ROLLUP의 단점 : 관심없는 서브그룹도 생성 해야한다.
               ROLLUP절에 기술한 컬럼을 오른쪽에서 지워나가기 때문에
               만약 중간과정에 있는 서브그룹이 불필요 할 경우 낭비임
               
GROUPING SETS : 개발자가 직접 생성할 서브그룹을 명시
사용법 : GROUP BY GROUPING SETS (col1, col2)
GROUP BY col1
UNION ALL
GROUP BY col2

GROUP BY GROUPING SETS (col2, col1)
GROUP BY col2
UNION ALL
GROUP BY col1


SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(job, deptno);

SELECT job, null deptno, SUM(sal)
FROM emp
GROUP BY job
UNION ALL
SELECT null, deptno, SUM(sal)
FROM emp
GROUP BY deptno;

그룹기준을 
1. job, deptno
2. mgr

GROUP BY GROUPING SETS ( (job, deptno), mgr )

SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY GROUPING SETS ( (job, deptno), mgr );



3. CUBE
사용법 : GROUP BY CUBE (col1, col2, ...)
기술된 컬럼의 가능한 모든 조합 (순서는 지킨다)

GROUP BY CUBE (job, deptno);

    1       2
  job,    deptno
  job,      x
    x,    deptno
    x,      x
    
SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE (job, deptno);


여러개의 REPORT GROUP 사용하기
SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

** 발생 가능한 조합을 계산   
1       2       3
job     deptno  mgr ==> GROUP BY job, deptno, mgr
job     x       mgr ==> GROUP BY job, mgr
job     deptno  x   ==> GROUP BY job, deptno
job     x       x   ==> GROUP BY job


SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(job, deptno), CUBE(mgr);

1       2       3       4
job     job     deptno  mgr ==> GROUP BY job, deptno, mgr
job     job     x       mgr ==> GROUP BY job, mgr
job     x       x       mgr ==> GROUP BY job, mgr
job     job     deptno  x   ==> GROUP BY job, deptno
job     job     x       x   ==> GROUP BY job
job     x       x       x   ==> GROUP BY job




상호 연관 서브쿼리 업데이트
1. emp테이블을 이용하여 emp_test 테이블 생성
   ==> 기존에 생성된 emp_test 테이블 삭제 먼저 진행
   DROP TABLE emp_test;
   CREATE TABLE emp_test AS
    SELECT *
    FROM emp
    WHERE 1=1;
    
    DESC emp_test;
2. emp_test 테이블에 dname컬럼 추가(dept 테이블 참고)
    DESC dept;
    ALTER TABLE emp_test ADD (dname VARCHAR2(14));
    DESC emp_test;
    
3. subquery를 이용하여 emp_test 테이블에 추가된 dname 컬럼을 업데이트 해주는 쿼리 작성
    emp_test의 dname 컬럼의 값을 dept 테이블의 dname 컬럼으로 update
    emp_test테이블의 deptno 값을 확인해서 dept 테이블의 deptno 값이랑 일치하는 dname 컬럼 값을 가져와 update
    SELECT *
    FROM emp_test;

    MERGE INTO emp_test
    USING dept
    ON (emp_test.deptno = dept.deptno)
    WHEN MATCHED THEN
        UPDATE SET dname = dept.dname;

    ROLLBACK;

    emp_test테이블의 dname 컬럼을 dept 테이블을 이용해서 dname 값 조회하여 업데이트
    update 대상이 되는 행 : 14 ==> WHERE 절을 기술하지 않음
    모든 직원을 대생으로 dname 컬럼을 dept 테이블에서 조회하여 업데이트
    UPDATE emp_test SET dname = (SELECT dname
                                 FROM dept
                                 WHERE emp_test.deptno = dept.deptno);
    SELECT *
    FROM emp_test;
    
    
-- sub_a1
DROP TABLE dept_test;

SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
    SELECT *
    FROM dept
    WHERE 1 = 1;
    
ALTER TABLE dept_test ADD empcnt NUMBER;
DESC dept_test;

UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                               FROM emp
                               WHERE dept_test.deptno = emp.deptno
                               GROUP BY deptno);                        

SELECT 결과 전체를 대상으로 그룹함수를 적용한 경우 대상되는 행이 없더라도 0값이 리턴                               
SELECT COUNT(*)
FROM emp
WHERE 1 = 2; -- GROUP BY 절이 없기 때문에 만족하는 행이 없으면 0

GROUP BY 절을 기술할 경우 대상이 되는 행이 없을 경우 조회되는 행이 없다
SELECT COUNT(*)
FROM emp
WHERE 1 = 2
GROUP BY deptno; -- GROUP BY 절이 없기 때문에 만족하는 행이 없으면 조회결과 행이 없음 <== GROUP BY 굳이 할필요 없음


SELECT *
FROM dept_test;
SELECT *
FROM emp;

ROLLBACK;

MERGE INTO dept_test
USING (SELECT deptno, COUNT(*) cnt FROM emp GROUP BY deptno) emp
ON (dept_test.deptno = emp.deptno)
WHEN MATCHED THEN
    UPDATE SET empcnt = emp.cnt;