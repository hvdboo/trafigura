set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 105;
set pagesize 2048;
select T1.M_LABEL || '      ' as Currency, T1.M_FULL_NAME as FullName , T2.M_CLS_M|| '         ' as "CLSEligible"
from FX_CURR_DBF T1, TABLE#DATA#CURRENCY_DBF T2 
where T1.M_LABEL=T2.M_LABEL 
order by T1.M_LABEL;
quit;
SPOOL OFF;