OUTER JOIN
���̺� ���� ������ �����ص�, �������� ���� ���̺��� �÷��� ��ȸ�� �ǵ��� �ϴ� ���� ���
<===>
INNER JOIN( ���ݱ��� ��� ��� )


LEFT OUTER JOIN     : ������ �Ǵ� ���̺��� JOIN Ű���� ���ʿ� ��ġ
RIGHT OUTER JOIN    : ������ �Ǵ� ���̺��� JOIN Ű���� �����ʿ� ��ġ
FULL OUTER JOIN     : LEFT OUTER JOIN + RIGHT OUTER JOIN - (�ߺ��Ǵ� �����Ͱ� �ѰǸ� ������ ó��)

emp���̺��� �÷��� mgr �÷��� ���� �ش� ������ ������ ������ ã�ư� �� �ִ�.
������ KING ������ ��� ����ڰ� ���� ������ �Ϲ����� inner ���� ó����
���ο� �����ϱ� ������ king�� ������ 13���� �����͸� ��ȸ�� ��.



SELECT a.employee_id as MGR_ID, a.first_name || a.last_name as MGR_NAME, b.employee_id as emp_id, b.first_name || b.last_name as NAME
FROM employees a, employees b
WHERE a.employee_id = b.manager_id
ORDER BY mgr_id;



INNER ���� ����
����� ���, ����� �̸�, ���� ���, ���� �̸�


������ �����ؾ����� �����Ͱ� ��ȸ�ȴ�
==> KING�� ����� ����(mgr)�� NULL �̱� ������ ���ο� �����ϰ�
    KING�� ������ ������ �ʴ´� (emp ���̺� �Ǽ� 14�� ==> ���� ��� 13��)


SELECT m.empno, m.ename, e.empno, e.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

ANSI-SQL
SELECT m.empno, m.ename, e.empno, e.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno );


���� ������ OUTER JOIN ���� ����
(KING ������ ���ο� �����ص� ���� ������ ���ؼ��� ��������,
 ������ ����� ������ ���� ������ ������ �ʴ´�) ;

ANSI-SQL : OUTER
SELECT m.empno as mgrno, m.ename as mgrnm, e.empno as empno, e.ename as empnm
FROM emp e  LEFT OUTER JOIN emp m ON ( e.mgr = m.empno ); -- 

SELECT m.empno as mgrno, m.ename as mgrnm, e.empno as empno, e.ename as empnm
FROM emp e  RIGHT OUTER JOIN emp m ON ( e.mgr = m.empno ); -- 
                                                           -- m�� �ִ� ����� �����ڷ� �ϴ� e�� ����� ���� ��찡 �ִ� 

SELECT m.empno, m.ename, e.empno, e.ename
FROM emp m  RIGHT OUTER JOIN emp e ON ( e.mgr = m.empno );

ORACLE-SQL : OUTER
oracle join
 1. FROM���� ������ ���̺��� ���( ,�� ���� )
 2. WHERE���� ���� ������ ���
 3. ���� �÷�(�������)�� ������ �����Ͽ� �����Ͱ� ���� ���� �÷��� (+)�� �ٿ� �ش�
    ==> ������ ���̺� �ݴ����� ���̺��� �÷�
 
SELECT m.empno, m.ename, e.empno, e.ename
FROM emp e, emp m -- e�� ������ ���̺�
WHERE e.mgr = m.empno(+);
 


OUTER ������ ���� ��� ��ġ�� ���� ��� ��ȭ

������ ����� �̸�, ���̵� �����ؼ� ��ȸ
��, ������ �ҼӺμ��� 10���� ���ϴ� �����鸸 �����ؼ�;

������ ON���� ������� ��
SELECT m.empno, m.ename, e.empno, e.ename, e.deptno
FROM emp e  LEFT OUTER JOIN emp m ON ( e.mgr = m.empno AND e.deptno = 10);

ORACLE-SQL
SELECT m.empno, m.ename, e.empno, e.ename, e.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
      AND e.deptno = 10;

������ WHERE���� ������� ��
SELECT m.empno, m.ename, e.empno, e.ename, e.deptno
FROM emp e  LEFT OUTER JOIN emp m ON ( e.mgr = m.empno )
WHERE e.deptno = 10;

OUTER ������ �ϰ� ���� ���̶�� ������ ON���� ����ϴ°� �´�


-- �ǽ� outerjoin1
SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT *
FROM prod;

