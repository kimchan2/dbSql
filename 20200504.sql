연산자

사칙 연산자 : +, -, *, /
삼항 연산자 : ?  1==1 ? true일 때 실행 : false일 때 실행

SQL 연산자
= : 컬럼|표현식 = 값 ==> 이항 연산자
IN : 컬럼|표현식 IN (집합)
    deptno IN (10, 30)
    
EXISTS 연산자
사용방법 : EXISTS (서브쿼리)
서브쿼리의 조회결과가 한건이라도 있으면 TRUE
잘못된 사용방법 : WHERE deptno EXISTS (서브쿼리)

메인쿼리의 값과 관계 없이 서브쿼리의 실행 결과는 항상 존재 하기 때문에
emp 테이블의 모든 데이터가 조회 된다

아래 쿼리는 비상호 서브쿼리
일반적으로 EXISTS 연산자는 상호연관 서브쿼리로 많이 사용

EXISTS 연산자의 장점
만족하는 행을 하나라도 발견을 하면 더이상 탐색을 하지 않고 중단함
행의 존재 여부에 관심이 있을 때 사용

SELECT *
FROM emp
WHERE EXISTS (SELECT 'X'
              FROM dept);
              
매니저가 없는 직원 : KING
매니저 정보가 존재하는 직원 : 13명의 직원

SELECT *
FROM emp e
WHERE EXISTS ( SELECT 'X' -- 컬럼의 값이 중요한게 아니고 행의 유무가 중요하기 때문에 'X'란 값으로 대체해줌
               FROM emp m
               WHERE e.mgr = m.empno);

IS NOT NULL을 통해서도 동일한 결과를 만들어 낼 수 있다
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

join
SELECT e.*
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- 실습 sub9

SELECT *
FROM cycle;

SELECT *
FROM product;

1번 고객이 먹는 제품정보
SELECT *
FROM cycle
WHERE cid = 1;

SELECT *
FROM product
WHERE EXISTS (SELECT *
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);
              
-- 실습 sub10              

SELECT *
FROM product
WHERE NOT EXISTS (SELECT *
                  FROM cycle
                  WHERE cid = 1
                    AND cycle.pid = product.pid);
          
집합연산
합집합
(1, 5, 3) U (2, 3) = {1, 2, 3, 5}

SQL에만 존재하는 UNION ALL (중복 데이터를 제거하지 않는다)
(1, 5, 3) U (2, 3) = {1, 5, 3, 2, 3}

교집합
(1, 5, 3) 교집합 (2, 3) = {3}

차집합
(1, 5, 3) - (2, 3) = {1, 5}

SQL에서의 집합연산
연산자 : UNION, UNION ALL, INTERSECT, MINUS
두개의 SQL의 실행결과를 행을 확장 (위, 아래로 결합 된다)

UNION 연산자 : 중복제거(수학적 개념의 집합과 동일);

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

UNION ALL 연산자 : 중복허용

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

INTERSECT 교집합 : 두집합간 중복되는 요소만 조회

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

MINUS 연산자 : 위쪽 집합에서 아래쪽 집합 요소를 제거

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);



SQL 집합연산자의 특징

1. 열의 이름 : 첫번 SQL의 컬럼을 따라간다

첫번째 쿼리의 컬럼명에 별칭 부여
두번째 쿼리는 별칭을 안주었지만 전체 실행결과에 첫번째 컬럼 별칭을 따라감
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)
UNION
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7698);

2. 정렬을 하고싶을 경우 마지막에 적용 가능 개별 SQL에는 ORDER BY 불가 (인라인뷰를 사용하여 메인쿼리에서 ORDER BY가 기술되지 않으면 가능)
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)
-- ORDER BY nm, 중간 쿼리에 정렬 불가
UNION
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7698)
ORDER BY nm;

3. SQL의 집합 연산자는 중복을 제거한다(수학적 집합 개념과 동일), UNION ALL은 중복 허용

4. 두개의 집합에서 중복을 제거하기 위해 각각의 집합을 정렬하는 작업이 필요
   ==> 사용자에게 결과를 보내주는 반응성이 느려짐
      ==> UNION ALL을 사용할 수 있는 상황일 경우 UNION을 사용하지 않아야 속도적인 측면에서 유리하다
   
