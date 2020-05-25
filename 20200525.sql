pro_3]

1. Ŀ�� �̿�
CREATE OR REPLACE PROCEDURE pro_3_dt2 IS
    CURSOR dt2_cursor IS
        SELECT *
        FROM dt2
        ORDER BY n DESC;
    
    sumValue NUMBER := 0;
    countValue NUMBER := 0;
    lastValue NUMBER := 0;
BEGIN
    FOR dt2Row IN dt2_cursor LOOP
        IF countValue = 0 THEN
            lastValue := dt2Row.n;
        ELSE
            sumValue := sumValue + lastValue - dt2Row.n;
            lastValue := dt2Row.n;
        END IF;
        
        countValue := countValue + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( sumValue / (countValue - 1) );
END;
/

SET SERVEROUTPUT ON;
SET SERVEROUTPUT OFF;

EXEC pro_3_dt2;

2.
CREATE OR REPLACE PROCEDURE pro_3_dt2_table IS
    TYPE dt2_table IS TABLE OF dt2%ROWTYPE INDEX BY BINARY_INTEGER;  
    v_dt2_table dt2_table;
        
    sumValue NUMBER := 0;
    
BEGIN
    SELECT * BULK COLLECT INTO v_dt2_table
    FROM dt2
    ORDER BY n DESC;
    
    FOR i IN 1..v_dt2_table.count-1 LOOP
        sumValue := sumValue + v_dt2_table(i).n - v_dt2_table(i+1).n;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE( sumValue / ( v_dt2_table.count-1 ) );
END;
/
EXEC pro_3_dt2_table;


PL/SQL : ȣ��ȣ�� ���� ����, �и��� �ʿ��� ���� ����(������ �����ϰ� ��ټ��� �κ��� �����Ϳ� ���õǾ��� ��)

�׷��� ���� ���� ��κ� �䱸������ SQL�� �ذ��� ����
�� ���� ��� ȭ�鿡 ��Ÿ������ �ϴ°� ������ ��հ� : 5
PL/SQL, SQL�� ����ϵ� 5��� ���� ����� ���� ������ �޼�

SQL �� ������ Ǯ�����
1] �м��Լ�
SELECT AVG(diff)
FROM
    (SELECT n - LEAD(n) OVER (ORDER BY n DESC) diff
     FROM dt2);

2] ����

SELECT AVG(a.n - b.n)
FROM
    (SELECT ROWNUM rn, n
     FROM
         (SELECT n
          FROM dt2
          ORDER BY n DESC)) a,
    (SELECT ROWNUM rn, n
     FROM
         (SELECT n
          FROM dt2
          ORDER BY n DESC)) b
WHERE b.rn = a.rn + 1;

3] �����Լ�
SELECT MAX(n), MIN(n), (MAX(n) - MIN(n)) / (COUNT(*) - 1)
FROM dt2;



pro_4] cycle ���̺�(��������)�� �̿��Ͽ� daily(�Ͻ���) ���̺��� �����͸� ���� ���ִ� ���ν���
����� �Ѻ��� �����ϴ� ���� 2~300��
�����Ѹ��� ��ǰ�� 2~3�� ���� ����
�Ͻ��� (�Ѵ� 20���� ������) 8000 ~ 12000�� ������ ������

cycle ���̺�
SELECT *
FROM cycle;
cid, pid, day, cnt
1	 100  2	   1     : 1�� ������ 100�� ��ǰ�� �����ϳ� 1�� �Դ´�

sales ���̺�
SELECT *
FROM sales;
cid, pid, dt, cnt
1   100 2020/05/04  1   : 1�� ������ 100�� ��ǰ�� 2020/05/04(������) 1�� �Դ´�
1   100 2020/05/11  1   : 1�� ������ 100�� ��ǰ�� 2020/05/11(������) 1�� �Դ´�
1   100 2020/05/18  1   : 1�� ������ 100�� ��ǰ�� 2020/05/18(������) 1�� �Դ´�
1   100 2020/05/25  1   : 1�� ������ 100�� ��ǰ�� 2020/05/25(������) 1�� �Դ´�


SELECT *
FROM daily;


2020�� 5���� ���� ��¥, ���� ������ ���� ���̺� ����

'202005' ==> :yyyymm
SELECT TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL - 1, 'YYYYMMDD' )dt,
       TO_CHAR( TO_DATE(:yyyymm, 'YYYYMM') + LEVEL - 1, 'D' ) d
FROM dual
CONNECT BY LEVEL <= TO_CHAR( LAST_DAY( TO_DATE(:yyyymm, 'YYYYMM') ), 'dd');


CREATE OR REPLACE PROCEDURE create_daily_sales (p_yyyymm IN VARCHAR2) IS
--    �����ֱ� Ŀ��
    CURSOR cycle_cur IS
        SELECT *
        FROM cycle;
        
