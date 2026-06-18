set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 50;
set pagesize 2048; 
select M_LABEL  as CurrencyCategory 
from FXCAT_CUR_DBF 
order by M_LABEL; 
quit;
SPOOL OFF;