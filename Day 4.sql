--https://sourceforge.net/projects/winscp/files/WinSCP/5.19.5/WinSCP-5.19.5-Setup.exe/download


-- 1- syntax check (parse)
-- 2- permession check
-- 3- compile
-- 4- execute

--in Procedures the first 3 stages are already done only we execute (imroved performacne)

--RMI --> Remote Method Inveokation (Java)
--RPC --> Remote Procedure call (Procedures)

--OLTP: Onlie Transaction Processing
--OLAP: Online Analytics Processing (reporing)


DESCRIBE user_source

SELECT text, name, type FROM user_source WHERE type = 'PROCEDURE' AND name = 'SECURE_DML';



CREATE OR REPLACE PACKAGE my_pkg IS
    --PROCEDURE Deposit_Amt(p_DNo deposits.DNo%TYPE,p_AcNo deposits.AcNo%TYPE,p_DAmount deposits.DAmount%TYPE,p_DLocation deposits.DLocation%TYPE);
    PROCEDURE display(msg VARCHAR);
END my_pkg;

CREATE OR REPLACE PACKAGE BODY my_pkg IS
    PROCEDURE display(msg VARCHAR) IS 
    BEGIN
        DBMS_OUTPUT.PUT_LINE(msg);
    END display;
END my_pkg;

EXEC my_pkg.display('Muayad');


SELECT * FROM departments;
DESC departments;


CREATE OR REPLACE PACKAGE add_pkg IS
    PROCEDURE add(num1 NUMBER, num2 NUMBER);
    PROCEDURE add(num1 NUMBER, num2 NUMBER, num3 NUMBER);
    PROCEDURE add(num1 NUMBER, num2 NUMBER, num3 NUMBER, num4 NUMBER);
END add_pkg;

CREATE OR REPLACE PACKAGE BODY add_pkg IS
    PROCEDURE add(num1 NUMBER, num2 NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(num1 + num2);
    END add;
    PROCEDURE add(num1 NUMBER, num2 NUMBER, num3 NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(num1 + num2 + num3);
    END add;
    PROCEDURE add(num1 NUMBER, num2 NUMBER, num3 NUMBER, num4 NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(num1 + num2 + num3 + num4);
    END add;
END add_pkg;

EXEC add_pkg.add(10,20);
EXEC add_pkg.add(10,20,30);
EXEC add_pkg.add(10,20,30,40);
