�Ѱ��� ��, �ϳ��� �÷��� �����ϴ� ��������
ex : ��ü ������ �޿� ���, SMITH ������ ���� �μ��� �μ���ȣ

WHERE���� ��밡���� ������
WHERE deptno = 10
==>

�μ���ȣ�� 10 Ȥ�� 30���� ���
WHERE deptno IN(10, 30)
WHERE deptno = 10 OR deptno = 30)

WHERE deptno = (10,30) ==> error

������ ������
�������� ��ȸ�ϴ� ���������� ��� = �����ڸ� ���Ұ�
WHERE deptno IN(�������� ���� �����ϰ�, �ϳ��� �÷����� �̷���� ����)

SMITH - 20, ALLEN�� 30�� �μ��� ����

SMITH ���� ALLEN�� ���ϴ� �μ��� ������ ������ ��ȸ

���� ��������, �÷��� �ϳ��� 
==> ������������ ��밡���� ������ IN(���̾�), ANY, ALL (�ΰ��� �󵵰� ����)
IN : ���������� ������� ������ ���� ���� �� TRUE
WHERE �÷�|ǥ���� IN (��������)

ANY : �����ڸ� �����ϴ� ���� �ϳ��� ���� �� TRUE
    WHERE Į��|ǥ���� ������ ANY (��������)

ALL : ���������� ��� ���� �����ڸ� ������ �� TRUE
    WHERE Į��|ǥ���� ������ ALL (��������)


SMITH�� ALLEN�� ���� �μ����� �ٹ��ϴ� ��� ������ ��ȸ

1. ���������� ������� ���� ��� : �ΰ��� ������ ����
1-1] SMITH, ALLEN�� ���� �μ��� �μ���ȣ�� Ȯ���ϴ� ����
20, 30
SELECT deptno
FROM emp
WHERE ename IN ('SMITH', 'ALLEN');

1-2] 1-1]���� ���� �μ���ȣ�� IN������ ���� �ش� �μ��� ���ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20, 30);

==> ���������� �̿��ϸ� �ϳ��� SQL���� ���డ��

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'ALLEN'));
                 
-- �ǽ� sub3

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
                 
ANY, ALL
SMITH�� WARD �� ����� �޿��� �ƹ� ������ ���� �޿��� �޴� ���� ��ȸ
==> sal < 1250
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                 
SMITH�� WARD �� ����� �޿����� ū �޿��� �޴� ���� ��ȸ                 
==> sal > 1250
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                                  
IN �������� ����
SELECT *
FROM emp
WHERE deptno NOT IN (20, 30);
NOT IN�����ڸ� ����� ��� ���������� ���� NULL�� �ִ��� ���ΰ� �߿�
==> ���� ���� x

NULL���� ���� ���� ����
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp);

NULL ó�� �Լ��� ���� ������ ������ ���� �ʴ� ������ ġȯ                    
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr,-1)
                    FROM emp
                    WHERE mgr IS NOT NULL);
                    
���� �÷��� �����ϴ� ���������� ���� ���� ==> ���� �÷��� �����ϴ� ��������
PAIRWISE ���� (������) ==> ���ÿ� ����

SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

7499, 7782����� ������ (���� �μ�, ���� �Ŵ���)�� ��� ���� ���� ��ȸ
�Ŵ����� 7698�̸鼭 �ҼӺμ��� 30�� ���
�Ŵ����� 7839�̸鼭 �ҼӺμ��� 10�� ���

mgr �÷��� deptno �÷��� �������� ����
(mgr, deptno)
����� ���� 4����

SELECT *
FROM emp
WHERE mgr IN (7698, 7839) AND deptno IN (30, 10);

PAIREWISE ���� (���� �������� ����� �� �� ����)
SELECT *
FROM emp
WHERE(mgr, deptno) IN (SELECT mgr, deptno
                       FROM emp
                       WHERE empno IN(7499, 7782));


���� ���� ���� - ��� ��ġ
SELECT - ��Į�� ��������
FROM - �ζ��κ�
WHERE - ��������

�������� ���� - ��ȯ�ϴ� ��, �÷��� ��
���� ��
    - ���� �÷�(��Į�� ���� ����)
    - ���� �÷�
��Ƽ ��
    - ���� �÷�(���� ���� ����)
    - ���� �÷�
    
��Į�� ��������
SELECT ���� ǥ���Ǵ� ��������
������ ���� �÷��� �����ϴ� ���������� ��� ����
���� ������ �ϳ��� �÷� ó�� �ν�;

SELECT 'X', (SELECT SYSDATE FROM dual)
FROM dual;

��Į�� ���� ������ �ϳ��� ��, �ϳ��� �÷��� ��ȯ �ؾ� �Ѵ�

���� �ϳ����� �÷��� 2������ ����
SELECT 'X', (SELECT empno, ename FROM emp WHERE ename='SMITH')
FROM dual;

