/*
This stored procedure is responsible for creating the Gold.CrimeData table.
It performs the following steps:
1. Checks if the Gold.CrimeData table exists.
2. Drops the existing table if it exists.
3. Creates a new Gold.CrimeData table with the specified schema.
4. Logs the start and end times of each process and the total time taken.
*/
create or alter procedure Gold_Table_Creation as
begin
     begin try
        IF OBJECT_ID('gold.crimedata', 'U') IS NOT NULL -- Check if the table exists
           BEGIN
              PRINT 'Table already exists. Dropping the existing table...';
              DROP TABLE gold.crimedata; -- Drop the existing table if it exists
            END
            ELSE
            BEGIN
            PRINT 'Table does not exist. Creating a new table...'; -- If the table does not exist, proceed to create it
            END;
        Print 'Creating the table...'; -- Print a message indicating that the table is being created
        create table  gold.crimedata ( -- Create the new table with the specified schema
            DR_NO int,
            Reported_Date datetime,
            Occorance_Date datetime,
            Occorance_Time datetime,
            AREA int,
            AREA_NAME nvarchar(50),
            Rpt_Dist_No int,
            Part int,
            Crime_Code int,
            Crime_Code_Description nvarchar(max),
            Mocodes nvarchar(max),
            Victim_Age int,
            Victim_Sex varchar(10),
            Victim_Descent nvarchar(50),
            Premis_Code int,
            Premis_Desc nvarchar(max),
            Weapon_Used_Code int,
            Weapon_Desc nvarchar(max),
            Status nvarchar(50),
            Status_Desc nvarchar(max),
            Crime_Code_1 int,
            Crime_Code_2 int,
            Crime_Code_3 int,
            Crime_Code_4 int,
            LOCATION nvarchar(100),
            Cross_Street varchar(50),
            LAT float,
            LON float
            );
        PRINT 'Table created successfully.'; -- Print a message indicating that the table was created successfully
        end try
        begin catch -- ERROR HANDLING
             PRINT 'An error occurred while creating the table.';
             PRINT 'Error Message: ' + ERROR_MESSAGE();
             Print 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(50));
        end catch
end;
