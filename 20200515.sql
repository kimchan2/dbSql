REPORT GROUP FUNCTION == > Ȯ��� GROUP BY
REPORT GROUP FUNCTION �� ��� ���� ������
�������� SQL �ۼ�, UNION ALL�� ���ؼ� �ϳ��� ����� ��ġ�� ������ �ʿ���
== REPORT GROUP FUNCTION �� ����ؼ� ���� ���ϰ�~

ROLLUP : ����׷� ���� - ����� �÷��� �����ʿ������� ���������� GROUP BY�� ����

�Ʒ� ������ ����׷�
1. GROUP BY job, deptno
2. GROUP BY job
3. GROUP BY ==> ��ü

ROLLUP ���� �����Ǵ� ����׷��� ���� : ROLLUP�� ����� �÷��� + 1;
SELECT NVL(job, '�Ѱ�'), deptno,
       GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


ROLLUP ���� ����Ǵ� �÷��� ������ ��ȸ ����� ������ ��ģ��
(***** ���� �׷��� ����� �÷��� ������ ���� ������ �����鼭 ����)

GROUPING
�Ұ� ��꿡 ���� ��� 1
�Ұ� ��꿡 ������ ���� ��� 0

-- group_ad2 CASE/END�� �÷��̴�~
SELECT (CASE
            WHEN GROUPING(job) = 1 THEN '�Ѱ�' -- �׷��� ���
            WHEN GROUPING(job) = 0 THEN job -- �׷��� ���x
        END) job,
        deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- group_ad2-1
SELECT (CASE
            WHEN GROUPING(job) = 1 THEN '��' -- �׷��� ���
            WHEN GROUPING(job) = 0 THEN job -- �׷��� ���x
        END) job,
        (CASE
            WHEN GROUPING(job) = 1 THEN '��' -- �׷��� ���
            WHEN GROUPING(deptno) = 1 THEN '�Ұ�' -- �׷��� ���
            WHEN GROUPING(deptno) = 0 THEN TO_CHAR(deptno) -- �׷��� ���x
        END) deptno,
        SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT DECODE(GROUPING(job), 1, '��', job) job,
       DECODE(GROUPING(job) + GROUPING(deptno), 2, '��', 1, '�Ұ�', 0, deptno) deptno,
       DECODE(GROUPING(job) || GROUPING(deptno), 11, '��', 01, '�Ұ�', 00, deptno) deptno,
       SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--group_ad3

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--group_ad4
SELECT dept.dname, a.job, a.sal
FROM dept,
    (SELECT deptno, job, SUM(sal) sal
     FROM emp
     GROUP BY ROLLUP (deptno, job)) a
WHERE a.deptno = dept.deptno(+);

SELECT dept.dname, emp.job, SUM(emp.sal)
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dept.dname, emp.job);

--group_ad5
SELECT NVL(dept.dname, '����'), a.job, a.sal
FROM dept,
    (SELECT deptno, job, SUM(sal) sal
     FROM emp
     GROUP BY ROLLUP (deptno, job)) a
WHERE a.deptno = dept.deptno(+);


2. GROUPING SETS
ROLLUP�� ���� : ���ɾ��� ����׷쵵 ���� �ؾ��Ѵ�.
               ROLLUP���� ����� �÷��� �����ʿ��� ���������� ������
               ���� �߰������� �ִ� ����׷��� ���ʿ� �� ��� ������
               
GROUPING SETS : �����ڰ� ���� ������ ����׷��� ����
���� : GROUP BY GROUPING SETS (col1, col2)
GROUP BY col1
UNION ALL
GROUP BY col2

GROUP BY GROUPING SETS (col2, col1)
GROUP BY col2
UNION ALL
GROUP BY col1


SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(job, deptno);

SELECT job, null deptno, SUM(sal)
FROM emp
GROUP BY job
UNION ALL
SELECT null, deptno, SUM(sal)
FROM emp
GROUP BY deptno;

�׷������ 
1. job, deptno
2. mgr

GROUP BY GROUPING SETS ( (job, deptno), mgr )

SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY GROUPING SETS ( (job, deptno), mgr );



