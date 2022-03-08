
select * from v$session where username = 'HR';

select name from v$datafile;

create tablespace test_tbs
datafile 'D:\ORACLE19C\ORADATA\MCD\PDB1\file1.DBF' size 200M;

select name from v$tablespace;

alter tablespace test_tbs add
datafile 'D:\ORACLE19C\ORADATA\MCD\PDB1\file2.DBF' size 300M;

alter tablespace test_tbs add
datafile 'D:\ORACLE19C\ORADATA\MCD\PDB1\file3.DBF' size 1G;

--create user username idendified by password
create user user1 identified by 1;
create user muayad identified by 1;
create user arif identified by 1;
create user ali identified by 1;
create user said identified by 1;

select username, account_status, default_tablespace from dba_users order by created desc;

alter user ali account lock;

alter user ali account unlock;

grant create session to arif;--because when you login you create a session

--rolses
create role developers;
create role endusers;


--adding users to roles
grant developers to muayad, ali;
grant endusers to said, arif;


--grant privillages to roles
grant create session to developers, endusers;


--change password for user1
alter user user1 identified by 1;

grant create table, create procedure, create view, create synonym, 
create sequence, create trigger to developers;

alter user ali quota unlimited on test_tbs
default tablespace test_tbs;

alter user muayad quota unlimited on test_tbs
default tablespace test_tbs;


grant insert, update, delete, select on t2 to endusers;



--SQL PLUs:
--Enter user-name: ali@pdb1
--or 
--Enter password: 1
--create table t2 (name varchar(30));
--grant insert, update, delete, select on t2 to endusers;



