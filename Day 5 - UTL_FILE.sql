
SELECT * fROM all_directories;


DROP DIRECTORY MUAYAD;
CREATE DIRECTORY MUAYAD AS 'D:\oracle19c\admin\MCD\muayad';
GRANT READ, WRITE ON DIRECTORY MUAYAD TO public;


--GRANT EXECUTE ON create_table TO hr;
GRANT CREATE ANY TABLE TO hr;

-- INSERT     UPDATE    DELETE
-- NEW        OLD/NEW   OLD

--Statement level trigger
--row level trigger
