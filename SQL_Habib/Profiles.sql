set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 400;
set pagesize 2048;
select T1.M_LABEL as Profile , T1.M_DESC as Description, 
case when T1.M_PROF_TYPE = 0 then 'NotSpecified'
	when T1.M_PROF_TYPE = 2 then 'Base'
	when T1.M_PROF_TYPE = 3 then 'Peak'
	when T1.M_PROF_TYPE = 4 then 'Offpeak'
end as ProfileType,
case when  T1.M_ALL_WEEK=0 then 'No'
	when  T1.M_ALL_WEEK=1 then 'Yes'
end as AllWeek,
case when  T1.M_WEIGHTS=0 then 'No'
when  T1.M_WEIGHTS=1 then 'Yes'
end as DifferentWeights,
T1.M_TIME_UNIT as TimeUnit,
case when T1.M_GAZ_PROF = 0 then 'No'
	when T1.M_GAZ_PROF = 1 then 'Yes'
end as GasProfile,
case when T1.M_HD_MODE = 0 then 'HolidayTreatedAs'
	when T1.M_HD_MODE = 1 then 'IgnoreHolidayForDelivery'
end as HolidayMode, 
case when T1.M_HD_WEEKDAY=0 then 'Sunday'
	when T1.M_HD_WEEKDAY=1 then 'Monday'
	when T1.M_HD_WEEKDAY=2 then 'Tuesday'
	when T1.M_HD_WEEKDAY=3 then 'Wednesday'
	when T1.M_HD_WEEKDAY=4 then 'Thursday'
	when T1.M_HD_WEEKDAY=5 then 'Friday'
	when T1.M_HD_WEEKDAY=6 then 'Saturday'
end as HolidayTreatedAs, 
case when T2.M_DAY is null then ' '
	when T2.M_DAY = 0 then 'Sunday'
	when T2.M_DAY = 1 then 'Monday'
	when T2.M_DAY = 2 then 'Tuesday'
	when T2.M_DAY = 3 then 'Wednesday'
	when T2.M_DAY = 4 then 'Thursday'
	when T2.M_DAY = 5 then 'Friday'
	when T2.M_DAY = 6 then 'Saturday'
end as WeekDay,
case when T2.M_ORDER is null then ' ' else to_char(T2.M_ORDER) end  as Interval,
case when M_WEIGHT0 is null then ' ' else to_char(M_WEIGHT0) end as Weight0,	
case when M_WEIGHT1 is null then ' ' else to_char(M_WEIGHT1) end as Weight1,	
case when M_WEIGHT2 is null then ' ' else to_char(M_WEIGHT2) end as Weight2,	
case when M_WEIGHT3 is null then ' ' else to_char(M_WEIGHT3) end as Weight3,	
case when M_WEIGHT4 is null then ' ' else to_char(M_WEIGHT4) end as Weight4,	
case when M_WEIGHT5 is null then ' ' else to_char(M_WEIGHT5) end as Weight5,	
case when M_WEIGHT6 is null then ' ' else to_char(M_WEIGHT6) end as Weight6,	
case when M_WEIGHT7 is null then ' ' else to_char(M_WEIGHT7) end as Weight7,	
case when M_WEIGHT8 is null then ' ' else to_char(M_WEIGHT8) end as Weight8,	
case when M_WEIGHT9 is null then ' ' else to_char(M_WEIGHT9) end as Weight9,	
case when M_WEIGHT10 is null then ' ' else to_char(M_WEIGHT10) end as Weight10,	
case when M_WEIGHT11 is null then ' ' else to_char(M_WEIGHT11) end as Weight11,	
case when M_WEIGHT12 is null then ' ' else to_char(M_WEIGHT12) end as Weight12,	
case when M_WEIGHT13 is null then ' ' else to_char(M_WEIGHT13) end as Weight13,	
case when M_WEIGHT14 is null then ' ' else to_char(M_WEIGHT14) end as Weight14,	
case when M_WEIGHT15 is null then ' ' else to_char(M_WEIGHT15) end as Weight15,	
case when M_WEIGHT16 is null then ' ' else to_char(M_WEIGHT16) end as Weight16,	
case when M_WEIGHT17 is null then ' ' else to_char(M_WEIGHT17) end as Weight17,	
case when M_WEIGHT18 is null then ' ' else to_char(M_WEIGHT18) end as Weight18,	
case when M_WEIGHT19 is null then ' ' else to_char(M_WEIGHT19) end as Weight19,	
case when M_WEIGHT20 is null then ' ' else to_char(M_WEIGHT20) end as Weight20,	
case when M_WEIGHT21 is null then ' ' else to_char(M_WEIGHT21) end as Weight21,	
case when M_WEIGHT22 is null then ' ' else to_char(M_WEIGHT22) end as Weight22,	
case when M_WEIGHT23 is null then ' ' else to_char(M_WEIGHT23) end as Weight23	
---------------
---------------
---------------
from CM_PROFH_DBF T1 
left outer join CM_PROF_STDB_DBF T2 on T1.M_REFERENCE=T2.M_REFERENCE
---------------
order by T1.M_LABEL,T2.M_DAY,T2.M_ORDER;
quit;
SPOOL OFF;