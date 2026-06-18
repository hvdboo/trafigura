set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 100;
set pagesize 2048;
select CAST(M_SE_EX_D_R AS VARCHAR2(15))  as ExDividendRule, M_SE_EX_D_D as Shifter ,
case when (M_SE_EX_D_T=1) then 'CALCULATION SCHEDULE'  when (M_SE_EX_D_T=0) then 'PAYMENT SCHEDULE'
	else to_char(M_SE_EX_D_T) end as BasedOn 
from SE_TREX_DBF 
order by M_SE_EX_D_R;
quit;
SPOOL OFF;