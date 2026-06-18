set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select  T2.M_SE_MKT_OPT as Contract, T3.M_SE_D_LABEL as Instrument, 	T1.M_SE_MARKET as Market, 
case when (T1.M_SE_LO_IRF = 0) then 'Inherited' else 'Redefined' end as TradingClausesFlag,
T1.M_SE_STR_STP as StrikeStep, T1.M_SE_OPT_LS0 as LotSize
from SE_MKT3_DBF T1, SE_MKT2_DBF T2, SE_HEAD_DBF T3
where T2.M_SE_OPT_IN=T1.M_SE_OPT_IN
and T1.M_SE_LABEL=T3.M_SE_LABEL
order by T2.M_SE_MKT_OPT,T3.M_SE_D_LABEL;
quit;
SPOOL OFF;