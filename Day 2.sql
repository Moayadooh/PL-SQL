
SET SERVEROUTPUT ON;
SET AUTOPRINT ON;
SET AUTOPRINT OFF;

VARIABLE b_result NUMBER
BEGIN
    SELECT (SALARY * 12) + NVL(COMMISSION_PCT, 0) 
    INTO :b_result 
    FROM employees 
    WHERE employee_id = 144;
END;

--PRINT b_result

--One bind variable can be used in multiple annonimous block
VARIABLE n1 NUMBER
VARIABLE n2 NUMBER


--annonymous block to add two numbers
DECLARE 
    result NUMBER;
BEGIN
    :n1 := 10;
    :n2 := 20;
    result := :n1 + :n2;
    dbms_output.put_line(result);
END;

--annonymous block to multiply two numbers
DECLARE 
    result NUMBER;
BEGIN
    :n1 := 10;
    :n2 := 20;
    result := :n1 * :n2;
    dbms_output.put_line(result);
END;


PRINT n1

CREATE TABLE copy_emp AS SELECT first_name, salary, employee_id FROM employees;

SELECT * FROM copy_emp where employee_id = 115;

TRUNCATE TABLE copy_emp;

INSERT INTO copy_emp VALUES('Aref', 1000, 115);

COMMIT;

SELECT first_name, salary, employee_id FROM employees WHERE employee_id = 115;
--Alexander	3100	115

BEGIN
    MERGE INTO copy_emp c USING employees e 
    ON (e.employee_id = c.employee_id) 
    WHEN MATCHED THEN 
    UPDATE SET c.first_name = e.first_name, c.salary = e.salary--, c.employee_id = e.employee_id 
    WHEN NOT MATCHED THEN INSERT VALUES(e.first_name, e.salary, e.employee_id);
END;



--Basic loop
DECLARE 
    i NUMBER := 0;
BEGIN
    LOOP
        i := i + 1;
        dbms_output.put_line(i);
        EXIT WHEN i = 10;
    END LOOP;
END;

--While loop
DECLARE 
    i NUMBER := 0;
BEGIN
    WHILE i < 20 LOOP
        i := i + 2;
        dbms_output.put_line(i);
    END LOOP;
END;

--For loop
BEGIN
    FOR i IN 5..10 LOOP
        dbms_output.put_line(i);
    END LOOP;
END;



DECLARE 
    TYPE t_rec IS RECORD
    (v_sal NUMBER(8),
    v_minsal NUMBER(8) DEFAULT 1000,
    v_hire_date employees.hire_date%TYPE,
    v_rec1 employees%rowtype);
    v_myrec t_rec;
BEGIN
    v_myrec.v_sal := v_myrec.v_minsal + 500;
    v_myrec.v_hire_date := sysdate;
    SELECT * INTO v_myrec.v_rec1  
    FROM employees 
    WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(v_myrec.v_rec1.last_name || ' ' || TO_CHAR(v_myrec.v_hire_date) || ' ' || TO_CHAR(v_myrec.v_sal));
END;


--Creating an INDEX BY Table
DECLARE
    TYPE tab_no IS TABLE OF VARCHAR2(100)
    INDEX BY PLS_INTEGER;
    v_tab_no tab_no;
BEGIN
    v_tab_no(1):='John';
    v_tab_no(6):='Allan';
    v_tab_no(4):='Roy';
    dbms_output.put_line(v_tab_no(1));
    dbms_output.put_line(v_tab_no(6));
    dbms_output.put_line(v_tab_no(4));
END;



--Nested table
CREATE TYPE type_item AS OBJECT --create object
    (prodid NUMBER(5),
    price NUMBER(7,2));

CREATE TYPE type_item_nst --define nested table type
AS TABLE OF type_item;

CREATE TABLE porder 
(ordid NUMBER(5), 
supplier NUMBER(5),
 NUMBER(4),
ordered DATE,
items type_item_nst)
NESTED TABLE items STORE AS item_store_tab;

INSERT INTO porder VALUES 
(500, 50, 5000, sysdate, type_item_nst
(type_item(55, 555),
type_item(55, 566),
type_item(57, 577)));

INSERT INTO porder VALUES 
(800, 80, 8000, sysdate, type_item_nst
(type_item(88, 888)));

SELECT * FROM porder;

SELECT p2.ordid, p1.* 
FROM porder p2, 
TABLE(p2.items) p1;

SELECT p2.ordid, p2.supplier, p2.requester, p1.* 
FROM porder p2, 
TABLE(p2.items) p1;
