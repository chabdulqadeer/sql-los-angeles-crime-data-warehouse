/*
Here are 50+ SQL queries to analyze the crime dataset in the gold layer. These queries cover various aspects of crime data analysis, including total crime counts, trends over time, distribution by various factors (age, gender, location, time, etc.), and more.
Make sure to adjust the queries based on the actual column names and data types in your gold layer if they differ from the provided schema.
*/
-- Q1 : How many total crimes are recorded in the dataset?
select count(*)
from gold.crimedata;

-- Answer : 2009788

--Q2 : How many crimes occurred each year?
select 
	year(Reported_date),
	Count(*) as [Number of Cases]
from Gold.crimedata
group by year(Reported_date)
order by [Number of Cases] desc;

-- Q3 : How many crimes occurred each month?
select 
	year(Reported_date)as Year,
	month(Reported_date) as Month,
	Count(*) as [Number of Cases]
from Gold.crimedata
group by year(Reported_date), month(Reported_date)
order by [Number of Cases] desc;

-- Q4 : What are the top 10 most common crime types?
select
	Crime_Code,
	Crime_Code_Description,
	count(*) as [Number of Cases]
from gold.crimedata
group by Crime_Code, Crime_Code_Description
order by [Number of Cases] desc
;

-- Q5 : Which areas have the highest crime rates?
select 
	AREA,
	AREA_NAME,
	count(*) as [Number of Cases]
from gold.crimedata
group by AREA, AREA_NAME
order by [Number of Cases] desc
;

-- Q6 : What is the distribution of crimes by time of day?
select 
	datepart(hour, Occorance_Time) as Hour,
	count(*) as [Number of Cases]
from gold.crimedata
group by datepart(hour, Occorance_Time)
order by [Number of Cases] desc
;

-- Q7 : What is the distribution of crimes by day of the week?
select 
	datename(WEEKDAY, Reported_date) as DayOfWeek,
	count(*) as [Number of Cases]
from gold.crimedata
group by datename(WEEKDAY, Reported_date)
order by [Number of Cases] desc
;

-- Q8 : What is the distribution of crimes by month of the year?
select 
	datename(MONTH, Reported_date) as Month,
	count(*) as [Number of Cases]
from gold.crimedata
group by datename(MONTH, Reported_date)
order by [Number of Cases] desc
;

-- Q9 : What is the distribution of crimes by victim age group?
select 
	Vict_Group,
	count(*) as [Number of Cases]
from silver.dim_victim_view
group by Vict_Group
order by [Number of Cases] desc
;

-- Q10 : What is the distribution of crimes by victim gender?
select
	Victim_Sex,
	count(*) as [Number of Cases]
from gold.crimedata
group by Victim_Sex
order by [Number of Cases] desc
;

-- Q11 : What are the top 10 most frequently used weapons?
select top 10
	Weapon_Used_Code,
	Weapon_Desc,
	count(*) as [Number of Cases]
from gold.crimedata
group by Weapon_Used_Code, Weapon_Desc
having Weapon_Used_Code > 1
order by [Number of Cases] desc
;

-- Q12 : How many crimes involved a weapon?
select
	count(*) as [Number of Cases],
	CASE 
		WHEN Weapon_Used_Code > 1 THEN 'Yes'
		ELSE 'No'
	END as Weapon_Involved
from gold.crimedata
group by CASE 
		WHEN Weapon_Used_Code > 1 THEN 'Yes'
		ELSE 'No'
	END
order by [Number of Cases] desc
;

-- Q13 : Which premises (street, residence, parking lot, etc.) have the most crimes?
select 
	Premis_Code,
	Premis_Desc,
	count(*) as [Number of Cases]
from gold.crimedata
group by Premis_Code, Premis_Desc
order by [Number of Cases] desc
;

-- Q14 : At what hour of the day do most crimes occur?
select
	datepart(hour, Occorance_Time) as Hour,
	count(*) as [Number of Cases]
from gold.crimedata
group by datepart(hour, Occorance_Time)
order by [Number of Cases] desc
;

-- Q15 : Which weekday has the highest number of crimes?

