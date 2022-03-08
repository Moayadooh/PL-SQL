
--Sequences
CREATE SEQUENCE seq1 START WITH 100 INCREMENT BY 1;

CREATE TABLE table1 (sno NUMBER PRIMARY KEY, sname VARCHAR(20));
INSERT INTO table1 VALUES(seq1.NEXTVAL, 'a');
INSERT INTO table1 VALUES(seq1.NEXTVAL, 'b');
INSERT INTO table1 VALUES(seq1.NEXTVAL, 'c');
SELECT * FROM table1;


--MERGE
CREATE TABLE copy_emp AS SELECT first_name, salary, employee_id FROM employees;
SELECT * FROM copy_emp;
SELECT * FROM copy_emp where employee_id = 115;
TRUNCATE TABLE copy_emp;

INSERT INTO copy_emp VALUES('Aref', 1000, 115);
SELECT first_name, salary, employee_id FROM employees WHERE employee_id = 115;

BEGIN
    MERGE INTO copy_emp c 
	USING employees e 
    ON (e.employee_id = c.employee_id) 
    WHEN MATCHED THEN 
    UPDATE SET c.first_name = e.first_name, c.salary = e.salary 
    WHEN NOT MATCHED THEN 
	INSERT VALUES(e.first_name, e.salary, e.employee_id);
END;
DROP TABLE copy_emp;


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


--%ROWTYPE holds the datatype of the entire row
--%TYPE holds the datatype of a single column
DECLARE
     v_sno t4.sno%TYPE := &sno;
     v_rec t4%ROWTYPE;
BEGIN
     SELECT * INTO v_rec 
	 FROM t4 
	 WHERE sno = v_sno;
     dbms_output.put_line(v_rec.gsm || '-' || v_rec.email || '-'|| v_sno);
END;


--PL/SQL Record
DECLARE 
    TYPE t_rec IS RECORD
    (v_sal NUMBER(8),
    v_minsal NUMBER(8) DEFAULT 1000,
    v_hire_date employees.hire_date%TYPE,
    v_rec1 employees%ROWTYPE);
    v_myrec t_rec;
BEGIN
    v_myrec.v_sal := v_myrec.v_minsal + 500;
    v_myrec.v_hire_date := sysdate;
    SELECT * INTO v_myrec.v_rec1  
    FROM employees 
    WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(v_myrec.v_rec1.last_name || ' ' || TO_CHAR(v_myrec.v_hire_date) || ' ' || TO_CHAR(v_myrec.v_sal));
END;

--Inserting a Record by Using %ROWTYPE
DECLARE
	v_employee_number number := 124;
	v_emp_rec retired_emps%ROWTYPE;
BEGIN
	SELECT employee_id, last_name, job_id, manager_id, hire_date, hire_date, salary, commission_pct, department_id 
	INTO v_emp_rec 
	FROM employees
	WHERE employee_id = v_employee_number;
	INSERT INTO retired_emps VALUES v_emp_rec;
END;

--Updating a Row in a Table by Using a Record
DECLARE
  v_employee_number number:= 124;
  v_emp_rec  retired_emps%ROWTYPE;
BEGIN
  SELECT * INTO v_emp_rec FROM retired_emps WHERE
  empno = v_employee_number;
  v_emp_rec.leavedate:= CURRENT_DATE;
  UPDATE retired_emps SET ROW = v_emp_rec WHERE
  empno=v_employee_number;
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


--Define an associative array to hold an entire row from a table.
DECLARE
TYPE dept_table_type
IS
  TABLE OF departments%ROWTYPE INDEX BY VARCHAR2(20);
  dept_table dept_table_type;
  -- Each element of dept_table is a record
BEGIN
   SELECT * INTO dept_table(1) FROM departments 
   WHERE department_id = 10;
   DBMS_OUTPUT.PUT_LINE(dept_table(1).department_id ||' '||
   dept_table(1).department_name ||' '||           
   dept_table(1).manager_id);
END;

--INDEX BY Table of Records Option
DECLARE
   TYPE emp_table_type IS TABLE OF 
   employees%ROWTYPE INDEX BY PLS_INTEGER;
   my_emp_table emp_table_type;
   max_count NUMBER(3) := 104; 
BEGIN
  FOR i IN 100..max_count
  LOOP
   SELECT * INTO my_emp_table(i) FROM employees
   WHERE employee_id = i;
  END LOOP;
  FOR i IN my_emp_table.FIRST..my_emp_table.LAST 
  LOOP
     DBMS_OUTPUT.PUT_LINE(my_emp_table(i).last_name);
  END LOOP;
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
requester NUMBER(4),
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
