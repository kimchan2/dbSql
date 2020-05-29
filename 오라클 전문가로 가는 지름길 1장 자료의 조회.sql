SELECT *
FROM temp;

SELECT *
FROM tdept;

EXPLAIN PLAN SET STATEMENT_ID = '임의지정' FOR
SELECT emp_id, emp_name
FROM temp
WHERE emp_id > 0;

SELECT *
FROM TABLE(dbms_xplan.display);

INDEX 조회 DATA DICTIONARY
SELECT index_name
FROM user_indexes
WHERE table_name = 'TEMP';

COLUMN 조회 DATA DICTIONARY
SELECT index_name, column_name
FROM user_ind_columns
WHERE table_name = 'TEMP';


SELECT emp_id, emp_name, hobby
FROM temp
WHERE hobby IS NOT NULL AND LEV = '과장';


SELECT emp_id, emp_name
FROM temp
ORDER BY emp_id DESC;


SElECT lev, emp_id, emp_name
FROM temp
ORDER BY 1,2 DESC;
-- 1이 의미하는 것은 첫 번째 컬럼 lev
-- 2가 의미하는 것은 두 번째 컬럼 emp_id


SELECT *
FROM tdept
ORDER BY area;


SELECT emp_id, emp_name, dept_code
FROM temp
WHERE dept_code LIKE '%A%';

SELECT emp_id, emp_name, dept_code
FROM temp
WHERE dept_code LIKE '_A____';


SELECT emp_id, emp_name
FROM temp
WHERE emp_id BETWEEN 19970001 AND 19979999;

SELECT emp_id, emp_name
FROM temp
WHERE emp_name BETWEEN '가' AND '나';


SELECT emp_id, emp_name
FROM temp
WHERE emp_name IN ('홍길동', '김길동');


SELECT LEV, MAX(salary) max_sal
FROM temp
GROUP BY lev;

SELECT MAX(salary)
FROM temp;

-- DISTINCT를 이용해 lev의 UNIQUE한 값만 조회
SELECT DISTINCT lev
FROM temp;

-- 아래 쿼리와 동일
SELECT lev
FROM temp
GROUP BY lev;

-- 사번이 가장 작은 ROW의 사번과 부서코드가 함께 읽혀 나옴
SELECT MIN(boss_id || dept_code)
FROM tdept;


SELECT lev, MAX(salary) max_sal
FROM temp
GROUP BY lev;


SELECT area, MIN(boss_id)
FROM tdept
GROUP BY area
ORDER BY 2;


SELECT lev, avg(salary)
FROM temp
GROUP BY lev
HAVING avg(salary) > 50000000;


SELECT lev, max(emp_id)
FROM temp
GROUP BY lev
HAVING max(emp_id) LIKE '1997%';

<1장 마무리>
SELECT 문에서 기술될 수 있는 6가지 구문(SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY)를 차례대로 짚어가며 무엇에 쓰는 문장인지 알아봄