Select 
	datename(WEEKDAY, Reported_date) as DayOfWeek,
	count(*) as [Number of Cases]
from gold.crimedata
group by datename(WEEKDAY, Reported_date)
order by [Number of Cases] desc
;

/* Q16 : How many crimes occur during:
			Morning
			Afternoon
			Evening
			Night
*/

select 
	CASE 
		WHEN datepart(hour, Occorance_Time) >= 6 AND datepart(hour, Occorance_Time) < 12 THEN 'Morning'
		WHEN datepart(hour, Occorance_Time) >= 12 AND datepart(hour, Occorance_Time) < 18 THEN 'Afternoon'
		WHEN datepart(hour, Occorance_Time) >= 18 AND datepart(hour, Occorance_Time) < 24 THEN 'Evening'
		ELSE 'Night'
	END as TimeOfDay,
	count(*) as [Number of Cases]
from gold.crimedata
group by CASE 
		WHEN datepart(hour, Occorance_Time) >= 6 AND datepart(hour, Occorance_Time) < 12 THEN 'Morning'
		WHEN datepart(hour, Occorance_Time) >= 12 AND datepart(hour, Occorance_Time) < 18 THEN 'Afternoon'
		WHEN datepart(hour, Occorance_Time) >= 18 AND datepart(hour, Occorance_Time) < 24 THEN 'Evening'
		ELSE 'Night'
	END
order by [Number of Cases] desc
;

-- Q17 : Find the yearly crime growth percentage?

with YearlyCrimeCount as (
	select 
		year(Reported_date) as Year,
		count(*) as CrimeCount
	from gold.crimedata
	group by year(Reported_date)
)
select 
	Year,
	CrimeCount,
	LEAD(CrimeCount) OVER (ORDER BY Year) as NextYearCrimeCount,
	CASE 
		WHEN LEAD(CrimeCount) OVER (ORDER BY Year) IS NULL THEN NULL
		ELSE (LEAD(CrimeCount) OVER (ORDER BY Year) - CrimeCount) * 100.0 / CrimeCount
	END as GrowthPercentage
from YearlyCrimeCount
order by Year
;

-- Q18 : Find the month-over-month crime growth.

select 
	year(Reported_date) as Year,
	month(Reported_date) as Month,
	count(*) as CrimeCount,
	LEAD(count(*)) OVER (ORDER BY year(Reported_date), month(Reported_date)) as NextMonthCrimeCount,
	CASE 
		WHEN LEAD(count(*)) OVER (ORDER BY year(Reported_date), month(Reported_date)) IS NULL THEN NULL
		ELSE cast(round((LEAD(count(*)) OVER (ORDER BY year(Reported_date), month(Reported_date)) - count(*)) * 100.0 / count(*), 2) as decimal(5,2))
	END as GrowthPercentage
from gold.crimedata
group by year(Reported_date), month(Reported_date)
order by Year, Month
;

-- Q19 : Which area has the highest number of violent crimes?

select 
	AREA,
	AREA_NAME,
	count(*) as [Number of Violent Crimes]
from gold.crimedata
group by AREA, AREA_NAME
order by [Number of Violent Crimes] desc
;

-- Q20 : Which areas have the highest firearm-related crimes?
select 
	AREA,
	AREA_NAME,
	count(*) as [Number of Firearm-Related Crimes]
from gold.crimedata
where Weapon_Desc like '%FIREARM%'
group by AREA, AREA_NAME
order by [Number of Firearm-Related Crimes] desc
;

-- Q21 : Find the most common crime type in each area.
select
	AREA,
	AREA_NAME,
	Crime_Code,
	Crime_Code_Description,
	count(*) as [Number of Cases]
from gold.crimedata
group by AREA, AREA_NAME, Crime_Code, Crime_Code_Description
order by AREA, AREA_NAME, [Number of Cases] desc;

-- Q22 : Which premise types are most dangerous at night?
select 
	Premis_Code,
	Premis_Desc,
	count(*) as [Number of Cases]
from gold.crimedata
where datepart(hour, Occorance_Time) >= 18 or datepart(hour, Occorance_Time) < 6
group by Premis_Code, Premis_Desc
order by [Number of Cases] desc
;

