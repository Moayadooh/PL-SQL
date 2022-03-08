
CREATE OR REPLACE PACKAGE accounts_pkg IS
    PROCEDURE Reg_Add_Record(
    p_AcNo registration.AcNo%TYPE,
    p_FName registration.FName%TYPE,
    p_LName registration.LName%TYPE,
    p_DOB registration.DOB%TYPE,
    p_CivilID registration.CivilID%TYPE,
    p_Gender registration.Gender%TYPE,
    p_GSM registration.GSM%TYPE,
    p_OpenBal registration.OpenBal%TYPE);
    
    PROCEDURE Reg_Update_OpenGSM(
    p_AcNo registration.AcNo%TYPE,
    p_newGSM registration.GSM%TYPE);
    
    PROCEDURE Reg_Del_Record(p_AcNo registration.AcNo%TYPE);
    
    PROCEDURE Deposit_Amt(
    p_DNo deposits.DNo%TYPE,
    p_AcNo deposits.AcNo%TYPE,
    p_DAmount deposits.DAmount%TYPE,
    p_DLocation deposits.DLocation%TYPE);
    
    PROCEDURE Withdraw_Amt(
    p_WNo withdrawls.WNo%TYPE,
    p_AcNo withdrawls.AcNo%TYPE,
    p_WAmount withdrawls.WAmount%TYPE,
    p_WLocation withdrawls.WLocation%TYPE);
END accounts_pkg;

CREATE OR REPLACE PACKAGE BODY accounts_pkg IS
    PROCEDURE Reg_Add_Record(
    p_AcNo registration.AcNo%TYPE,
    p_FName registration.FName%TYPE,
    p_LName registration.LName%TYPE,
    p_DOB registration.DOB%TYPE,
    p_CivilID registration.CivilID%TYPE,
    p_Gender registration.Gender%TYPE,
    p_GSM registration.GSM%TYPE,
    p_OpenBal registration.OpenBal%TYPE) IS 
    BEGIN
        INSERT INTO registration(AcNo,FName,LName,DOB,CivilID,Gender,GSM,OpenBal) 
        VALUES(p_AcNo,p_FName,p_LName,p_DOB,p_CivilID,p_Gender,p_GSM,p_OpenBal);
        COMMIT;
    END Reg_Add_Record;
    
    PROCEDURE Reg_Update_OpenGSM(
    p_AcNo registration.AcNo%TYPE,
    p_newGSM registration.GSM%TYPE) IS
    BEGIN
        UPDATE registration 
        SET GSM = p_newGSM 
        WHERE AcNo = p_AcNo;
        COMMIT;
    END Reg_Update_OpenGSM;
    
    PROCEDURE Reg_Del_Record(p_AcNo registration.AcNo%TYPE) IS
    BEGIN
        DELETE FROM registration 
        WHERE AcNo = p_AcNo;
        COMMIT;
    END Reg_Del_Record;
    
    PROCEDURE Deposit_Amt(
    p_DNo deposits.DNo%TYPE,
    p_AcNo deposits.AcNo%TYPE,
    p_DAmount deposits.DAmount%TYPE,
    p_DLocation deposits.DLocation%TYPE) IS
    BEGIN
        INSERT INTO deposits(DNo,AcNo,DAmount,DLocation) 
        VALUES(p_DNo,p_AcNo,p_DAmount,p_DLocation);
        COMMIT;
    END Deposit_Amt;
    
    PROCEDURE Withdraw_Amt(
    p_WNo withdrawls.WNo%TYPE,
    p_AcNo withdrawls.AcNo%TYPE,
    p_WAmount withdrawls.WAmount%TYPE,
    p_WLocation withdrawls.WLocation%TYPE) IS
    BEGIN
        INSERT INTO withdrawls(WNo,AcNo,WAmount,WLocation) 
        VALUES(p_WNo,p_AcNo,p_WAmount,p_WLocation);
        COMMIT;
    END Withdraw_Amt;
END accounts_pkg;

EXEC accounts_pkg.Reg_Add_Record(2,'Muayad','Al Falahi','28-NOV-1997',472424,'M','25814796',33);
