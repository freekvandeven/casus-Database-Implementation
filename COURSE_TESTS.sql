USE COURSE

EXEC tSQLt.NewTestClass 'testDepartmentAdminConstraint';
EXEC tSQLt.NewTestClass 'testEmployeeAdultConstraint';
EXEC tSQLt.NewTestClass 'testSalaryGradeConstraint';
EXEC tSQLt.NewTestClass 'testTrainerCoursePerDayConstraint';
EXEC tSQLt.NewTestClass 'testTrainerTeachesFromHomeConstraint';
EXEC tSQLt.NewTestClass 'testTrainerQualifiedConstraint';

/*--------------------------------------------------------
CONSTRAINT 1
--------------------------------------------------------*/

-- procedure test insert employee
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for correct employee insert]
go
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for correct employee insert]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC [tSQLt].[ExpectException]

	--Zet een gegarandeerd goede eerste president rij in dbo. emp
	INSERT INTO dbo.emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	VALUES(5560,'Freek','PRESIDENT','1957-12-22','1992-01-01',10,1000,'FREEK',10);

	EXEC SP_InsertEmployee 1000, 'enaam', 'ADMIN', '1900-01-01', '1980-01-01', 8, 1000, 'testgebruiker', 8
END;
go

-- procedure test insert employee
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for false employee insert]
go
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for false employee insert]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC [tSQLt].[ExpectException]

	--Zet een gegarandeerd goede eerste president rij in dbo. emp
	INSERT INTO dbo.emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	VALUES(5560,'Freek','PRESIDENT','1957-12-22','1992-01-01',10,1000,'FREEK',10);

	EXEC SP_InsertEmployee 1000, 'enaam', 'ADMIN', '1900-01-01', '1980-01-01', 8, 1000, 'testgebruiker', 8
END;
go

-- procedure test update employee
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for correct employee update]
go
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for correct employee update]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC [tSQLt].[ExpectException]

	--Zet een gegarandeerd goede eerste president rij in dbo. emp
	INSERT INTO dbo.emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	VALUES(5560,'Freek','PRESIDENT','1957-12-22','1992-01-01',10,1000,'FREEK',10);

	EXEC SP_UpdateEmployee 1000, 'enaam', 'ADMIN', '1900-01-01', '1980-01-01', 8, 1000, 'testgebruiker', 8
END;
go

-- procedure test update employee
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for false employee update]
go
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for false employee update]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC [tSQLt].[ExpectException]

	--Zet een gegarandeerd goede eerste president rij in dbo. emp
	INSERT INTO dbo.emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	VALUES(5560,'Freek','PRESIDENT','1957-12-22','1992-01-01',10,1000,'FREEK',10);

	EXEC SP_UpdateEmployee 1000, 'enaam', 'ADMIN', '1900-01-01', '1980-01-01', 8, 1000, 'testgebruiker', 8
END;
go

-- procedure test delete employee
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for correct employee delete]
go
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for correct employee delete]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC [tSQLt].[ExpectException]

	--Zet een gegarandeerd goede eerste president rij in dbo. emp
	INSERT INTO dbo.emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	VALUES(5560,'Freek','PRESIDENT','1957-12-22','1992-01-01',10,1000,'FREEK',10);

	EXEC SP_DeleteEmployee 1000, 'enaam', 'ADMIN', '1900-01-01', '1980-01-01', 8, 1000, 'testgebruiker', 8
END;
go

-- procedure test delete employee
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for correct employee delete]
go
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for correct employee delete]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC [tSQLt].[ExpectException]

	--Zet een gegarandeerd goede eerste president rij in dbo. emp
	INSERT INTO dbo.emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	VALUES(5560,'Freek','PRESIDENT','1957-12-22','1992-01-01',10,1000,'FREEK',10);

	EXEC SP_DeleteEmployee 1000, 'enaam', 'ADMIN', '1900-01-01', '1980-01-01', 8, 1000, 'testgebruiker', 8
END;
go

-- trigger test 1
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for correct insert]
GO
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for correct insert]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyTrigger @TableName =  'emp', @TriggerName =  'DepartmentAdministratorPresident';
	EXEC tSQLt.ExpectException

	--actie
	UPDATE emp SET job='SALESREP' WHERE empno = 1004
END
GO

