-- ===================================================================
-- SQL Server DDL script:   am4dp_create.sql
--                    Creates the COURSE schema
--Based on example database AM4DP
--described in Applied Mathematics for Database Professionals (published by Apress, 2007)
--written by Toon Koppelaars and Lex de Haan

use COURSE;

-- Een salarisschaal specificeert salarisinterval van minimaal 500 euro.
-- De ondergrens waarde van een salarisschaal (llimit) identificeert de schaal in kwestie.
-- Oefeningen studenten eind week 1

 -- attribute constraints:
alter table grd add constraint  grd_chk_grad  check (grade  > 0);
alter table grd add constraint  grd_chk_llim  check (llimit > 0);
alter table grd add constraint  grd_chk_ulim  check (ulimit > 0);
alter table grd add constraint  grd_chk_bon1  check (bonus  > 0);

 -- tuple constraints:

alter table grd add constraint  grd_chk_bon2  check (bonus < llimit);
  --table constraints:
alter table grd add constraint  grd_pk        primary key (grade);
alter table grd add constraint  grd_unq2      unique (ulimit);
  -- attribute constraints: --
alter table emp add constraint  emp_chk_empno check (empno > 999);
alter table emp add constraint  emp_chk_job   check (job in ('PRESIDENT'
                                         ,'MANAGER'
                                         ,'SALESREP'
                                         ,'TRAINER'
                                         ,'ADMIN'  ));
alter table emp add constraint  emp_chk_brn    check (cast(born as date) = born);
alter table emp add constraint  emp_chk_hrd   check (cast(hired as date) = hired);
alter table emp add constraint  emp_chk_msal   check (msal > 0);
alter table emp add constraint  emp_chk_usrnm  check(upper(username) = username);
  -- tuple constraints:
  -- table constraints:
alter table emp add constraint  emp_pk        primary key (empno);
alter table emp add constraint  emp_unq1      unique (username);
  -- attribute constraints:
alter table srep add constraint  srp_chk_empno check (empno > 999);
alter table srep add constraint  srp_chk_targ  check (target > 9999);
alter table srep add constraint  srp_chk_comm  check (comm > 0);
  -- table constraints:
alter table srep add constraint  srp_pk        primary key (empno);
  -- attribute constraints:
alter table memp add constraint  mmp_chk_empno check (empno > 999);
alter table memp add constraint  mmp_chk_mgr   check (mgr > 999);
  -- tuple constraints:
alter table memp add constraint  mmp_chk_cycl  check (empno <> mgr);
  -- table constraints:
alter table memp add constraint  mmp_pk        primary key (empno);
  -- attribute constraints:
alter table term add constraint  trm_chk_empno check (empno > 999);
alter table term add constraint  trm_chk_lft   check (cast(leftcomp as date) = leftcomp);
  -- tuple constraints:
  -- table constraints:
alter table term add constraint  trm_pk        primary key (empno);
  -- attribute constraints:
alter table dept add constraint  dep_chk_dno   check (deptno > 0);
alter table dept add constraint  dep_chk_dnm   check (upper(dname) = dname);
alter table dept add constraint  dep_chk_loc   check (upper(loc) = loc);
alter table dept add constraint  dep_chk_mgr   check (mgr > 999);
  -- tuple constraints:
  -- table constraints:
alter table dept add constraint  dep_pk        primary key (deptno);
alter table dept add constraint  dep_unq1      unique (dname,loc);
  -- attribute constraints:
alter table crs add constraint  reg_chk_code  check (code = upper(code));
alter table crs add constraint  reg_chk_cat   check (cat in ('GEN','BLD','DSG'));
alter table crs add constraint  reg_chk_dur1  check (dur between 1 and 15);
  -- tuple constraints:
alter table crs add constraint  reg_chk_dur2  check (cat <> 'BLD' OR dur <= 5);
  -- table constraints:
alter table crs add constraint  crs_pk        primary key (code);


-- Een cursus uitvoering (tabel OFFR) heeft altijd een trainer tenzij de status waarde
-- aangeeft dat de cursus afgeblazen (status �CANC�) is of dat de cursus gepland is (status �SCHD�).
-- Oefening studenten eind week 1

  -- attribute constraints:
alter table offr add constraint  ofr_chk_crse  check (course = upper(course));
alter table offr add constraint  ofr_chk_strs  check (cast(starts as date) = starts);
alter table offr add constraint  ofr_chk_stat  check (status in ('SCHD','CONF','CANC'));
alter table offr add constraint  ofr_chk_mxcp  check (maxcap between 6 and 99);
  -- tuple constraints:

  -- table constraints:
alter table offr add constraint  ofr_pk        primary key (course,starts);
  -- attribute constraints:
