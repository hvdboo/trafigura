set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 473;
set pagesize 50000; 
select M_CAL_LABEL as Calendar, to_char(M_DATE,'DD MON YY') as Holiday, M_COMMENT as Comments, 
case when (M_GENERAL =0) then 'No'  when (M_GENERAL =1 ) then 'Yes' else to_char(M_GENERAL) end as Yearly
-------
from CAL_HOL_DBF T1, CAL_DEF_DBF T2
where T2.M_ISUNION = 0
and T1.M_CAL_LABEL = T2.M_LABEL
order by M_CAL_LABEL, M_DATE;
quit;
SPOOL OFF;