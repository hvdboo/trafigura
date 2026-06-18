set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 80;
set pagesize 2048;
select	CAST(M_SE_TRDCL AS CHAR(15)) as TradingClauses , M_SE_GROUP as GroupType, CAST(M_SE_CUR AS CHAR(10)) as Currency, 
	M_SE_TCQ_L as Quotation, M_SE_TCS_L as Settlement
from	SE_TRDC_DBF
order by M_SE_TRDCL;
quit;
SPOOL OFF;