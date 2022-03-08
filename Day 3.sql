
--ALTER PLUGGABLE DATABASE PDB_Name open;
--alter pluggable database all open;

shutdown immediate;
startup;

select * from v$datafile;

select name, con_id from v$datafile;

select * from v$tablespace;

select * from dba_users where username = 'HR';

select * from employees;

select distinct department_id from employees order by 1;


--Lab Assignment No. 1
CREATE TABLE messages (results NUMBER);

BEGIN
    FOR i IN 1..10 LOOP
        IF i != 6 AND i != 8 
        THEN
            INSERT INTO messages VALUES(i);
        END IF;
    END LOOP;
    COMMIT;
END;
--DELETE FROM messages;
SELECT * FROM messages;


--Lab Assignment No. 2
CREATE TABLE emp2 AS (SELECT * FROM employees);
ALTER TABLE emp2 ADD (STARS varchar2(50));

DECLARE
    v_empno emp2.employee_id%TYPE := 176;
    v_asterisk emp2.stars%TYPE := NULL;
    v_salary emp2.salary%TYPE;
BEGIN
    SELECT salary INTO v_salary FROM emp2 WHERE employee_id = v_empno;
    
    FOR i IN 1..ROUND(v_salary/1000) LOOP
        v_asterisk := NVL(v_asterisk, '') || '*';
    END LOOP;
    
    UPDATE emp2 SET stars = v_asterisk WHERE employee_id = v_empno;
    
    COMMIT;
END;

SELECT * FROM EMP2;


SET SERVEROUT On;
SET verify OFF;


--Cursor Example 1
DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE department_id =30;
  v_empno employees.employee_id%TYPE;
  v_lname employees.last_name%TYPE;
BEGIN
  OPEN c_emp_cursor;
  LOOP
    FETCH c_emp_cursor INTO v_empno, v_lname;
    EXIT WHEN c_emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( v_empno ||'  '||v_lname);  
  END LOOP;
END;


--Cursors and Records using %ROWTYPE
--Process the rows of the active set by fetching values into a PL/SQL record.
DECLARE 
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE  department_id =30;
   v_emp_record	c_emp_cursor%ROWTYPE;
BEGIN
  OPEN c_emp_cursor;
  LOOP
    FETCH c_emp_cursor INTO v_emp_record;

    EXIT WHEN c_emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( v_emp_record.employee_id ||' '||v_emp_record.last_name);    
  END LOOP;
  CLOSE c_emp_cursor;
END;


--Cursor FOR Loops
DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE department_id =30; 
BEGIN
   FOR emp_record IN c_emp_cursor 
    LOOP
     DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' ' ||emp_record.last_name);   
    END LOOP; 
END;


--%ROWCOUNT and %NOTFOUND: Example
DECLARE
  CURSOR c_emp_cursor IS SELECT employee_id, 
    last_name FROM employees;
  v_emp_record	c_emp_cursor%ROWTYPE;
BEGIN
  OPEN c_emp_cursor;
  LOOP
   FETCH c_emp_cursor INTO v_emp_record;
   EXIT WHEN c_emp_cursor%ROWCOUNT > 10 OR  
                     c_emp_cursor%NOTFOUND;        
   DBMS_OUTPUT.PUT_LINE( v_emp_record.employee_id ||' '||v_emp_record.last_name);
  END LOOP;
  CLOSE c_emp_cursor;
END ;


--Cursor FOR Loops Using Subqueries
--There is no need to declare the cursor.
BEGIN
  FOR emp_record IN (SELECT employee_id, last_name   FROM employees WHERE department_id =30)
  LOOP
   DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' '||emp_record.last_name);   
  END LOOP; 
END;



select * from countries;

--Lab Assignment No. 3
DECLARE
    v_countryid countries.country_id%TYPE := UPPER('&v_countryid');
    v_country_record countries%ROWTYPE;
BEGIN
    SELECT * INTO v_country_record FROM countries WHERE country_id = v_countryid;
    DBMS_OUTPUT.PUT_LINE('Country Id: ' || v_country_record.country_id ||' '|| 'Country Name: ' || v_country_record.country_name ||' '|| 'Region: ' || v_country_record.region_id);  
