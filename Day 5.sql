

--catproc.sql

--UNIFIED AUDITIM

--sqlldr
--expdp
--iompdp

--show parameters smtp_out


CREATE OR REPLACE PROCEDURE employee_report(
p_dir IN VARCHAR2, p_filename IN VARCHAR2) IS
f UTL_FILE.FILE_TYPE;

CURSOR cur_avg IS
SELECT last_name, department_id, salary FROM employees ORDER BY department_id;

BEGIN
f := UTL_FILE.FOPEN(p_dir, p_filename,'W');
UTL_FILE.PUT_LINE(f, 'Employees Report');

UTL_FILE.PUT_LINE(f, 'REPORT GENERATED ON ' ||SYSDATE);

UTL_FILE.NEW_LINE(f);

FOR emp IN cur_avg
LOOP
UTL_FILE.PUT_LINE(f, emp.last_name || ' ' || emp.department_id || ' ' || emp.salary);

--UTL_FILE.PUT_LINE(f,RPAD(emp.last_name, 30) || ' ' || LPAD(NVL(TO_CHAR(emp.department_id,'9999'),'-'), 5) || ' '||LPAD(TO_CHAR(emp.salary, '$99,999.00'), 12));

END LOOP;
UTL_FILE.NEW_LINE(f);
UTL_FILE.PUT_LINE(f, '*** END OF REPORT ***');
UTL_FILE.FCLOSE(f);

END employee_report;

EXECUTE employee_report('MUAYAD','employee_report1.txt');



declare
cursor c is
select * from hr.employees;
v varchar2(100);
f utl_file.file_type;

file_name varchar2(100) := 'Data.xls';
dir varchar2(50) := 'MUAYAD';

--select * from dba_directories

begin


f := utl_file.fopen(dir, file_name, 'W');

v := 'EMPLOYEE_ID'||chr(9)||'FIRST_NAME'||chr(9)||'JOB_Id'||chr(9)||'SALARY'||chr(9)||'HIRE_DATE'||chr(9)||'DEPARTMENT_ID';
utl_file.put_line(f, v);

for i in c
loop

v := i.EMPLOYEE_ID||chr(9)||i.FIRST_NAME||chr(9)||i.job_ID||chr(9)||i.salary||chr(9)||i.hire_date||chr(9)||i.department_id;
utl_file.put_line(f, v);

end loop;
utl_file.fclose(f);

--utl_file.frename(dir, file_name, dir, replace(file_name, '.xls', '_')||to_char(sysdate, 'MMDDYY')||'.xls', false);

utl_file.fcopy(dir, file_name, dir, replace(file_name, '.xls', '_')||to_char(sysdate, 'MMDDYY')||'.xls');

end;



--Dynamic SQL