������ �ϳ��� �÷��� �����ϴ� ��Į�� �������� ==> ����
SELECT 'X', (SELECT empno FROM emp) -- single row subquery
FROM dual;

emp ���̺��� ����� ��� �ش� ������ �Ҽ� �μ� �̸��� �˼��� ���� ==> ����

Ư�� �μ��� �μ� �̸��� ��ȸ�ϴ� ����
SELECT dname
FROM dept
WHERE deptno = 10;

join���� ����
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

�� ������  ��Į�� ���������� ����
SELECT empno, ename, emp.deptno,(SELECT dname FROM dept WHERE deptno = emp.deptno)--, dname
FROM emp; -- ��ȣ���� �������� 

�������� ���� - ���������� �÷��� ������������ ����ϴ��� ���ο� ���� ����
��ȣ���� ��������(corelated sub query)
    . ���� ������ ����Ǿ�� ���� ������ ������ �����ϴ�
���ȣ ���� ��������(non corelated sub query)
    . ���� ������ ���̺��� ���� ��ȸ �� ���� �ְ�
      ���� ������ ���̺��� ���� ��ȸ �� ���� �ִ�
      ==> ����Ŭ�� �Ǵ� ���� �� ���ɻ� ������ �������� ����

��� ������ �޿���� ���� ���� �޿��� �޴� ������ ��ȸ�ϴ� ������ �ۼ� �ϼ���(���� ���� �̿�)
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
�����غ� ����, ���� ������ ��ȣ ���� ���������ΰ�? ���ȣ �ΰ�? ==> ���ȣ ����

������ ���� �μ��� �޿� ��պ��� ���� �޿��� �޴� ����
��ü ������ �޿� ��� ==> ������ ���� �μ��� �޿� ���

Ư�� �μ�(10)�� �޿� ����� ���ϴ� SQL
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = e.deptno); ==> ��ȣ ����
             
             
�ƿ��� ���� => ���̺��� �÷��� ���ο� �����ϴ��� ��ȸ�� �ȴ�
oracle 9i ���� ������ ������ �Ǵ� ���̺� ���� �д´�
==> 10g ���� ���ʹ� ���ɻ� ������ ���̺� ���� �д´�
             

SELECT *
FROM dept;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

emp���̺��� ��ϵ� �������� 10, 20, 30�� �μ����� �Ҽ��� �Ǿ�����
���� �Ҽӵ��� ���� �μ��� 40, 99

-- �ǽ� sub4
SELECT *
FROM dept
WHERE deptno NOT IN ( SELECT deptno
                      FROM emp
                      WHERE emp.deptno = dept.deptno);
                      
������ �μ���ȣ�� ������������ ��ȸ���� �ʵ��� ���� �ҷ��� �׷� ������ �Ѱ�� (���� ����)                      
SELECT *
FROM dept
WHERE deptno NOT IN ( SELECT emp.deptno
                      FROM dept, emp
                      WHERE dept.deptno = emp.deptno
                      GROUP BY emp.deptno);

������ ���� �μ� ���� ��ȸ(������ �Ѹ��̶� �����ϴ� �μ�)
SELECT *
FROM dept
WHERE deptno IN ( SELECT deptno
                  FROM emp);
                  
SELECT *
FROM dept
WHERE deptno NOT IN ( SELECT deptno
                      FROM emp);
                      
���������� �̿��Ͽ� IN�����ڸ� ���� ��ġ�ϴ� ���� �ִ��� ������ ��
���� ������ �־ ����� ����(����)

-- �ǽ� sub5

SELECT PID
FROM cycle
WHERE cid = 1;

SELECT *
FROM product
WHERE PID NOT IN (SELECT PID
                  FROM cycle
                  WHERE cid = 1);
                  
-- �ǽ� sub6
1�� ������ ������ǰ ������ ��ȸ�� �Ѵ�.
��, 2�� ������ �Դ� ������ǰ�� ��ȸ�� �Ѵ�

1] 1�� ������ �Դ� ������ǰ����
SELECT *
FROM cycle
WHERE cid = 1;
2] 2�� ������ �Դ� ������ǰ����
SELECT *
FROM cycle
WHERE cid = 2;


SELECT *
FROM cycle
WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle
                          WHERE cid = 2);
                          
-- �ǽ� sub7            
SELECT cnm FROM customer WHERE cid = 1;
SELECT pnm FROM product WHERE pid = 100 ;

��Į�� ���������� �̿��� ���
SELECT cid, (SELECT cnm FROM customer WHERE cid = cycle.cid) cnm,
       pid, (SELECT pnm FROM product WHERE pid = cycle.pid ) pnm, day, cnt
FROM cycle
WHERE cid = 1 
  AND pid IN (SELECT pid
              FROM cycle
              WHERE cid = 2);

������ �̿��� ���
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = customer.cid
      AND cycle.pid = product.pid 
      AND cycle.cid = 1
      AND cycle.pid IN (SELECT pid
                        FROM cycle b
                        WHERE cid = 2);