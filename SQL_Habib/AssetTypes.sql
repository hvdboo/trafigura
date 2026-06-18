set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_LABEL as AssetType, T1.M_DESC as Description
from CM_ATYPE_DBF T1  
order by T1.M_LABEL;
quit;
SPOOL OFF;