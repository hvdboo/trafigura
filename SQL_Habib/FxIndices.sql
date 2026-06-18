set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 120;
set pagesize 2048;
select M_IND_LAB as FxIndices, CAST(M_CURR1 AS CHAR(10)) as Currency1, CAST(M_CURR2 AS CHAR(10)) as Currency2, M_FX_GROUP as Publisher, M_COL_CODE as Columns
from RT_INDEX_DBF
where M_CATEGORY=4
and M_CREAT_MODE = 0 
order by M_IND_LAB;
quit;
SPOOL OFF;