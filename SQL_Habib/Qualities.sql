set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1539;
set pagesize 2048;
select T1.M_LABEL as Quality,
T1.M_DESC as Description
from CM_QUALITY_DBF T1
order by 1;
quit;
SPOOL OFF;
