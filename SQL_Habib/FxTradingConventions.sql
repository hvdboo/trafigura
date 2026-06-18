set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 250;
set pagesize 2048;
select	M_LABEL as Market , M_NAME as FullName, 
case when(M_TYPE = 0) then 'Cash options and futures market' 
	when(M_TYPE = 1) then 'Cash options market' 
	when(M_TYPE = 2) then 'Futures market' 
end as Type, 
CAST(M_CURRENCY AS VARCHAR2(10)) as Currency, M_CALENDAR as Calendar, 
CAST(M_OPT_MSET AS VARCHAR2(25)) as CashOptionsMaturitySet, CAST(M_FUT_MSET AS VARCHAR2(20)) as FutureMaturitySet,
 CAST(M_OFUT_MSET AS VARCHAR2(25)) as FutureOptionsMaturitySet
from MARKET_DBF
order by M_LABEL;
quit;
SPOOL OFF;