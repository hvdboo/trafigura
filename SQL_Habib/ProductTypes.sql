set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 120;
set pagesize 2048;
select 	T1.M_LABEL as ProductType, T1.M_DESC as Description
from 	CM_PTYPE_DBF T1	
order by  T1.M_LABEL;
quit;
SPOOL OFF;