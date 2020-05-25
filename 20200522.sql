���ν����� ����

����
�ϳ��� ���� ���� ������ �� �ִ� ����(String)
����ü�� ������ �� �ִ� ����(Map,Class)
�������� ������ �� �ִ� ����(List<Map>, List<Class>)



SET SERVEROUTPUT ON;

DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept dept_tab;
BEGIN
    SELECT * BULK COLLECT INTO v_dept
    FROM dept;  
    /*
    java : for
    int[] arr = new int[20]();
    for(int i = 0; i < max; i++){
        System.out.println( arr[i] );
    }*/
    
    FOR i IN 1..v_dept.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_dept(i).deptno || ' / ' || v_dept(i).dname || ' / ' || v_dept(i).loc);
    END LOOP;
END;
/



��������
1. IF ����
IF condition THEN
    statement;
ELSIF condition THEN
    statement;
ELSE
    statement;
END IF;


NUMBER Ÿ���� p ������ �����ϰ� 2�� ����
IF ������ ���� p���� üũ�Ͽ� ����ϴ� ����

DECLARE
    /* int p = 2 */
    p NUMBER := :p;
BEGIN
   /* p�� 1�̸� 1�� ���
    p�� 2�̸� 2�� ���
    �׹��� ���� ���� else�� ��� */
    
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('else');
    END IF;
END;
/




CASE ����
�˻� ���̽�(java switch)
����
    CASE ǥ����
        WHEN VALUE THEN
            statement;
        WHEN VALUE2 THEN
            statement;
        ELSE
            statement;
    END CASE;
    
    
    
�Ϲ� ���̽� : �Ϲݾ���� IF ����, SQL���� ����� CASE ������ ����, CASE - END CASE;
    CASE
        WHEN expression TEHN
            statement;
        WHEN expression TEHN
            statement;
        ELSE
            statement;
    END CASE;
    
    
    
���̽� ǥ����
    CASE
        WHEN expression TEHN
            ��ȯ�� ��
        WHEN expression TEHN
            ��ȯ�� ��
        ELSE
            ��ȯ�� ��
    END;




�˻� ���̽�
DECLARE
    p NUMBER := 2;
BEGIN   
    CASE P
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('1');
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('2');
        ELSE
            DBMS_OUTPUT.PUT_LINE('else');
    END CASE;
END;
/




�Ϲ� ���̽�
DECLARE
    p NUMBER := 2;
BEGIN   
    CASE
        WHEN p = 1 THEN
            DBMS_OUTPUT.PUT_LINE('1');
        WHEN p = 2 THEN
            DBMS_OUTPUT.PUT_LINE('2');
        ELSE
            DBMS_OUTPUT.PUT_LINE('else');
    END CASE;
END;
/




���̽� ǥ����
DECLARE
    p NUMBER := 2;
    ret NUMBER := 0;
BEGIN   
    ret := CASE
                WHEN p = 1 THEN
                    4
                WHEN p = 2 THEN
                    5
                ELSE
                    6
            END;
    DBMS_OUTPUT.PUT_LINE(ret);
END;
/





�ݺ���
�ε��������� �����ڰ� ������ �������� �ʴ´�
REVERSE �ɼ��� ����ϸ� ���ᰪ���� ���� 1�� �ٿ� ������ �ε��������� ���۰��� �� ������ ����
FOR �ε������� IN [REVERSE] ���۰�..���ᰪ LOOP
END LOOP;

1���� 5���� �ݺ����� �̿��Ͽ� ���

DECLARE
    
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

2~9�� ������ ����ϱ�
DECLARE
    
BEGIN
    FOR i IN 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE(i || '��');
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE( i || ' * ' || j || ' = ' || i * j );
        END LOOP;
    END LOOP;
END;
/





while
����
WHILE condition LOOP
    statement;
END LOOP;

DECLARE
    i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
    END LOOP;
END;
/


LOOP
java : while(true){
            if(condition){
                break;
            }
       }
����
LOOP
    statement;
    EXIT WHEN condition;
    statement;
END LOOP;

DECLARE
    i NUMBER := 1;
BEGIN
    LOOP
        EXIT WHEN i > 5;
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;
/