--    �޷� ���̺��� ���� ����(�������� ��, ���� Ư�� ���̺��� ���ϴ� ��찡 �ƴ�)
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
    
--    ���� ���࿡ ���ؼ� ������ �����ʹ� �����Ѵ�
    DELETE daily
    WHERE dt BETWEEN TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM'), 'YYYYMMDD') AND
                     TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'YYYYMMDD');
--    Ŀ���� ������ ���鼭(outter loop)
--    �ش� ������ �������������� ��ġ�ϴ� �޷����̺�(INNER LOOP)�� ���ڸ� ã�Ƽ�
--    ��ġ�� ��� SALES ���̺��� ����
    
    FOR cycle_row IN cycle_cur LOOP
        FOR i IN 1..cal_rec_tab.COUNT LOOP
            --�������� �����ֱ� ���ϰ� �޷��� ������ ���� ��
            IF cycle_row.day = cal_rec_tab(i).d THEN
                INSERT INTO daily VALUES (cycle_row.cid,
                                          cycle_row.pid,
                                          cal_rec_tab(i).dt,
                                          cycle_row.cnt);
            END IF;
        END LOOP;
    END LOOP; 
    COMMIT;
END;
/

EXEC create_daily_sales('202005');

SELECT *
FROM daily
WHERE CID = 1;

TRUNCATE TABLE daily;

-- one query
INSERT INTO daily
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM cycle,
        (SELECT TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') DT,
                TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD')) cal
WHERE cycle.day = cal.d;

SELECT *
FROM cycle;

SELECT *
FROM daily;





EXCEPTION

DECLARE
    v_ename emp.ename%TYPE;
BEGIN    
--  ���� ����� �������ε� ������ ��Į�� ���� ==> ���̺� Ÿ���� ������ �����ؾ� �Ѵ�
    SELECT ename INTO v_ename
    FROM emp;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
END;
/


����� ���� ���� : ����Ŭ���� ������ ���ܰ� �ƴ϶� �����ڰ� ���� ������ ����
java������ �ݵ�� ó���� �ؾ��ϴ� ���ܸ� ��Ƽ� �ش� ȸ�糪 �����ڰ� ������ ���ܷ� �ٲپ ó���� �� �ִ�
mybatis ���� ORM(Object Relation mapping) �����ӿ�ũ������ jdbc ���α׷��ֿ��� �ݵ�� ���� �ϴ�
SQLException(checked exception)�� ���� ���Ǹ� ���� �����ӿ�ũ���� ������ ���ܷ� ġȯ�Ͽ� ����Ѵ�


SELECT ����� ���� �� ==> NO_DATA_FOUND

�Ʒ� ������ Ư�� ������ ��ȸ�ϱ� ���� ����
���࿡ �ش��ϴ� �����Ͱ� ���� �� NO_DATA_FOUND
                ==> NO_EMP ������ ���� ���ܷ� ġȯ�Ͽ� �ǹ̻����� ��Ȯ�ϰ� ǥ��
                
SELECT *
FROM emp
WHERE empno = :empno;

DECLARE
    -- ����� ���� ����
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = 9999;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
--           NO_EMP ���ܷ� ġȯ�Ͽ� ���ܸ� ������
            RAISE NO_EMP; -- throw new Exception();
    END;
EXCEPTION
    WHEN NO_EMP THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/



function : ���ϰ��� �ִ� pl/sql ����
��� ��ȣ�� �Է¹޾� �ش����� �̸��� �����ϴ� function : getEmpName ����

CREATE OR REPLACE FUNCTION getEmpName(p_empno IN emp.empno%TYPE) RETURN VARCHAR2 IS
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename;
END;
/

SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM emp;


function1]
CREATE OR REPLACE FUNCTION getdeptName(p_deptno IN dept.deptno%TYPE) RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/

SELECT deptno, getdeptName(deptno)
FROM dept;


function2] �Լ��� ���鶧 � ���ڰ� �ʿ�����,
           ���������� ���踦 ���� �� � ������ �߻��ϴ���
-- SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm deptnm           
SELECT deptcd, INDENT(LEVEL, ' ') || deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

CREATE OR REPLACE FUNCTION INDENT (lv NUMBER) RETURN VARCHAR2 IS
    indent_str VARCHAR2(50) := '';
BEGIN
    SELECT LPAD(' ', (lv - 1) * 4, ' ') INTO indent_str
    FROM dual;
    
    RETURN indent_str;
END;
/

CREATE OR REPLACE FUNCTION INDENT (lv NUMBER, padString VARCHAR2) RETURN VARCHAR2 IS
    indent_str VARCHAR2(50) := '';
BEGIN
    SELECT LPAD(' ', (lv - 1) * 4, padString) INTO indent_str
    FROM dual;
    
    RETURN indent_str;
END;
/