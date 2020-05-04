GROUP BY
�������� �ϳ��� ���̴°� �ٽ�


DBMS : DataBase Management System
 ==> db
RDBMS : Relational DataBase Management System
 ==> ������ �����ͺ��̽� ���� �ý���
        80�� �ʹ�
        
JOIN ������ ����
ANSI - ǥ��
�������� ����(ORACLE)
        

JOIN�� ��� �ٸ� ���̺��� �÷��� ����� �� �ֱ� ������
SELECT �� �� �ִ� �÷��� ������ ��������(���� Ȯ��)


NATURAL JOIN 
    . �����Ϸ��� �� ���̺��� ������� �÷��� �̸��� ���� ���
    . emp, dept ���̺����� deptno��� �����(������ Ÿ��, �̸���) ������� �÷��� ����
    . �ٸ� ANSI-SQL ������ ���ؼ� ��ü�� �����ϰ�, ���� ���̺����� �÷����� �������� ������
      ����� �Ұ����ϱ� ������ ���󵵴� �ټ� ����

    
.emp ���̺� : 14��
.dept ���̺� : 4��

���� �Ϸ��� �ϴ� �÷��� ���� ������� ����
SELECT *
FROM emp NATURAL JOIN dept;

ORACLE ���� ������ ANSI ����ó�� ����ȭ ���� ����
����Ŭ ���� ����
 1. ������ ���̺� ����� FROM ���� ����ϸ� �����ڴ� �ݷ�(,)
 2. ������� ������ WHERE���� ����ϸ� �ȴ� (ex : WHERE emp.deptno = dept.deptno)
 
 SELECT *
 FROM emp, dept
 WHERE emp.deptno = dept.deptno;
 
 deptno�� 10���� �����鸸 dept ���̺��� ���� �Ͽ� ��ȸ

 SELECT *
 FROM emp, dept
 WHERE emp.deptno = 10 AND emp.deptno = dept.deptno;

 ANSI-SQL : JOIN with USING
  . join �Ϸ��� ���̺��� �̸��� ���� �÷��� 2�� �̻��� ��
  . �����ڰ� �ϳ��� �÷����θ� �����ϰ����� �� ���� �÷Ÿ��� ���
  
 SELECT *
 FROM emp JOIN dept USING (deptno);
 
 ANSI-SQL : JOIN with ON
  . ���� �Ϸ��� �� ���̺��� �÷����� �ٸ� ��
  . ON���� ������� ������ ���
  
 SELECT *
 FROM emp JOIN dept ON (emp.deptno = dept.deptno);
 
 ORACLE �������� �� SQL�� �ۼ�
 SELECT *
 FROM emp, dept
 WHERE emp.deptno = dept.deptno;
 
 
 
 JOIN�� �������� ����
 SELF JOIN : �����Ϸ��� ���̺��� ���� ���� ��
 emp ���̺��� ������ ������ ������ ��Ÿ���� ������ ������ mgr �÷��� �ش� ������ ������ ����� ����
 �ش� ������ �������� �̸��� �˰����� ��

 ANSI-SQL�� SQL ���� :
 �����Ϸ��� �ϴ� ���̺� emp(����), emp(������ ������)
            ������� �÷� : ����.mgr = ������.empno
            ==> ���� �÷� �̸��� �ٸ���(mgr, empno)
                 ==> NATURAL JOIN, JOIN WITH USING�� ����� �Ұ����� ����
                     ==> JOIN with ON
 
 SELECT *
 FROM emp a JOIN emp b ON (a.mgr=b.empno);
                     
 SELECT *
 FROM emp a, emp b
 WHERE a.mgr = b.empno;
 
 
 NONEQUI JOIN : ������� ������ = �� �ƴҶ�
 
 �׵��� WHERE���� ����� ������ : =, !=, <>, <=, <, >, >=
                             AND, OR, NOT
                             LIKE %, _
                             OR - IN
                             BETWEEN AND ==> >=, <=
                             
 SELECT *
 FROM emp;
 
 SELECT *
 FROM salgrade;
 
 SELECT *
 FROM emp JOIN salgrade ON ( LOSAL <= emp.sal AND HISAL >= emp.sal );
 
 SELECT empno, ename, sal, salgrade.grade
 FROM emp JOIN salgrade ON ( emp.sal BETWEEN salgrade.losal AND salgrade.hisal );
 
 SELECT *
 FROM emp, salgrade
 WHERE losal <= emp.sal AND hisal >= emp.sal;
 
 
 -- �ǽ� join0
 SELECT empno, ename, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno )
 ORDER BY dname;
 
 SELECT empno, ename, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno
 ORDER BY dname;
 
 -- �ǽ� join0_1
 
 SELECT empno, ename, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno AND emp.deptno IN(10,30))
 ORDER BY empno ASC;
 
 SELECT empno, ename, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno AND a.deptno IN (10, 30)
 ORDER BY empno ASC;
 
 -- �ǽ� join0_2
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a JOIN dept b ON ( a.deptno = b.deptno AND sal > 2500 )
 ORDER BY a.deptno;
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno AND sal > 2500
 ORDER BY a.deptno;
 
 -- �ǽ� join0.3~4 ����
 
 --3
 SELECT empno, ename, sal, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600 )
 ORDER BY deptno;
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno
       AND sal > 2500
       AND empno > 7600
 ORDER BY deptno;
 --4
 SELECT empno, ename, sal, emp.deptno, dname
 FROM emp JOIN dept ON ( emp.deptno = dept.deptno
                         AND sal > 2500
                         AND empno > 7600
                         AND dname = 'RESEARCH' )
 ORDER BY empno DESC;
 
 SELECT empno, ename, sal, a.deptno, dname
 FROM emp a, dept b
 WHERE a.deptno = b.deptno
       AND sal > 2500
       AND empno > 7600
       AND dname = 'RESEARCH'
 ORDER BY empno DESC;
 
 -- �ǽ� join1
 
 SELECT lprod_gu, lprod_nm, prod_id, prod_name
 FROM prod JOIN lprod ON ( prod_lgu = lprod_gu );
 
 SELECT lprod_gu, lprod_nm, prod_id, prod_name
 FROM prod, lprod
 WHERE prod_lgu = lprod_gu;