-- Q23 : Find areas where vehicle theft is most common.

select 
	AREA,
	AREA_NAME,
	count(*) as [Number of Vehicle Thefts]
from gold.crimedata
where Crime_Code_Description like 'VEHICLE%' and Crime_Code = 510
group by AREA, AREA_NAME
order by [Number of Vehicle Thefts] desc
;

-- Q24 : Which age group suffers the most crimes?

select 
	Vict_Group,
	count(*) as [Number of Cases]
from silver.dim_victim_view
group by Vict_Group
order by [Number of Cases] desc
;

-- Q25 : Which crime type affects females the most?

select
	Crime_Code,
	Crime_Code_Description,
	count(*) as [Number of Cases]
from gold.crimedata
where Victim_Sex = 'Female'
group by Crime_Code, Crime_Code_Description
order by [Number of Cases] desc
;

-- Q26 : Which crime type affects males the most?

select
	Crime_Code,
	Crime_Code_Description,
	count(*) as [Number of Cases]
from gold.crimedata
where Victim_Sex = 'Male'
group by Crime_Code, Crime_Code_Description
order by [Number of Cases] desc
;

-- Q27 : Which descent category has the highest victim count?

select 
	Victim_Descent,
	count(*) as [Number of Cases]
from gold.crimedata
group by Victim_Descent
order by [Number of Cases] desc
;

-- Q28 : Find the most common weapon used against each gender.

select
	Victim_Sex,
	Weapon_Used_Code,
	Weapon_Desc,
	count(*) as [Number of Cases]
from gold.crimedata
group by Victim_Sex, Weapon_Used_Code, Weapon_Desc
order by Victim_Sex, [Number of Cases] desc
;

-- Q29 : Which age group is most targeted during nighttime?

select 
	Vict_Group,
	count(*) as [Number of Cases]
from silver.dim_victim_view vv
left join gold.crimedata gc on vv.DR_NO = gc.DR_NO
where datepart(hour, Occorance_Time) >= 18 or datepart(hour, Occorance_Time) < 6
group by Vict_Group
order by [Number of Cases] desc
;

-- Q30 : Find the top 3 crime types in each area.


with AreaCrimeRank as (
	select
		AREA,
		AREA_NAME,
		Crime_Code,
		Crime_Code_Description,
		count(*) as [Number of Cases],
		RANK() OVER (PARTITION BY AREA ORDER BY count(*) desc) as CrimeRank
	from gold.crimedata
	group by AREA, AREA_NAME, Crime_Code, Crime_Code_Description
)select 
	AREA,
	AREA_NAME,
	Crime_Code,
	Crime_Code_Description,
	[Number of Cases]
	from AreaCrimeRank
	where CrimeRank <= 3
	;

-- Q31 : Find the top crime type for every year.


with YearlyCrimeRank as (
	select
		year(Reported_date) as Year,
		Crime_Code,
		Crime_Code_Description,
		count(*) as [Number of Cases],
		RANK() OVER (PARTITION BY year(Reported_date) ORDER BY count(*) desc) as CrimeRank
	from gold.crimedata
	group by year(Reported_date), Crime_Code, Crime_Code_Description
	)select
	Year,
	Crime_Code,
	Crime_Code_Description,
	[Number of Cases],
	CrimeRank
from YearlyCrimeRank
where CrimeRank = 1
;

-- Q32 : Which crimes are increasing year by year?

with YearlyCrimeCount as (
	select 
		year(Reported_date) as Year,
		Crime_Code,
		Crime_Code_Description,
		count(*) as CrimeCount
	from gold.crimedata
	group by year(Reported_date), Crime_Code, Crime_Code_Description
)select
	Year,
	Crime_Code,
	Crime_Code_Description,
	CrimeCount,
	LEAD(CrimeCount) OVER (PARTITION BY Crime_Code ORDER BY Year) as NextYearCrimeCount,
	CASE 
		WHEN LEAD(CrimeCount) OVER (PARTITION BY Crime_Code ORDER BY Year) IS NULL THEN NULL
		ELSE round((LEAD(CrimeCount) OVER (PARTITION BY Crime_Code ORDER BY Year) - CrimeCount) * 100.0 / CrimeCount, 2)
	END as GrowthPercentage
	from YearlyCrimeCount
	order by Year, CrimeCount desc
	;

-- Q33 : Find areas where crime decreased compared to previous year.

with AreaYearlyCrimeCount as (
	select 
		AREA,
		AREA_NAME,
		year(Reported_date) as Year,
		count(*) as CrimeCount
	from gold.crimedata
	group by AREA, AREA_NAME, year(Reported_date)
	)select
	AREA,
	AREA_NAME,
	Year,
	CrimeCount,
	LAG(CrimeCount) OVER (PARTITION BY AREA ORDER BY Year) as PreviousYearCrimeCount,
	CAST(ROUND(CASE 
		WHEN LAG(CrimeCount) OVER (PARTITION BY AREA ORDER BY Year) IS NULL THEN NULL
		ELSE (CrimeCount - LAG(CrimeCount) OVER (PARTITION BY AREA ORDER BY Year)) * 100.0 / LAG(CrimeCount) OVER (PARTITION BY AREA ORDER BY Year)
	END, 2) as decimal(5,2)) as GrowthPercentage
	from AreaYearlyCrimeCount
	ORDER BY AREA, Year, CrimeCount desc
	;

-- Q34 : Find repeat patterns of crimes by hour and weekday.

select 
	datepart(hour, Occorance_Time) as Hour,
	datename(WEEKDAY, Reported_date) as DayOfWeek,
	count(*) as [Number of Cases]
from gold.crimedata
group by datepart(hour, Occorance_Time), datename(WEEKDAY, Reported_date)
order by [Number of Cases] desc
;

-- Q35 : Which areas consistently appear in top 5 crime areas every year?

with AreaYearlyCrimeCount as (
	select 
		AREA,
		AREA_NAME,
		year(Reported_date) as Year,
		count(*) as CrimeCount,
		RANK() OVER (PARTITION BY year(Reported_date) ORDER BY count(*) desc) as AreaRank
	from gold.crimedata
	group by AREA, AREA_NAME, year(Reported_date)
	)select
	AREA,
	AREA_NAME,
	YEAR,
	CrimeCount,
	AreaRank
from AreaYearlyCrimeCount
where AreaRank <= 5
order by YEAR, AreaRank
;

-- Q36 : Find the fastest growing crime category.

WITH CrimeYearlyGrowth AS (
	SELECT 
		Crime_Code,
		Crime_Code_Description,
		YEAR(Reported_date) AS Year,
		COUNT(*) AS CrimeCount,
		LEAD(COUNT(*)) OVER (PARTITION BY Crime_Code ORDER BY YEAR(Reported_date)) AS NextYearCrimeCount
	FROM gold.crimedata
	GROUP BY Crime_Code, Crime_Code_Description, YEAR(Reported_date)
)SELECT 
	Crime_Code,
	Crime_Code_Description,
	Year,
	CrimeCount,
	NextYearCrimeCount,
	TRY_CAST(CASE 
		WHEN NextYearCrimeCount IS NULL THEN NULL
		ELSE ROUND((NextYearCrimeCount - CrimeCount) * 100.0 / CrimeCount, 2)
	END AS DECIMAL(5,2)) AS GrowthPercentage
	FROM CrimeYearlyGrowth
	ORDER BY GrowthPercentage DESC
	;

-- Q37 : Find crimes that mostly happen on weekends.

WITH WeekendCrimes AS (
	SELECT 
		Crime_Code,
		Crime_Code_Description,
		DATENAME(WEEKDAY, Reported_date) AS DayOfWeek,
		COUNT(*) AS CrimeCount
	FROM gold.crimedata
	WHERE DATENAME(WEEKDAY, Reported_date) IN ('Saturday', 'Sunday')
	GROUP BY Crime_Code, Crime_Code_Description, DATENAME(WEEKDAY, Reported_date)
	)SELECT
	*,
	TRY_CAST(CASE 
		WHEN CrimeCount = 0 THEN NULL
		ELSE ROUND(CrimeCount * 100.0 / (SELECT COUNT(*) FROM gold.crimedata WHERE DATENAME(WEEKDAY, Reported_date) IN ('Saturday', 'Sunday')), 2)
	END AS DECIMAL(5,2)) AS PercentageOfWeekendCrimes
	FROM WeekendCrimes
	ORDER BY PercentageOfWeekendCrimes DESC
	;

-- Q38 : Rank all areas based on total crimes.

WITH AreaCrimeCount AS (
	SELECT 
		AREA,
		AREA_NAME,
		COUNT(*) AS TotalCrimes
	FROM gold.crimedata
	GROUP BY AREA, AREA_NAME
)SELECT
	RANK() OVER (ORDER BY TotalCrimes DESC) AS AreaRank,
	*
FROM AreaCrimeCount
ORDER BY AreaRank
;

-- Find the second most common crime in every area.

WITH AreaCrimeRank AS (
	SELECT 
		AREA,
		AREA_NAME,
		Crime_Code,
		Crime_Code_Description,
		COUNT(*) AS CrimeCount,
		RANK() OVER (PARTITION BY AREA ORDER BY COUNT(*) DESC) AS CrimeRank
	FROM gold.crimedata
	GROUP BY AREA, AREA_NAME, Crime_Code, Crime_Code_Description
	)SELECT
	*
FROM AreaCrimeRank
WHERE CrimeRank = 2
;

-- Q40 : Calculate running total of crimes by year.

WITH YearlyCrimeCount AS (
	SELECT 
		YEAR(Reported_date) AS Year,
		COUNT(*) AS CrimeCount
	FROM gold.crimedata
	GROUP BY YEAR(Reported_date)
)SELECT
	Year,
	CrimeCount,
	SUM(CrimeCount) OVER (ORDER BY Year) AS RunningTotal
FROM YearlyCrimeCount
ORDER BY Year
;

-- Q41 : Calculate cumulative monthly crimes.

WITH MonthlyCrimeCount AS (
	SELECT 
		YEAR(Reported_date) AS Year,
		MONTH(Reported_date) AS Month,
		COUNT(*) AS CrimeCount
	FROM gold.crimedata
	GROUP BY YEAR(Reported_date), MONTH(Reported_date)
	)SELECT
	*,
	SUM(CrimeCount) OVER (ORDER BY Year, Month) AS CumulativeCrimes
	FROM MonthlyCrimeCount
	ORDER BY Year, Month
	;

-- Q42 : Find moving average of monthly crimes.

WITH MonthlyCrimeCount AS (
	SELECT 
		YEAR(Reported_date) AS Year,
		MONTH(Reported_date) AS Month,
		COUNT(*) AS CrimeCount
	FROM gold.crimedata
	GROUP BY YEAR(Reported_date), MONTH(Reported_date)
	)SELECT
	*,
	ROUND(AVG(CrimeCount) OVER (ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS MovingAverage
	FROM MonthlyCrimeCount
	ORDER BY Year, Month
	;

-- Find percentage contribution of each crime type.

WITH CrimeTypeCount AS (
	SELECT 
		Crime_Code,
		Crime_Code_Description,
		COUNT(*) AS CrimeCount
	FROM gold.crimedata
	GROUP BY Crime_Code, Crime_Code_Description
	)SELECT
	*,
	CAST(ROUND(CrimeCount * 100.0 / (SELECT COUNT(*) FROM gold.crimedata), 2) AS DECIMAL(5,2)) AS PercentageContribution
	FROM CrimeTypeCount
	ORDER BY PercentageContribution DESC
	;

-- Q44 : Find top 5 weapon types using DENSE_RANK().

WITH WeaponCount AS (
	SELECT 
		Weapon_Used_Code,
		Weapon_Desc,
		COUNT(*) AS CrimeCount,
		DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS WeaponRank
	FROM gold.crimedata
	GROUP BY Weapon_Used_Code, Weapon_Desc
)SELECT
	*
FROM WeaponCount
WHERE WeaponRank <= 5
ORDER BY WeaponRank
;

-- Q45 : Compare each year’s crime count with previous year using LAG().

WITH YearlyCrimeCount AS (
	SELECT 
		YEAR(Reported_date) AS Year,
		COUNT(*) AS CrimeCount,
		LAG(COUNT(*)) OVER (ORDER BY YEAR(Reported_date)) AS PreviousYearCrimeCount
	FROM gold.crimedata
	GROUP BY YEAR(Reported_date)
	)SELECT
	*,
	CAST(ROUND(CASE 
		WHEN PreviousYearCrimeCount IS NULL THEN NULL
		ELSE (CrimeCount - PreviousYearCrimeCount) * 100.0 / PreviousYearCrimeCount
	END, 2) AS DECIMAL(5,2)) AS GrowthPercentage
	FROM YearlyCrimeCount
	ORDER BY Year
	;

-- Q46 : Find crime count difference between consecutive months.

WITH MonthlyCrimeCount AS (
	SELECT 
		YEAR(Reported_date) AS Year,
		MONTH(Reported_date) AS Month,
		COUNT(*) AS CrimeCount,
		LAG(COUNT(*)) OVER (ORDER BY YEAR(Reported_date), MONTH(Reported_date)) AS PreviousMonthCrimeCount
	FROM gold.crimedata
	GROUP BY YEAR(Reported_date), MONTH(Reported_date)
)SELECT
	*,
	(CASE 
		WHEN PreviousMonthCrimeCount IS NULL THEN NULL
		ELSE (CrimeCount - PreviousMonthCrimeCount)
	END) AS MonthDifference
	FROM MonthlyCrimeCount
	ORDER BY Year, Month
	;

-- Q47 : Identify areas whose crime count is above average.

WITH AreaCrimeCount AS (
	SELECT 
		AREA,
		AREA_NAME,
		COUNT(*) AS CrimeCount,
		AVG(COUNT(*)) OVER () AS AvgCrimeCount
	FROM gold.crimedata
	GROUP BY AREA, AREA_NAME
)SELECT
	*
FROM AreaCrimeCount
WHERE CrimeCount > AvgCrimeCount
ORDER BY CrimeCount DESC
;

-- Q48 : If LAPD wants to deploy more police units, which areas and hours should they prioritize?

WITH AreaHourCrimeCount AS (
	SELECT 
		AREA,
		AREA_NAME,
		datepart(hour, Occorance_Time) AS Hour,
		COUNT(*) AS CrimeCount
	FROM gold.crimedata
	GROUP BY AREA, AREA_NAME, datepart(hour, Occorance_Time)
	)SELECT
	*,
	CAST(ROUND(CrimeCount * 100.0 / (SELECT COUNT(*) FROM gold.crimedata), 2) AS DECIMAL(5,2)) AS PercentageOfTotalCrimes
	FROM AreaHourCrimeCount
	ORDER BY CrimeCount DESC
	;

-- Q49 : Which crime categories should receive the highest prevention budget?

WITH CrimeCategoryCount AS (
	SELECT 
		Crime_Code,
		Crime_Code_Description,
		COUNT(*) AS CrimeCount
	FROM gold.crimedata
	GROUP BY Crime_Code, Crime_Code_Description
	)SELECT
	*,
	CAST(ROUND(CrimeCount * 100.0 / (SELECT COUNT(*) FROM gold.crimedata), 2) AS DECIMAL(5,2)) AS PercentageOfTotalCrimes
	FROM CrimeCategoryCount
	ORDER BY PercentageOfTotalCrimes DESC
	;

-- Q50 : Which victim demographic is at highest risk?

with VictimDemographicCount AS (
	SELECT
		Vict_Sex as Victim_Sex,
		Vict_Group,
		count(*) as CrimeCount
	FROM silver.dim_victim_view
	GROUP BY Vict_Sex,Vict_Group
)SELECT
	*,
	CAST(ROUND(CrimeCount * 100.0 / (SELECT COUNT(*) FROM gold.crimedata), 2) AS DECIMAL(5,2)) AS PercentageOfTotalCrimes
	FROM VictimDemographicCount
	ORDER BY PercentageOfTotalCrimes DESC
	;

-- Q51 : Which areas are becoming safer over time in 2024?

with AreaYearlyCrimeCount as (
	select 
		AREA,
		AREA_NAME,
		year(Reported_date) as Year,
		count(*) as CrimeCount,
		LAG(count(*)) OVER (PARTITION BY AREA ORDER BY year(Reported_date)) as PreviousYearCrimeCount
	from gold.crimedata
	group by AREA, AREA_NAME, year(Reported_date)
	)select
	AREA,
	AREA_NAME,
	Year,
	CrimeCount,
	PreviousYearCrimeCount,
	CAST(ROUND(CASE 
		WHEN PreviousYearCrimeCount IS NULL THEN NULL
		ELSE (CrimeCount - PreviousYearCrimeCount) * 100.0 / PreviousYearCrimeCount
	END, 2) as decimal(5,2)) as GrowthPercentage
	from AreaYearlyCrimeCount
	where CAST(ROUND(CASE 
		WHEN PreviousYearCrimeCount IS NULL THEN NULL
		ELSE (CrimeCount - PreviousYearCrimeCount) * 100.0 / PreviousYearCrimeCount
	END, 2) as decimal(5,2)) < 0 and
	Year = 2024
	order by GrowthPercentage asc
	;

-- Q52 : Which areas show abnormal crime spikes?

with AreaYearlyCrimeCount as (
	select 
		AREA,
		AREA_NAME,
		year(Reported_date) as Year,
		count(*) as CrimeCount,
		LAG(count(*)) OVER (PARTITION BY AREA ORDER BY year(Reported_date)) as PreviousYearCrimeCount
	from gold.crimedata
	group by AREA, AREA_NAME, year(Reported_date)
	)select
	AREA,
	AREA_NAME,
	Year,
	CrimeCount,
	PreviousYearCrimeCount,
	CAST(ROUND(CASE 
		WHEN PreviousYearCrimeCount IS NULL THEN NULL
		ELSE (CrimeCount - PreviousYearCrimeCount) * 100.0 / PreviousYearCrimeCount
	END, 2) as decimal(5,2)) as GrowthPercentage
	from AreaYearlyCrimeCount
	order by GrowthPercentage desc
	;

-- Q53 : Which crimes are most common during holidays/weekends?

with HolidayWeekendCrimes as (
	select 
		Crime_Code,
		Crime_Code_Description,
		DATENAME(WEEKDAY, Reported_date) AS DayOfWeek,
		COUNT(*) AS CrimeCount
	from gold.crimedata
	where DATENAME(WEEKDAY, Reported_date) IN ('Saturday', 'Sunday') or 
		CAST(Reported_date AS DATE) IN ('2024-01-01', '2024-12-25', '2024-07-04') -- Example holidays
	group by Crime_Code, Crime_Code_Description, DATENAME(WEEKDAY, Reported_date)
	)select
		*
	from HolidayWeekendCrimes
	order by CrimeCount desc
	;

-- Q54 : Which premises should improve security measures?

with PremiseCrimeCount as (
	select 
		year(Reported_date) as Year,
		Premis_Code,
		Premis_Desc,
		count(*) as CrimeCount
	from gold.crimedata
	group by Premis_Code, Premis_Desc, year(Reported_date)
	)select
		Premis_Code,
		Premis_Desc,
		CrimeCount
	from PremiseCrimeCount
	where Year = 2024
	order by CrimeCount desc
	;

/*
Find crime hotspots by combining:
	area
	hour
	crime type
*/

with CrimeHotspots as (
	select 
		AREA,
		AREA_NAME,
		datepart(hour, Occorance_Time) as Hour,
		Crime_Code,
		Crime_Code_Description,
		count(*) as CrimeCount
	from gold.crimedata
	group by AREA, AREA_NAME, datepart(hour, Occorance_Time), Crime_Code, Crime_Code_Description
	)select
		*,
		CAST(ROUND(CrimeCount * 100.0 / (SELECT COUNT(*) FROM gold.crimedata), 2) AS DECIMAL(5,2)) AS PercentageOfTotalCrimes
		from CrimeHotspots
		order by CrimeCount desc
		;
