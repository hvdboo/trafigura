set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 50;
set pagesize 2048; 
select M_AGENCY as Agency 
from RT_AGNCY_DBF 
order by M_AGENCY;
quit;
SPOOL OFF;