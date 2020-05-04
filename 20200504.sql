������

��Ģ ������ : +, -, *, /
���� ������ : ?  1==1 ? true�� �� ���� : false�� �� ����

SQL ������
= : �÷�|ǥ���� = �� ==> ���� ������
IN : �÷�|ǥ���� IN (����)
    deptno IN (10, 30)
    
EXISTS ������
����� : EXISTS (��������)
���������� ��ȸ����� �Ѱ��̶� ������ TRUE
�߸��� ����� : WHERE deptno EXISTS (��������)

���������� ���� ���� ���� ���������� ���� ����� �׻� ���� �ϱ� ������
emp ���̺��� ��� �����Ͱ� ��ȸ �ȴ�

�Ʒ� ������ ���ȣ ��������
�Ϲ������� EXISTS �����ڴ� ��ȣ���� ���������� ���� ���

EXISTS �������� ����
�����ϴ� ���� �ϳ��� �߰��� �ϸ� ���̻� Ž���� ���� �ʰ� �ߴ���
���� ���� ���ο� ������ ���� �� ���

SELECT *
FROM emp
WHERE EXISTS (SELECT 'X'
              FROM dept);
              
�Ŵ����� ���� ���� : KING
�Ŵ��� ������ �����ϴ� ���� : 13���� ����

SELECT *
FROM emp e
WHERE EXISTS ( SELECT 'X' -- �÷��� ���� �߿��Ѱ� �ƴϰ� ���� ������ �߿��ϱ� ������ 'X'�� ������ ��ü����
               FROM emp m
               WHERE e.mgr = m.empno);

IS NOT NULL�� ���ؼ��� ������ ����� ����� �� �� �ִ�
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

join
SELECT e.*
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- �ǽ� sub9

SELECT *
FROM cycle;

SELECT *
FROM product;

1�� ������ �Դ� ��ǰ����
SELECT *
FROM cycle
WHERE cid = 1;

SELECT *
FROM product
WHERE EXISTS (SELECT *
              FROM cycle
              WHERE cid = 1
              AND cycle.pid = product.pid);
              
-- �ǽ� sub10              

SELECT *
FROM product
WHERE NOT EXISTS (SELECT *
                  FROM cycle
                  WHERE cid = 1
                    AND cycle.pid = product.pid);
          
���տ���
������
(1, 5, 3) U (2, 3) = {1, 2, 3, 5}

SQL���� �����ϴ� UNION ALL (�ߺ� �����͸� �������� �ʴ´�)
(1, 5, 3) U (2, 3) = {1, 5, 3, 2, 3}

������
(1, 5, 3) ������ (2, 3) = {3}

������
(1, 5, 3) - (2, 3) = {1, 5}

SQL������ ���տ���
������ : UNION, UNION ALL, INTERSECT, MINUS
�ΰ��� SQL�� �������� ���� Ȯ�� (��, �Ʒ��� ���� �ȴ�)

UNION ������ : �ߺ�����(������ ������ ���հ� ����);

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

UNION ALL ������ : �ߺ����

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

INTERSECT ������ : �����հ� �ߺ��Ǵ� ��Ҹ� ��ȸ

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

MINUS ������ : ���� ���տ��� �Ʒ��� ���� ��Ҹ� ����

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);



SQL ���տ������� Ư¡

1. ���� �̸� : ù�� SQL�� �÷��� ���󰣴�

ù��° ������ �÷����� ��Ī �ο�
�ι�° ������ ��Ī�� ���־����� ��ü �������� ù��° �÷� ��Ī�� ����
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)
UNION
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7698);

2. ������ �ϰ����� ��� �������� ���� ���� ���� SQL���� ORDER BY �Ұ� (�ζ��κ並 ����Ͽ� ������������ ORDER BY�� ������� ������ ����)
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)
-- ORDER BY nm, �߰� ������ ���� �Ұ�
UNION
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7698)
ORDER BY nm;

3. SQL�� ���� �����ڴ� �ߺ��� �����Ѵ�(������ ���� ����� ����), UNION ALL�� �ߺ� ���

4. �ΰ��� ���տ��� �ߺ��� �����ϱ� ���� ������ ������ �����ϴ� �۾��� �ʿ�
   ==> ����ڿ��� ����� �����ִ� �������� ������
      ==> UNION ALL�� ����� �� �ִ� ��Ȳ�� ��� UNION�� ������� �ʾƾ� �ӵ����� ���鿡�� �����ϴ�
   
