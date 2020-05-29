1.db 설치 완료 보고서 ORACLE SERVER

DATA DICTIONARY
USER : 사용자가 소유한 객체
ALL : user + 사용자가 사용할 수 있는 권한을 부여받은 객체 까지
DBA : 모든 객체
V$ : 성능관련

SELECT *
FROM DBA_USERS;

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ( 'LPROD', 'PROD' )
      AND constraint_type IN ('P', 'R');
      
SELECT *
FROM MEMBER;

CREATE TABLE MEMBER2 AS
    SELECT *
    FROM MEMBER;
    
UPDATE MEMBER2 SET MEM_JOB = '군인'
WHERE MEM_NAME = '김은대';

SELECT mem_name, mem_job
FROM MEMBER2
WHERE MEM_NAME = '김은대';


CREATE OR REPLACE VIEW VW_PROD_BUY AS
    SELECT buy_prod, SUM(BUY_COST) buy_cost
    FROM buyprod
    GROUP BY buy_prod;

SELECT *
FROM vw_prod_buy;

SELECT *
FROM user_views;

create or replace PROCEDURE proc_test1 (p_yyyymm IN VARCHAR2) IS
    CURSOR cycle_cur IS SELECT * FROM cycle;
    TYPE cal_rec_type IS RECORD (
        dt VARCHAR2(8),
        d VARCHAR2(1)
    );
    TYPE cal_rec_tab_type IS TABLE OF cal_rec_type INDEX BY BINARY_INTEGER;
    cal_rec_tab cal_rec_tab_type;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') DT,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
           BULK COLLECT INTO cal_rec_tab
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'DD');
    DELETE daily
    WHERE dt BETWEEN TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM'), 'YYYYMMDD') AND
                     TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'YYYYMMDD');
    FOR cycle_row IN cycle_cur LOOP
        FOR i IN 1..cal_rec_tab.COUNT LOOP
            IF cycle_row.day = cal_rec_tab(i).d THEN
                INSERT INTO daily VALUES (cycle_row.cid, cycle_row.pid, cal_rec_tab(i).dt, cycle_row.cnt);
            END IF;
        END LOOP;
    END LOOP; 
    COMMIT;
END;
/

SELECT cart_member, SUM(cart_qty)
FROM cart
GROUP BY cart_member;

SELECT cart.*, SUM(cart_qty) OVER (PARTITION BY cart_prod) sum
FROM cart;


(프로젝트)개발을 하다보니까 뭔가가 계속적으로 반복

1. 다른 사람이 작성한 라이브러리를 우리가 진행하는 프로젝트에 가져와서 쓰는 경우가 많이 발생
    ==> 개발자가 혼자서 모든 개발하는 건 어려움
        ==> 비기능(로깅 라이브러리)까지 개발자가 직접 개발하기에는 시간적 여유가 부족
            내가 진짜 개발하려고 하는 기능에 집중을 하고
            공통적인 것들은 이미 개발된 라이브러리를 복사해서 가져다 쓰는 경우가 많음
            
2000년도 초반만 하더라도 프로젝트의 핵심적인 인력 한명이 라이브러리를 관리
==> 여러사람이 라이브러리를 관리하기 시작하면 꼬임

빌드 도구(ant, maven, gradle...) ==> apache foundation
정해진 형식을 갖춰놓고 짜여진대로 작성을 하면 빈드도구가 알아서 라이브러리를 복사, 관리

필요한 라이브러리를 설정파일에 알려주면 apache foundation에서 라이브러리 저장소에서 빌드도구를 통해 다운

mybatis : 우리가 만든게 아님. 다른 사람이 만듦
        ==> 그 사람들이 작성한 사용법을 따라야함
            왜 클래스명이 xxx 인가요?
mybatis : java에서 sql을 손쉽게 실행할 수 있게끔 해주는 프레임워크(라이브러리)
1. 연결설정 정보 필요
2. 실행할 sql 정보를 모아두는 파일 mapper(xml)

사용방법
1. db 연결정보 xml파일로 준비
2. mybatis의 java 설정파일 준비
   ==> 1번에서 만든 xml파일을 사용해서 설정
3. mapper를 생성/등록
4. dao에서 2번에 만든 설정 java파일을 통해 sql을 실행