-- trigger test 2
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for false update]
GO
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for false update]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyTrigger @TableName =  'emp', @TriggerName =  'DepartmentAdministratorPresident';
	EXEC tSQLt.ExpectNoException

	--actie
	UPDATE emp SET job='SALESREP' WHERE empno = 1011
END
GO

-- trigger test 3
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for bad multirow insert]
GO
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for bad multirow insert]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyTrigger @TableName =  'emp', @TriggerName =  'DepartmentAdministratorPresident';
	EXEC tSQLt.ExpectNoException

	--multi-row insert
	--INSERT INTO emp VALUES(),(),()
END
GO

/*--------------------------------------------------------
CONSTRAINT 2
--------------------------------------------------------*/

DROP PROCEDURE IF EXISTS [testEmployeeAdultConstraint].[test for child labour]
GO
CREATE PROCEDURE [testEmployeeAdultConstraint].[test for child labour]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyConstraint 'emp', 'emp_chk_age'
	EXEC tSQLt.ExpectException

	insert into emp
	values (6969,'daoisjd','SALESREP','2008-12-12','2012-12-12',6,5500,'lkdsjaslk',15)
END

DROP PROCEDURE IF EXISTS [testEmployeeAdultConstraint].[test for adult personel success]
GO
CREATE PROCEDURE [testEmployeeAdultConstraint].[test for adult personel success]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyConstraint 'emp', 'emp_chk_age'
	EXEC tSQLt.ExpectNoException

	insert into emp
	values (6969,'daoisjd','SALESREP','1969-12-12','2012-12-12',6,5500,'lkdsjaslk',15)
END

/*--------------------------------------------------------
CONSTRAINT 3
--------------------------------------------------------*/
-- trigger test 1
DROP PROCEDURE IF EXISTS [testSalaryGradeConstraint].[test for adult personel future baby]
GO
CREATE PROCEDURE [testSalaryGradeConstraint].[test for adult personel future baby]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyConstraint 'emp', 'emp_chk_age'
	EXEC tSQLt.ExpectException

	insert into emp
	values (6969,'daoisjd','SALESREP','2100-12-12','2012-12-12',6,5500,'lkdsjaslk',15)
END

-- trigger test 2
DROP PROCEDURE IF EXISTS [testSalaryGradeConstraint].[test for incremental salary]
GO
CREATE PROCEDURE [testSalaryGradeConstraint].[test for incremental salary]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'grd'
	EXEC tSQLt.ApplyTrigger @TableName =  'grd', @TriggerName =  'LimitSalaryGradeIncremental';
	EXEC tSQLt.ExpectException
	insert into grd
	values (12,9000,14000,5000)
	,(13,8000,12000,5000)
END

-- trigger test 3
DROP PROCEDURE IF EXISTS [testSalaryGradeConstraint].[test for incremental salary success]
GO
CREATE PROCEDURE [testSalaryGradeConstraint].[test for incremental salary success]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'grd'
	EXEC tSQLt.ApplyTrigger @TableName =  'grd', @TriggerName =  'LimitSalaryGradeIncremental';
	EXEC tSQLt.ExpectNoException
	insert into grd
	values (13,9000,14000,5000)
	,(12,8000,12000,5000)
END






/*--------------------------------------------------------
CONSTRAINT 4
--------------------------------------------------------*/

-- trigger test 1
DROP PROCEDURE IF EXISTS testTrainerCoursePerDayConstraint.[test trainer only one course per day success]
GO
CREATE PROCEDURE testTrainerCoursePerDayConstraint.[test trainer only one course per day success]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerOnlyOneCoursePerDay';
	EXEC tSQLt.ExpectNoException
	insert into offr
	values ('APEX','1998-09-06','CONF',6,1018,'AMSTERDAM'),
	('AM4DP','1998-09-07','CONF',6,1018,'SAN FRANCISCO')
END
GO

-- trigiger test 2
DROP PROCEDURE IF EXISTS testTrainerCoursePerDayConstraint.[test trainer only one course per day failure]
GO
CREATE PROCEDURE [testTrainerCoursePerDayConstraint].[test trainer only one course per day failure]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerOnlyOneCoursePerDay';
	EXEC tSQLt.ExpectException
	insert into offr
	values ('APEX','1998-09-06','CONF',6,1018,'AMSTERDAM'),
	('AM4DP','1998-09-06','CONF',6,1018,'SAN FRANCISCO')