������� �߿��� ��
CURSOR : SELECT ���� ���� ����� �����͸� ����Ű�� ������
SQL�� ����ڰ� DBMS�� ��û�� ������ �� ó�� ����
1. ������ SQL�� ����� ���� �ִ��� Ȯ��(�����ȹ�� �����ϱ� ���ؼ�)
2. ���ε� ��������(���ε� ������ ���Ǿ��� ���)
3. ����(execution)
4. ����(fetch)

cursor�� ����ϰ� �Ǹ� ����ܰ踦 �����
==> SELECT ������ ����� ������ ���� �ʰ� CURSOR�� ���� ���� �޸𸮿� ������ �� �ִ�

PL/SQL�� ��κ��� ������ SELECT ����� Ư�� ������ �����Ͽ� ó���ϴ� ���̱� ������
������ ������ SELECT ����� ��� ���� ���ո����� �� �ִ�.



CURSOR�� ����
������ : ������ �̸��� �ο����� �ʰ� ������ DML ����
������ : �����ڰ� �̸��� �ο��� CURSOR

CURSOR�� ����ó�� ���� ==> DECLARE

CURSOR ���ܰ�
1. ����
2. ����(OPEN)
3. ����(FETCH)
4. �ݱ�(CLOSE)

����
1. ���� (DECLARE ��)
    CURSOR Ŀ���̸� IS
        QUERY;
2. ���� (BEGIN)
    OPEN Ŀ���̸�;
3. ���� (BEGIN)
    FETCH Ŀ���̸� INTO variable;
4. �ݱ� (BEGIN)
    CLOSE Ŀ���̸�;
    
    
dept ���̺��� ��� ���� ��ȸ�ϰ�, deptno, dname �÷��� Ŀ���� ���ؼ�
��Į�� ����(v_deptno, v_dname)

�������� ��ȸ�ϴ� SELECT ������ ������� �����ϱ� ���ؼ� TABLE TYPE�� ���

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    CURSOR deptcursor IS
        SELECT deptno, dname
        FROM dept;

BEGIN
    OPEN deptcursor;
    LOOP
        FETCH deptcursor INTO v_deptno, v_dname;
        EXIT WHEN deptcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_deptno || ' / ' || v_dname);
    END LOOP;
    CLOSE deptcursor;
END;
/


������ Ŀ���� FOR LOOP ���� ==> ���� ����ϱ� ���� ����
OPEN, CLOSE, FETCH �ϴ� ������ FOR LOOP���� �ڵ������� �������ش�
�����ڴ� Ŀ�� ����� FOR LOOP�� Ŀ������ �־��ִ� �ɷ� ������ �ܼ�ȭ

����
FOR ���ڵ��̸�(�������� ����) IN Ŀ���̸� LOOP
    ���ڵ��̸�.�÷������� �÷����� ����
END FOR;
    
DECLARE
    CURSOR deptcursor IS
        SELECT deptno, dname
        FROM dept;

BEGIN
    FOR rec IN deptcursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' / ' || rec.dname);
    END LOOP;
END;
/
    
    
    
�Ķ���Ͱ� �ִ� ������ Ŀ��
�μ� ��ȣ�� �Է¹޾� WHERE������ ����ϴ� Ŀ���� ����
DECLARE
    CURSOR deptcursor ( p_deptno dept.deptno%TYPE ) IS
        SELECT deptno, dname
        FROM dept
        WHERE p_deptno >= deptno;

BEGIN
    FOR rec IN deptcursor(30) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' / ' || rec.dname);
    END LOOP;
END;
/



FOR LOOP�� �ζ��� Ŀ��
DECLARE���� Ŀ���� ���������� �������� �ʰ�
FOR LOOP���� SQL�� ���� ���.
DECLARE
BEGIN
    FOR rec IN ( SELECT deptno, dname FROM dept ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' / ' || rec.dname);
    END LOOP;
END;
/

SELECT *
FROM dt2;

pro_3]

CREATE OR REPLACE avgdt IS
    v_dt dept%ROWTYPE
BEGIN
    FOR i IN (SELECT n FROM dt2) LOOP
        FOR j IN ( SELECT n FROM (SELECT n, ROWNUM rn FROM dt2) WHERE rn > 1) LOOP
             
        END LOOP;
    END LOOP;
    
END;
/
