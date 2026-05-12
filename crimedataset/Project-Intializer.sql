/*
===========================
Creating Database & Schema
===========================

In the script, We'll create database 'crimedatabase' and three schema: 'bronze,silver,gold'
*/

-- Drop the database 'datawarehouse' if it exist
IF EXISTS (SELECT 1 FROM SYS.DATABASES WHERE NAME = 'crimedatabase')
BEGIN
	ALTER DATABASE crimedatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE crimedatabase;
END ;

GO

-- create the database
CREATE DATABASE crimedatabase;

GO 
USE crimedatabase;

GO
-- create bronze schema
CREATE SCHEMA bronze;

GO
-- create silver schema
CREATE SCHEMA silver;

GO
-- create gold schema
CREATE SCHEMA gold;
