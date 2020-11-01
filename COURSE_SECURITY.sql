/*------------------------------------------------------------------------------------------------
F - SECURITY
------------------------------------------------------------------------------------------------*/


-- create employee role
CREATE ROLE Employee

CREATE LOGIN [Employee1] WITH PASSWORD=N'qwerty', DEFAULT_DATABASE=[COURSE]
CREATE USER [Employee1] FOR LOGIN [Employee1]
-- assign new employee to the employee role
ALTER ROLE Employee ADD MEMBER [Employee1]

-- give permission for data
GRANT CONTROL ON dbo.reg TO Employee
GRANT SELECT ON dbo.emp TO Employee
GRANT SELECT ON dbo.offr TO Employee


-- create reporting role
CREATE ROLE Reporting

CREATE LOGIN [Employee2] WITH PASSWORD=N'qwerty', DEFAULT_DATABASE=[COURSE]
CREATE USER [Employee2] FOR LOGIN [Employee2]
-- assign new employee to the reporting role
ALTER ROLE Reporting ADD MEMBER [Employee2]

GRANT SELECT ON SCHEMA :: [dbo] TO Reporting


-- testen van security policy
-- test employee1 account
EXECUTE AS USER = 'Employee1'

-- test full access Reg table
SELECT * FROM reg

BEGIN TRANSACTION
UPDATE reg
SET eval = 5 WHERE stud = 1000
ROLLBACK TRANSACTION

-- test read access emp & offr table
SELECT * FROM emp
SELECT * FROM offr


REVERT --switch back to previous user

-- test reporting account
EXECUTE AS USER = 'Employee2'
-- test full read access on all data
SELECT * FROM grd

--test no access to insert
INSERT INTO dbo.grd VALUES(12,12000,17000,6000)
