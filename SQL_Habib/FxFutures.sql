set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 500;
set pagesize 2048; 
select 	M_LABEL as FXFuture, CAST(M_OTC_CNT AS VARCHAR2(15)) as OTCContract,CAST(M_CNTSIZE0 AS VARCHAR2(10)) as FaceAmount,
	CAST(M_CURRENCY AS VARCHAR2(20)) as FaceAmountCurrency,  CAST(M_MARGIN_CUR AS VARCHAR2(15)) as PaymentCurrency, M_MARKET as Market,
	M_CALENDAR0 as Calendar, 
        case	when (M_CASH_SETTL = 0) then 'Delivery' when (M_CASH_SETTL = 1) then 'Cash' end as Settlement, CAST(M_MATSET AS VARCHAR2(20)) as SettlementCalendar, 
	M_SP_SCHED0 as ValueDate, CAST(M_QUOTMODE0 AS VARCHAR2(20)) as DefaultQuotation,
        case	when (M_SPOT_EXPM= 0) then 'Decimal' 
		when (M_SPOT_EXPM= 1) then '8`' 
		when (M_SPOT_EXPM= 2) then '16`' 
		when (M_SPOT_EXPM= 3) then '32`' 
		when (M_SPOT_EXPM= 4) then '64`' 
		when (M_SPOT_EXPM= 5) then '128`' 
		when (M_SPOT_EXPM= 6) then 'Variable' 
	end as DefaultQuotationNotation,CAST(M_UND_QUOT AS VARCHAR2(20)) as UnderlyingQuotation, 
	 M_SPOT_FF0 as PriceFormFactor1, M_SPOT_FF1 as PriceFormFactor2, M_SWAP_FF0 as SwapFormFactor1,
        M_SWAP_FF1 as SwapFormFactor2, M_STRIKEINCR as StrikeIncrement,
	case    when (M_CNT_ACTIVE = 0) then 'Unchecked'
                when (M_CNT_ACTIVE = 1) then 'checked' end as ContractActive,
        case    when (M_VOL_IMP = 0) then 'Interpolated from OTC'
                when (M_VOL_IMP = 1) then 'Listed curve + OTC shift' end as ListedVolatilities,
        case    when (M_FUT_IMP = 0) then 'Interpolated from OTC'
                when (M_FUT_IMP = 1) then 'Listed curve + OTC shift' end as FuturePrices
-------
from FX_CNT_DBF 
where M_TYPE='OMFUT'
order by M_LABEL;
quit;
SPOOL OFF;