alter table reg add constraint  reg_chk_stud  check (stud > 999);
alter table reg add constraint  reg_chk_crse  check (course = upper(course));
alter table reg add constraint  reg_chk_strs  check (cast(starts as date) = starts);
alter table reg add constraint  reg_chk_eval  check (eval between -1 and 5);
  -- tuple constraints:
  -- table constraints:
alter table reg add constraint  reg_pk        primary key (stud,starts);
  -- attribute constraints:
alter table hist add constraint  hst_chk_eno   check (empno > 999);
alter table hist add constraint  hst_chk_unt   check (cast(until as date) = until);
alter table hist add constraint  hst_chk_dno   check (deptno > 0);
alter table hist add constraint  hst_chk_msal  check (msal > 0);
  -- tuple constraints:
  -- table constraints:
alter table hist add constraint  hst_pk        primary key (empno,until);
 -- database constraints:
alter table emp add constraint  emp_fk_grd    foreign key (sgrade)
                            references grd(grade)
                            ON UPDATE CASCADE
                            ON DELETE NO ACTION;

alter table emp add constraint  emp_fk_dep foreign key (deptno)
										        references dept(deptno)
                            ON UPDATE NO ACTION
                            ON DELETE NO ACTION;

 -- database constraints:
alter table srep add constraint  srp_fk_emp    foreign key (empno)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE CASCADE;
 -- database constraints:
alter table memp add constraint  mmp_fk1_emp   foreign key (empno)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE NO ACTION;

alter table memp add constraint  mmp_fk2_emp   foreign key (mgr)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE NO ACTION;
 -- database constraints:
alter table term add constraint  trm_fk_emp    foreign key (empno)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE CASCADE;

alter table dept add constraint  dep_fk_emp    foreign key (mgr)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE NO ACTION;

 -- database constraints:
alter table offr add constraint  ofr_fk_crs    foreign key (course)
                            references crs(code)
                            ON UPDATE CASCADE
                            ON DELETE NO ACTION;

alter table offr add  constraint  ofr_fk_emp    foreign key (trainer)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE SET NULL;

 -- database constraints:
alter table reg add constraint  reg_fk_emp    foreign key (stud)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE CASCADE;

alter table reg add constraint  reg_fk_ofr    foreign key (course,starts)
                            references offr(course,starts)
                            ON UPDATE NO ACTION
                            ON DELETE NO ACTION;

 -- database constraints:
alter table hist add constraint  hst_fk_emp    foreign key (empno)
                            references emp(empno)
                            ON UPDATE NO ACTION
                            ON DELETE NO ACTION;

alter table hist add constraint  hst_fk_dep    foreign key (deptno)
                            references dept(deptno)
                            ON UPDATE NO ACTION
                            ON DELETE CASCADE;


/*
1.	A department that employs the president or a manager should also employ at least one administrator.
2.	The company hires adult personnel only.
3.	The llimit of a salary grade must be higher than the llimit of the next lower salary grade. The ulimit of the salary grade must be higher than the ulimit of the next lower salary grade. Note; the numbering of grades can contain holes.
4.	The start date and known trainer uniquely identify course offerings.
Note: the constraint ‘ofr_unq’ is too strict, this does not allow multiple unknown trainers on the same start date, this unique constraint should therefore be dropped. Create a new constraint to implement the constraint, the use of a filtered index is not allowed.
5.	At least half of the course offerings (measured by duration) taught by a trainer must be ‘home based’. Note: ‘Home based’ means the course is offered at the same location where the employee is employed.
6.	You are allowed to teach a course only if:
your job type is trainer and
-      you have been employed for at least one year
-	or you have attended the course yourself (as participant)
*/

/*
Implement the constraints
Use the following plan of approach
1.	Include in your report the original definition of the constraint,
2.	Describe which tables and columns are involved in this constraint
3.	Describe for which actions (I/U/D) this constraint should be validated
4.	Define how to implement the constraint using a check constraint, a trigger of a stored procedure or a combination.
The following order is preferred;
-	if it can be implemented as a declarative constraint do so, if not
-	if it can be implemented with a check constraint do so, if not
-	if it can be implemented with a trigger do so, if not
-	implement it with a stored procedure (and disallow direct access to the involving tables!)
-	Of course a combination of these is also an option.

*/

/* 1. A department that employs the president or a manager should also employ at least one administrator */
# need trigger when president or a manager gets added.

GO
DROP TRIGGER IF EXISTS DepartmentAdministratorPresident
GO
CREATE TRIGGER DepartmentAdministratorPresident
ON emp --mogelijk ook nog dept table checken op veranderingen
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
IF @@ROWCOUNT=0
    RETURN