알고리즘( 정렬 - 버블정렬, 삽입정렬, .....
           자료구조 : 트리구조(이진트리, 밸런스 트리)
                     heap
                     stack, queue
                     list
                     
집합연산에서 중요한 사항 : 중복제거

도시발전지수
사용된 SQL 문법 : WHERE, 그룹연산을 위한 GROUP BY, 복수행 함수(COUNT), 
                인라인 뷰, ROWNUM, ORDER BY, 별칭(컬럼, 테이블), ROUND, JOIN

SELECT ROWNUM rank, SIDO, SIGUNGU, jisu
FROM (SELECT SIDO, SIGUNGU, ROUND((beg+mac+kfc)/(CASE
                                                 WHEN lot = 0 THEN 1
                                                 WHEN lot > 0 THEN lot
                                                 END), 2) jisu
      FROM(SELECT SIDO, SIGUNGU, COUNT(CASE
                                       WHEN GB = '롯데리아' Then 1
                                       END) lot, COUNT(CASE
                                                       WHEN GB = '버거킹' Then 1
                                                       END) beg, COUNT(CASE
                                                                       WHEN GB = '맥도날드' Then 1
                                                                       END) mac, COUNT(CASE
                                                                                       WHEN GB = 'KFC' Then 1
                                                                                       END) kfc
          FROM FASTFOOD  
          GROUP BY SIDO, SIGUNGU)
      ORDER BY jisu DESC);


SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = '롯데리아'
GROUP BY SIDO, SIGUNGU;

SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = '버거킹'
GROUP BY SIDO, SIGUNGU;

SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = '맥도날드'
GROUP BY SIDO, SIGUNGU;

SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = 'KFC'
GROUP BY SIDO, SIGUNGU;

SELECT beg.SIDO, beg.SIGUNGU, ROUND((Beg.Cnt+Mac.Cnt+Kfc.Cnt)/rot.cnt, 2) num
FROM (SELECT SIDO, SIGUNGU, COUNT(*) cnt
      FROM FASTFOOD
      WHERE GB = '버거킹'
      GROUP BY SIDO, SIGUNGU) beg , (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                     FROM FASTFOOD
                                     WHERE GB = '맥도날드'
                                     GROUP BY SIDO, SIGUNGU) mac, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                   FROM FASTFOOD
                                                                   WHERE GB = 'KFC'
                                                                   GROUP BY SIDO, SIGUNGU) kfc, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                                                 FROM FASTFOOD
                                                                                                 WHERE GB = '롯데리아'
                                                                                                 GROUP BY SIDO, SIGUNGU) rot
WHERE beg.SIDO = mac.SIDO AND mac.SIDO = kfc.SIDO AND kfc.SIDO = rot.SIDO 
AND beg.SIGUNGU = Mac.Sigungu AND Mac.SIGUNGU = kfc.SIGUNGU AND kfc.SIGUNGU = rot.SIGUNGU
ORDER BY num DESC;                                



SELECT ROWNUM RANK, sido, sigungu, num
FROM (SELECT beg.SIDO as sido, beg.SIGUNGU as sigungu, ROUND((Beg.Cnt+Mac.Cnt+Kfc.Cnt)/rot.cnt, 2) num
      FROM (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM FASTFOOD
            WHERE GB = '버거킹'
            GROUP BY SIDO, SIGUNGU) beg , (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                           FROM FASTFOOD
                                           WHERE GB = '맥도날드'
                                           GROUP BY SIDO, SIGUNGU) mac, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                         FROM FASTFOOD
                                                                         WHERE GB = 'KFC'
                                                                         GROUP BY SIDO, SIGUNGU) kfc, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                                                       FROM FASTFOOD
                                                                                                       WHERE GB = '롯데리아'
                                                                                                       GROUP BY SIDO, SIGUNGU) rot
WHERE beg.SIDO = mac.SIDO AND mac.SIDO = kfc.SIDO AND kfc.SIDO = rot.SIDO 
  AND beg.SIGUNGU = Mac.Sigungu AND Mac.SIGUNGU = kfc.SIGUNGU AND kfc.SIGUNGU = rot.SIGUNGU
