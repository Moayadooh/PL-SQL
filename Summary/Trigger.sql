create table hello (sno number, sname varchar(020));

--spool on

create or replace trigger trig1
before insert on hello
begin
dbms_output.put_line('statement level trigger demo');
end;

insert into hello values(1,'b');

create or replace trigger trig1
before insert or update or delete on hello
begin
dbms_output.put_line('statement level trigger demo');
end;

update hello set sname='arif' where sno=1;

delete from hello where sno=2;

commit;

create or replace trigger trig1
before insert or update or delete on hello
for each row
begin
dbms_output.put_line('statement level trigger demo');
end;

create or replace trigger trig1
before insert or update or delete on hello
for each row
begin
dbms_output.put_line('row level trigger demo');
end;

insert into hello values(1,'a');
insert into hello values(2,'a');
insert into hello values(3,'a');

delete from hello;

create table hello2 as select * from hello;

--inserting data in hello and hello2 simultaneously
create or replace trigger trig1
after insert on hello
for each row
begin
insert into hello2 values(:new.sno, :new.sname);
end;

insert into hello values(3,'a');

--whenever a record is deleted from hello table, it will be inserted in hello2
alter table hello2 add(who varchar(20), when1 date);
create or replace trigger trig1
after delete on hello
for each row
begin
insert into hello2 values(:old.sno, :old.sname,user,sysdate);
end;

delete from hello;

grant delete on hello to public;

insert into hello values(3,'a');
insert into hello values(2,'b');

commit;

--connect ali/1@pdb1
--connect hr/hr@pdb1

select * from hello;
select * from hello2;

create view v1 as select * from hello;
select * from v1;
insert into v1 values(4,'d');
commit;

select * from v1;
select * from hello;

create view v2 as select * from hello with read only;

select * from hello;
alter table hello add constraint snopkk primary key(sno);

create table hellochild(sno number, dated date);
alter table hellochild add constraint snofkk foreign key(sno) references hello (sno);
insert into hellochild values(2,sysdate);
commit;

create view hello_v as select hello.sno,sname,dated from hello join hellochild on hello.sno=hellochild.sno;

select * from hello_v;

desc hello_v;

ed insteadoftrig

CREATE TABLE new_emps AS SELECT employee_id,last_name,salary,department_id FROM employees;

CREATE VIEW emp_details AS
SELECT e.employee_id, e.last_name, e.salary,
e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;
desc emp_details;

@trig;
show errors;
ed trig;

select * from new_emps;
--ed

CREATE TABLE new_depts AS
SELECT d.department_id,d.department_name,
e.salary dept_sal FROM employees e, departments d
WHERE e.department_id = d.department_id;

select * from hello;
select * from hellochild;
select * from hello_v;

--spool off
