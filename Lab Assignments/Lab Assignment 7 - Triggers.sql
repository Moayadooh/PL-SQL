
DROP TABLE registration;
CREATE TABLE registration
(AcNo Number Primary Key,
FName Varchar(15) Not null,
LName Varchar(15) Not null,
DOB Date,
RegDate Date Default sysdate,
CivilID Number Not null,
Gender Char(1),
GSM Number(8) Unique,
OpenBal Number,
CONSTRAINT registration_Gender CHECK(Gender = 'M' OR Gender = 'm' OR Gender = 'F' OR Gender = 'f'),
CONSTRAINT registration_OpenBal CHECK(OpenBal >= 50));
DESC registration;

ALTER TABLE registration DROP CONSTRAINT registration_OpenBal;
ALTER TABLE registration ADD CONSTRAINT registration_OpenBal CHECK(OpenBal >= 50);

DROP TABLE deposits;
CREATE TABLE deposits
(DNo Number Primary Key,
AcNo Number,
DDate Date Default sysdate,
DAmount Number Not null,
DLocation Varchar(10) Not null,
CONSTRAINT deposits_registration_id_fk FOREIGN KEY(AcNo) REFERENCES registration(AcNo));
DESC deposits;

DROP TABLE withdrawls;
CREATE TABLE withdrawls
(WNo Number Primary Key,
AcNo Number,
WDate Date Default sysdate,
WAmount Number Not null,
WLocation Varchar(10) Not null,
CONSTRAINT withdrawls_registration_id_fk FOREIGN KEY(AcNo) REFERENCES registration(AcNo));
DESC withdrawls;

CREATE OR REPLACE PROCEDURE Reg_Add_Record
(
    p_AcNo registration.AcNo%TYPE,
    p_FName registration.FName%TYPE,
    p_LName registration.LName%TYPE,
    p_DOB registration.DOB%TYPE,
    p_CivilID registration.CivilID%TYPE,
    p_Gender registration.Gender%TYPE,
    p_GSM registration.GSM%TYPE,
    p_OpenBal registration.OpenBal%TYPE
)
IS
BEGIN
    INSERT INTO registration(AcNo,FName,LName,DOB,CivilID,Gender,GSM,OpenBal) 
    VALUES(p_AcNo,p_FName,p_LName,p_DOB,p_CivilID,p_Gender,p_GSM,p_OpenBal);
    COMMIT;
END Reg_Add_Record;
EXEC Reg_Add_Record(1,'Muayad','Al Falahi','28-NOV-1997',123456789,'M','96430801',50);
SELECT * FROM registration;

CREATE OR REPLACE PROCEDURE Reg_Update_OpenGSM
(
    p_AcNo registration.AcNo%TYPE,
    p_newGSM registration.GSM%TYPE
)
IS
BEGIN
    UPDATE registration 
    SET GSM = p_newGSM 
    WHERE AcNo = p_AcNo;
    COMMIT;
END Reg_Update_OpenGSM;
EXEC Reg_Update_OpenGSM(1,'96430801');
SELECT * FROM registration;

CREATE OR REPLACE PROCEDURE Reg_Del_Record
(
    p_AcNo registration.AcNo%TYPE
)
IS
BEGIN
    DELETE FROM registration 
    WHERE AcNo = p_AcNo;
    COMMIT;
END Reg_Del_Record;
EXEC Reg_Del_Record(1);
SELECT * FROM registration;

CREATE OR REPLACE PROCEDURE Deposit_Amt
(
    p_DNo deposits.DNo%TYPE,
    p_AcNo deposits.AcNo%TYPE,
    p_DAmount deposits.DAmount%TYPE,
    p_DLocation deposits.DLocation%TYPE
)
IS
BEGIN
    INSERT INTO deposits(DNo,AcNo,DAmount,DLocation) 
    VALUES(p_DNo,p_AcNo,p_DAmount,p_DLocation);
    COMMIT;
END Deposit_Amt;
EXEC Deposit_Amt(5,1,50,'Sur');
SELECT * FROM deposits;

CREATE OR REPLACE PROCEDURE Withdraw_Amt
(
    p_WNo withdrawls.WNo%TYPE,
    p_AcNo withdrawls.AcNo%TYPE,
    p_WAmount withdrawls.WAmount%TYPE,
    p_WLocation withdrawls.WLocation%TYPE
)
IS
BEGIN
    INSERT INTO withdrawls(WNo,AcNo,WAmount,WLocation) 
    VALUES(p_WNo,p_AcNo,p_WAmount,p_WLocation);
    COMMIT;
END Withdraw_Amt;
EXEC Withdraw_Amt(5,1,90,'Muscat');
SELECT * FROM withdrawls;


select * from registration;


create or replace trigger deposits_trig
after insert on deposits
for each row
begin
update registration set OpenBal = (:NEW.DAmount + OpenBal) where :NEW.AcNo = AcNo;
end;

create or replace trigger withdrawls_trig
after insert on withdrawls
for each row
begin
update registration set OpenBal = (OpenBal - :NEW.WAmount) where :NEW.AcNo = AcNo;
end;

