NULL 처리하는 방법 4가지 중에 본인 편한걸로 하나 이상은 기억

DESC emp;

SELECT NVL(empno, 0), ename, NVL(sal, 0), NVL(comm, 0)
FROM emp;

구성정보를 보면 empno는 NOT NULL 형식이라 null값이 들어올수 없으므로 NVL이 필요치 않음

condition : CASE, DECODE 다 암기

실행계획 : 실행계획이 뭔지, 보는 순서 알기


 emp 테이블에 등록된 직원들에게 보너스를 추가적으로 지급할 예정
 해당 직원의 job이 SALESMAN일 경우 sal 5% 인상된 금액을 보너스로 지급
 
 해당 직원의 job이 MANAGER이면서 deptno가 10이면 sal 30% 인상된 금액을 보너스로 지급
                            그 외의 부서에 속하는 사람은 10% 인상된 금액을 보너스로 지급
                            
 해당 직원의 job이 PRESIDENT일 경우 sal 20% 인상된 금액을 보너스로 지급
 그외 직원들은 sal만큼만 지급
  SELECT empno, ename, job, deptno, sal,
       DECODE( job, 'SALESMAN', sal * 1.05, 'MANAGER', DECODE(deptno, 10, sal * 1.3, sal * 1.1), 'PRESIDENT', sal * 1.2, sal) as bonus_sal
 FROM emp;
 
 
 SELECT *
 FROM emp
 ORDER BY deptno;



 집합 A = {10, 15 ,18, 23, 24, 25 ,29 ,30 ,35 ,37}
 Prime Number 소수 : { 23, 29, 37} COUNT 3, MAX 23, AVG 29.6 SUM 89
 비소수 : { 10, 15, 18, 24, 25, 30, 35}
 
 SELECT *
 FROM emp
 ORDER BY deptno;
 
 
 
 GROUP FUNCTION
 여러행의 데이터를 이용하여 같은 그룹끼리 묶어 연산하는 함수
 여러행을 입력받아 하나의 행으로 결과가 묶인다
 EX : 부서별 급여 평균
    emp 테이블에는 14명의 직원이 있고, 14명의 직원은 3개의 부서 (10,20,30)에 속해 있다
    부서별 급여 평균은 3개의 행으로 결과가 반환된다.
 
 SELECT 그룹핑 기준 칼럼, 그룹함수
 FROM 테이블
 GROUP BY 그룹핑 기준 컬럼
 [ORDER BY];
 
 GROUP BY 적용시 주의 사항 : SELECT에 기술할 수 있는 컬럼이 제한됨
 
 SELECT deptno, sal
 FROM emp
 GROUP BY deptno, sal;
 
 부서별로 가장 높은 급여 값
 SELECT deptno, MAX(sal)
 FROM emp
 GROUP BY deptno;
 
 SELECT deptno, ename, MAX(sal) ==> 실행이 안됨, deptno로 그룹을 지정 10, 20, 30 해놨는데 ename을 조회함, 예를들어 deptno 10에는 ename이 3개가 있음
 FROM emp                           그중에 무엇을 조회할지가 정해져있지 않음 MIN(ename), MAX(ename)이런식은 괜찮음
 GROUP BY deptno;
 
 SELECT deptno, ROUND(AVG(sal), 2)as sal_avg,
                MAX(sal),
                MIN(sal),
                SUM(sal),
                COUNT(sal), -- 부서별 급여 건수, sal 컬럼의 값이 NULL이 아닌 row의 수
                COUNT(*), -- 부서별 행의 수
                COUNT(mgr)
 FROM emp
 GROUP BY deptno;
 
 * 그룹 함수를 통해 부서번호 별 가장 높은 급여를 구할 수 는 있지만
   가장 높은 급여를 받는 사람의 이름을 알 수는 없다
    ==> 추후 WINDOW/분석 FUCTION을 통해 해결 가능
 
 
 
 emp 테이블의 그룹 기준을 부서번호가 아닌 전체 직원으로 설정 하는 방법
  SELECT ROUND(AVG(sal), 2)as sal_avg,
                MAX(sal), -- 전체 직원중 가장 높은 급여 값
                MIN(sal), -- 전체 직원중 가장 낮은 급여 값
                SUM(sal), -- 전체 직원의 급여 평균
                COUNT(sal), -- 전체 직원중 급여 건수, sal 컬럼의 값이 NULL이 아닌 row의 수
                COUNT(*), -- 전체 행의 수
                COUNT(mgr) -- mgr 칼럼이 NULL이 아닌 건수
 FROM emp;
 
 GROUP BY 절에 기술된 컬럼이
    SELECT 절에 나오지 않으면 상관없지만 
 
 GROUP BY 절에 기술되지 않은 컬럼이 
    SELECT 절에 나오면 에러가 난다
    
 그룹화와 관련 없는 문자열, 상수 등은 SELECT 절에 표현 될 수 있다 (에러 아님);
  SELECT deptno, 'TEST', 1,
                ROUND(AVG(sal), 2)as sal_avg,
                MAX(sal),
                MIN(sal),
                SUM(sal),
                COUNT(sal), -- 부서별 급여 건수, sal 컬럼의 값이 NULL이 아닌 row의 수
                COUNT(*), -- 부서별 행의 수
                COUNT(mgr)
 FROM emp
 GROUP BY deptno;

 GROUP 함수 연산시 NULL 값은 제외가 된다
 30번 부서에는 NULL값을 갖는 행이 있지만 SUM(comm)의 값이 정상적으로 계산된 걸 확인 할 수 있다
 20, 10은 전부 NULL이라 제외됐으므로 결과로 NULL이 나옴
 SELECT deptno, SUM(comm)
 FROM emp
 GROUP BY deptno;

