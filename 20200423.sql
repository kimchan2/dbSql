NULL�� ���õ� �Լ�
NVL
NVL2
NULLIF
COALESCE;


 NVL(expr1, expr2)
 expr1 ==  NULL return expr2 
 expr1 != NULL return expr1, expr1�� expr2�� ������ Ÿ���� ��ġ�ؾ��Ѵ�
 
 
 NVL2(expr1, expr2, expr3)
 if expr1 != null
    return expr2
 else
    return expr3
 
 SELECT empno, ename, sal, comm, NVL2(comm, 100, 200)
 FROM emp;
 
 
 
 NULLIF(expr1, expr2)
 if expr1 == expr2
    return null
 else
    return expr1
 
 sal�÷��� ���� 3000�̸� NULL�� ����   
 SELECT empno, ename, sal, NULLIF(sal, 3000)
 FROM emp;
 
 
 �������� : �Լ��� ������ ������ ������ ���� ����, �������ڵ��� Ÿ���� ���� �ؾ���
 ���ڵ��߿� ���� ���������� NULL�� �ƴ� ���� ���� ����
 coalesce(expr1, expr2, expr3.......)
 if expr1 != null
    return expr1
 else
    coalesce(expr2, expr3.......)
 
 mgr �÷� NULL
 comm �÷� NULL
 
 SELECT empno, ename, comm, sal, coalesce(comm, sal)
 FROM emp;
 
 
 -- null �ǽ� fn4
 
 SELECT empno, ename, mgr, NVL(mgr, 9999) MGR_N, NVL2(mgr, mgr, 9999) MGR_N_1, coalesce(mgr, 9999) MGR_N_2
 FROM emp;
 
 -- null �ǽ� fn5
 
 SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) N_REG_DT
 FROM users
 WHERE usernm != '����';
 
 
 
 condition
 ���ǿ� ���� �÷� Ȥ�� ǥ������ �ٸ� ������ ��ü
 java if, switch ���� ����
 1. case ����
 2. decode �Լ�
 
 1. CASE
 CASE
    WHEN ��/������ �Ǻ��� �� �ִ� �� THEN ������ ��
    [WHEN ��/������ �Ǻ��� �� �ִ� �� THEN ������ ��]
    [ELSE ������ ��(�Ǻ����� ���� WHEN ���� ���� ��� ����)]
 END
 
 emp ���̺��� ��ϵ� �����鿡�� ���ʽ��� �߰������� ������ ����
 �ش� ������ job�� SALESMAN�� ��� sal 5% �λ�� �ݾ��� ���ʽ��� ����
 �ش� ������ job�� MANAGER�� ��� sal 10% �λ�� �ݾ��� ���ʽ��� ����
 �ش� ������ job�� PRESIDENT�� ��� sal 20% �λ�� �ݾ��� ���ʽ��� ����
 �׿� �������� sal��ŭ�� ����
 
 SELECT empno, ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal * 1
        END bonus
 FROM emp;
 
 
 2. DECODE(EXPR1, search1, return1, search2, return2, search3, return3....., [default])
 
 DECODE(EXPR1,
            search1, return1,
            search2, return2,
            search3, return3
            ................,
            [default])
            
 if EXPR1 == search1
    return return1
 else if EXPR1 == search2
    return return2
 else if EXPR1 == search3
    return return3
 .....
 else
    return defual
 
 
 SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal*1.05, 'MANAGER', sal*1.1, 'PRESIDENT', sal*1.2, sal) bonus
 FROM emp;
 
 
 -- condition �ǽ� cond1
 
 SELECT empno, ename,
    CASE
        WHEN deptno = '10' THEN 'ACCOUNTING'
        WHEN deptno = '20' THEN 'RESEARCH'
        WHEN deptno = '30' THEN 'SALES'
        WHEN deptno = '40' THEN 'OPERATIONS'
        ELSE 'DDIT'
    END DNAME
 FROM emp;
 
 
 SELECT empno, ename,
    DECODE(deptno, '10', 'ACCOUNTING', '20', 'RESEARCH', '30', 'SALES', '40', 'OPERATIONS', 'DDIT') DNAME
 FROM emp;
 
 -- condition �ǽ� cond2
 SELECT empno, ename, hiredate,
    CASE
        WHEN MOD(TO_CHAR( hiredate, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
    END CONTACT_TO_DOCTOR
 FROM emp;
 
 SELECT empno, ename, hiredate,
    DECODE(MOD(TO_CHAR(hiredate, 'YYYY'),2), MOD(TO_CHAR(SYSDATE, 'YYYY'), 2), '�ǰ����� �����', '�ǰ����� ������') CONTACT_TO_DOCTOR
 FROM emp;
 
 -- condition �ǽ� cond3
 
 SELECT userid, usernm, ALIAS, REG_DT,
    CASE
        WHEN  MOD(TO_CHAR( reg_dt, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '�ǰ����� �����'
        WHEN reg_dt IS NULL THEN '�ǰ����� ������'
        ELSE '�ǰ����� ������'
    END CONTACTODOCTOR
 FROM users
 ORDER BY userid ASC;