END;


--Lab Assignment No. 4
DECLARE
   v_deptno NUMBER := &department_id;
   CURSOR c_emp_cursor IS 
   SELECT last_name, salary, manager_id 
   FROM employees
   WHERE department_id = v_deptno; 
BEGIN
   FOR emp_record IN c_emp_cursor 
    LOOP
        IF emp_record.salary < 5000 AND (emp_record.manager_id = 101 OR emp_record.manager_id = 124) THEN
            DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' Due for a raise');
        ELSE
            DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' Not Due for a raise');
        END IF;
    END LOOP; 
END;



CREATE TABLE test(sno NUMBER(4), name VARCHAR(30));
INSERT INTO test VALUES(1, 'Aref');
INSERT INTO test VALUES(2, 'Muayad');
INSERT INTO test VALUES(3, 'Zakir');
COMMIT;
SELECT * FROM test;

DELETE FROM test
WHERE ROWID IN(SELECT RID FROM 
(SELECT ROWID RID, ROW_NUMBER() OVER
(PARTITION BY sno ORDER BY ROWID)
RN FROM test)
WHERE RN <> 1);


--Exception example 1
DECLARE
    v_lname VARCHAR2(15) := '&name';
BEGIN
    SELECT last_name INTO v_lname 
    FROM employees 
    WHERE TRIM(LOWER(first_name)) = v_lname;
    DBMS_OUTPUT.PUT_LINE(v_lname);
END;
--ORA-01422: exact fetch returns more than requested number of rows
--ORA-01403: no data found

DECLARE
    v_lname VARCHAR2(15) := '&name';
    v_fname employees.first_name%TYPE;
BEGIN
    SELECT first_name, last_name INTO v_fname , v_lname 
    FROM employees 
    WHERE TRIM(LOWER(first_name)) = v_lname;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' last name is ' || v_lname);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
       DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
END;

select first_name from employees where first_name = 'John';



CREATE TABLE employees(sno NUMBER);
--ORA-00955: name is already used by an existing object

CREATE TABLE employees3(sno NUMBER PRIMARY KEY);
INSERT INTO employees3 VALUES(1);
--ORA-00001: unique constraint (HR.SYS_C007491) violated

ALTER TABLE employees3 ADD(ename VARCHAR(20));

INSERT INTO employees3 VALUES(NULL, 'Aref');
--ORA-01400: cannot insert NULL into ("HR"."EMPLOYEES3"."SNO")



--EXCEPTION WHEN OTHERS THEN ROLLBACK



DECLARE
    v_lname VARCHAR2(15) := '&name';
    v_fname employees.first_name%TYPE;
BEGIN
    SELECT first_name, last_name INTO v_fname , v_lname 
    FROM employees 
    WHERE TRIM(LOWER(first_name)) = v_lname;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' last name is ' || v_lname);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20201, 'TOO_MANY_ROWS');
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20202, 'NO_DATA_FOUND');
END;



--Lab Assignment No. 5
CREATE TABLE student
(student_id NUMBER(8,0) NOT NULL,
salutation VARCHAR2(5) NULL,
first_name VARCHAR2(25) NULL,
last_name VARCHAR2(25) NOT NULL,
street_address VARCHAR2(50) NULL,
zip VARCHAR2(5) NOT NULL,
phone VARCHAR2(15) NULL);

INSERT INTO student VALUES(1,'NONE','Muayad','Al Falahi','Barka','123','96430801');
INSERT INTO student VALUES(2,'Mr','Aref','Ahmed','Kashmeer','456','99999999');
INSERT INTO student VALUES(3,'Dr','Zakir','Naik','Malysia','789','12345678');

SELECT * FROM student;

DECLARE
    v_lname student.student_id%TYPE := '&student_id';
BEGIN
    SELECT first_name, last_name INTO v_fname , v_lname 
    FROM employees 
    WHERE TRIM(LOWER(first_name)) = v_lname;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' last name is ' || v_lname);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20201, 'TOO_MANY_ROWS');
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
END;
