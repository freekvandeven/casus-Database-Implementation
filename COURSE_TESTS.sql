USE COURSE

EXEC tSQLt.NewTestClass 'testDepartmentAdminConstraint';
EXEC tSQLt.NewTestClass 'testEmployeeAdultConstraint';
EXEC tSQLt.NewTestClass 'testSalaryGradeConstraint';
EXEC tSQLt.NewTestClass 'testTrainerCoursePerDayConstraint';
EXEC tSQLt.NewTestClass 'testTrainerTeachesFromHomeConstraint';
EXEC tSQLt.NewTestClass 'testTrainerQualifiedConstraint';

--1
DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for updating Administrator job]
GO
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for updating Administrator job]
AS
BEGIN
	--EXEC tSQLt.FakeTable 'dbo', 'emp'; --dbo is het default schema igv create table
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	--exec tSQLt.FakeTable 'dbo', 'emp',1,1,1
	--EXEC tSQLt.ApplyTrigger @TableName =  'emp', @TriggerName =  'DepartmentAdministratorPresident';
	EXEC tSQLt.ExpectException

	--actie
	UPDATE emp SET job='SALESREP' WHERE empno = 1004
END
GO

DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for updating Administrator job success]
GO
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for updating Administrator job success]
AS
BEGIN
	--EXEC tSQLt.FakeTable 'dbo', 'emp'; --dbo is het default schema igv create table
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	--exec tSQLt.FakeTable 'dbo', 'emp',1,1,1
	--EXEC tSQLt.ApplyTrigger @TableName =  'emp', @TriggerName =  'DepartmentAdministratorPresident';
	EXEC tSQLt.ExpectNoException

	--actie
	UPDATE emp SET job='SALESREP' WHERE empno = 1011
END
GO

--2
DROP PROCEDURE IF EXISTS testEmployeeAdultConstraint.[test for child labour]
GO
CREATE PROCEDURE testEmployeeAdultConstraint.[test for child labour]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyConstraint 'emp', 'emp_chk_age'
	EXEC tSQLt.ExpectException

	insert into emp
	values (6969,'daoisjd','SALESREP','2008-12-12','2012-12-12',6,5500,'lkdsjaslk',15)
END
DROP PROCEDURE IF EXISTS testEmployeeAdultConstraint.[test for adult personel success]
GO
CREATE PROCEDURE testEmployeeAdultConstraint.[test for adult personel success]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp';
	EXEC tSQLt.ApplyConstraint 'emp', 'emp_chk_age'
	EXEC tSQLt.ExpectNoException

	insert into emp
	values (6969,'daoisjd','SALESREP','1969-12-12','2012-12-12',6,5500,'lkdsjaslk',15)
END

DROP PROCEDURE IF EXISTS testSalaryGradeConstraint.[test for adult personel future baby]
GO
CREATE PROCEDURE testSalaryGradeConstraint.[test for adult personel future baby]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp'; 
	EXEC tSQLt.ApplyConstraint 'emp', 'emp_chk_age'
	EXEC tSQLt.ExpectException

	insert into emp
	values (6969,'daoisjd','SALESREP','2100-12-12','2012-12-12',6,5500,'lkdsjaslk',15)
END

--3
DROP PROCEDURE IF EXISTS testSalaryGradeConstraint.[test for incremental salary]
GO
CREATE PROCEDURE testSalaryGradeConstraint.[test for incremental salary]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'grd'
	EXEC tSQLt.ApplyTrigger @TableName =  'grd', @TriggerName =  'LimitSalaryGradeIncremental';
	EXEC tSQLt.ExpectException
	insert into grd
	values (12,9000,14000,5000)
	,(13,8000,12000,5000)
END

DROP PROCEDURE IF EXISTS testSalaryGradeConstraint.[test for incremental salary success]
GO
CREATE PROCEDURE testSalaryGradeConstraint.[test for incremental salary success]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'grd'
	EXEC tSQLt.ApplyTrigger @TableName =  'grd', @TriggerName =  'LimitSalaryGradeIncremental';
	EXEC tSQLt.ExpectNoException
	insert into grd
	values (13,9000,14000,5000)
	,(12,8000,12000,5000)
END

--4
DROP PROCEDURE IF EXISTS testTrainerCoursePerDayConstraint.[test trainer only one course per day]
GO
CREATE PROCEDURE testTrainerCoursePerDayConstraint.[test trainer only one course per day]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerOnlyOneCoursePerDay';
	EXEC tSQLt.ExpectException
	insert into offr
	values ('APEX','1998-09-06','CONF',6,1018,'AMSTERDAM'),
	('AM4DP','1998-09-06','CONF',6,1018,'SAN FRANCISCO')
END

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

--5
DROP PROCEDURE IF EXISTS testTrainerTeachesFromHomeConstraint.[test at least halve the courses are home based]
GO
CREATE PROCEDURE testTrainerTeachesFromHomeConstraint.[test at least halve the courses are home based]
AS
BEGIN
	EXEC tSQLt.ExpectException
	insert into offr
	values ('AM4DP','1998-09-09','CONF',6,1016,'AMSTERDAM') -- this trainer already teaches too much at home so there is already an exception here
END

DROP PROCEDURE IF EXISTS testTrainerTeachesFromHomeConstraint.[test at least halve the courses are home based success]
GO
CREATE PROCEDURE testTrainerTeachesFromHomeConstraint.[test at least halve the courses are home based success]
AS
BEGIN
	EXEC tSQLt.ExpectNoException
	insert into offr
	values ('AM4DP','1998-09-09','CONF',6,1016,'SAN FRANCISCO') -- 10 hour course at home makes it so this trainer does qualify now
END

--6
DROP PROCEDURE IF EXISTS testTrainerQualifiedConstraint.[test emp doesn't have trainer as his job]
GO
CREATE PROCEDURE testTrainerQualifiedConstraint.[test emp doesn't have trainer as his job]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerQualified';
	EXEC tSQLt.ExpectException

	insert into offr
	values ('APEX','1998-09-11','CONF',6,1011,'AMSTERDAM')
END

DROP PROCEDURE IF EXISTS testTrainerQualifiedConstraint.[test this trainer doesn't work here for a year]
GO
CREATE PROCEDURE testTrainerQualifiedConstraint.[test this trainer doesn't work here for a year]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerQualified';
	EXEC tSQLt.ExpectException

insert into emp values(1034,'dshkdsa','TRAINER','1965-03-21','2020-07-22',4,4000,'sdkaljda',15) -- nieuwe trainer die hier nog geen jaar werkt
insert into offr values('APEX','1998-09-11','CONF',6,1034,'AMSTERDAM') -- wordt ook in de offr tabel gezet 
END

DROP PROCEDURE IF EXISTS testTrainerQualifiedConstraint.[test at least halve the courses are home based success]
GO
CREATE PROCEDURE testTrainerQualifiedConstraint.[test at least halve the courses are home based success]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'offr'
	EXEC tSQLt.ApplyTrigger @TableName =  'offr', @TriggerName =  'TrainerQualified';
	EXEC tSQLt.ExpectNoException
insert into emp values(1034,'dshkdsa','TRAINER','1965-03-21','2020-07-22',4,4000,'sdkaljda',15)
insert into reg values(1034,'APEX','2001-10-11',4) -- nieuwe trainer heeft nu wel de course gevolgd in het verleden
insert into offr values('APEX','1998-09-11','CONF',6,1034,'AMSTERDAM')
END


EXEC tSQLt.runAll
