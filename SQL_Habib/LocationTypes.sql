set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 120;
set pagesize 2048;
select T1.M_LABEL as LocationType, T1.M_DESC as Description 
from CM_LTYPE_DBF T1 
order by T1.M_LABEL;
quit;
SPOOL OFF;