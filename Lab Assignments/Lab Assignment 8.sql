
CREATE OR REPLACE FUNCTION VALID_ACNO
(
    p_AcNo deposits.AcNo%TYPE
)
RETURN BOOLEAN IS 
    v_is_account_number_exist BOOLEAN := FALSE;
    v_num_of_accounts NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_num_of_accounts FROM registration WHERE AcNo = p_AcNo;
    IF v_num_of_accounts > 0 THEN
        v_is_account_number_exist := TRUE;
    ELSE
        v_is_account_number_exist := FALSE;
    END IF;
    RETURN v_is_account_number_exist;
END VALID_ACNO;

CREATE OR REPLACE PROCEDURE Deposit_Amt
(
    p_DNo deposits.DNo%TYPE,
    p_AcNo deposits.AcNo%TYPE,
    p_DAmount deposits.DAmount%TYPE,
    p_DLocation deposits.DLocation%TYPE
)
IS
BEGIN
    IF VALID_ACNO(p_AcNo) THEN
        INSERT INTO deposits(DNo,AcNo,DAmount,DLocation) 
        VALUES(p_DNo,p_AcNo,p_DAmount,p_DLocation);
        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Account number not exist');
    END IF;
END Deposit_Amt;
SET SERVEROUTPUT ON;
EXEC Reg_Add_Record(4,'Arif','Ahmed','28-NOV-1970',963852741,'M','77777777',40);
SELECT * FROM registration;
EXEC my_pkg.Deposit_Amt(400,4558,100,'Al khaweer');
SELECT * FROM deposits;
