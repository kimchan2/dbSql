1.db ��ġ �Ϸ� ������ ORACLE SERVER

DATA DICTIONARY
USER : ����ڰ� ������ ��ü
ALL : user + ����ڰ� ����� �� �ִ� ������ �ο����� ��ü ����
DBA : ��� ��ü
V$ : ���ɰ���

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
    
UPDATE MEMBER2 SET MEM_JOB = '����'
WHERE MEM_NAME = '������';

SELECT mem_name, mem_job
FROM MEMBER2
WHERE MEM_NAME = '������';


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


(������Ʈ)������ �ϴٺ��ϱ� ������ ��������� �ݺ�

1. �ٸ� ����� �ۼ��� ���̺귯���� �츮�� �����ϴ� ������Ʈ�� �����ͼ� ���� ��찡 ���� �߻�
    ==> �����ڰ� ȥ�ڼ� ��� �����ϴ� �� �����
        ==> ����(�α� ���̺귯��)���� �����ڰ� ���� �����ϱ⿡�� �ð��� ������ ����
            ���� ��¥ �����Ϸ��� �ϴ� ��ɿ� ������ �ϰ�
            �������� �͵��� �̹� ���ߵ� ���̺귯���� �����ؼ� ������ ���� ��찡 ����
            
2000�⵵ �ʹݸ� �ϴ��� ������Ʈ�� �ٽ����� �η� �Ѹ��� ���̺귯���� ����
==> ��������� ���̺귯���� �����ϱ� �����ϸ� ����

���� ����(ant, maven, gradle...) ==> apache foundation
������ ������ ������� ¥������� �ۼ��� �ϸ� ��嵵���� �˾Ƽ� ���̺귯���� ����, ����

�ʿ��� ���̺귯���� �������Ͽ� �˷��ָ� apache foundation���� ���̺귯�� ����ҿ��� ���嵵���� ���� �ٿ�

mybatis : �츮�� ����� �ƴ�. �ٸ� ����� ����
        ==> �� ������� �ۼ��� ������ �������
            �� Ŭ�������� xxx �ΰ���?
mybatis : java���� sql�� �ս��� ������ �� �ְԲ� ���ִ� �����ӿ�ũ(���̺귯��)
1. ���ἳ�� ���� �ʿ�
2. ������ sql ������ ��Ƶδ� ���� mapper(xml)

�����
1. db �������� xml���Ϸ� �غ�
2. mybatis�� java �������� �غ�
   ==> 1������ ���� xml������ ����ؼ� ����
3. mapper�� ����/���
4. dao���� 2���� ���� ���� java������ ���� sql�� ����



