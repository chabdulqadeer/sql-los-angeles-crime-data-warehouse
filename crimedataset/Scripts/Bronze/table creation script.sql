/*
=================================
Drop the table if it already exists and create a new one with the specified schema.
There are 28 columns in the table, including various data types such as int, nvarchar, varchar, and float.
Author : Abdul Qadeer
*/
create or alter procedure bronze.table_creation as
begin
    begin try
       
            IF OBJECT_ID('bronze.crimedata', 'U') IS NOT NULL -- Check if the table exists
            BEGIN
                 PRINT 'Table already exists. Dropping the existing table...';
                 DROP TABLE bronze.crimedata; -- Drop the existing table if it exists
             END
             ELSE
             BEGIN
                 PRINT 'Table does not exist. Creating a new table...'; -- If the table does not exist, proceed to create it
             END;
             create table bronze.crimedata ( -- Create the new table with the specified schema
                        DR_NO int,
                        Date_Rptd varchar(50),
                        DATE_OCC varchar(50),
                        TIME_OCC varchar(50),
                        AREA int,
                        AREA_NAME nvarchar(50),
                        Rpt_Dist_No int,
                        Part int,
                        Crm_Cd int,
                        Crm_Cd_Desc nvarchar(max),
                        Mocodes nvarchar(max),
                        Vict_Age int,
                        Vict_Sex varchar(10),
                        Vict_Descent nvarchar(50),
                        Premis_Cd int,
                        Premis_Desc nvarchar(max),
                        Weapon_Used_Cd int,
                        Weapon_Desc nvarchar(max),
                        Status nvarchar(50),
                        Status_Desc nvarchar(max),
                        Crm_Cd_1 int,
                        Crm_Cd_2 int,
                        Crm_Cd_3 int,
                        Crm_Cd_4 int,
                        LOCATION nvarchar(100),
                        Cross_Street varchar(50),
                        LAT float,
                        LON float
                        );
    end try
    begin catch -- ERROR HANDLING
    print 'Error has been occured!';
    print 'Error Message : ' + error_message();
    print 'Error Line : ' + error_line();
    end catch
end
;
