
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

SELECT * FROM emp2;


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