ORDER BY num DESC);
-- 버거킹 = 맥도날드, 버거킹 = kfc, 버거킹 = 롯데리아 한 결과랑 위에랑 다름, 행의 수가 각각 다르기때문에

SELECT ROWNUM RANK, sido, sigungu, num
FROM (SELECT beg.SIDO as sido, beg.SIGUNGU as sigungu, ROUND((Beg.Cnt+Mac.Cnt+Kfc.Cnt)/rot.cnt, 2) num
      FROM (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM FASTFOOD
            WHERE GB = '버거킹'
            GROUP BY SIDO, SIGUNGU) beg , (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                           FROM FASTFOOD
                                           WHERE GB = '맥도날드'
                                           GROUP BY SIDO, SIGUNGU) mac, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                         FROM FASTFOOD
                                                                         WHERE GB = 'KFC'
                                                                         GROUP BY SIDO, SIGUNGU) kfc, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                                                       FROM FASTFOOD
                                                                                                       WHERE GB = '롯데리아'
                                                                                                       GROUP BY SIDO, SIGUNGU) rot
WHERE beg.SIDO = mac.SIDO AND mac.SIDO = kfc.SIDO AND kfc.SIDO = rot.SIDO 
  AND beg.SIGUNGU = Mac.Sigungu AND Mac.SIGUNGU = kfc.SIGUNGU AND kfc.SIGUNGU = rot.SIGUNGU
ORDER BY num DESC);




--필수
과제1] fastfood 테이블과 tax 테이블을 이용하여 다음과 같이 조회되도록 SQL 작성
 1. 시도 시군구별 도시발전지수를 구하고(지수가 높은 도시가 순위가 높다) 
 2. 인당 연말 신고액이 높은 시도 시군구별로 순위를 구하여
 3. 도시발전지수와 인당 신고액 순위가 같은 데이터끼리 조인하여 아래와 같이 컬럼이 조회되도록 작성
 
순위, 햄버거 시도, 햄버거 시군구, 햄버거 도시발전지수, 국세청 시도, 국세청 시군구, 국세청 연말정산 금액1인당 신고액

SELECT *
FROM tax;

SELECT ROWNUM tax_rank, sido tax_sido, sigungu tax_sigungu, tax_jisu  -- 국세청 순위
FROM (SELECT sido, sigungu, people, sal, ROUND(sal/people, 2) tax_jisu
      FROM tax
      ORDER BY tax_jisu DESC);


SELECT ham_rank as rank, ham_sido, ham_sigungu, ham_jisu, tax_sido, tax_sigungu, tax_jisu
FROM (SELECT ROWNUM ham_rank, SIDO ham_sido, SIGUNGU ham_sigungu, ham_jisu
      FROM (SELECT SIDO, SIGUNGU, ROUND((beg+mac+kfc)/(CASE
                                                       WHEN lot = 0 THEN 1
                                                       WHEN lot > 0 THEN lot
                                                       END), 2) ham_jisu
            FROM(SELECT SIDO, SIGUNGU, COUNT(CASE
                                             WHEN GB = '롯데리아' Then 1
                                             END) lot, COUNT(CASE
                                                             WHEN GB = '버거킹' Then 1
                                                             END) beg, COUNT(CASE
                                                                             WHEN GB = '맥도날드' Then 1
                                                                             END) mac, COUNT(CASE
                                                                                             WHEN GB = 'KFC' Then 1
                                                                                             END) kfc
                 FROM FASTFOOD  
                 GROUP BY SIDO, SIGUNGU)
                 ORDER BY ham_jisu DESC)) ham

, (SELECT ROWNUM tax_rank, sido tax_sido, sigungu tax_sigungu, tax_jisu 
   FROM (SELECT sido, sigungu, people, sal, ROUND(sal/people, 2) tax_jisu
         FROM tax
         ORDER BY tax_jisu DESC)) tax
WHERE ham.ham_rank = tax.tax_rank;


--옵션
과제2] 햄버거 도시발전 지수를 구하기 위해 4개의 인라인 뷰를 사용 하였는데 (fastfood 테이블을 4번 사용)
이를 개선하여 테이블을 한번만 읽는 형태로 쿼리를 개선 (fastfood 테이블을 1번만 사용), CASE나 DECODE 이용

