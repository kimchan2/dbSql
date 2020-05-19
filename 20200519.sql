'202005' ==> 일반적인 달력을 row, col;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);


JOIN 수업할 때
CROSS JOIN : 데이터 복제 할 때...


부서번호별, 전체 행 별 SAL 합을 구하는 3번째 방법
SELECT DECODE(lv, 1, deptno, 2, null), SUM(sal)
FROM emp, (SELECT level lv
           FROM dual
           CONNECT BY LEVEL <= 2)
GROUP BY DECODE(lv, 1, deptno, 2, null)
ORDER BY DECODE(lv, 1, deptno, 2, null);
           
서브쿼리 1, 2 나옴 ==> 가능한 모든조합이 1,2에 대해 나옴 데이터가 2배~


create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;


계층형 쿼리
START WITH : 계층 쿼리의 시작점 기술
CONNECT BY  : 계층(행)간 연결고리를 표현

xx회사부터(최상위 노드)에서 부터 하향식으로 조직구조를 탐색하는 오라클 계층형 쿼리 작성
1. 시작점을 선택 : xx회사
2. 계층간(행과 행) 연결고리 표현
    PRIOR : 내가 현재 읽고 있는 행을 표현
    아무것도 붙이지 않음 : 내가 앞으로 읽을 행을 표현

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;
-- 내가 읽고있는 행의 deptcd가 앞으로 읽을행의 p_deptcd와 같은것


실습 h_1]

SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm, p_deptcd -- LEVEL이 1이면 xx회사이면 들여쓰기가 안됨
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

실습 h_2]
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


상향식
시작점 : 디자인팀 - dept0_00_0

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;


실습 h_3]

SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;


실습 h_4]
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;


SELECT *
FROM h_sum;

DESC h_sum;

SELECT LPAD(' ', (LEVEL-1)*3) || S_ID as S_ID, VALUE
FROM h_sum
START WITH S_ID = 0
CONNECT BY PRIOR s_id = ps_id;


실습 h_5]
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

DESC no_emp;

SELECT *
FROM no_emp;

CONNECT BY 이후에 이어서 PRIOR가 오지 않아도 괜찮다
PRIOR는 현재 읽고 있는 행을 지칭하는 키워드!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT LPAD(' ', (LEVEL-1)*4) || org_cd as org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
--CONNECT BY PRIOR org_cd = parent_org_cd; 둘다 가능
CONNECT BY parent_org_cd = PRIOR org_cd;


Pruning branch : 가지 치기
WHERE절에 조건을 기술 했을 때 : 계층형 쿼리를 실행후 가장 마지막에 적용
CONNECT BY 절에 기술 했을 때 : 연결중에 조건이 적용
차이를 비교

*단 계층형 쿼리는 FROM -> START WITH CONNECT BY -> WHERE 순으로 처리된다

1. WHERE절에 조건을 기술한 경우

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

2. CONNECT BY 절에 조건을 기술한 경우

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';


계층형 쿼리에서 사용할 수 있는 특수 함수
CONNECT_BY_ROOT(column) : 해당 컬럼의 최상위 데이터를 조회
SYS_CONNECT_BY_PATH(column, 구분자) : 해당 행을 오기까지 거쳐온 행의 column들을 포현하고 구분자를 통해 연결
CONNECT_BY_ISLEAF 인자가 없음 : 해당 행이 연결이 더이상 없는 마지막 노드인지 (LEAF 노드)
                               LEAF노드 : 1, NO LEAF 노드 : 0

원본글
    ==답글
        ==답글
        
원본글
    ==답글
    ==답글
        
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd,
       CONNECT_BY_ROOT(deptnm),
       LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-'), -- LTRIM(문자1, 문자2) 문자1에서 맨왼쪽의 문자2를 지움
       CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


실습 h_6]
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덟번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT *
FROM board_test;

DESC board_test;

SELECT SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;


실습 h_7] 최신글이 위로 오도록
계층형 쿼리를 정렬시 계층 구조를 유지하면서 정렬하는 기능이 제공
ORDER SIBLINGS BY

SELECT SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;


실습 h_8]
계층형 쿼리를 정렬시 계층 구조를 유지하면서 정렬하는 기능이 제공
ORDER SIBLINGS BY

SELECT SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;


실습 h_9]
SELECT *
FROm board_test;

SELECT CONNECT_BY_ROOT(seq) nseq, SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY nseq DESC, seq;

ALTER TABLE board_test ADD (gp_no NUMBER);
UPDATE board_test SET gp_no = 4
WHERE seq IN (4, 10, 11, 5, 8, 6, 7);
UPDATE board_test SET gp_no = 2
WHERE seq IN (2, 3);
UPDATE board_test SET gp_no = 1
WHERE seq IN (1, 9);


전체 직원중에 가장 높은 급여를 받는 사람의 급여정보
근데 그게 누군데??
emp 테이블을 2번 읽어서 목적은 달성 ==> 조금 더 효율적인 방법이 없을까?? ==> WINDOW/ANALYSIS FUNCTION 
SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal) FROM emp);


실습 ana0]

SELECT c.ename, c.sal, c.deptno, f.lv
FROM
    (SELECT e.*, ROWNUM rn
     FROM(SELECT ename, sal, deptno
          FROM emp
          ORDER BY deptno, sal DESC) e) c,

    (SELECT ROWNUM rn, d.*
     FROM
        (SELECT a.*, b.lv
         FROM
        (SELECT deptno, COUNT(*) cnt
         FROM emp
         GROUP BY deptno) a, (SELECT LEVEL lv
                              FROM dual
                              CONNECT BY LEVEL <= 6) b
         WHERE a.cnt >= lv
         ORDER BY a.deptno, b.lv) d) f
WHERE f.rn = c.rn;


SELECT ename, sal, deptno, ROWNUM sal_rank
FROM emp
WHERE deptno = 10
ORDER BY sal DESC;

