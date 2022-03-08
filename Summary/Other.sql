
--Database Architecture
show con_name;
show con_id;
show pdbs;
SELECT name FROM v$database;
SELECT instance_name FROM v$instance;
SELECT name FROM v$datafile;
SELECT banner FROM v$version;

--other
--sqlplus / as sysdba
ALTER SESSION SET container = ORCLPDB;
COLUMN name FORMAT a20;
SELECT name, open_mode FROM v$pdbs;
ALTER PLUGGABLE DATABASE open;
ALTER USER hr IDENTIFIED BY hr ACCOUNT UNLOCK;

--SQL Plus
--hr@orclpdb
--hr

--ALTER PLUGGABLE DATABASE PDB_Name OPEN;
--ALTER PLUGGABLE DATABASE ALL OPEN;

SHUTDOWN IMMEDIATE;
STARTUP;

SHOW PARAMETERS smtp_out


SET SERVEROUTPUT ON;
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


--delete repated data
CREATE TABLE test(sno NUMBER(4), name VARCHAR(30));
INSERT INTO test VALUES(1, 'Aref');
INSERT INTO test VALUES(2, 'Muayad');
INSERT INTO test VALUES(3, 'Zakir');
COMMIT;
SELECT * FROM test;

SELECT ROWID,sno,city FROM t8;
DELETE FROM t8 WHERE ROWID NOT IN('AAAR5BAABAAAbxRAAA') AND city = 'muscat';

DELETE FROM test
WHERE ROWID IN(SELECT RID FROM 
(SELECT ROWID RID, ROW_NUMBER() OVER
(PARTITION BY sno ORDER BY ROWID)
RN FROM test)
WHERE RN <> 1);


--CREATE tablespace
SELECT * FROM v$datafile;

SELECT name, con_id FROM v$datafile;

SELECT * FROM v$tablespace;

SELECT * FROM dba_USERs WHERE USERname = 'HR';

SELECT * FROM v$SESSION WHERE USERname = 'HR';

SELECT name FROM v$datafile;

CREATE tablespace test_tbs
datafile 'D:\ORACLE19C\ORADATA\MCD\PDB1\file1.DBF' SIZE 200M;

SELECT name FROM v$tablespace;

ALTER tablespace test_tbs ADD
datafile 'D:\ORACLE19C\ORADATA\MCD\PDB1\file2.DBF' SIZE 300M;

ALTER tablespace test_tbs ADD
datafile 'D:\ORACLE19C\ORADATA\MCD\PDB1\file3.DBF' SIZE 1G;

--CREATE USER [username] IDENTIFIED BY [password]
CREATE USER USER1 IDENTIFIED BY 1;
CREATE USER muayad IDENTIFIED BY 1;
CREATE USER arif IDENTIFIED BY 1;
CREATE USER ali IDENTIFIED BY 1;
CREATE USER said IDENTIFIED BY 1;

SELECT username, account_status, DEFAULT_tablespace FROM dba_USERs ORDER BY CREATEd DESC;

ALTER USER ali account lock;

ALTER USER ali account unlock;

GRANT CREATE SESSION TO arif;--because when you login you create a session

--rolses
CREATE role developers;
CREATE role endusers;

--ADDing USERs TO roles
GRANT developers TO muayad, ali;
GRANT endusers TO said, arif;

--GRANT privillages TO roles
GRANT CREATE SESSION TO developers, endusers;

--change password for USER1
ALTER USER USER1 IDENTIFIED BY 1;

GRANT CREATE table, CREATE procedure, CREATE view, CREATE synonym, 
CREATE sequence, CREATE trigger TO developers;

ALTER USER ali quota unlimited ON test_tbs
DEFAULT tablespace test_tbs;

ALTER USER muayad quota unlimited ON test_tbs
DEFAULT tablespace test_tbs;

GRANT INSERT, UPDATE, DELETE, SELECT ON t2 TO endusers;



--SQL PLUs:
--Enter USER-name: said@pdb1
--Enter password: 1
--or
--SQL> connect ali/1@pdb1



SELECT * FROM ali.t2;
INSERT INTO ali.t2 VALUES(1);
SELECT * FROM ali.t2;
COMMIT;

SHOW USER
SELECT * FROM t2;

ALTER TABLE t2 ADD(salary NUMBER);
revoke INSERT,UPDATE,DELETE,SELECT ON t2 FROM endusers;
GRANT UPDATE (salary) ON t2 TO endusers;
GRANT UPDATE (salary), SELECT ON t2 TO endusers;
SELECT * FROM ali.t2;
UPDATE ali.t2 SET salary = 4000 WHERE sno = 333;
UPDATE ali.t2 SET sno = 4000 WHERE sno = 333;
