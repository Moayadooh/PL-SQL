
--Environment Variables: The setting stays untill the session is connected. If we disconnect from oracle, we will loose the setting..
SET VERIFY ON; --DEFAULT
SET VERIFY OFF;

SET SERVEROUTPUT OFF; --DEFAULT
SET SERVEROUTPUT ON;


--without using %TYPE
DECLARE
    v_salary NUMBER;
    v_fname VARCHAR(20);
    v_empno NUMBER := &employee_id;
BEGIN
    SELECT SALARY, FIRST_NAME 
    INTO v_salary, v_fname 
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = v_empno;
    dbms_output.put_line('Name is: ' || v_fname);
    dbms_output.put_line('Salry is: ' || v_salary);
END;


--by using %TYPE
DECLARE
    v_salary employees.salary%TYPE;
    v_fname employees.first_name%TYPE;
    v_empno employees.employee_id%TYPE := &employee_id;
BEGIN
    SELECT SALARY, FIRST_NAME 
    INTO v_salary, v_fname 
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = v_empno;
    dbms_output.put_line('Name is: ' || v_fname);
    dbms_output.put_line('Salry is: ' || v_salary);
END;


SET AUTOPRINT OFF; --DEFAULT
SET AUTOPRINT ON;

--bind variable
--one bind variable can be used in multiple anonymous block
VARIABLE b_result NUMBER
BEGIN
    SELECT (SALARY * 12) + NVL(COMMISSION_PCT, 0) 
    INTO :b_result 
    FROM employees 
    WHERE employee_id = 144;
END;

PRINT b_result


--Transaction
CREATE TABLE x(sno NUMBER, sname VARCHAR(20));

BEGIN
	INSERT INTO x VALUES(1,'arif');
	INSERT INTO x VALUES(2,'ali');
	COMMIT;
END;
DELETE FROM x;
ROLLBACK;


--DEFAULT Constraint: column will have a value which you specify at the time of table creation
CREATE TABLE hello2(sno NUMBER PRIMARY KEY, city VARCHAR(20) DEFAULT 'Muscat', salary NUMBER DEFAULT 100);
INSERT INTO hello2 (sno) VALUES(1);
SELECT * FROM hello2;