-- Create a table using dynamic SQL
CREATE OR REPLACE PROCEDURE create_table(
  p_table_name VARCHAR2, p_col_specs  VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE ' || p_table_name || ' (' || p_col_specs || ')';
END;

-- Call the procedure
BEGIN
  create_table('EMPLOYEE_NAMES','id NUMBER(4) PRIMARY KEY, name VARCHAR2(40)');
END;

-- Delete rows from any table:
CREATE OR REPLACE FUNCTION del_rows(p_table_name VARCHAR2)
RETURN NUMBER IS
BEGIN
  EXECUTE IMMEDIATE 'DELETE FROM '|| p_table_name;
  RETURN SQL%ROWCOUNT;
END;

BEGIN DBMS_OUTPUT.PUT_LINE(
  del_rows('EMPLOYEE_NAMES')|| ' rows deleted.');
END;

-- Insert a row into a table with two columns:
CREATE OR REPLACE PROCEDURE add_row(p_table_name VARCHAR2,
   p_id NUMBER, p_name VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'INSERT INTO '|| p_table_name || ' VALUES (:1, :2)' USING p_id, p_name;
END;

CREATE OR REPLACE FUNCTION get_emp(p_emp_id NUMBER)
RETURN employees%ROWTYPE IS
  v_stmt VARCHAR2(200);
  v_emprec employees%ROWTYPE;
BEGIN
  v_stmt := 'SELECT * FROM employees ' || 'WHERE employee_id = :p_emp_id';
  EXECUTE IMMEDIATE v_stmt INTO v_emprec USING p_emp_id ;
  RETURN v_emprec;
END;

DECLARE
  v_emprec employees%ROWTYPE := get_emp(100);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Emp: ' || v_emprec.last_name);
END;


CREATE OR REPLACE FUNCTION delete_all_rows
  (p_table_name  VARCHAR2) RETURN NUMBER IS
   v_cur_id      INTEGER;
   v_rows_del    NUMBER;
BEGIN
  v_cur_id := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cur_id, 'DELETE FROM ' || p_table_name, DBMS_SQL.NATIVE);
  v_rows_del := DBMS_SQL.EXECUTE (v_cur_id);
  DBMS_SQL.CLOSE_CURSOR(v_cur_id);
  RETURN v_rows_del;
END;


CREATE TABLE temp_emp AS SELECT * FROM employees;
BEGIN
 DBMS_OUTPUT.PUT_LINE('Rows Deleted: ' || delete_all_rows('temp_emp')); 
END;


CREATE PROCEDURE insert_row (p_table_name VARCHAR2,
 p_id VARCHAR2, p_name VARCHAR2, p_region NUMBER) IS
  v_cur_id     	INTEGER;
  v_stmt       	VARCHAR2(200);
  v_rows_added 	NUMBER;
BEGIN
  v_stmt := 'INSERT INTO '|| p_table_name || ' VALUES (:cid, :cname, :rid)';
  v_cur_id := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cur_id, v_stmt, DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(v_cur_id, ':cid', p_id);
  DBMS_SQL.BIND_VARIABLE(v_cur_id, ':cname', p_name);
  DBMS_SQL.BIND_VARIABLE(v_cur_id, ':rid', p_region);
  v_rows_added := DBMS_SQL.EXECUTE(v_cur_id);
  DBMS_SQL.CLOSE_CURSOR(v_cur_id);
  DBMS_OUTPUT.PUT_LINE(v_rows_added||' row added');
END;



--Triggers

-- 1-BEFORE statement trigger
-- 2-BEFORE row trigger
-- 3-AFTER row trigger
-- 4-AFTER statement trigger

Contacts:
Contact_ID, FirstName,Last_Name, Email, Phone, Customer_ID

CREATE TABLE Contacts (contact_id NUMBER, name VARCHAR(20), customer_id NUMber);

Customers:
Customer_ID, Name, Address, Website, Credit_limit

DROP  TABLE Customers;
CREATE TABLE Customers (Customer_ID NUMBER, cust_name VARCHAR(20), Address VARCHAR(20));


CREATE OR REPLACE VIEW vw_customers AS
    SELECT contact_id, name, cust_name, address
    FROM customers
    INNER JOIN contacts USING (customer_id);
    
    desc vw_customers;

INSERT INTO vw_customers(contact_id, name, cust_name, address)
    VALUES(1,'arif','muayad','www.arif.com');

CREATE OR REPLACE TRIGGER new_customer_trg
    INSTEAD OF INSERT ON vw_customers
    FOR EACH ROW
DECLARE
    l_customer_id NUMBER;
BEGIN
    -- insert a new customer first
    INSERT INTO customers(name, address, website, credit_limit)
    VALUES(:NEW.NAME, :NEW.address, :NEW.website, :NEW.credit_limit)
    RETURNING customer_id INTO l_customer_id;
    
    -- insert the contact
    INSERT INTO contacts(first_name, last_name, email, phone, customer_id)
    VALUES(:NEW.first_name, :NEW.last_name, :NEW.email, :NEW.phone, l_customer_id);
END;


SELECT * FROM user_objects WHERE object_type = 'TRIGGER';

DESCRIBE user_triggers;

SET SERVEROUTPUT ON;
DECLARE
    counter binary_integer;
BEGIN
 dbms_output.put_line(counter);
END;

DECLARE
    x number;
BEGIN
    x := 10;
    FOR v_counter IN 1..10
    LOOP
    x := x + 10;
    END LOOP;
 dbms_output.put_line(x);
END;

DECLARE
   a number;
PROCEDURE squareNum(x IN OUT number) IS
BEGIN
  x := x * x;
END; 
BEGIN
   a:= 5;
   squareNum(a);
   dbms_output.put_line(a);
END;

DECLARE
   a number (2) := 21;
   b number (2) := 10;
BEGIN
   
   IF ( a <= b ) THEN
      dbms_output.put_line(a);
   END IF;

   IF ( b >= a ) THEN
      dbms_output.put_line(a);
   END IF;
   
   IF ( a <> b ) THEN
      dbms_output.put_line(b);
   
   END IF;

END;


dbms_output.put_line ( SUBSTR ('Hello World', 7, 5));


























--Mutating Table: Example
CREATE OR REPLACE TRIGGER check_salary
  BEFORE INSERT OR UPDATE OF salary, job_id 
  ON employees
  FOR EACH ROW
  WHEN (NEW.job_id <> 'AD_PRES')
DECLARE
  v_minsalary employees.salary%TYPE;
  v_maxsalary employees.salary%TYPE;
BEGIN
  SELECT MIN(salary), MAX(salary)
   INTO	v_minsalary, v_maxsalary
   FROM	employees
   WHERE job_id = :NEW.job_id;
  IF :NEW.salary < v_minsalary OR :NEW.salary > v_maxsalary THEN
    RAISE_APPLICATION_ERROR(-20505,'Out of range');
  END IF; 			
END;


UPDATE employees
SET salary = 3400
WHERE last_name = 'Stiles';

--Using a Compound Trigger to Resolve the Mutating Table Error
--*********************************************************

CREATE OR REPLACE TRIGGER check_salary
  FOR INSERT OR UPDATE OF salary, job_id
  ON employees
  WHEN (NEW.job_id <> 'AD_PRES')
  COMPOUND TRIGGER

  TYPE salaries_t            IS TABLE OF employees.salary%TYPE;
  min_salaries               salaries_t;
  max_salaries               salaries_t;

  TYPE department_ids_t       IS TABLE OF employees.department_id%TYPE;
  department_ids              department_ids_t;

  TYPE department_salaries_t  IS TABLE OF employees.salary%TYPE
                                INDEX BY VARCHAR2(80);
  department_min_salaries     department_salaries_t;
  department_max_salaries     department_salaries_t;

BEFORE STATEMENT IS
  BEGIN
    SELECT MIN(salary), MAX(salary), NVL(department_id, -1)
     BULK COLLECT INTO  min_Salaries, max_salaries, department_ids
    FROM    employees
    GROUP BY department_id;
    FOR j IN 1..department_ids.COUNT() LOOP
      department_min_salaries(department_ids(j)) := min_salaries(j);
      department_max_salaries(department_ids(j)) := max_salaries(j);
    END LOOP;
END BEFORE STATEMENT;

AFTER EACH ROW IS
  BEGIN
    IF :NEW.salary < department_min_salaries(:NEW.department_id)
      OR :NEW.salary > department_max_salaries(:NEW.department_id) THEN
      RAISE_APPLICATION_ERROR(-20505,'New Salary is out of acceptable   
                                      range');
    END IF;
  END AFTER EACH ROW;
END check_salary;


CREATE TABLE schema_audit ( ddl_date DATE, 
ddl_user VARCHAR2(15), object_created VARCHAR2(15), 
object_name VARCHAR2(15), 
ddl_operation VARCHAR2(15)); 


--Login to pdb1 as HR user
--***********************
CREATE OR REPLACE TRIGGER hr_audit_tr
AFTER DDL ON SCHEMA 
BEGIN 
INSERT INTO schema_audit VALUES 
( sysdate, 
sys_context('USERENV','CURRENT_USER'), 
ora_dict_obj_type, 
ora_dict_obj_name, 
ora_sysevent); 
END; 


--Login to pdb1 as sys user
--***********************
CREATE OR REPLACE TRIGGER hr_audit_tr
AFTER DDL ON SCHEMA 
BEGIN 
INSERT INTO schema_audit VALUES
( sysdate, 
sys_context('USERENV','CURRENT_USER'), 
ora_dict_obj_type, 
ora_dict_obj_name, 
ora_sysevent); 
END;


CREATE TABLE log_trig_table (user_id NUMBER,log_date DATE,action VARCHAR(30));

-- Create the log_trig_table shown in the notes page first
CREATE OR REPLACE TRIGGER logon_trig
AFTER LOGON  ON  SCHEMA
BEGIN
  INSERT INTO log_trig_table(user_id,log_date,action)
  VALUES (USER, SYSDATE, 'Logging on');
END;


CREATE OR REPLACE TRIGGER logoff_trig
BEFORE LOGOFF  ON  SCHEMA
BEGIN
  INSERT INTO log_trig_table(user_id,log_date,action)
  VALUES (USER, SYSDATE, 'Logging off');
END;


--Using the RETURNING Clause
--******************************
CREATE OR REPLACE PROCEDURE update_salary(p_emp_id NUMBER) IS
  v_name    employees.last_name%TYPE;
  v_new_sal employees.salary%TYPE;
BEGIN
  UPDATE employees 
    SET salary = salary * 1.1
  WHERE employee_id = p_emp_id
  RETURNING last_name, salary INTO v_name, v_new_sal;
  DBMS_OUTPUT.PUT_LINE(v_name || ' new salary is ' || v_new_sal);
END update_salary;


--Bulk Binding FORALL: Example
--*******************************
CREATE OR REPLACE PROCEDURE raise_salary(p_percent NUMBER) IS
  TYPE numlist_type IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  v_id  numlist_type; -- collection
BEGIN
 v_id(1):= 100; v_id(2):= 102; v_id(3):= 104; v_id(4) := 110;
 -- bulk-bind the PL/SQL table
  FORALL i IN v_id.FIRST .. v_id.LAST
    UPDATE employees
      SET salary = (1 + p_percent/100) * salary
      WHERE employee_id = v_id(i);
END;


EXECUTE raise_salary(10);


--Using BULK COLLECT INTO with Queries
--*************************************
CREATE PROCEDURE get_departments(p_loc NUMBER) IS
  TYPE dept_tab_type IS
    TABLE OF departments%ROWTYPE;
  v_depts dept_tab_type;
BEGIN
  SELECT * BULK COLLECT INTO v_depts
  FROM departments
  WHERE location_id = p_loc;                         
  FOR i IN 1 .. v_depts.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_depts(i).department_id
     ||' '|| v_depts(i).department_name);
  END LOOP;
END;


--Using BULK COLLECT INTO with Cursors
--**************************************
CREATE OR REPLACE PROCEDURE get_departments(p_loc NUMBER) IS
  CURSOR cur_dept IS 
    SELECT * FROM departments
    WHERE location_id = p_loc;                         
  TYPE dept_tab_type IS TABLE OF cur_dept%ROWTYPE;
  v_depts dept_tab_type;
BEGIN
  OPEN cur_dept;
  FETCH cur_dept BULK COLLECT INTO v_depts;
  CLOSE cur_dept;
 FOR i IN 1 .. v_depts.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_depts(i).department_id
     ||' '|| v_depts(i).department_name);
  END LOOP;
END;