SET NOCOUNT ON
BEGIN TRY
	-- make special construction
	--IF INSERT() if no manager or president is inserted

	-- make special construction for delete
	--IF DELETE() if no admin is deleted

    --IF UPDATE(deptno) OR UPDATE(job) -- need to make this smarter
    BEGIN
		IF EXISTS(
			SELECT d.deptno as departments FROM emp e right join dept d on e.deptno = d.deptno WHERE job = 'MANAGER' OR job = 'PRESIDENT' GROUP BY d.deptno
			EXCEPT
			SELECT d.deptno as departments FROM emp e right join dept d on e.deptno = d.deptno WHERE job = 'ADMIN' GROUP BY d.deptno
		)
		BEGIN
		;THROW 50000,'Every department that employs a manager or president must have atleast one administrator',1
		END
    END
END TRY
BEGIN CATCH
  ;THROW
END CATCH
END

-- 3 stored procedures to insert,update and delete employees

CREATE OR ALTER PROCEDURE SP_InsertEmployee
@empno numeric(4), @ename varchar(8),
@job varchar(9), @born date,
@hired date, @sgrade numeric(2),
@msal numeric(7,2), @username varchar(15),
@deptno numeric(2)
AS
BEGIN
	DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3)); --= truc
	DECLARE @startTrancount int = @@TRANCOUNT;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		SAVE TRANSACTION @savepoint;
		----------------------------------------
    IF (@job = 'MANAGER' OR @job ='PRESIDENT') AND NOT EXISTS(SELECT 1 FROM emp WHERE deptno = @deptno AND job = 'ADMIN')
    BEGIN
        ;THROW 50000, 'Every department that employs a manager or president must have atleast one administrator', 1
    END
    INSERT INTO emp (empno,ename,job,born,hired,sgrade,msal,username,deptno)
    VALUES(@empno,@ename,@job,@born,@hired,@sgrade,@msal,@username,@deptno)
		----------------------------------------
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() = -1 AND @startTrancount = 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
			IF XACT_STATE() = 1
			BEGIN
				ROLLBACK TRANSACTION @savepoint;
				COMMIT TRANSACTION;
			END;
		END;
		DECLARE @errormessage varchar(2000);
		SET @errormessage = 'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() + '''';
		THROW 50000, @errormessage, 1;
	END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE SP_UpdateEmployee
@empno numeric(4), @ename varchar(8),
@job varchar(9), @born date,
@hired date, @sgrade numeric(2),
@msal numeric(7,2), @username varchar(15),
@deptno numeric(2)
AS
BEGIN
	DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3)); --= truc
	DECLARE @startTrancount int = @@TRANCOUNT;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		SAVE TRANSACTION @savepoint;
		----------------------------------------
    IF(@job != 'ADMIN' AND
      (((SELECT job FROM emp WHERE empno = @empno) = 'ADMIN' AND (SELECT COUNT(*) FROM emp WHERE deptno = (SELECT deptno FROM emp WHERE empno = @empno) AND job = 'ADMIN' GROUP BY deptno)<2)
      OR ((@job = 'PRESIDENT' OR @job = 'MANAGER') AND NOT EXISTS(SELECT * FROM emp WHERE job = 'ADMIN' AND deptno = @deptno))))
    BEGIN
      ;THROW 50000, 'Every department that employs a manager or president must have atleast one administrator', 1
    END
    UPDATE emp SET ename = @ename, job = @job, born = @born, hired = @hired, sgrade = @sgrade, msal = @msal, username = @username, deptno = @deptno WHERE empno = @empno
		----------------------------------------
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() = -1 AND @startTrancount = 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
			IF XACT_STATE() = 1
			BEGIN
				ROLLBACK TRANSACTION @savepoint;
				COMMIT TRANSACTION;
			END;
		END;
		DECLARE @errormessage varchar(2000);
		SET @errormessage = 'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() + '''';
		THROW 50000, @errormessage, 1;
	END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE SP_DeleteEmployee
