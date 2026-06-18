set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_LABEL as DeliveryTerms, T1.M_DESC
from CMC_DLV_TRM_DBF T1
order by 1;
quit;
SPOOL OFF;