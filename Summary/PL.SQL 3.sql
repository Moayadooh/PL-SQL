
SET SERVEROUT ON
SET VERIFY OFF


--Cursor Example
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
   WHERE  department_id = 30;
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

--%ROWCOUNT and %NOTFOUND: Example
DECLARE
	CURSOR c_emp_cursor IS 
	SELECT employee_id, last_name 
	FROM employees;
	v_emp_record c_emp_cursor%ROWTYPE;
BEGIN
	OPEN c_emp_cursor;
	LOOP
		FETCH c_emp_cursor INTO v_emp_record;
		EXIT WHEN c_emp_cursor%ROWCOUNT > 10 OR c_emp_cursor%NOTFOUND;        
		DBMS_OUTPUT.PUT_LINE( v_emp_record.employee_id ||' '||v_emp_record.last_name);
	END LOOP;
	CLOSE c_emp_cursor;
END; 

--Cursor FOR Loops
DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE department_id = 30; 
BEGIN
   FOR emp_record IN c_emp_cursor 
    LOOP
     DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' ' ||emp_record.last_name);   
    END LOOP; 
END;

--Cursor FOR Loops Using Subqueries
--There is no need to declare the cursor.
BEGIN
	FOR emp_record IN (SELECT employee_id, last_name FROM employees WHERE department_id = 30)
	LOOP
		DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' '||emp_record.last_name);   
	END LOOP; 
END;


--Exception example
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

CREATE TABLE employees(sno NUMBER);
--ORA-00955: name is already used by an existing object

CREATE TABLE employees3(sno NUMBER PRIMARY KEY);
INSERT INTO employees3 VALUES(1);
--ORA-00001: unique constraint (HR.SYS_C007491) violated

ALTER TABLE employees3 ADD(ename VARCHAR(20));

INSERT INTO employees3 VALUES(NULL, 'Aref');
--ORA-01400: cannot insert NULL into ("HR"."EMPLOYEES3"."SNO")

--Nonpredefined Error Trapping: Example
--To trap Oracle Server error 01400 (cannot insert NULL):
DECLARE
	e_insert_excep EXCEPTION;
	PRAGMA EXCEPTION_INIT(e_insert_excep, -01400);
BEGIN
	INSERT INTO departments (department_id, department_name) 
	VALUES (280, NULL);
	EXCEPTION
		WHEN e_insert_excep THEN
		DBMS_OUTPUT.PUT_LINE('INSERT OPERATION FAILED');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


--Functions for Trapping Exceptions (SQLCODE and SQLERRM)
DECLARE
    v_lname VARCHAR2(15) := '&name';
    v_fname employees.first_name%TYPE;
    
    error_code NUMBER;
    error_message VARCHAR2(255);
BEGIN
    SELECT first_name, last_name INTO v_fname , v_lname 
    FROM employees 
    WHERE TRIM(LOWER(first_name)) = v_lname;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' last name is ' || v_lname);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        error_code := SQLCODE ;
        error_message := SQLERRM ;
        DBMS_OUTPUT.PUT_LINE('User: ' || USER || ' | Date: ' || SYSDATE || ' | Error Code: ' || error_code || ' | Error Message: ' || error_message);
       --INSERT INTO errors (e_user,e_date,error_code,error_message) VALUES(USER,SYSDATE,error_code,error_message);
END;


--RAISE_APPLICATION_ERROR
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
    --WHEN OTHERS THEN ROLLBACK
END;


--Trapping User-Defined Exceptions
DECLARE 
	v_deptno NUMBER := 500;
	v_name VARCHAR2(20) := 'Testing';
	e_invalid_department EXCEPTION;
BEGIN
	UPDATE departments
	SET department_name = v_name
	WHERE department_id = v_deptno;
	IF SQL%NOTFOUND THEN
		RAISE e_invalid_department;
	END IF;
	COMMIT;
	EXCEPTION
		WHEN e_invalid_department THEN
		DBMS_OUTPUT.PUT_LINE('No such department id.');
END;