@empno numeric(4)
AS
BEGIN
	DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3)); --= truc
	DECLARE @startTrancount int = @@TRANCOUNT;
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		SAVE TRANSACTION @savepoint;
		----------------------------------------
    IF((SELECT job FROM emp WHERE empno = @empno) = 'ADMIN' AND SELECT COUNT(*) FROM emp WHERE deptno = (SELECT deptno FROM emp WHERE empno = @empno) AND job = 'ADMIN' GROUP BY deptno)<2)
        BEGIN
            ;THROW 50000, 'Every department that employs a manager or president must have atleast one administrator', 1
        END
    DELETE FROM emp WHERE empno = @empno
		----------------------------------------
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() = -1 AND @startTrancount = 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
			IF XACT_STATE() = 1
			BEGIN
				ROLLBACK TRANSACTION @savepoint;
				COMMIT TRANSACTION;
			END;
		END;
		DECLARE @errormessage varchar(2000);
		SET @errormessage = 'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() + '''';
		THROW 50000, @errormessage, 1;
	END CATCH;
END;
GO

/* 2. The company hires adult personnel only. */

ALTER TABLE emp ADD CONSTRAINT emp_chk_age CHECK (born <= dateadd(year,(-18), getdate()));

/* 3. The llimit of a salary grade must be higher than the llimit of the next lower salary grade. The ulimit of the salary grade must be higher than the ulimit of the next lower salary grade. Note; the numbering of grades can contain holes. */
GO
DROP TRIGGER IF EXISTS LimitSalaryGradeIncremental
GO
CREATE TRIGGER LimitSalaryGradeIncremental
ON grd
AFTER INSERT, UPDATE
AS
BEGIN
IF @@ROWCOUNT=0
    RETURN
SET NOCOUNT ON
BEGIN TRY
	/*
	make a more advanced version
	IF NOT EXISTS(SELECT * FROM deleted)
	BEGIN
		SELECT grade FROM Inserted
	END
	*/
    IF(UPDATE(llimit) OR UPDATE(ulimit))
		IF EXISTS(SELECT grade, llimit FROM grd g WHERE llimit > (SELECT llimit FROM grd WHERE grade = g.grade + 1))
		OR EXISTS(SELECT grade, ulimit FROM grd g WHERE ulimit > (SELECT ulimit FROM grd WHERE grade = g.grade + 1))
		BEGIN
			;THROW 50000,'Salary must be lower/higher for this salary grade',1
		END
END TRY
BEGIN CATCH
  ;THROW
END CATCH
END
GO

/* 4. The start date and known trainer uniquely identify course offerings. replace the unique key on startdate and trainer Note. no filtered index */
-- need stored procedure to fetch all trainer startdate combinations where trainer IS NOT NULL
alter table offr
drop constraint ofr_unq
GO
DROP TRIGGER IF EXISTS TrainerOnlyOneCoursePerDay
GO
CREATE TRIGGER TrainerOnlyOneCoursePerDay
ON offr
AFTER INSERT, UPDATE
AS
BEGIN
IF @@ROWCOUNT=0
    RETURN
SET NOCOUNT ON
BEGIN TRY
    IF EXISTS(SELECT 1 FROM offr WHERE trainer IS NOT NULL GROUP BY trainer, starts HAVING COUNT(*) > 1)
	BEGIN
    ;THROW 50000,'Person can only give 1 course on a day',1
	END
END TRY
BEGIN CATCH
  ;THROW
END CATCH
END


/* 5. At least half of the course offerings (measured by duration) taught by a trainer must be ‘home based’. Note: ‘Home based’ means the course is offered at the same location where the employee is employed. */
GO
DROP TRIGGER IF EXISTS TrainerTeachesFromHome
GO
CREATE TRIGGER TrainerTeachesFromHome
ON offr
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
IF @@ROWCOUNT=0
    RETURN
SET NOCOUNT ON
BEGIN TRY
    IF EXISTS(SELECT trainer,SUM(dur) FROM offr o join crs c on o.course = c.code
			GROUP BY trainer HAVING SUM(dur)/2 >
			(SELECT SUM(dur) FROM crs join offr on offr.course = crs.code join emp on offr.trainer = emp.empno join dept on emp.deptno = dept.deptno
			WHERE offr.trainer = o.trainer AND offr.loc = dept.loc))
	BEGIN
		;THROW 50000,'Teacher needs to teach atleast 50 percent of his time at home office',1
	END
END TRY
BEGIN CATCH
  ;THROW
END CATCH
END


/* 6. You are allowed to teach a course only if:
your job type is trainer and
-      you have been employed for at least one year
-	or you have attended the course yourself (as participant) */
GO
DROP TRIGGER IF EXISTS TrainerQualified
GO
CREATE TRIGGER TrainerQualified
ON offr
AFTER INSERT, UPDATE
AS
BEGIN
IF @@ROWCOUNT=0
    RETURN
SET NOCOUNT ON
BEGIN TRY
	IF EXISTS(SELECT trainer FROM offr join emp on trainer = empno WHERE job != 'TRAINER')
	OR EXISTS (SELECT trainer FROM offr join emp on trainer = empno WHERE DATEDIFF(year, hired, GETDATE()) < 1
					AND NOT EXISTS(SELECT 1 FROM reg WHERE stud = trainer AND reg.course = offr.course))
	BEGIN
		;THROW 50000,'Person needs to attend the course or be employed for 1 year as a teacher to teach a course',1
	END
END TRY
BEGIN CATCH
  ;THROW
END CATCH
END
