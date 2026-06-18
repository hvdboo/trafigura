set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 450;
set pagesize 2048;
select  CAST(T1.M_LABEL AS VARCHAR2(10)) as Currency , T1.M_FULL_NAME as FullName , CAST( T1.M_SYMBOL AS VARCHAR2(8)) as Symbol, 
case when (T1.M_PRECISION = 0)  then '1/10'  
	when  (T1.M_PRECISION = 1)  then '1/100'  
	when  (T1.M_PRECISION = 2)  then '1/1000' 
    when  (T1.M_PRECISION = 3)  then '1'  
	when  (T1.M_PRECISION = 4)  then '10'  
	when  (T1.M_PRECISION = 5)  then '100'  
	when  (T1.M_PRECISION = 6)  then '1000'  
	when  (T1.M_PRECISION = 7)  then '10000' 
	when  (T1.M_PRECISION = 8)  then '1(trunc)' 
	when  (T1.M_PRECISION = 9)  then 'round 1/10 + 1 (trunc)'  
	when  (T1.M_PRECISION = 10) then 'round 1/100 + 1 (trunc)' 
	when  (T1.M_PRECISION = 11) then 'round 1/1000 + 1 (trunc)' 
	end as Precision ,
CAST(T1.M_ISO_CODE AS VARCHAR2(10)) as ISOCode, T1.M_AREA as Area, 
case when (T2.M_LABEL is null) then ' ' else T2.M_LABEL end  as Category, 
case when (T1.M_REMODE = 0 ) then 'Rate' 
	when  (T1.M_REMODE = 1 ) then 'Swap points'  end as RateEntryMode,
case when (T3.M_GRP_DESC is null ) then ' ' else T3.M_GRP_DESC end as ArchivingGroup, 
CAST(T1.M_STCONV AS VARCHAR2(20)) as ShortTermConvention, CAST(T1.M_LTCONV AS VARCHAR2(20))  as LongTermConvention, CAST(T1.M_LT_SCHED AS VARCHAR2(18)) as LongTermSchedule,T1.M_SP_SCHED0 as SpotSchedule, 
CAST(T1.M_HOLCLN0 AS VARCHAR2(15)) as HolidayCalendar ,
case when T4.M_REF_CURR is null then ' ' else T4.M_REF_CURR end as RefCurrency,
case when (T1.M_FRNDRULE = 0) then 'None' 
	when  (T1.M_FRNDRULE = 1) then 'Nearest'                  
	when  (T1.M_FRNDRULE = 2) then 'By default' 
	when  (T1.M_FRNDRULE = 3) then 'By excess'  end  as FlowRoundingRule ,               
T1.M_FRDECIMAL as FlowRoundingDecimal,  T1.M_RATE_FT_S as PricingConvention,  T1.M_RATE_FT_D  as PricingConventionDecimals
------
from FX_CURR_DBF T1
left outer join  FXCAT_CUR_DBF T2 on T1.M_CATEGORY=T2.M_REFERENCE
left outer join  RT_GROUP_DBF  T3 on T1.M_HISFILE=T3.M_HISFILE 
left outer join  CU_REFCURR_DBF  T4 on T1.M_LABEL=T4.M_CURR
order by T1.M_LABEL;
quit;
SPOOL OFF;