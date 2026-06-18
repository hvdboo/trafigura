set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 700;
set pagesize 2048;
select M_LABEL as FXFuture, CAST(M_OTC_CNT AS VARCHAR2(12)) as OTCContract, M_MARKET as Market,M_CNTSIZE0 as FaceAmount,
	CAST(M_CURRENCY AS VARCHAR2(19)) as FaceAmountCurrency, CAST(M_BASE AS VARCHAR2(13)) as BaseCurrency ,CAST(M_UNDERLNG AS VARCHAR2(19)) as UnderlyingCurrency,
	M_SP_SCHED0 as ValueDate, M_CALENDAR0 as Calendar, CAST(M_QUOTMODE0 AS VARCHAR2(16)) as DefaultQuotaion,
	CAST(M_HISFN AS VARCHAR2(15)) as HistoricalFile, M_STRIKEINCR as StrikeIncrement, CAST(M_MARGIN_CUR AS VARCHAR2(16)) as PaymentCurrency,
	case when (M_CASH_SETTL = 0) then 'Delivery' when (M_CASH_SETTL = 1) then 'Cash' end as Settlement,
	CAST(M_MATSET AS VARCHAR2(19)) as SettlementCalendar, 	
	M_SPOT_FF0  as PriceFormFactor1,M_SPOT_FF1  as PriceFormFactor2, M_SWAP_FF0 as SwapFormFactor1, M_SWAP_FF1 as SwapFormFactor2,
	case when (M_OPT_STYLE   = 0) then 'American' when (M_OPT_STYLE   = 1) then 'European' end as OptionStyle,
	CAST(M_OPTMATSET AS VARCHAR2(18)) as OptionMaturitySet,CAST(M_PLQUOT AS VARCHAR2(17)) as PremiumQuotation, 
	case when (M_PREM_EXPM= 0) then 'Decimal' 
		when (M_PREM_EXPM= 1) then '8`' 
		when (M_PREM_EXPM= 2) then '16`' 
		when (M_PREM_EXPM= 3) then '32`' 
		when (M_PREM_EXPM= 4) then '64`' 
		when (M_PREM_EXPM= 5) then '128`' 
		when (M_PREM_EXPM= 6) then 'Variable' 
	end  as PremiumQuotationNotation, 
	M_PREM_FF0 as PremiumFormFactor1, M_PREM_FF1 as PremiumFormFactor2,
	CAST(M_SMILE_QUOT AS VARCHAR2(14)) as SmileCurrency,
	case when (M_SM_INTERP = 1) then 'Delta' when (M_SM_INTERP = 2) then 'Strike'
		when (M_SM_INTERP = 0) then 'Inherited'  end  as SmileIndex, 
	case when (M_SM_ITERM  = 1) then 'Linear' 
		when (M_SM_ITERM  = 2) then 'Spline' 
		when (M_SM_ITERM  = 3) then 'Polynomial' 
		when (M_SM_ITERM  = 0) then 'Inherited' 
		when (M_SM_ITERM  = 5) then 'Smooth' 
	end as SmileInterpolationMode,
	case when (M_SM_EXTRA = 0) then 'Flat curve'  
		when (M_SM_EXTRA = 1) then 'Extrapolate'  
		when (M_SM_EXTRA = 0) then 'Inherited' 
	end as SmileInterpolationMethod, 
	CAST(M_UND_QUOT AS VARCHAR2(20)) as UnderlyingQuotation, M_SIGMA as SigmaSmoothInterpolation, 
	case when (M_VOL_IMP = 0) then 'Interpolated from OTC'  
	when (M_VOL_IMP = 1) then 'Off + spread ' 
	end as ListedVolatilities
-------
from FX_CNT_DBF
-------
where M_TYPE='OMOPT'
-------
order by M_LABEL;
quit;
SPOOL OFF;