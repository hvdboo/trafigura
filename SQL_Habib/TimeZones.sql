set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 330;
set pagesize 2048;
select T1.M_LABEL as TimeZone, T1.M_DESC as Description, T1.M_SHIFT/3600 as ShiftToGMT, 
case when T2.M_LABEL is NULL then ' ' else T2.M_LABEL end as DSTSet, 
case when T2.M_DESC is NULL then ' ' else T2.M_DESC end as DSTDesc,
case when (T3.M_DATE is NULL) then ' ' else to_char(T3.M_DATE, 'DD MON YY') end as DateOfChanging,
case when (T3.M_LOC_TIME is NULL) then ' ' else to_char(T3.M_LOC_TIME/3600) end as "LocalTime",
case when (T3.M_ADJUST is NULL) then ' ' else to_char(T3.M_ADJUST/3600) end as Adjustment
-------
from DAT_TZONE_DBF T1  
left outer join DAT_DSTSET_DBF T2 on T1.M_DST=T2.M_REFERENCE
left outer join DAT_DSTTR_DBF T3 on T2.M_REFERENCE=T3.M_DST_SET
-------
order by T1.M_LABEL, T3.M_DATE;
quit;
SPOOL OFF;