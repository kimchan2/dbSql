�θ�-�ڽ� ���̺� ����

1. ���̺� ������ ����
 1] �θ� (dept)
 2] �ڽ� (emp)
 
2. ������ ������(INSERT) ����
 1] �θ� (dept)
 2] �ڽ� (emp)
 
3. ������ ������(DELETE) ����
 1] �ڽ� (emp)
 2] �θ� (dept)
 
���̺� �����(���̺��� �̹� �����Ǿ� �ִ� ���) �������� �߰� ����

DROP TABLE emp_test;

CREATE TABLE emp_test(
	empno NUMBER(4),
	ename VARCHAR2(10),
	deptno NUMBER(2)
);

���̺� ������ ���������� Ư���� �������� �ʾ���

���̺� ������ ���� PRIMARY KEY �߰�

���� : ALTER TABLE ���̺��� ADD CONSTRAINT �������Ǹ� ��������Ÿ�� (������ �÷�[,....]);
�������� Ÿ�� : PRIMARY KEY, UNIQUE, FOREIGN KEY, CHECK, (NOT NULL)

ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

desc emp_test;

���̺� ����� �������� ����

���� : ALTER TABLE ���̺��� DROP CONSTRAINT �������Ǹ�;

������ �߰��� �������� pk_emp_test ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;


���̺� �������� �ܷ�Ű �������� �߰� �ǽ�
emp_test.depto ==> dept_test.deptno

dept_test ���̺��� deptno�� �ε��� ���� �Ǿ��ִ��� Ȯ��
desc dept_test;

ALTER TABLE ���̺��� ADD CONSTRAINT �������Ǹ� ��������Ÿ�� (�÷�) REFERENCES �������̺��� (�������̺��÷���);

ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) 
                                                 REFERENCES dept_test (deptno);
                                                 
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

NULL ��������
ALTER TABLE ���̺��� MODIFY (�÷��� NOT NULL);
ALTER TABLE ���̺��� MODIFY (�÷��� NULL);


�������� Ȱ��ȭ ��Ȱ��ȭ
���̺��� ������ ���������� �����ϴ� ���� �ƴ϶� ��� ����� ���δ� ����
���� : ALTER TABLE ���̺��� ENABLE | DISABLE CONSTRAINT �������Ǹ�;

������ ������ fk_emp_test_dept_test FOREIGN KEY ���������� ��Ȱ��ȭ
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;

dept(�θ�) ���̺����� 99�� �μ��� �����ϴ� ��Ȳ
SELECT *
FROM dept_test;

fk_emp_test_dept_test ���������� ��Ȱ��ȭ�Ǿ� �ֱ� ������
emp_test ���̺����� 99�� �μ� �̿��� ���� �Է°��� �ϴ�

dept_test ���̺��� 88�� �μ��� ������ �Ʒ� ������ ���������� ����
INSERT INTO emp_test VALUES (9999, 'brown', 88);

���� ��Ȳ : empt_test ���̺��� dept_test ���̺��� �������� �ʴ� 88�� �μ��� ����ϰ� �ִ� ��Ȳ
          fk_emp_test_dept_test ���������� ��Ȱ��ȭ�� ����
          
�������� ���Ἲ�� ���� ���¿��� fk_emp_test_dept_test�� Ȱ��ȭ ��Ű��???
==> ������ ���Ἲ�� ��ų �� �����Ƿ� Ȱ��ȭ �� �� ����
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;

emp, dept ���̺����� ���� PRIMARY KEY, FOREIGN KEY ������ �ɷ� ���� ���� ��Ȳ
emp ���̺��� empno�� key�� dept ���̺��� deptno�� key�� �ϴ� PRIMARY KEY ������ �߰��ϰ�

emp.deptno ==> dept.deptno�� �����ϵ��� FOREIGN KEY�� �߰�

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

desc emp;
desc dept;

ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);


