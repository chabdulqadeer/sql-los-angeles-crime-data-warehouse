/*
====================================================
Truncate & Loading Data into Silver Schemas Tables
====================================================
In silver schema, data load from bronze schema tables and did following operation on it to clean the data.
-- Handling Null Values
-- Remove unwanted spaces
-- Remove duplicates values
-- and other operation which explain at their respective position

*/
-- ========================================
-- Drop the procedure if it already exists
-- ========================================
IF OBJECT_ID('silver_load_crimedata', 'P') IS NOT NULL
    DROP PROCEDURE silver_load_crimedata;
GO
-- ==================================================================
-- create or alter procedure to load data into silver.crimedata table
-- ==================================================================
create or alter procedure silver_load_crimedata as
begin
	declare @starttime datetime, @endtime datetime
	set @starttime = getdate();
	begin try
	    -- ==========================================
		-- Truncating the table silver.crimedata
		-- ==========================================
		PRINT 'Truncating the table silver.crimedata';
		truncate table silver.crimedata;
		PRINT 'Truncating Done';
		-- ==========================================
		/*Load the data from bronze.crimedata and did some cleaning operation on it. 
		Then load into silver.crimedata*/
		PRINT 'Loading Data into silver.crimedata';
		insert into silver.crimedata (
		DR_NO,
		Date_Rptd,
		Date_Occ,
		Time_Occ,
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
		Location,
		Cross_Street,
		LAT,
		LON
		)
		select
		DR_NO,

		try_convert(datetime, Date_Rptd, 120) as Date_Rptd,

		try_convert(datetime, Date_Occ, 120) as Date_Occ,

		format(
			try_convert(
				datetime,
				stuff(right('0000'+ Time_Occ, 4),3,0,':')
			),
		'hh:mm tt') as Time_Occ,

		CONVERT(INT, AREA) as AREA,

		AREA_NAME,
		Rpt_Dist_No,
		Part,
		Crm_Cd,
		Crm_Cd_Desc,

		ISNULL(REPLACE(mocodes, ' ', ','), 'UNKNOWN') as Mocodes,

		VICT_AGE,

		case
			when VICT_SEX = 'M' then 'Male'
			when VICT_SEX = 'F' then 'Female'
			else 'Unknown'
		end as VICT_SEX,

		case
			when Vict_Descent = 'A' then 'Other Asian'
			when Vict_Descent = 'B' then 'Black'
			when Vict_Descent = 'C' then 'Chinese'
			when Vict_Descent = 'H' then 'Hispanic'
			when Vict_Descent = 'I' then 'American Indian or Alaska Native'
			when Vict_Descent = 'J' then 'Japanese'
			when Vict_Descent = 'K' then 'Korean'
			when Vict_Descent = 'O' then 'Other'
			when Vict_Descent = 'P' then 'Pacific Islander'
			when Vict_Descent = 'U' then 'Unknown'
			when Vict_Descent = 'V' then 'Vietnamese'
			when Vict_Descent = 'W' then 'White'
			else 'Unknown'
		end as VICT_DESENT,

		coalesce(Premis_Cd ,0) as Premis_Cd,
		coalesce(Premis_Desc, 'Unknown') as Premis_Desc,

		coalesce(Weapon_Used_Cd,0) as Weapon_Used_Cd,
		coalesce(Weapon_Desc,'No Weapon Used') as Weapon_Desc,

		coalesce([status],'Unknown') as [status],

		Status_Desc,

		case
			when Crm_Cd != Crm_Cd_1 then Crm_Cd
			else Crm_Cd_1
		end as Crm_Cd_1,

		Coalesce(Crm_Cd_2, 0) as Crm_Cd_2,
		Coalesce(Crm_Cd_3, 0) as Crm_Cd_3,
		Coalesce(Crm_Cd_4, 0) as Crm_Cd_4,

		coalesce(loc.Clean_Location, 'Unknown') as Location,
		coalesce(cs.Clean_Cross_Street, 'Unknown') as Cross_Street,
		LAT,
		LON

		from bronze.crimedata c

		CROSS APPLY (
			SELECT STRING_AGG(value,' ') AS Clean_Location
			FROM STRING_SPLIT(TRIM(c.Location), ' ')
			WHERE value <> ''
		) loc

		CROSS APPLY (
			SELECT STRING_AGG(value,' ') AS Clean_Cross_Street
			FROM STRING_SPLIT(TRIM(c.Cross_Street), ' ')
			WHERE value <> ''
		) cs
		print 'Loading Done'
		END TRY
		begin catch
			print 'Error Occured while loading data into silver.crimedata';
			print 'Error Message: ' + ERROR_MESSAGE();
			print 'Error Line: ' + cast(ERROR_LINE() as nvarchar);
			print 'Error Severity: ' + cast(ERROR_SEVERITY() as nvarchar);
			print 'Error State: ' + cast(ERROR_STATE() as nvarchar);
			 -- Optionally, you can log the error details into an error logging table for further analysis
		END CATCH
		set @endtime = getdate()
		print '========================================='
		print 'Total Loading Time : ' + cast(Datediff(second,@starttime, @endtime) as nvarchar) + ' seconds';
		print '========================================='
	end
;