ANSI-SQL
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON ( prod.prod_id = buyprod.buy_prod
                                       AND buyprod.buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD') );
                                       
ORACLE-SQL
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
      FROM prod a, buyprod b
      WHERE a.prod_id = b.buy_prod(+) AND b.buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT c.buy_date, c.buy_prod, d.prod_id, d.prod_name, c.buy_qty
FROM
     (SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
      FROM prod a, buyprod b
      WHERE a.prod_id = b.buy_prod AND b.buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD')) c, prod d
WHERE d.prod_id = c.prod_id(+);


SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod RIGHT OUTER JOIN buyprod ON ( prod.prod_id = buyprod.buy_prod
AND buyprod.buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD') );

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod LEFT OUTER JOIN prod ON ( prod.prod_id = buyprod.buy_prod
AND buyprod.buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD') );


-- �ǽ� outerjoin2
SELECT TO_DATE('2005/01/25', 'YYYY/MM/DD') as buy_date, buy_prod, prod_id, prod_name, buy_qty
      FROM prod a, buyprod b
      WHERE a.prod_id = b.buy_prod(+) AND b.buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');
      
-- �ǽ� outerjoin3
SELECT TO_DATE('2005/01/25', 'YYYY/MM/DD') as buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0) as buy_qty
      FROM prod a, buyprod b
      WHERE a.prod_id = b.buy_prod(+) AND b.buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

-- �ǽ� outerjoin4
SELECT *
FROM cycle
WHERE cid = 1;

SELECT *
FROM product;

ORACLE-SQL
SELECT b.pid, b.pnm, 1 as cid, NVL(a.day, 0) day, NVL(a.cnt, 0) CNT 
FROM cycle a, product b
WHERE  b.pid = a.pid(+) AND a.cid(+) = 1;

ANSI-SQL
SELECT a.pid, a.pnm, 1 as cid, NVL(b.day, 0) day, NVL(b.cnt, 0) cnt
FROM product a LEFT OUTER JOIN cycle b ON ( a.pid = b.pid AND b.cid = 1);

SELECT *
FROM product a LEFT OUTER JOIN cycle b ON ( a.pid = b.pid AND b.cid = 1);

SELECT *
FROM product a RIGHT OUTER JOIN cycle b ON ( a.pid = b.pid AND b.cid = 1);

-- �ǽ� outerjoin5
SELECT *
FROM customer;

ANSI-SQL
SELECT c.pid, c.pnm, c.cid, d.cnm, c.day, c.cnt
FROM
(SELECT a.pid, a.pnm, 1 as cid, NVL(b.day, 0) day, NVL(b.cnt, 0) cnt
FROM product a LEFT OUTER JOIN cycle b ON ( a.pid = b.pid AND b.cid = 1)) c JOIN customer d ON ( c.cid = d.cid );

ORACLE-SQL
SELECT c.pid, c.pnm, c.cid, d.cnm, c.day, c.cnt
FROM
(SELECT b.pid, b.pnm, 1 as cid, NVL(a.day, 0) day, NVL(a.cnt, 0) CNT 
FROM cycle a, product b
WHERE  b.pid = a.pid(+) AND a.cid(+) = 1) c, customer d
WHERE c.cid = d.cid
ORDER BY c.pid DESC, c.day DESC;


CROSS JOIN
���� ������ ������� ���� ���
��� ������ ���� �������� ����� ��ȸ�ȴ�
emp 14 * dept 4 = 56

ANSI-SQL
SELECT *
FROM emp CROSS JOIN dept;

ORACLE-SQL (���� ���̺��� ����ϰ� WHERE ���� ������ ������� �ʴ´�)
SELECT *
FROM emp, dept;

SELECT *
FROM product, cycle
WHERE product.pid = cycle.pid;

SELECT *
FROM product, cycle, customer
WHERE product.pid = cycle.pid;

-- �ǽ� crossjoin1
SELECT *
FROM customer, product;

SELECT *
FROM customer CROSS JOIN product;


��������
WHERE : ������ �����ϴ� �ุ ��ȸ�ǵ��� ����
SELECT *
FROM emp
WHERE 1 = 1
      OR 1 != 1; -- TRUE OR FALSE -> TRUE
      
���� <==> ����
���������� �ٸ� ���� �ȿ��� �ۼ��� ����
�������� ������ ��ġ
1. SELECT
    SCALAR SUB QUERY
    * ��Į�� ���������� ��ȸ�Ǵ� ���� 1���̰�, �÷��� �Ѱ��� �÷��̾�� �Ѵ�
     EX) DUAL ���̺�

2. FROM
    INLINE-VIEW
    SELECT ������ ��ȣ�� ���� ��
    
3. WHERE
    SUB QUERY
    WHERE ���� ���� ����
    
    
SMITH�� ���� �μ��� ���� �������� ���� ������?

1. SMITH�� ���� �μ���  �������?
2. 1������ �˾Ƴ� ������ȣ�� ���ϴ� ������ ��ȸ

==> �������� 2���� ������ ���� ����
    �ι�° ������ ù��° ������ ����� ���� ���� �ٸ��� �����;� �Ѵ�
    (SMITH(20) => WARD(30) ==> �ι�° ���� �ۼ��� 20������ 30������ ������ ����
     ==> �����������鿡�� ���� ����)
    
;
ù��° ����
SELECT deptno   -- 20
FROM emp
WHERE ename = 'SMITH';

�ι�° ����
SELECT *
FROM emp
WHERE deptno = 20;

���������� ���� ���� ����
SELECT *
FROM emp
WHERE deptno = (SELECT deptno   -- 20
                FROM emp
                WHERE ename = :ename);
                
-- �ǽ� sub1
SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);