3. CUBE
���� : GROUP BY CUBE (col1, col2, ...)
����� �÷��� ������ ��� ���� (������ ��Ų��)

GROUP BY CUBE (job, deptno);

    1       2
  job,    deptno
  job,      x
    x,    deptno
    x,      x
    
SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE (job, deptno);


�������� REPORT GROUP ����ϱ�
SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

** �߻� ������ ������ ���   
1       2       3
job     deptno  mgr ==> GROUP BY job, deptno, mgr
job     x       mgr ==> GROUP BY job, mgr
job     deptno  x   ==> GROUP BY job, deptno
job     x       x   ==> GROUP BY job


SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(job, deptno), CUBE(mgr);

1       2       3       4
job     job     deptno  mgr ==> GROUP BY job, deptno, mgr
job     job     x       mgr ==> GROUP BY job, mgr
job     x       x       mgr ==> GROUP BY job, mgr
job     job     deptno  x   ==> GROUP BY job, deptno
job     job     x       x   ==> GROUP BY job
job     x       x       x   ==> GROUP BY job




��ȣ ���� �������� ������Ʈ
1. emp���̺��� �̿��Ͽ� emp_test ���̺� ����
   ==> ������ ������ emp_test ���̺� ���� ���� ����
   DROP TABLE emp_test;
   CREATE TABLE emp_test AS
    SELECT *
    FROM emp
    WHERE 1=1;
    
    DESC emp_test;
2. emp_test ���̺��� dname�÷� �߰�(dept ���̺� ����)
    DESC dept;
    ALTER TABLE emp_test ADD (dname VARCHAR2(14));
    DESC emp_test;
    
3. subquery�� �̿��Ͽ� emp_test ���̺��� �߰��� dname �÷��� ������Ʈ ���ִ� ���� �ۼ�
    emp_test�� dname �÷��� ���� dept ���̺��� dname �÷����� update
    emp_test���̺��� deptno ���� Ȯ���ؼ� dept ���̺��� deptno ���̶� ��ġ�ϴ� dname �÷� ���� ������ update
    SELECT *
    FROM emp_test;

    MERGE INTO emp_test
    USING dept
    ON (emp_test.deptno = dept.deptno)
    WHEN MATCHED THEN
        UPDATE SET dname = dept.dname;

    ROLLBACK;

    emp_test���̺��� dname �÷��� dept ���̺��� �̿��ؼ� dname �� ��ȸ�Ͽ� ������Ʈ
    update ����� �Ǵ� �� : 14 ==> WHERE ���� ������� ����
    ��� ������ ������� dname �÷��� dept ���̺����� ��ȸ�Ͽ� ������Ʈ
    UPDATE emp_test SET dname = (SELECT dname
                                 FROM dept
                                 WHERE emp_test.deptno = dept.deptno);
    SELECT *
    FROM emp_test;
    
    
-- sub_a1
DROP TABLE dept_test;

SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
    SELECT *
    FROM dept
    WHERE 1 = 1;
    
ALTER TABLE dept_test ADD empcnt NUMBER;
DESC dept_test;

UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                               FROM emp
                               WHERE dept_test.deptno = emp.deptno
                               GROUP BY deptno);                        

SELECT ��� ��ü�� ������� �׷��Լ��� ������ ��� ���Ǵ� ���� ������ 0���� ����                               
SELECT COUNT(*)
FROM emp
WHERE 1 = 2; -- GROUP BY ���� ���� ������ �����ϴ� ���� ������ 0

GROUP BY ���� ����� ��� ����� �Ǵ� ���� ���� ��� ��ȸ�Ǵ� ���� ����
SELECT COUNT(*)
FROM emp
WHERE 1 = 2
GROUP BY deptno; -- GROUP BY ���� ���� ������ �����ϴ� ���� ������ ��ȸ��� ���� ���� <== GROUP BY ���� ���ʿ� ����


SELECT *
FROM dept_test;
SELECT *
FROM emp;

ROLLBACK;

MERGE INTO dept_test
USING (SELECT deptno, COUNT(*) cnt FROM emp GROUP BY deptno) emp
ON (dept_test.deptno = emp.deptno)
WHEN MATCHED THEN
    UPDATE SET empcnt = emp.cnt;