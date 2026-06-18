set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 80;
set pagesize 2048;
select CAST(M_LABEL AS CHAR(15)) as UnderlyingAreas, M_DESC as Description
from UND_AREA_DBF 
order by  M_LABEL;
quit;
SPOOL OFF;