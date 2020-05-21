sub_a2]
DROP TABLE dept_test;

SELECT *
FROM dept;

DELETE dept
WHERE deptno NOT IN (10, 20, 30, 40);

COMMIT;

CREATE TABLE dept_test as
    SELECT *
    FROM dept;
    
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES(99, 'it1', 'daejeon');
INSERT INTO dept_test VALUES(99, 'it1', 'daejeon');

SELECT *
FROM emp;

DELETE dept_test
WHERE deptno NOT IN ( SELECT deptno FROM emp );

DELETE dept_test
WHERE NOT EXISTS(SELECT 'X'
                 FROM emp
                 WHERE emp.deptno = dept_test.deptno);

SELECT *
FROM dept_test;


sub_a3]

SELECT *
FROM emp_test;

SELECT *
FROM emp_test a
WHERE sal < ( SELECT AVG(sal)
              FROM emp_test b
              WHERE a.deptno = b.deptno
              GROUP BY deptno);
              
SELECT deptno, AVG(sal)
FROM emp_test
GROUP BY deptno;


UPDATE emp_test a SET sal = sal + 200
WHERE sal < ( SELECT AVG(sal)
              FROM emp_test b
              WHERE a.deptno = b.deptno
              GROUP BY deptno);

������Ʈ ���� SELECT�� �غ���!

SELECT *
FROM emp_test;


���� ���� �ƴ�����, �˻�-������ ���� ������ ǥ��
���������� ���� ���
1. Ȯ���� : ��ȣ���� �������� (EXISTS)
           ==> ���� ���� ���� ���� ==> �������� ����, ������ �ڹٲ� �� ���� 
2. ������ : ���������� ���� ����ż� ���������� ���� ���� ���ִ� ����
13�� : �Ŵ����� �����ϴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IN (SELECT empno
              FROM emp);

�μ��� �޿������ ��ü �޿���պ��� ū �μ��� �μ���ȣ, �μ��� �޿� ���

�μ��� ��� �޿� (�Ҽ��� ��° �ڸ����� ��� �����)
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;

��ü �޿� ���
SELECT ROUND(AVG(sal), 2)
FROM emp;


�Ϲ����� �������� ����
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal), 2) > (SELECT ROUND(AVG(sal), 2)
                             FROM emp);


WITH �� : SQL���� �ݺ������� ������ QUERY BLOCK(SUBQUERY)�� ������ �����Ͽ�
          SQL ����� �ѹ��� �޸𸮿� �ε��� �ϰ� �ݺ������� ����� �� �޸� ������ �����͸�
          Ȱ���Ͽ� �ӵ� ������ �� �� �ִ� KEYWORD
          ��, �ϳ��� SQL���� �ݺ����� SQL ������ ������ ���� �߸� �ۼ��� SQL�� ���ɼ��� ���� ������
          �ٸ� ���·� �����Ҽ� �ִ����� ���� �غ��� ���� ��õ.
WITH emp_avg_sal AS( SELECT ROUND(AVG(sal), 2)
                     FROM emp)
SELECT deptno, ROUND(AVG(sal), 2), (SELECT * FROM emp_avg_sal)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal), 2) > (SELECT * FROM emp_avg_sal);



CONNECT BY LEVEL : ���� �ݺ��ϰ� ���� ����ŭ ������ ���ִ� ���
��ġ : FROM(WHERE)�� ������ ���
DUAL ���̺��� ���� ���

���̺��� ���� �Ѱ�, �޸𸮿��� ����
SELECT dual.*, LEVEL
FROM dual
CONNECT BY LEVEL <= 5;

���� ���� ������ �̹� ��� KEYWORD�� �̿��Ͽ� �ۼ� ����
5�� �̻��� �����ϴ� ���̺��� ���� ���� ����
���࿡ �츮�� ������ �����Ͱ� 10000���̸� 10000�ǿ� ���� DISK I/O�� �߻�
SELECT ROWNUM
FROM emp
WHERE ROWNUM < 6;



