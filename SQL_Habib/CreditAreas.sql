set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 69;
set pagesize 2048;
select M_AREA as Area, '     ' as Empty 
from CR_AREA_DBF 
order by M_AREA;
quit;
SPOOL OFF;