-- �ǽ�
CREATE TABLE DEPT_TEST2 AS
    SELECT *
    FROM dept
    WHERE 1 = 1;
    
SELECT *
FROM dept_test2;

idx1]
CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_dept_test2_02 ON dept_test2 (dname);
CREATE INDEX idx_dept_test2_03 ON dept_test2 (deptno, dname);

idx2]
DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_dept_test2_02;
DROP INDEX idx_dept_test2_03;

idx3]
SELECT *
FROM emp
WHERE empno = :empno; -- ����� �Է¹޾Ƽ� �ش� ����� ���������� ��ȸ

SELECT *
FROM emp
WHERE ename = :ename; -- �̸��� �Է¹޾Ƽ� �ش� �̸��� ���������� ��ȸ

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno = :deptno
  AND emp.empno LIKE :empno || '%'; -- �Է��� ���, �Էµ� ������� �����ϴ� ������ ������ �μ��������� ���� ��ȸ
  
SELECT *
FROM emp
WHERE sal BETWEEN :st_sal AND :ed_sal
  AND deptno = :deptno;  -- �Է¹��� ����� ���� ������ �޿��� ������ �������� Ȯ��
  
SELECT B.*
FROM emp A, emp B
WHERE A.mgr = B.empno
  AND A.deptno = :deptno; -- ���� �Է��� �μ��� �Ŵ��� ������ȸ 
  
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'), COUNT(*) cnt
FROM emp
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm'); -- �Ի����ں�,������ �μ��� �Ի��� ����� �� 
  

1] empno(=) x
2] ename(=) x
3] deptno(=), empno(LIKE :empno || '%') x 

4] deptno(=), sal( BETWEEN :st_sal AND :ed_sal ) x -- sal ���� �����ϴ°� ���ƺ���
5] deptno(=), mgr(=)
6] deptno(GROUP), hiredate(GROUP) -- �׳� full

CREATE UNIQUE INDEX idx_emp_01 ON emp (empno, deptno);
CREATE INDEX idx_emp_02 ON emp (ename);
CREATE INDEX idx_emp_03 ON emp (deptno, mgr);
CREATE INDEX idx_emp_04 ON emp (sal);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN :st_sal AND :ed_sal
  AND deptno = :deptno;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

idx4] �غ���

SELECT *
FROM emp
WHERE empno = :empno;

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
  AND emp.deptno = :deptno;
  AND emp.empno LIKE :empno || '%';
  
SELECT *
FROM dept
WHERE deptno = :deptno;

SELECT *
FROM emp
WHERE sal BETWEEN :st_sal AND :ed_sal
  AND deptno = :deptno;

EXPLAIN PLAN FOR  
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno = :deptno
  AND dept.loc = :loc;
  
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT *
FROM dept;
  
1] empno(=) x
2] deptno(=), empno(LIKE :empno || '%') x
3] deptno(=) x
4] deptno(=), sal(BETWEEN) x
5] deptno(=), loc(=)

CREATE UNIQUE INDEX idx_u_emp_01 ON emp ( empno, deptno );
CREATE INDEX idx_emp_02 ON emp ( deptno, sal );


DROP INDEX idx_u_emp_01;
DROP INDEX idx_emp_02;



�����ȹ

�����ð��� ��� ����
==> ������ ���� ���¸� ��� ��, ������� �̾߱Ⱑ �ƴ�
inner join : ���ο� �����ϴ� �����͸� ��ȸ�ϴ� ���� ���
outer join : ���ο� �����ص� ������ �Ǵ� ���̺��� �÷������� ��ȸ�ϴ� ���� ���
cross join : ������ ����(īƼ�� ������Ʈ), ���� ������ ������� �ʾƼ� ���ᰡ���� ��� ����Ǽ��� ���εǴ� ���
self join : ���� ���̺����� ���� �ϴ� ����

�����ڰ� DBMS�� SQL�� ���� ��û�� �ϸ� DBMS�� SQL�� �м��ؼ�
��� �� ���̺��� ������ �� ����,
3���� ����� ���� ���(������ ���ι��, ������� �̾߱�)
1. Nested Loop Join
2. Sort Merge Join
3. Hash Join

Online Transaction Processing (OLTP) : �ǽð� ó�� ==> ������ ����� �ϴ� �ý��� (�Ϲ����� �� ����)
Online Analysis Processing (OLAP) : �ϰ�ó�� ==> ��ü ó���ӵ��� �߿��� ���(���� ���� ���, ���� �� ���� ���)

SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'DEPT';



