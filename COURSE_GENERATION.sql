/*------------------------------------------------------------------------------------------------
E - CODE GENERATION
------------------------------------------------------------------------------------------------*/

CREATE OR ALTER PROCEDURE sp_CreateHistoryTable
	@tablename VARCHAR(255)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX) = 'CREATE TABLE HIST_' + @tablename + ' (timestamp TIMESTAMP NOT NULL'
	EXEC ('DROP TABLE IF EXISTS HIST_' + @tablename)
	SELECT @SQL = @SQL + ', ' + COLUMN_NAME + ' ' + DATA_TYPE + CASE
	WHEN DATA_TYPE = 'VARCHAR' THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')'
	WHEN DATA_TYPE = 'NUMERIC' THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')'
	ELSE '' END +
	CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END

	FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tablename
	SET @SQL = @SQL + ')'
	EXEC (@SQL)

	-- add primary key
	SET @SQL = 'ALTER TABLE HIST_' + @tablename + ' ADD PRIMARY KEY (timestamp'
	SELECT @SQL = @SQL + ', ' + COLUMN_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS itc JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE icc
	ON itc.CONSTRAINT_NAME = icc.CONSTRAINT_NAME WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND itc.TABLE_NAME = @tablename
	SET @SQL = @SQL + ')'
	EXEC (@SQL)
END
GO

CREATE OR ALTER PROCEDURE sp_CreateTriggerForTable
	@tablename varchar(255)
AS
BEGIN
	DECLARE @QUERY NVARCHAR(MAX) = 'INSERT INTO HIST_' + @tablename + ' ('
	SELECT @QUERY = @QUERY + COLUMN_NAME + ',' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tablename AND COLUMN_NAME != 'timestamp'
	SET @QUERY = LEFT(@QUERY, LEN(@QUERY) -1) + ')'

	DECLARE @SQL NVARCHAR(MAX) = '
			CREATE OR ALTER TRIGGER TRG_' + @tablename + '_FILLHISTORY
			ON dbo.' + @tablename + '
			AFTER INSERT, UPDATE, DELETE
			AS
			BEGIN
				SET NOCOUNT ON;
				IF EXISTS(SELECT 1 FROM DELETED)
				BEGIN
					IF EXISTS(SELECT 1 FROM INSERTED) ' + @QUERY + ' SELECT * FROM Inserted
					ELSE ' + @QUERY + ' SELECT * FROM Deleted
				END
				ELSE
				' + @QUERY + ' SELECT * FROM Inserted
			END'
	EXEC (@SQL)
END
GO

CREATE OR ALTER PROCEDURE sp_CreateHistory
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX) = ''
	DECLARE @rowAmount INT;
	DECLARE @cursor INT = 0;
	DECLARE @tableName VARCHAR(255);
	--get total amount of tables excluding History tables
	SELECT @rowAmount = COUNT(TABLE_NAME) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE' AND NOT TABLE_NAME LIKE 'HIST_%'
	WHILE @cursor < @rowAmount
	BEGIN
		-- loop through all the tables
		SELECT @tableName = TABLE_NAME
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE' AND NOT TABLE_NAME LIKE 'HIST_%'
		ORDER BY TABLE_NAME
		OFFSET @cursor ROWS
		FETCH NEXT 1 ROWS only

		-- run 2 stored procedures for every table in the database
		EXEC sp_CreateHistoryTable @tableName
		EXEC sp_CreateTriggerForTable @tableName
		SET @cursor = @cursor + 1
	 END
END
GO

EXEC sp_CreateHistory


/*
testing for code generation
*/
INSERT INTO HIST_emp (empno, ename, job,born,hired,sgrade,msal,username, deptno) SELECT * FROM emp
SELECT * FROM emp
SELECT * FROM HIST_emp
DELETE FROM emp WHERE empno = 1664
INSERT INTO emp VALUES(1664, 'Freek', 'ADMIN', '2001-09-11', '2019-09-12', 2, 2400,'qwerty',10)
