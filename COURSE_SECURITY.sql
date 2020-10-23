/*------------------------------------------------------------------------------------------------
F - SECURITY
------------------------------------------------------------------------------------------------*/


-- create employee user
GO
CREATE LOGIN [Employee] WITH PASSWORD=N'klootviool', DEFAULT_DATABASE=[COURSE]
CREATE USER [Employee] FOR LOGIN [Employee]
-- make this a role instead?


-- give permission for data
GRANT EXECUTE ON dbo.reg TO Employee
GRANT SELECT ON dbo.emp TO Employee
GRANT SELECT ON dbo.offr TO Employee


-- create reporting user
CREATE LOGIN [Reporting] WITH PASSWORD=N'kutverslag', DEFAULT_DATABASE=[COURSE]
CREATE USER [Reporting] FOR LOGIN [Reporting]

GRANT SELECT ON SCHEMA :: [dbo] TO Reporting


-- testen van security policy

-- test empolyee account
EXECUTE AS USER = 'Employee'

-- test full access Reg table

-- test read access emp & offr table



-- test reporting account
EXECUTE AS USER = 'Reporting'

INSERT INTO dbo.grd VALUES(12,12000,17000,6000)