10, 20번 부서의 SUM(comm) 컬럼이 NULL이 아니라 0이 나오도록 NULL 처리
SELECT deptno, NVL(SUM(comm), 0)
 FROM emp
 GROUP BY deptno;
* 특별한 사유가 아니면 그룹함수 계산결과에 NULL 처리를 하는게 성능상 유리하다

NVL(SUM(comm), 0) : COMM 컬럼에 SUM 그룹함수를 적용하고 최종 결과에 NVL을 적용(1회 호출)
SUM(NVL(comm, 0)) : 모든 COMM 컬럼에 NVL 함수를 적용후(해당 그룹의 ROW 수만큼 실행) SUM 그룹함수 적용

single row 함수는 WHERE절에 기술할수 있지만
multi row 함수는(group 함수)는 WHERE절에 기술할 수 없고
GROUP BY 절 이후 HAVING 절에 별도로 기술

single row 함수는 WHERE 절에서 사용가능
SELECT *
FROm emp
WHERE LOWER(ename) = 'smith'; -- 좌변을 가공하지마라, 효율 떨어짐

부서별 급여 합이 5000이 넘는 부서만 조회
SELECT deptno, SUM(sal)
FROM emp
WHERE SUM(sal) > 5000   <== 오류 발생 WHERE절에 사용불가
GROUP BY deptno;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;


-- group function 실습 grp1

SELECT MAX(sal) MAX_SAL,
       MIN(sal) MIN_SAL,
       ROUND(AVG(sal), 2) AVG_SAL,
       SUM(sal) SUM_SAL,
       COUNT(sal) COUNT_SAL,
       COUNT(mgr) COUNT_MGR,
       COUNT(*) COUNT_ALL
       
FROM emp;

-- group function 실습 grp2

SELECT deptno,
       MAX(sal) MAX_SAL,
       MIN(sal) MIN_SAL,
       ROUND(AVG(sal), 2) AVG_SAL,
       SUM(sal) SUM_SAL,
       COUNT(sal) COUNT_SAL,
       COUNT(mgr) COUNT_MGR,
       COUNT(*) COUNT_ALL
       
FROM emp
GROUP BY deptno;

SELECT deptno,
       MAX(sal) MAX_SAL,
       MIN(sal) MIN_SAL,
       ROUND(AVG(sal), 2) AVG_SAL,
       SUM(sal) SUM_SAL,
       COUNT(CASE
                WHEN sal > 3000 THEN sal
             END) COUNT_SAL,
       COUNT(mgr) COUNT_MGR,
       COUNT(*) COUNT_ALL
       
FROM emp
GROUP BY deptno;


-- group function 실습 grp3
SELECT *
FROM emp;

SELECT *
FROM dept;


SELECT DECODE(deptno, '10', 'ACCOUNTING', '20', 'RESEARCH', '30', 'SALES', '40', 'OPERATIONS') DNAME,
       MAX(sal) MAX_SAL,
       MIN(sal) MIN_SAL,
       ROUND(AVG(sal), 2) AVG_SAL,
       SUM(sal) SUM_SAL,
       COUNT(sal) COUNT_SAL,
       COUNT(mgr) COUNT_MGR,
       COUNT(*) COUNT_ALL
       
FROM emp
GROUP BY deptno;


-- grp4

SELECT TO_CHAR(hiredate, 'yyyymm') as HIRE_YYYYMM, COUNT(*) as CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm')
ORDER BY TO_CHAR(hiredate, 'yyyymm') ASC;

-- grp5

SELECT TO_CHAR(hiredate, 'yyyy') as HIRE_YYYYMM, COUNT(*) as CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy')
ORDER BY CNT ASC;

-- grp6

SELECT *
FROM dept;

SELECT COUNT(*) CNT
FROM dept;

-- grp7

SELECT COUNT(*) as CNT
FROM
    (SELECT deptno
    FROM emp
    GROUP BY deptno);