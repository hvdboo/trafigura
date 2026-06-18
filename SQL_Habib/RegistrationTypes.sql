set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1785;
set pagesize 2048;
select T1.M_LABEL as RegistrationType,
T1.M_DESC as Description
from CM_REGTYPE_DBF T1
order by 1;
quit; 
SPOOL OFF;