�˰�����( ���� - ��������, ��������, .....
           �ڷᱸ�� : Ʈ������(����Ʈ��, �뷱�� Ʈ��)
                     heap
                     stack, queue
                     list
                     
���տ��꿡�� �߿��� ���� : �ߺ�����

���ù�������
���� SQL ���� : WHERE, �׷쿬���� ���� GROUP BY, ������ �Լ�(COUNT), 
                �ζ��� ��, ROWNUM, ORDER BY, ��Ī(�÷�, ���̺�), ROUND, JOIN

SELECT ROWNUM rank, SIDO, SIGUNGU, jisu
FROM (SELECT SIDO, SIGUNGU, ROUND((beg+mac+kfc)/(CASE
                                                 WHEN lot = 0 THEN 1
                                                 WHEN lot > 0 THEN lot
                                                 END), 2) jisu
      FROM(SELECT SIDO, SIGUNGU, COUNT(CASE
                                       WHEN GB = '�Ե�����' Then 1
                                       END) lot, COUNT(CASE
                                                       WHEN GB = '����ŷ' Then 1
                                                       END) beg, COUNT(CASE
                                                                       WHEN GB = '�Ƶ�����' Then 1
                                                                       END) mac, COUNT(CASE
                                                                                       WHEN GB = 'KFC' Then 1
                                                                                       END) kfc
          FROM FASTFOOD  
          GROUP BY SIDO, SIGUNGU)
      ORDER BY jisu DESC);


SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = '�Ե�����'
GROUP BY SIDO, SIGUNGU;

SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = '����ŷ'
GROUP BY SIDO, SIGUNGU;

SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = '�Ƶ�����'
GROUP BY SIDO, SIGUNGU;

SELECT SIDO, SIGUNGU, COUNT(*)
FROM FASTFOOD
WHERE GB = 'KFC'
GROUP BY SIDO, SIGUNGU;

SELECT beg.SIDO, beg.SIGUNGU, ROUND((Beg.Cnt+Mac.Cnt+Kfc.Cnt)/rot.cnt, 2) num
FROM (SELECT SIDO, SIGUNGU, COUNT(*) cnt
      FROM FASTFOOD
      WHERE GB = '����ŷ'
      GROUP BY SIDO, SIGUNGU) beg , (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                     FROM FASTFOOD
                                     WHERE GB = '�Ƶ�����'
                                     GROUP BY SIDO, SIGUNGU) mac, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                   FROM FASTFOOD
                                                                   WHERE GB = 'KFC'
                                                                   GROUP BY SIDO, SIGUNGU) kfc, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                                                 FROM FASTFOOD
                                                                                                 WHERE GB = '�Ե�����'
                                                                                                 GROUP BY SIDO, SIGUNGU) rot
WHERE beg.SIDO = mac.SIDO AND mac.SIDO = kfc.SIDO AND kfc.SIDO = rot.SIDO 
AND beg.SIGUNGU = Mac.Sigungu AND Mac.SIGUNGU = kfc.SIGUNGU AND kfc.SIGUNGU = rot.SIGUNGU
ORDER BY num DESC;                                



SELECT ROWNUM RANK, sido, sigungu, num
FROM (SELECT beg.SIDO as sido, beg.SIGUNGU as sigungu, ROUND((Beg.Cnt+Mac.Cnt+Kfc.Cnt)/rot.cnt, 2) num
      FROM (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM FASTFOOD
            WHERE GB = '����ŷ'
            GROUP BY SIDO, SIGUNGU) beg , (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                           FROM FASTFOOD
                                           WHERE GB = '�Ƶ�����'
                                           GROUP BY SIDO, SIGUNGU) mac, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                         FROM FASTFOOD
                                                                         WHERE GB = 'KFC'
                                                                         GROUP BY SIDO, SIGUNGU) kfc, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                                                       FROM FASTFOOD
                                                                                                       WHERE GB = '�Ե�����'
                                                                                                       GROUP BY SIDO, SIGUNGU) rot
WHERE beg.SIDO = mac.SIDO AND mac.SIDO = kfc.SIDO AND kfc.SIDO = rot.SIDO 
  AND beg.SIGUNGU = Mac.Sigungu AND Mac.SIGUNGU = kfc.SIGUNGU AND kfc.SIGUNGU = rot.SIGUNGU
ORDER BY num DESC);
-- ����ŷ = �Ƶ�����, ����ŷ = kfc, ����ŷ = �Ե����� �� ����� ������ �ٸ�, ���� ���� ���� �ٸ��⶧����

SELECT ROWNUM RANK, sido, sigungu, num
FROM (SELECT beg.SIDO as sido, beg.SIGUNGU as sigungu, ROUND((Beg.Cnt+Mac.Cnt+Kfc.Cnt)/rot.cnt, 2) num
      FROM (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM FASTFOOD
            WHERE GB = '����ŷ'
            GROUP BY SIDO, SIGUNGU) beg , (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                           FROM FASTFOOD
                                           WHERE GB = '�Ƶ�����'
                                           GROUP BY SIDO, SIGUNGU) mac, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                         FROM FASTFOOD
                                                                         WHERE GB = 'KFC'
                                                                         GROUP BY SIDO, SIGUNGU) kfc, (SELECT SIDO, SIGUNGU, COUNT(*) cnt
                                                                                                       FROM FASTFOOD
                                                                                                       WHERE GB = '�Ե�����'
                                                                                                       GROUP BY SIDO, SIGUNGU) rot
