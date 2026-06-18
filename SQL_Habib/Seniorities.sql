set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 90;
set pagesize 2048;
select M_LABEL as Seniority, M_CODE as SeniorityCode
from RT_SEN_DBF
order by M_LABEL;
quit;
SPOOL OFF;
