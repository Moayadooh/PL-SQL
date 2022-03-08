
DESCRIBE user_source
SELECT text, name, type FROM user_source WHERE type = 'PROCEDURE' AND name = 'SECURE_DML';


--package example
CREATE OR REPLACE PACKAGE my_pkg IS
    PROCEDURE display(msg VARCHAR);
END my_pkg;

CREATE OR REPLACE PACKAGE BODY my_pkg IS
    PROCEDURE display(msg VARCHAR) IS 
    BEGIN
        DBMS_OUTPUT.PUT_LINE(msg);
    END display;
END my_pkg;

EXEC my_pkg.display('Muayad');


--overloading
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
