ȣ��ȣ
10��, 1~2ȸ�簡 PL/SQL�� ��ȣ

PL/SQL ==> PL/SQL�� �����ϴ� ���� ����Ŭ ��ü
           �ڵ� ��ü�� ����Ŭ�� ����(����Ŭ ��ü�ϱ�)
           ������ �ٲ� �Ϲ� ���α׷��� ���� ���� �� �ʿ䰡 ����
           
SQL ==> SQL ������ �Ϲ� ���� ����(java)
        .���� sql�� ���õ� ������ �ٲ�� java������ ������ ���ɼ��� ŭ
        
        
PL/SQL : Procedual Language / Structured Query Language
SQL : ������, ������ ����(�̺��ϰ� ����, CASE, DECODE...)

������ �ϴٺ��� � ���ǿ� ���� ��ȸ�ؾ��� ���̺� ��ü�� �ٲ�ų� ������ ��ŵ�ϴ� ����
�������� �κ��� �ʿ��� ���� ����

�������� : �ҵ��� 25%�� �ſ�ī�� + ���ݿ����� + üũī��� �Һ�
         �Һ� �ݾ��� �ҵ��� 25%�� �ʰ��ϴ� �ݾ׿� ���ؼ�
         �ſ�ī��� ���� : 20%, ���ݿ������� 30%, üũī�� 25% �����ϴµ�
         ��, ���� �ݾ��� 300������ ���� �� ����
         ��, ���߱��뿡 ���� �߰������� 100������ ���� ���� �� �ְ�
         ��, ������忡�� ����� �ݾ׿� ���ؼ��� �߰������� 100������ �������� �� �ִ�;
         
DBMS�󿡼� ���Ͱ��� ������ ������ SQL�� �ۼ��ϴµ��� ������ ����(��������)
�Ϲ����� ���α׷��� ���� ����ϴ� ��������(if, case), �ݺ���(for, while), �������� Ȱ���� �� �ִ�
PL/SQL �� ����

* ���� : �򰥸� ����

���� ������
java =
pl/sql :=


java���� sysout ==> console�� ���
PL/SQL���� ����
SET SERVEROUTPUT ON; �α׸� �ܼ�â�� ��°����ϰԲ� �ϴ� ����, ���ϸ� ����� �ȵ�
SET SERVEROUTPUT OFF;

SET SERVEROUTPUT ON;

PL/SQL block�� �⺻����
DECLARE : ����� (���� ���� ����, ��������)
BEGIN : ����� (������ �����Ǵ� �κ�)
EXCEPTION : ���ܺ� (���ܰ� �߻� ���� �� CATCH�Ͽ� �ٸ� ������ �����ϴ� �κ�(java try-catch));

pl/sql �͸�(�̸��� ����, 1ȸ��) ����;

DESC dept;

DECLARE
    /*JAVA : ����TYPE ������
    PL/SQL : ������ ����TYPE*/
    
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
BEGIN
    /*dept ���̺��� 10�� �μ��� �ش��ϴ� �μ���ȣ, �μ����� DECLARE���� ������ �ΰ��� ������ ���*/
    
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;

    /*JAVA�� SYSOUT, System.out.println(v_deptno + "     " + v_dname);*/
    DBMS_OUTPUT.PUT_LINE(v_deptno || '     ' || v_dname);
END;
/
/* /�� pl/sql ������ ���Ḧ ���� */



������ Ÿ�� ����
v_deptno, v_dname �ΰ��� ���� ���� ==> dept ���̺��� �÷� ���� �������� ����
                                ==> dept ���̺��� �÷� ������ Ÿ�԰� �����ϰ� �����ϰ� ���� ��Ȳ
������ Ÿ���� ���� �������� �ʰ� ���̺��� �÷� Ÿ���� �����ϵ��� ������ �� �ִ�
==> ���̺� ������ �ٲ� pl/sql ���Ͽ� ����� ������ Ÿ���� �������� �ʾƵ� �ڵ����� ����ȴ�

���̺���.�÷���%type

DECLARE
    v_deptno dept.deptno%type;
    v_dname dept.dname%type;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || '     ' || v_dname);
END;
/

��¥�� �Է¹޾� ==> ��ȸ���� �����ϱ������� 5�� ���� ��¥�� �����ϴ� �Լ� => ȸ�縸�� Ư���� ������ �ʿ��� ��� �Լ��� �����ߴ� ��



PROCEDURE : �̸��� �ִ� PL/SQL ����, ���ϰ��� ����
            ������ ���� ó���� �����͸� �ٸ� ���̺��� �Է��ϴ� ����
            �����Ͻ� ������ ó�� �� �� ���
            ����Ŭ ��ü ==> ����Ŭ ������ ������ �ȴ�
            ������ �ִ� ������� ���ν��� �̸��� ���� ������ ����
            
CREATE OR REPLACE PROCEDURE printdept (p_deptno IN dept.deptno%TYPE) IS
--�����
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = p_deptno;
        
    DBMS_OUTPUT.PUT_LINE(v_deptno || '     ' || v_dname);
