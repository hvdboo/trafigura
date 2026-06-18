set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 80;
set pagesize 2048; 
select T2.M_SE_D_LABEL as Future, CAST(T1.M_FU_CNC_RUL AS VARCHAR2(20)) as PriceFactorRule 
from MPX_PF_DBF T1, SE_HEAD_DBF T2 
where T1.M_FU_LABEL=T2.M_SE_LABEL
order by T2.M_SE_D_LABEL;
quit;
SPOOL OFF;