�������� Ȯ��
������ �������ִ� �޴�(���̺� ���� ==> �������� tab)
USER_CONSTRAINT : �������� ����(MASTER);
USER_CONS_COLUMNS : �������� �÷� ����(��);

- �÷�Ȯ��
��, SELECT, DESC,
USER_TAB_COLUMNS ( data dictionary, ����Ŭ���� ���������� �����ϴ� view );
SELECT *
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'EMP';

- �������� Ȯ��
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP';

SELECT *
FROM USER_CONS_COLUMNS;


���̺�, �÷� �ּ� : USER_TAB_COMMENTS, USER_COL_COMMENTS;

�����ϸ� �ּ��� ����~
���̺��� �ּ� �����ϱ�
���� : COMMENT ON TABLE ���̺��� IS '�ּ�';

emp ���̺��� �ּ� �����ϱ�
COMMENT ON TABLE emp IS '����';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME = 'EMP';

�÷��ּ� Ȯ��
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'EMP';

�÷� �ּ� ����
���� : COMMENT ON COLUMN ���̺���.�÷��� IS '�ּ�';

empno : ���, ename : �̸�, hiredate : �Ի����� ������ user_col_comments�� ���� Ȯ��

COMMENT ON COLUMN emp.empno IS '���';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';


-- �ǽ� comment1
SELECT *
FROM user_tab_comments;
SELECT *
FROM user_col_comments;

SELECT a.TABLE_NAME, TABLE_TYPE, A.Comments as "TAB.COMMENT", COLUMN_NAME, B.Comments as "COL.COMMENT"
FROM user_tab_comments a, user_col_comments b
WHERE a.TABLE_NAME = b.TABLE_NAME 
  AND a.TABLE_NAME IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');




View�� ������
�������� ������ ���� = SQL
�������� ������ ������ �ƴϴ�

View ��� �뵵
 . ������ ����(���ʿ��� �÷� ������ ����)
 . ���ֻ���ϴ� ������ ���� ����
    . IN-LINE VIEW�� ����ص� ������ ����� ����� �� �� ������
      MAIN ������ ������� ������ �ִ�.
 
view�� �����ϱ� ���ؼ��� CREATE VIEW ������ ���� �־�� �Ѵ� (DBA����)

SYSTEM ������ ����
GRANT CREATE VIEW TO ����������� �ο��� ������;

���� : CREATE OR [REPLACE] VIEW ���̸� [�÷���Ī1, �÷���Ī2,...] AS
        SELECT ����;

emp���̺����� sal, comm �÷��� ������ 6���� �÷��� ��ȸ�� ������ v_emp view�� ����

CREATE OR REPLACE VIEW v_emp AS
 SELECT empno, ename, job, mgr, hiredate, deptno
 FROM emp;

view (v_emp)�� ���� ������ ��ȸ
SELECT *
FROM v_emp;

v_emp view�� chan���� ����
HR�������� �λ� �ý��� ������ ���ؼ� EMP���̺��� �ƴ� SAL, COMM ��ȸ�� ���ѵ�
v_emp view�� ��ȸ�� �� �ֵ��� ������ �ο�

���� �ο��� hr �������� v_emp ��ȸ ����
SELECT *
FROM chan.v_emp;

chan�������� hr�������� v_emp view�� ��ȸ�� �� �ִ� ���� �ο�
GRANT SELECT ON v_emp TO HR;

v_emp view ������ hr ������ �ο��� ���� ��ȸ �׽�Ʈ ����
SELECT *
FROM chan.v_emp;


�ǽ�
v_emp_dept �並 ����
emp, dept ���̺��� deptno �÷����� �����ϰ�
emp.empno, ename, dept.deptno, dname 4���� �÷����� ����

CREATE OR REPLACE VIEW v_emp_dept AS
    SELECT emp.empno, ename, dept.deptno, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

VIEW ����
���� : DROP VIEW �躣�� �� �̸�;