END;
/


���ν��� ���� ��� : EXEC ���ν��� �̸�;
EXEC printdept;

���ڰ� �ִ� printdept ����
EXEC printdept(50);

PL/SQL ������ SELECT ������ ���� ���� �� �����Ͱ� �Ѱǵ� �ȳ��� ��� NO_DATA_FOUND ���ܸ� ������

�ǽ� pro_1]
SELECT *
FROM emp;

SELECT *
FROM dept;

CREATE OR REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS
    v_ename emp.ename%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname INTO v_ename, v_dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno AND emp.empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(v_ename || '     ' || v_dname);
END;
/

EXEC printemp(7654);


�ǽ� pro_2]
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES (99, 'ddit', 'daejoen');
ROLLBACK;

CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept_test.deptno%TYPE,
                                             p_dname IN dept_test.dname%TYPE,
                                             p_loc IN dept_test.loc%TYPE) IS
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
END;
/

EXEC registdept_test(99, 'ddit', 'daejeon');

SELECT *
FROM dept_test;

�ǽ� pro_3]
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE,
                                             p_dname IN dept_test.dname%TYPE,
                                             p_loc IN dept_test.loc%TYPE) IS
BEGIN
    UPDATE dept_test SET deptno = p_deptno, dname = p_dname, loc = p_loc
    WHERE deptno = p_deptno;
END;
/

EXEC UPDATEdept_test(89, 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;



���պ���
��ȸ����� �÷��� �ϳ��� ������ ��� �۾��� ���ŷӴ� ==> ���� ������ ����Ͽ� �������� �ؼ�

0. %TYPE : �÷�
1. %ROWTYPE : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ���� ���� Ÿ��
  (���� %TYPE - Ư�� ���̺��� �÷� Ÿ���� ����)
2. PL/SQL RECORD : ���� ������ �� �ִ� Ÿ��, �÷��� �����ڰ� ���� ���
                   ���̺��� ��� �÷��� ����ϴ°� �ƴ϶� �÷��� �Ϻθ� ����ϰ� ���� ��
3. PL/SQL TABLE TYPE : �������� ��, �÷��� ������ �� �ִ� Ÿ��

1. %ROWTYPE
�͸����� dept ���̺��� 10�� �μ������� ��ȸ�Ͽ� %ROWTYPE���� ������ ������ ������� �����ϰ�
DBMS_OUTPUT.PUT_LINE�� �̿��Ͽ� ���;
SELECT *
FROM dept
WHERE deptno = 10;

DECLARE
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' / ' || v_dept_row.dname || ' / ' || v_dept_row.loc);
END;
/


2. RECORD : ���� ������ �� �ִ� ����Ÿ��, �÷� ������ �����ڰ� ���� ������ �� �ִ�
dept���̺����� deptno, dname �ΰ� �÷��� ������� �����ϰ� ���� ��

SELECT deptno, dname
FROM dept
WHERE deptno = 10;

DECLARE
    /*deptno, dname �÷� �ΰ��� ���� ������ �� �ִ� TYPE�� ����*/
    TYPE dept_rec IS RECORD(
         deptno dept.deptno%TYPE,
         dname dept.dname%TYPE);
        
    /*���Ӱ� ���� Ÿ������ ������ ���� (class ����� �ν��Ͻ� �����ϴ� �Ͱ� ���)*/
    v_dept_rec dept_rec;
BEGIN
    SELECT deptno, dname INTO v_dept_rec
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE( v_dept_rec.deptno || ' / ' || v_dept_rec.dname );
END;
/



�������� ������ �� ��
SELECT ����� �������̱� ������ �ϳ��� �� ������ ���� �� �ִ� ROWTYPE ��������
���� ���� ���� ���� ���� �߻�
==> ���� ���� ������ �� �ִ� TABLE TYPE ���

DECLARE
    v_dept_row dept%ROWTYPE;
BEGIN
    SELECT * INTO v_dept_row
    FROM dept;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' / ' || v_dept_row.dname || ' / ' || v_dept_row.loc);
END;
/


3. TABLE TYPE : �������� ������ �� �ִ� Ÿ��
���� : TYPE Ÿ�Ը� IS TABLE OF �� Ÿ�� INDEX BY �ε����� ����Ÿ��;

dept���̺��� �� ������ ������ �� �ִ� ���̺� TYPE
    ArrayList<dept> dept_tab= new ArrayList<>();
    
    java���� �迭 �ε���
    int[] intArray = new int[50];
    intArray[0]
    java������ �ε����� �翬�� ����
    
    PL/SQL������ �ΰ����� Ÿ���� ���� : ����(BINARY_INTEGER), ���ڿ�(VARCHAR(2))
    intArray["ù��°"] = 50;
    System.out.println(intArray["ù��°"]); ���ڿ� �ε����� �䷱ ����
    Map<String, Dept> deptMap = new HashMap<String, Dept>();
    deptMap.put("ù��°", new Dept());
    
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER



