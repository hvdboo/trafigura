set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 50;
set pagesize 2048; 
select T1.M_LABEL as '#RollingConfiguration',
case when  T1.M_REF_DATE = 0 then 'Expiry' when T1.M_REF_DATE = 1 then 'First business day of month' end as ReferenceDate,
case when (T1.M_REF_DATE = 1 and T1.M_SHIFTER is not null) then T1.M_SHIFTER else ' ' end as Shifter,
case when T2.M_DAY is null then ' ' else to_char(T2.M_DAY) end as Day,
case when T2.M_WEIGHT is null then ' ' else to_char(T2.M_WEIGHT) end as FirstWeight
---------------
from CM_LI_ROLL_DBF T1
left join CM_LI_RWGT_DBF T2 on T2.M_ROLL = T1.M_REFERENCE
---------------
order by T1.M_LABEL, T2.M_DAY; 
quit;
SPOOL OFF;