SELECT ROWNUM rank, SIDO, SIGUNGU, jisu
FROM (SELECT SIDO, SIGUNGU, ROUND((beg+mac+kfc)/(CASE
                                                 WHEN lot = 0 THEN 1
                                                 WHEN lot > 0 THEN lot
                                                 END), 2) jisu
      FROM(SELECT SIDO, SIGUNGU, COUNT(CASE
                                       WHEN GB = '롯데리아' Then 1
                                       END) lot, COUNT(CASE
                                                       WHEN GB = '버거킹' Then 1
                                                       END) beg, COUNT(CASE
                                                                       WHEN GB = '맥도날드' Then 1
                                                                       END) mac, COUNT(CASE
                                                                                       WHEN GB = 'KFC' Then 1
                                                                                       END) kfc
          FROM FASTFOOD  
          GROUP BY SIDO, SIGUNGU)
      ORDER BY jisu DESC);
      
과제3] 햄버거 지수 sql을 다른형태로 도전하기
-- 원래 테이블을 시도 시군구로 그룹지은 다음 롯데리아, 맥도날드, 버거킹, KFC와 아우터조인 적용, NULL은 0처리
SELECT *
FROM fastfood;

SELECT origin.sido, origin.sigungu,
       NVL(lot_num, 0) as lot_num,
       NVL(beg_num, 0) as beg_num,
       NVL(mac_num, 0) as mac_num,
       NVL(kfc_num, 0) as kfc_num,
       ROUND( ( (NVL(beg_num, 0) + NVL(mac_num, 0) + NVL(kfc_num, 0)) / NVL(lot_num, 1) ), 2 ) as ham_jisu
FROM(SELECT sido, sigungu
     FROM fastfood
     GROUP BY sido, sigungu) origin, (SELECT sido, sigungu, count(*) lot_num
                                      FROM FASTFOOD
                                      WHERE gb = '롯데리아'
                                      GROUP BY sido, sigungu) lot, (SELECT sido, sigungu, count(*) beg_num
                                                                    FROM FASTFOOD
                                                                    WHERE gb = '버거킹'
                                                                    GROUP BY sido, sigungu) beg, (SELECT sido, sigungu, count(*) mac_num
                                                                                                  FROM FASTFOOD
                                                                                                  WHERE gb = '맥도날드'
                                                                                                  GROUP BY sido, sigungu) mac, (SELECT sido, sigungu, count(*) kfc_num
                                                                                                                                FROM FASTFOOD
                                                                                                                                WHERE gb = 'KFC'
                                                                                                                                GROUP BY sido, sigungu) kfc
WHERE origin.sido = lot.sido(+) AND origin.sido = beg.sido(+) AND origin.sido = mac.sido(+) AND origin.sido = kfc.sido(+)
  AND origin.sigungu = lot.sigungu(+) AND origin.sigungu = beg.sigungu(+) AND origin.sigungu = mac.sigungu(+) AND origin.sigungu = kfc.sigungu(+)
ORDER BY ham_jisu DESC;

SELECT sido, sigungu, count(*) mac
FROM FASTFOOD
WHERE gb = '맥도날드'
GROUP BY sido, sigungu;


SELECT * /* lot.sido as sido, lot.sigungu as sigungu, lot_num, mac_num, beg_num, kfc_num */
FROM
(SELECT sido, sigungu, count(*) lot_num
 FROM FASTFOOD
 WHERE gb = '롯데리아'
 GROUP BY sido, sigungu) lot, (SELECT sido, sigungu, count(*) mac_num
                               FROM FASTFOOD
                               WHERE gb = '맥도날드'
                               GROUP BY sido, sigungu) mac, (SELECT sido, sigungu, count(*) beg_num
                                                             FROM FASTFOOD
                                                             WHERE gb = '버거킹'
                                                             GROUP BY sido, sigungu) beg, (SELECT sido, sigungu, count(*) kfc_num
                                                                                           FROM FASTFOOD
                                                                                           WHERE gb = 'KFC'
                                                                                           GROUP BY sido, sigungu) kfc
WHERE lot.sido = mac.sido(+) AND lot.sido = beg.sido(+) AND lot.sido = kfc.sido
  AND lot.sigungu = mac.sigungu(+) AND lot.sigungu = beg.sigungu(+) AND lot.sigungu = kfc.sigungu(+);