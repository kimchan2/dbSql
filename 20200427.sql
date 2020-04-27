GROUP BY
여러행이 하나로 묶이는게 핵심


DBMS : DataBase Management System
 ==> db
RDBMS : Relational DataBase Management System
 ==> 관계형 데이터베이스 관리 시스템
        80년 초반
        
JOIN 문법의 종류
ANSI - 표준
벤더사의 문법(ORACLE)
        

JOIN의 경우 다른 테이블의 컬럼을 사용할 수 있기 때문에
SELECT 할 수 있는 컬럼의 개수가 많아진다(가로 확장)


NATURAL JOIN 
    . 조인하려는 두 테이블의 연결고리 컬럼의 이름이 같을 경우
    . emp, dept 테이블에는 deptno라는 공통된(동일한 타입, 이름의) 연결고리 컬럼이 존재
    . 다른 ANSI-SQL 문법을 통해서 대체가 가능하고, 조인 테이블들의 컬럼명이 도일하지 않으면
      사용이 불가능하기 때문에 사용빈도는 다소 낮다

    
.emp 테이블 : 14건
.dept 테이블 : 4건

조인 하려고 하는 컬럼을 별도 기술하지 않음
SELECT *
FROM emp NATURAL JOIN dept;

ORACLE 조인 문법을 ANSI 문법처럼 세분화 하지 않음
오라클 조인 문법
 1. 조인할 테이블 목록을 FROM 절에 기술하며 구분자는 콜론(,)
 2. 연결고리 조건을 WHERE절에 기술하면 된다 (ex : WHERE emp.deptno = dept.deptno)
 
 SELECT *
 FROM emp, dept
 WHERE emp.deptno = dept.deptno;
 
 deptno가 10번인 직원들만 dept 테이블과 조인 하여 조회

 SELECT *
 FROM emp, dept
 WHERE emp.deptno = 10 AND emp.deptno = dept.deptno;

 ANSI-SQL : JOIN with USING
  . join 하려는 테이블간 이름이 같은 컬럼이 2개 이상일 때
  . 개발자가 하나의 컬럼으로만 조인하고싶을 때 조인 컬렴명을 기술
  
 SELECT *
 FROM emp JOIN dept USING (deptno);
 
 ANSI-SQL : JOIN with ON
  . 조인 하려는 두 테이블간 컬럼명이 다를 때
  . ON절에 연결고리 조건을 기술
  
 SELECT *
 FROM emp JOIN dept ON (emp.deptno = dept.deptno);
 
 ORACLE 문법으로 위 SQL을 작성
 SELECT *
 FROM emp, dept
 WHERE emp.deptno = dept.deptno;
 
 
 
 JOIN의 논리적인 구분
 SELF JOIN : 조인하려는 테이블이 서로 같을 때
 emp 테이블의 한행은 직원의 정보를 나타내고 직원의 정보중 mgr 컬럼은 해당 직원의 관리자 사번을 관리
 해당 직원의 관리자의 이름을 알고싶을 때

 ANSI-SQL로 SQL 조인 :
 조인하려고 하는 테이블 emp(직원), emp(직원의 관리자)
            연결고리 컬럼 : 직원.mgr = 관리자.empno
            ==> 조인 컬럼 이름이 다르다(mgr, empno)
                 ==> NATURAL JOIN, JOIN WITH USING은 사용이 불가능한 형태
                     ==> JOIN with ON
 
 SELECT *
 FROM emp a JOIN emp b ON (a.mgr=b.empno);
                     
 SELECT *
 FROM emp a, emp b
 WHERE a.mgr = b.empno;
 
 
 NONEQUI JOIN : 연결고리 조건이 = 이 아닐때
 
 그동안 WHERE에서 사용한 연산자 : =, !=, <>, <=, <, >, >=
                             AND, OR, NOT
                             LIKE %, _
                             OR - IN
                             BETWEEN AND ==> >=, <=
                             
 SELECT *
 FROM emp;
 
 SELECT *
 FROM salgrade;
 
 SELECT *
 FROM emp JOIN salgrade ON ( LOSAL <= emp.sal AND HISAL >= emp.sal );
 
 SELECT empno, ename, sal, salgrade.grade
 FROM emp JOIN salgrade ON ( emp.sal BETWEEN salgrade.losal AND salgrade.hisal );
 
 SELECT *
 FROM emp, salgrade
 WHERE losal <= emp.sal AND hisal >= emp.sal;
 
 
 -- 실습 join0
 SELECT empno, ename, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno )
 ORDER BY dname;
 
 SELECT empno, ename, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno
 ORDER BY dname;
 
 -- 실습 join0_1
 
 SELECT empno, ename, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno AND emp.deptno IN(10,30))
 ORDER BY empno ASC;
 
 SELECT empno, ename, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno AND a.deptno IN (10, 30)
 ORDER BY empno ASC;
 
 -- 실습 join0_2
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a JOIN dept b ON ( a.deptno = b.deptno AND sal > 2500 )
 ORDER BY a.deptno;
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno AND sal > 2500
 ORDER BY a.deptno;
 
 -- 실습 join0.3~4 과제
 
 --3
 SELECT empno, ename, sal, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600 )
 ORDER BY deptno;
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno
       AND sal > 2500
       AND empno > 7600
 ORDER BY deptno;
 --4
 SELECT empno, ename, sal, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno
                         AND sal > 2500
                         AND empno > 7600
                         AND dname = 'RESEARCH' )
 ORDER BY empno DESC;
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno
       AND sal > 2500
       AND empno > 7600
       AND dname = 'RESEARCH'
 ORDER BY empno DESC;
 
 -- 실습 join1
 
 SELECT lprod_gu, lprod_nm, prod_id, prod_name
 FROM prod JOIN lprod ON ( prod_lgu = lprod_gu );
 
 SELECT lprod_gu, lprod_nm, prod_id, prod_name
 FROM prod, lprod
 WHERE prod_lgu = lprod_gu;