set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 100;
set pagesize 2048;
select	CAST(T1.M_SE_CLEAR AS VARCHAR2(14)) as ClearingHouse, 
case	when (T1.M_SE_WENABLE = 0) then 'UNCHECKED' 
when (T1.M_SE_WENABLE = 1) then 'CHECKED' 
else ' ' end  as WebEnabled, 
case	when  (T2.M_DVP_CUR  is null) then ' ' else T2.M_DVP_CUR  end  as Currency 
from SE_TRCL_DBF T1 
left outer join SE_DVP_DBF T2 on T1.M_SE_CLEAR = T2.M_DVP_CEN
order by T1.M_SE_CLEAR;
quit;
SPOOL OFF;