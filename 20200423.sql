NULL과 관련된 함수
NVL
NVL2
NULLIF
COALESCE;


 NVL(expr1, expr2)
 expr1 ==  NULL return expr2 
 expr1 != NULL return expr1, expr1과 expr2의 데이터 타입은 일치해야한다
 
 
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
 
 sal컬럼의 값이 3000이면 NULL을 리턴   
 SELECT empno, ename, sal, NULLIF(sal, 3000)
 FROM emp;
 
 
 가변인자 : 함수의 인자의 갯수가 정해져 있지 않음, 가변인자들의 타입은 동일 해야함
 인자들중에 가장 먼저나오는 NULL이 아닌 인자 값을 리턴
 coalesce(expr1, expr2, expr3.......)
 if expr1 != null
    return expr1
 else
    coalesce(expr2, expr3.......)
 
 mgr 컬럼 NULL
 comm 컬럼 NULL
 
 SELECT empno, ename, comm, sal, coalesce(comm, sal)
 FROM emp;
 
 
 -- null 실습 fn4
 
 SELECT empno, ename, mgr, NVL(mgr, 9999) MGR_N, NVL2(mgr, mgr, 9999) MGR_N_1, coalesce(mgr, 9999) MGR_N_2
 FROM emp;
 
 -- null 실습 fn5
 
 SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) N_REG_DT
 FROM users
 WHERE usernm != '브라운';
 
 
 
 condition
 조건에 따라 컬럼 혹은 표현식을 다른 값으로 대체
 java if, switch 같은 개념
 1. case 구문
 2. decode 함수
 
 1. CASE
 CASE
    WHEN 참/거짓을 판별할 수 있는 식 THEN 리턴할 값
    [WHEN 참/거짓을 판별할 수 있는 식 THEN 리턴할 값]
    [ELSE 리턴할 값(판별식이 참인 WHEN 절이 없을 경우 실행)]
 END
 
 emp 테이블에 등록된 직원들에게 보너스를 추가적으로 지급할 예정
 해당 직원의 job이 SALESMAN일 경우 sal 5% 인상된 금액을 보너스로 지급
 해당 직원의 job이 MANAGER일 경우 sal 10% 인상된 금액을 보너스로 지급
 해당 직원의 job이 PRESIDENT일 경우 sal 20% 인상된 금액을 보너스로 지급
 그외 직원들은 sal만큼만 지급
 
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
 
 
 -- condition 실습 cond1
 
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
 
 -- condition 실습 cond2
 SELECT empno, ename, hiredate,
    CASE
        WHEN MOD(TO_CHAR( hiredate, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END CONTACT_TO_DOCTOR
 FROM emp;
 
 SELECT empno, ename, hiredate,
    DECODE(MOD(TO_CHAR(hiredate, 'YYYY'),2), MOD(TO_CHAR(SYSDATE, 'YYYY'), 2), '건강검진 대상자', '건강검진 비대상자') CONTACT_TO_DOCTOR
 FROM emp;
 
 -- condition 실습 cond3
 
 SELECT userid, usernm, ALIAS, REG_DT,
    CASE
        WHEN  MOD(TO_CHAR( reg_dt, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '건강검진 대상자'
        WHEN reg_dt IS NULL THEN '건강검진 비대상자'
        ELSE '건강검진 비대상자'
    END CONTACTODOCTOR
 FROM users
 ORDER BY userid ASC;