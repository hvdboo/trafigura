set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 500;
set pagesize 2048;
select T1.M_LABEL as CreditIndexName, T2.M_FAMILY as Family, T2.M_RED_ID as "REDId", T2.M_SERIES as Series, T2.M_VERSION || '       ' as Version
from CR_BSKH_DBF T1, TABLE#DATA#CREDITBA_DBF T2
where T1.M__INDEX_=T2.M__NB_
and T1.M_B_NATURE=0
order by T1.M_LABEL;
quit;
SPOOL OFF;