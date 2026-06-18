set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 320;
set pagesize 2048;
select  T1.M_COFFCODE as CutOffCode, T1.M_LABEL as City, T1.M_COMMENT as Description, case when T2.M_CODE is null then ' ' else T2.M_CODE end as SwiftLocation, 
T1.M_COFFTIME as TimeShiftGMT, T1.M_CUTHOUR as LocalTimeHr, T1.M_CUTMIN as LocalTimeMin
from CITIES_DBF T1
left join SWIFT_LOCATION_DBF T2 on T1.M_SWIFT_LOC = T2.M_CODE
order by 1;
quit; 
SPOOL OFF;