1. �츮���� �־��� ���ڿ� ��� : 202005
   �־��� ����� �ϼ��� ���Ͽ� �ϼ���ŭ ���� ���� ==> 31


�޷��� �÷��� 7�� - �÷��� ������ ���� : Ư�����ڴ� �ϳ��� ���Ͽ� ����
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');


SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt, 7�� �÷��� �߰��� ����
      �Ͽ����̸� dt �÷�, �������̸� dt�÷�, ȭ�����̸� dt �÷�, ����� �̸� dt�÷�
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');


�Ʒ� ������� SQL�� �ۼ��ص� ������ �ϼ��ϴ°� �����ϳ�
������ ���鿡�� �ʹ� �����Ͽ� �ζ��κ並 �̿��Ͽ� ������ �ܼ��ϰ� �����
SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt,
       DECODE(TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'd'), '1', TO_DATE(202005, 'YYYYMM') + LEVEL-1) mon -- �Ͽ���1 ~ �����7
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');
 
 
�÷��� ����ȭ �Ͽ� ǥ��
SELECT TO_DATE(202005, 'YYYYMM') ==> dt;

SELECT dt, dt�� �� dt, dt�� ȭ dt, .... 7���� �÷��߿� �� �ϳ��� �÷����� dt ���� ǥ���ȴ�
FROM
(SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt  
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd'));


- ����Ŭ������ ��~�ϱ����� ���� ������
SELECT TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd');


-- � �׷��Լ��� ����ص� ���� ������ min�� ����ϴ°� ���ɻ� ���� ���ٰ� �Ѵ�.
SELECT DECODE(d, 1, iw+1, iw) "iw", -- �Ͽ����̸� ������ + 1
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) thu,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(202005, 'YYYYMM') + LEVEL-1 dt,
        TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'd') d,
        TO_CHAR(TO_DATE(202005, 'YYYYMM') + LEVEL-1, 'iw') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(202005, 'YYYYMM')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);



-- ���ε� ��������
SELECT DECODE(d, 1, iw+1, iw) "iw", -- �Ͽ����̸� ������ + 1
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) thu,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1 dt,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'd') d,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'iw') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


SELECT
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) thu,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1 dt,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'd') d,
        TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'iw') iw,
        TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) - TO_CHAR( TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'd' ) + 1 f_sun
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'dd'))
GROUP BY f_sun
ORDER BY f_sun;



create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;


SELECT *
FROM SALES;

SELECT DECODE(MONTH, 01, sum) JAN,
       DECODE(MONTH, 02, sum) FEB,
       DECODE(MONTH, 03, sum) MAR,
       DECODE(MONTH, 04, sum) APR,
       DECODE(MONTH, 05, sum) MAY,
       DECODE(MONTH, 06, sum) JUN
FROM
(SELECT TO_CHAR(DT, 'MM') MONTH, SUM(sales) sum
 FROM sales
 GROUP BY TO_CHAR(DT, 'MM'))
GROUP BY ;


SELECT TO_CHAR(DT, 'MM') m, sales
FROM sales;

SELECT MIN(DECODE(MONTH, 01, SUM(sales))) JAN,
       MIN(DECODE(MONTH, 02, SUM(sales))) FEB,
       MIN(DECODE(MONTH, 03, SUM(sales))) MAR,
       MIN(DECODE(MONTH, 04, SUM(sales))) APR,
       MIN(DECODE(MONTH, 05, SUM(sales))) MAY,
       MIN(DECODE(MONTH, 06, SUM(sales))) JUN
FROM
(SELECT TO_CHAR(DT, 'MM') MONTH, sales
 FROM sales)
GROUP BY MONTH;

�ǽ�2
ù��° �Ͽ��ϰ� ������������� ���ϴ¹�?
5�� 1�Ϸ� ���� 4�� 28��

