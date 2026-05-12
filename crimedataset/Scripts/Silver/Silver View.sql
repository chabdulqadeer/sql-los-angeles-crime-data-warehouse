Go
create or alter view silver.dim_victim_view as
	select
	DR_NO,
	Vict_Sex,
	Vict_Descent,
	Vict_Age,
	case
		when Vict_Age between 0 and 17 then 'Child'
		when Vict_age between 18 and 25 then 'Young Adult'
		when Vict_Age between 26 and 40 then 'Adult'
		when Vict_Age between 41 and 60 then 'Middle Age'
		else 'Senior' 
	end as Vict_Group
	from silver.crimedata
;
GO
create or alter view silver.dim_area_view as
	select
	Row_number() over(order by DR_NO) as Ranking_ID,
	Area,
	AREA_NAME
	from silver.crimedata
;
GO
create or alter view silver.dim_weapon_view as
	select
	Row_number() over(order by DR_NO) as Ranking_ID,
	Weapon_Used_Cd,
	Weapon_Desc
	from silver.crimedata
;
GO
create or alter view silver.dim_premise_view as
	select
	Row_number() over(order by DR_NO) as Ranking_ID,
	Premis_Cd,
	Premis_Desc
	from silver.crimedata
;

