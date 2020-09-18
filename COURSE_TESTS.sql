USE COURSE

EXEC tSQLt.NewTestClass 'testDepartmentAdminConstraint';
EXEC tSQLt.NewTestClass 'testEmployeeAdultConstraint';
EXEC tSQLt.NewTestClass 'testSalaryGradeConstraint';
EXEC tSQLt.NewTestClass 'testTrainerCoursePerDayConstraint';
EXEC tSQLt.NewTestClass 'testTrainerTeachesFromHomeConstraint';
EXEC tSQLt.NewTestClass 'testTrainerQualifiedConstraint';

DROP PROCEDURE IF EXISTS [testDepartmentAdminConstraint].[test for updating Administrator job]
GO
CREATE PROCEDURE [testDepartmentAdminConstraint].[test for updating Administrator job]
AS
BEGIN
	EXEC tSQLt.FakeTable 'dbo', 'emp'; --dbo is het default schema igv create table
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyTrigger @TableName =  'emp', @TriggerName =  'DepartmentAdministratorPresident';
	EXEC tSQLt.ExpectException
	--actie
	UPDATE emp SET job='SALESREP' WHERE empno = 1004
END
GO

EXEC tSQLt.runAll
