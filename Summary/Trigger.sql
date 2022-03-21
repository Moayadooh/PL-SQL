
SET SERVEROUTPUT ON;

DROP TRIGGER trig1;
DROP TABLE hello;
DROP TABLE hello2;

create table hello (sno number, sname varchar(20));
--do something before insert
create or replace trigger trig1
before insert on hello
begin
    dbms_output.put_line('statement level trigger demo');
end;

insert into hello values(1,'b');
insert into hello values(2,'b');
insert into hello values(3,'b');



create or replace trigger trig1
--do something before insert or update or delete
before insert or update or delete on hello
begin
    dbms_output.put_line('statement level trigger demo');
end;

update hello set sname='arif' where sno=1;

delete from hello where sno=2;



create or replace trigger trig1
--do something before insert or update or delete FOR EACH ROW
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

insert into hello values(1,'a');
insert into hello values(2,'b');
insert into hello values(3,'a');


alter table hello2 add(who varchar(20), when1 date);
--whenever a record is deleted from hello table, it will be inserted in hello2
create or replace trigger trig1
after delete on hello
for each row
begin
    insert into hello2 values(:old.sno, :old.sname,user,sysdate);
end;

delete from hello;
