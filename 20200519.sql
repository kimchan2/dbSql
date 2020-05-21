'202005' ==> �Ϲ����� �޷��� row, col;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);


JOIN ������ ��
CROSS JOIN : ������ ���� �� ��...


�μ���ȣ��, ��ü �� �� SAL ���� ���ϴ� 3��° ���
SELECT DECODE(lv, 1, deptno, 2, null), SUM(sal)
FROM emp, (SELECT level lv
           FROM dual
           CONNECT BY LEVEL <= 2)
GROUP BY DECODE(lv, 1, deptno, 2, null)
ORDER BY DECODE(lv, 1, deptno, 2, null);
           
�������� 1, 2 ���� ==> ������ ��������� 1,2�� ���� ���� �����Ͱ� 2��~


create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;


������ ����
START WITH : ���� ������ ������ ���
CONNECT BY  : ����(��)�� ��������� ǥ��

xxȸ�����(�ֻ��� ���)���� ���� ��������� ���������� Ž���ϴ� ����Ŭ ������ ���� �ۼ�
1. �������� ���� : xxȸ��
2. ������(��� ��) ������� ǥ��
    PRIOR : ���� ���� �а� �ִ� ���� ǥ��
    �ƹ��͵� ������ ���� : ���� ������ ���� ���� ǥ��

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;
-- ���� �а��ִ� ���� deptcd�� ������ �������� p_deptcd�� ������


�ǽ� h_1]

SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm, p_deptcd -- LEVEL�� 1�̸� xxȸ���̸� �鿩���Ⱑ �ȵ�
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

�ǽ� h_2]
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


�����
������ : �������� - dept0_00_0

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;


�ǽ� h_3]

SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;


�ǽ� h_4]
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;


SELECT *
FROM h_sum;

DESC h_sum;

SELECT LPAD(' ', (LEVEL-1)*3) || S_ID as S_ID, VALUE
FROM h_sum
START WITH S_ID = 0
CONNECT BY PRIOR s_id = ps_id;


�ǽ� h_5]
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

DESC no_emp;

SELECT *
FROM no_emp;

CONNECT BY ���Ŀ� �̾ PRIOR�� ���� �ʾƵ� ������
PRIOR�� ���� �а� �ִ� ���� ��Ī�ϴ� Ű����!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT LPAD(' ', (LEVEL-1)*4) || org_cd as org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
--CONNECT BY PRIOR org_cd = parent_org_cd; �Ѵ� ����
CONNECT BY parent_org_cd = PRIOR org_cd;


Pruning branch : ���� ġ��
WHERE���� ������ ��� ���� �� : ������ ������ ������ ���� �������� ����
CONNECT BY ���� ��� ���� �� : �����߿� ������ ����
���̸� ��

*�� ������ ������ FROM -> START WITH CONNECT BY -> WHERE ������ ó���ȴ�

1. WHERE���� ������ ����� ���

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

2. CONNECT BY ���� ������ ����� ���

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��';


������ �������� ����� �� �ִ� Ư�� �Լ�
CONNECT_BY_ROOT(column) : �ش� �÷��� �ֻ��� �����͸� ��ȸ
SYS_CONNECT_BY_PATH(column, ������) : �ش� ���� ������� ���Ŀ� ���� column���� �����ϰ� �����ڸ� ���� ����
CONNECT_BY_ISLEAF ���ڰ� ���� : �ش� ���� ������ ���̻� ���� ������ ������� (LEAF ���)
                               LEAF��� : 1, NO LEAF ��� : 0

������
    ==���
        ==���
        
������
    ==���
    ==���
        
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm DEPTNM, p_deptcd,
       CONNECT_BY_ROOT(deptnm),
       LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-'), -- LTRIM(����1, ����2) ����1���� �ǿ����� ����2�� ����
       CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


�ǽ� h_6]
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

SELECT *
FROM board_test;

DESC board_test;

SELECT SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;


�ǽ� h_7] �ֽű��� ���� ������
������ ������ ���Ľ� ���� ������ �����ϸ鼭 �����ϴ� ����� ����
ORDER SIBLINGS BY

SELECT SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;


�ǽ� h_8]
������ ������ ���Ľ� ���� ������ �����ϸ鼭 �����ϴ� ����� ����
ORDER SIBLINGS BY

SELECT SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;


�ǽ� h_9]
SELECT *
FROm board_test;

SELECT CONNECT_BY_ROOT(seq) nseq, SEQ, LPAD(' ', (LEVEL-1)*3)||TITLE
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY nseq DESC, seq;

ALTER TABLE board_test ADD (gp_no NUMBER);
UPDATE board_test SET gp_no = 4
WHERE seq IN (4, 10, 11, 5, 8, 6, 7);
UPDATE board_test SET gp_no = 2
WHERE seq IN (2, 3);
UPDATE board_test SET gp_no = 1
WHERE seq IN (1, 9);


��ü �����߿� ���� ���� �޿��� �޴� ����� �޿�����
�ٵ� �װ� ������??
emp ���̺��� 2�� �о ������ �޼� ==> ���� �� ȿ������ ����� ������?? ==> WINDOW/ANALYSIS FUNCTION 
SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal) FROM emp);


�ǽ� ana0]

SELECT c.ename, c.sal, c.deptno, f.lv
FROM
    (SELECT e.*, ROWNUM rn
     FROM(SELECT ename, sal, deptno
          FROM emp
          ORDER BY deptno, sal DESC) e) c,

    (SELECT ROWNUM rn, d.*
     FROM
        (SELECT a.*, b.lv
         FROM
        (SELECT deptno, COUNT(*) cnt
         FROM emp
         GROUP BY deptno) a, (SELECT LEVEL lv
                              FROM dual
                              CONNECT BY LEVEL <= 6) b
         WHERE a.cnt >= lv
         ORDER BY a.deptno, b.lv) d) f
WHERE f.rn = c.rn;


SELECT ename, sal, deptno, ROWNUM sal_rank
FROM emp
WHERE deptno = 10
ORDER BY sal DESC;