WHERE beg.SIDO = mac.SIDO AND mac.SIDO = kfc.SIDO AND kfc.SIDO = rot.SIDO 
  AND beg.SIGUNGU = Mac.Sigungu AND Mac.SIGUNGU = kfc.SIGUNGU AND kfc.SIGUNGU = rot.SIGUNGU
ORDER BY num DESC);




--�ʼ�
����1] fastfood ���̺��� tax ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� SQL �ۼ�
 1. �õ� �ñ����� ���ù��������� ���ϰ�(������ ���� ���ð� ������ ����) 
 2. �δ� ���� �Ű����� ���� �õ� �ñ������� ������ ���Ͽ�
 3. ���ù��������� �δ� �Ű��� ������ ���� �����ͳ��� �����Ͽ� �Ʒ��� ���� �÷��� ��ȸ�ǵ��� �ۼ�
 
����, �ܹ��� �õ�, �ܹ��� �ñ���, �ܹ��� ���ù�������, ����û �õ�, ����û �ñ���, ����û �������� �ݾ�1�δ� �Ű���

SELECT *
FROM tax;

SELECT ROWNUM tax_rank, sido tax_sido, sigungu tax_sigungu, tax_jisu  -- ����û ����
FROM (SELECT sido, sigungu, people, sal, ROUND(sal/people, 2) tax_jisu
      FROM tax
      ORDER BY tax_jisu DESC);


SELECT ham_rank as rank, ham_sido, ham_sigungu, ham_jisu, tax_sido, tax_sigungu, tax_jisu
FROM (SELECT ROWNUM ham_rank, SIDO ham_sido, SIGUNGU ham_sigungu, ham_jisu
      FROM (SELECT SIDO, SIGUNGU, ROUND((beg+mac+kfc)/(CASE
                                                       WHEN lot = 0 THEN 1
                                                       WHEN lot > 0 THEN lot
                                                       END), 2) ham_jisu
            FROM(SELECT SIDO, SIGUNGU, COUNT(CASE
                                             WHEN GB = '�Ե�����' Then 1
                                             END) lot, COUNT(CASE
                                                             WHEN GB = '����ŷ' Then 1
                                                             END) beg, COUNT(CASE
                                                                             WHEN GB = '�Ƶ�����' Then 1
                                                                             END) mac, COUNT(CASE
                                                                                             WHEN GB = 'KFC' Then 1
                                                                                             END) kfc
                 FROM FASTFOOD  
                 GROUP BY SIDO, SIGUNGU)
                 ORDER BY ham_jisu DESC)) ham

, (SELECT ROWNUM tax_rank, sido tax_sido, sigungu tax_sigungu, tax_jisu 
   FROM (SELECT sido, sigungu, people, sal, ROUND(sal/people, 2) tax_jisu
         FROM tax
         ORDER BY tax_jisu DESC)) tax
WHERE ham.ham_rank = tax.tax_rank;


--�ɼ�
����2] �ܹ��� ���ù��� ������ ���ϱ� ���� 4���� �ζ��� �並 ��� �Ͽ��µ� (fastfood ���̺��� 4�� ���)
�̸� �����Ͽ� ���̺��� �ѹ��� �д� ���·� ������ ���� (fastfood ���̺��� 1���� ���), CASE�� DECODE �̿�

SELECT ROWNUM rank, SIDO, SIGUNGU, jisu
FROM (SELECT SIDO, SIGUNGU, ROUND((beg+mac+kfc)/(CASE
                                                 WHEN lot = 0 THEN 1
                                                 WHEN lot > 0 THEN lot
                                                 END), 2) jisu
      FROM(SELECT SIDO, SIGUNGU, COUNT(CASE
                                       WHEN GB = '�Ե�����' Then 1
                                       END) lot, COUNT(CASE
                                                       WHEN GB = '����ŷ' Then 1
                                                       END) beg, COUNT(CASE
                                                                       WHEN GB = '�Ƶ�����' Then 1
                                                                       END) mac, COUNT(CASE
                                                                                       WHEN GB = 'KFC' Then 1
                                                                                       END) kfc
          FROM FASTFOOD  
          GROUP BY SIDO, SIGUNGU)
      ORDER BY jisu DESC);
      
����3] �ܹ��� ���� sql�� �ٸ����·� �����ϱ�
SELECT sido, sigungu, count(*)
FROM FASTFOOD
WHERE gb = '�Ե�����'
GROUP BY sido, sigungu;