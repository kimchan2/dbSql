SELECT
    :yyyymm param,
    TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm') ),'dd') dt
FROM
    dual;
    


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 3956160932
�����ȹ�� ���� ����(id)
* �鿩���Ⱑ �Ǿ������� �ڽ� ���۷��̼�
1. ������ �Ʒ���
2. * �� �ڽ� ���۷��̼��� ������ �ڽ� ���� �д´�.
 
 
 1 == > 0
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
   

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

   1 - filter(TO_CHAR("EMPNO")='7369')
   
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);



SELECT ename, sal, TO_CHAR(sal, 'L009,999.00') fm_sal
FROM emp;




NULL�� ���õ� �Լ�
NVL
NVL2
NULLIF
COALESCE;


�� NULL ó���� �ؾ��ұ�?
NULL�� ���� �������� NULL�̴�

������ emp ���̺��� �����ϴ� sal, comm �ΰ��� �÷� ���� ���� ���� �˰� �; ������ ���� SQL�� �ۼ�

SELECT empno, ename, sal, comm, sal + comm AS sal_plus_comm
FROM emp;

NVL(expr1, expr2)
 expr1�� NULL �̸� expr2 ���� �����ϰ� 
 expr1�� NULL�� �ƴϸ� expr1�� ����, expr1�� expr2�� ������ Ÿ���� ��ġ�ؾ��Ѵ�
 
 SELECT empno, ename, sal, comm, sal + NVL(comm, 0) AS sal_plus_comm
 FROM emp;
 
 REG_DT �÷��� NULL�� ��� ���� ��¥�� ���� ���� ������ ���ڷ� ǥ��
 SELECT userid, usernm, reg_dt
 FROM users;
 
 DESC users;
 
 SELECT userid, usernm, NVL(reg_dt, LAST_DAY(SYSDATE))
 FROM users;
 
SELECT userid, usernm, NVL( TO_CHAR(reg_dt, 'yyyymmdd'), TO_CHAR(LAST_DAY(SYSDATE), 'dd'))
 FROM users;
 
 
 
 
 
 
 
 
 