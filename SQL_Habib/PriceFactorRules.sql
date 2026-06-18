set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048; 
select	M_RULE_LABEL as PriceFactor, CAST(M_DEF_CONV AS VARCHAR2(20)) as DefaultConvention, 
	case when (M_ROUNDING = 0) then 'None' when (M_ROUNDING = 1) then 'Nearest' when (M_ROUNDING = 2) then 'By default'  
	when (M_ROUNDING = 3) then 'By excess'	end as RoundingRule, M_DECIMALS as Decimals , 
	case when (M_EX_D_FLAG = 0 ) then 'No' when (M_EX_D_FLAG = 1 ) then 'Yes' end as ExDivididend , M_EX_D_RULE as ExDividendRule
from CONC_FC_DBF 
order by M_RULE_LABEL;
quit;
SPOOL OFF;