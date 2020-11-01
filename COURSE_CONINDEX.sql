-- fix for bad stored procedure

BEGIN TRANSACTION;
SAVE TRANSACTION @savepoint;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
----------------------------------------
IF(EXISTS(SELECT 1 FROM emp e left join term t on t.empno=e.empno WHERE e.empno = @empno and isnull(t.leftcomp,'1753-1-1') < e.hired AND JOB = 'ADMIN')
			AND (SELECT COUNT(e.empno) FROM emp e left join term t on e.empno = t.empno WHERE deptno = (SELECT deptno FROM emp WHERE empno = @empno) AND job = 'ADMIN' and isnull(t.leftcomp,'1753-1-1') < e.hired GROUP BY deptno)<2
			AND EXISTS (SELECT 1 FROM emp e left join term t on e.empno = t.empno WHERE deptno = (SELECT deptno FROM emp WHERE empno = @empno) AND (job = 'MANAGER' OR job='PRESIDENT') and isnull(t.leftcomp,'1753-1-1') < e.hired))
		BEGIN
			;THROW 50000, 'Every department that employs a manager or president must have at least one administrator', 1
		END
		IF(EXISTS(SELECT 1 FROM term where empno = @empno))
		BEGIN
			UPDATE term set empno = @empno, leftcomp = getdate(), comment = @comment
		END
		ELSE
		BEGIN
			INSERT INTO term values(@empno,getdate(),@comment)
		END
----------------------------------------
COMMIT TRANSACTION;


-- index 1
BEGIN TRAN
DBBC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
EXEC SP_InsertEmployee 1664, Jaap, 'ADMIN', '2001-09-11', '2019-09-12', 2,2400,'MO324',10
ROLLBACK TRAN


CREATE NONCLUSTERED INDEX IX_EMP_DEPTNO_JOB_HIRED
ON EMP (DEPTNO,JOB,HIRED)

-- index 2
BEGIN TRAN
DBBC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
INSERT INTO OFFR VALUES
('AM4DP','1997-10-06','CONF',6,1017,'SAN FRANCISCO')
ROLLBACK TRAN

CREATE NONCLUSTERED INDEX IX_OFFR_TRAINER
ON OFFR (TRAINER)
