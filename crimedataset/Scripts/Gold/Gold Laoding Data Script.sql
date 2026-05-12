/*
This stored procedure is responsible for creating and populating the Gold.CrimeData table.
It performs the following steps:
1. Truncates the existing data in the Gold.CrimeData table.
2. Inserts data from the Silver.CrimeData table into the Gold.CrimeData table.
3. Logs the start and end times of each process and the total time taken.
*/
create or alter procedure Gold.Table_Creation as
begin
	declare @starttime datetime,
			@endtime datetime,
			@batchstarttime datetime,
			@batchendtime datetime;
	 begin try
		set @starttime = getdate();
		set @batchstarttime = getdate();
		 print '=============================================';
		 print 'Truncating Process Started at: ' + convert(varchar, @starttime, 120);
		 print '=============================================';
		-- Check if the gold table already exists
		-- Truncate the gold table to remove existing data
		print '=============================================';
		print 'Truncating Gold Crimedata Table...';
		print '=============================================';
		set @endtime = getdate();
		print 'Truncating Process Ended at: ' + convert(varchar, @endtime, 120);
		print 'Total Time Taken for Truncating: ' + convert(varchar, datediff(second, @starttime, @endtime)) + ' seconds';
		set @starttime = getdate();
		print '=============================================';
		print 'Inserting Process Started at: ' + convert(varchar, @starttime, 120);
		print '=============================================';
		-- Inserting data from silver to gold table
		print '=============================================';
		print 'Inserting data from Silver to Gold...';
		print '=============================================';
		insert into gold.crimedata (
		DR_NO,
		Reported_Date,
		Occorance_Date,
		Occorance_Time,
		AREA,
		AREA_NAME,
		Rpt_Dist_No,
		Part,
		Crime_Code,
		Crime_Code_Description,
		Mocodes,
		Victim_Age,
		Victim_Sex,
		Victim_Descent,
		Premis_Code,
		Premis_Desc,
		Weapon_Used_Code,
		Weapon_Desc,
		Status,
		Status_Desc,
		Crime_Code_1,
		Crime_Code_2,
		Crime_Code_3,
		Crime_Code_4,
		LOCATION,
		Cross_Street,
		LAT,
		LON
		)
		select
		DR_NO,
		Date_Rptd,
		DATE_OCC,
		TIME_OCC,
		AREA,
		AREA_NAME,
		Rpt_Dist_No,
		Part,
		Crm_Cd,
		Crm_Cd_Desc,
		Mocodes,
		Vict_Age,
		Vict_Sex,
		Vict_Descent,
		Premis_Cd,
		Premis_Desc,
		Weapon_Used_Cd,
		Weapon_Desc,
		Status,
		Status_Desc,
		Crm_Cd_1,
		Crm_Cd_2,
		Crm_Cd_3,
		Crm_Cd_4,
		LOCATION,
		Cross_Street,
		LAT,
		LON
		from silver.crimedata;
		print '=============================================';
		print 'Inserting Done...';
		print '=============================================';
		set @endtime = getdate();
		print '=============================================';
		print 'Inserting Process Ended at: ' + convert(varchar, @endtime, 120);
		print 'Total Time Taken for Inserting: ' + convert(varchar, datediff(second, @starttime, @endtime)) + ' seconds';
		print '=============================================';
		set @batchendtime = getdate();
		print '----------------------------------------------'
		print 'Batch Process Ended at: ' + convert(varchar, @batchendtime, 120);
		print 'Total Time Taken for Batch Process: ' + convert(varchar, datediff(second, @batchstarttime, @batchendtime)) + ' seconds';
		print '----------------------------------------------'
	end try
	begin catch
		print 'An error occurred during the table creation process.';
		print 'Error Message: ' + ERROR_MESSAGE();
		print 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(50));
		print 'Batch Process Failed.';
	end catch;
end;
