4/28

-- join1
SELECT *
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;

-- join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON ( buyer_id = prod_buyer);

SELECT COUNT(*) CNT
FROM 
    (SELECT COUNT(*)
    FROM buyer JOIN prod ON ( buyer_id = prod_buyer)
    GROUP BY prod_id);

SELECT COUNT(*) CNT
FROM 
    (SELECT prod_id
    FROM buyer JOIN prod ON ( buyer_id = prod_buyer)
    GROUP BY prod_id);
    
SELECT COUNT(*) CNT
FROM prod, buyer
WHERE prod.prod_buyer = buyer.buyer_id;

buyer_name별 건수 조회 쿼리 작성
SELECT buyer_name ,COUNT(*)
FROM buyer JOIN prod ON ( buyer_id = prod_buyer)
GROUP BY buyer_name;

-- join3
--ORACLE
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE ( member.mem_id = cart.cart_member ) AND ( cart.cart_prod = prod.prod_id );

--ANSI
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON ( member.mem_id = cart.cart_member )
            JOIN prod ON ( cart.cart_prod = prod.prod_id );

SELECT *
FROM cart
WHERE cart_member = 'a001';

참고사항
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT *
FROM
    (SELECT deptno, COUNT(*)
    FROM emp
    GROUP BY deptno)
WHERE deptno = 30;


SELECT deptno, COUNT(*)
FROM emp
WHERE deptno = 30
GROUP BY deptno;

cid : customer id
cnm : customer name

SELECT *
FROM customer;

pid : product id
pnm : product name

SELECT *
FROM product;

cycle : 애음주기
cid : 고객 id
pid : 제품 id
day : 애음요일 ( 일요일 1 ~ 토요일 7 )
cnt : 수량

SELECT *
FROM cycle;

-- join4

SELECT a.cid, cnm, pid, day, cnt
FROM CUSTOMER a, CYCLE b
WHERE a.cid = b.cid AND cnm  IN ('brown', 'sally');

SELECT cid, cnm, pid, day, cnt -- customer.cid는 안됨
FROM customer NATURAL JOIN cycle
WHERE customer.cnm IN ('brown', 'sally');

-- join5

SELECT a.cid, cnm, b.pid, pnm, day, cnt
FROM CUSTOMER a, CYCLE b, product c
WHERE a.cid = b.cid AND b.pid = c.pid AND cnm IN ('brown', 'sally');

-- join6
SELECT a.cid, cnm, b.pid, pnm, sum(cnt), count(*)
FROM customer a, cycle b, product c
WHERE a.cid = b.cid AND b.pid = c.pid
GROUP BY a.cid, cnm, b.pid, pnm
ORDER BY a.cid, b.pid;

-- join7 그룹을 여러컬럼으로 해줌
SELECT c.pid, a.pnm, a.cnt
FROM product c, (SELECT pnm, SUM(a.cnt) CNT
                 FROM cycle a, product b
                 WHERE a.pid = b.pid
                 GROUP BY pnm) a
WHERE c.pnm = a.pnm;

SELECT a.pid, b.pnm, sum(cnt) CNT
FROM cycle a, product b
WHERE a.pid = b.pid
GROUP BY a.pid, b.pnm;
             

SELECT a.pid, b.pnm, a.cnt
FROM
(SELECT pid, SUM(cnt) cnt
FROM cycle
GROUP BY cycle.pid) a, product b
WHERE a.pid = b.pid;

-- join8