VIEW�� ���� DML ó��
SIMPLE VIEW�� ���� ����

SIMPLE VIEW : ���ε��� �ʰ�, �Լ�, GROUP BY, ROWNUM�� ������� ���� ������ ������ VIEW
COMPLEX VIEW : SIMPLE VIEW�� �ƴ� ����

v_emp : simple view

SELECT *
FROM v_emp;

v_emp�� ���� 7369 SMITH ����� �̸��� brown���� ����

UPDATE v_emp SET ename = 'brown'
WHERE empno = 7369;

SELECT *
FROM emp;

v_emp �÷����� sal �÷��� �������� �ʱ� ������ ����
UPDATE v_emp SET sal = '1000'
WHERE empno = 7369; 

ROLLBACK;



SEQUENCE
������ �������� �������ִ� ����Ŭ ��ü
���� �ĺ��ڸ� ���� ������ �� �ַ� ���


�ĺ��� ==> �ش� ���� �����ϰ� ������ �� �ִ� ��
���� <==> ���� �ĺ���

�Ϲ������� � ���̺�(����Ƽ)�� �ĺ��ڸ� ���ϴ� �����
[����], [����], [������]

�Խ����� �Խñ� : �Խñ� �ۼ��ڰ� ���� ����� �ۼ� �ߴ���
�Խñ��� �ĺ��� : �ۼ���id, �ۼ�����, ������
    ==> ���� �ĺ��ڰ� �ʹ� �����ϱ� ������ ������ ���̼��� ����
        ���� �ĺ��ڸ� ��ü�� �� �ִ� (�ߺ����� �ʴ�) ���� �ĺ��ڸ� ���

������ �ϴٺ��� ������ ���� �����ؾ��� ���� ����
ex : ���, �й�, �Խñ� ��ȣ
     ���, �й� : ü��
     ��� : 15101001 - ȸ�� �������� 15, 10�� 10��, �س� ��¥�� ù��° �Ի��� ��� 01
     �й� : 
     
     ü�谡 �ִ� ���� �ڵ�ȭ�Ǳ� ���ٴ� ����� ���� Ÿ�� ��찡 ����
     
     �Խñ� ��ȣ : ��ġ�� �ʴ� ����
     ü�谡 ���� ���� �ڵ�ȭ�� ���� ==> SEQUENCE ��ü�� Ȱ���Ͽ� �ս��� ���� ����
                                     ==> �ߺ����� �ʴ� ���� ���� ��ȯ
                                     
�ߺ����� �ʴ� ���� �����ϴ� ���
1. KEY table�� ����
   ==> SELECT FOR UPDATE �ٸ� ����� ���ÿ� ������� ���ϵ��� ���°� ����
   ==> ���� ���� ���� ��, ������ ���� �̻ڰ� �����ϴ°� ���� (SEQUENCE ������ �Ұ���)

2. JAVA ������ UUID Ŭ������ Ȱ��, ������ ���̺귯�� Ȱ��(����) ==> ������, ����, ī��
   ==>

3. ORACLE DB - SEQUENCE




SEQUENCE ����
���� : CREATE SEQUENCE ������ ��;

sql_emp��� �������� ����
CREATE SEQUENCE seq_emp;
CREATE SEQUENCE  "CHAN"."SEQ_EMP"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;

���� : ��ü���� �������ִ� �Լ��� ���ؼ� ���� �޾ƿ´�
NEXTVAL : �������� ���� ���ο� ���� �޾ƿ´�
CURRVAL : ������ ��ü�� NEXTVAL�� ���� ���� ���� �ٽ� Ȯ���� �� ���
          (Ʈ����ǿ��� NEXTVAL �����ϰ� ���� ����� ����);
          
SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

SEQUENCE�� ���� �ߺ����� �ʴ� empno �� ���� �Ͽ� INSERT �ϱ�
INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'sally', '88');
SELECT *
FROM emp_test;
