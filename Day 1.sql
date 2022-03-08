select banner from v$version;

create table x(sno number, sname varchar(20));

insert into x values (1,'ali');
insert into x values (2,'ali');

begin
insert into x values (1,'ali');
insert into x values (2,'ali');
commit;
end;

select * from x;

delete from x;

rollback;



SET SERVEROUTPUT ON;
SET VERIFY OFF;

BEGIN
dbms_output.put_line('My first program in PL/SQL');
END;

DECLARE
    v1 varchar(20):='Muayad';
BEGIN
    dbms_output.put_line('Welcom '||v1);
END;

--Program to add two numbers and display the result using PL/SQL
DECLARE
    n1 number:=5;
    n2 number:=6;
BEGIN
    dbms_output.put_line(n1 + n2);
END;

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


DECLARE
    p1 PLS_INTEGER := 2147483647;
    p2 INTEGER := 1;
    n NUMBER;
BEGIN
    n := p1 + p2;
    dbms_output.put_line(n);
END;


CREATE TABLE table1 (n1 NUMBER);
INSERT INTO table1 VALUES(123.45);
SELECT * FROM table1;

SELECT n1, TO_BINARY_FLOAT(n1) FROM table1;