END
GO

-- trigger test 3
DROP PROCEDURE IF EXISTS [testTrainerCoursePerDayConstraint].[test trainer only one course per day multi-row failure]
GO
CREATE PROCEDURE [testTrainerCoursePerDayConstraint].[test trainer only one course per day multi-row failure]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr';
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerOnlyOneCoursePerDay';
	EXEC tSQLt.ExpectException
  insert into offr
	values ('APEX','1997-08-15','CONF',6,1017,'SAN FRANCISCO'),
  ('J2EE','1997-08-15','CONF',6,1017,'SAN FRANCISCO'),
	('PLSQL','1998-08-16','CONF',6,1018,'SAN FRANCISCO')
END
GO

/*--------------------------------------------------------
CONSTRAINT 5
--------------------------------------------------------*/

-- trigger test 1
DROP PROCEDURE IF EXISTS [testTrainerTeachesFromHomeConstraint].[test at least halve the courses are home based failure]
GO
CREATE PROCEDURE [testTrainerTeachesFromHomeConstraint].[test at least halve the courses are home based failure]
AS
BEGIN
	EXEC tSQLt.ExpectException
	insert into offr
	values ('AM4DP','1998-09-09','CONF',6,1016,'AMSTERDAM') -- this trainer already teaches too much at home so there is already an exception here
END

-- trigger test 2
DROP PROCEDURE IF EXISTS [testTrainerTeachesFromHomeConstraint].[test at least halve the courses are home based success]
GO
CREATE PROCEDURE [testTrainerTeachesFromHomeConstraint].[test at least halve the courses are home based success]
AS
BEGIN
	EXEC tSQLt.ExpectNoException
	insert into offr
	values ('AM4DP','1998-09-09','CONF',6,1016,'SAN FRANCISCO') -- 10 hour course at home makes it so this trainer does qualify now
END

-- trigger test 3
DROP PROCEDURE IF EXISTS [testTrainerTeachesFromHomeConstraint].[test at least halve the courses are home based multi-row failure]
GO
CREATE PROCEDURE [testTrainerTeachesFromHomeConstraint].[test at least halve the courses are home based multi-row failure]
AS
BEGIN
	EXEC tSQLt.ExpectNoException
	insert into offr
	values ('AM4DP','1998-09-09','CONF',6,1016,'SAN FRANCISCO') -- 10 hour course at home makes it so this trainer does qualify now
END

/*--------------------------------------------------------
CONSTRAINT 6
--------------------------------------------------------*/

-- trigger test 1
DROP PROCEDURE IF EXISTS [testTrainerQualifiedConstraint].[test emp does not have trainer as his job]
GO
CREATE PROCEDURE [testTrainerQualifiedConstraint].[test emp does not have trainer as his job]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerQualified';
	EXEC tSQLt.ExpectException

	insert into offr
	values ('APEX','1998-09-11','CONF',6,1011,'AMSTERDAM')
END

-- trigger test 2
DROP PROCEDURE IF EXISTS [testTrainerQualifiedConstraint].[test this trainer does not work here for a year]
GO
CREATE PROCEDURE [testTrainerQualifiedConstraint].[test this trainer does not work here for a year]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerQualified';
	EXEC tSQLt.ExpectException

insert into emp values(1034,'dshkdsa','TRAINER','1965-03-21','2020-07-22',4,4000,'sdkaljda',15) -- nieuwe trainer die hier nog geen jaar werkt
insert into offr values('APEX','1998-09-11','CONF',6,1034,'AMSTERDAM') -- wordt ook in de offr tabel gezet
END


-- trigger test 3
DROP PROCEDURE IF EXISTS [testTrainerQualifiedConstraint].[test at least halve the courses are home based success]
GO
CREATE PROCEDURE [testTrainerQualifiedConstraint].[test at least halve the courses are home based success]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerQualified';
	EXEC tSQLt.ExpectNoException
	insert into emp values(1034,'dshkdsa','TRAINER','1965-03-21','2020-07-22',4,4000,'sdkaljda',15)
	insert into reg values(1034,'APEX','2001-10-11',4) -- nieuwe trainer heeft nu wel de course gevolgd in het verleden
	insert into offr values('APEX','1998-09-11','CONF',6,1034,'AMSTERDAM')
END
GO


EXEC tSQLt.runAll
