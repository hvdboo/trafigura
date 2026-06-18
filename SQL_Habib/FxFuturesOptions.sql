set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 350;
set pagesize 2048;
select 	CAST(M_LABEL AS VARCHAR(14)) as FXFutureLabel,	
	case	when (M_OPT_STYLE   = 0) then 'American' when (M_OPT_STYLE   = 1) then 'European' end as OptionStyle,
	CAST(M_OPTMATSET AS VARCHAR(18)) as OptionMaturitySet, CAST(M_PLQUOT AS VARCHAR(17)) as PremiumQuotation,
	case	when (M_PREM_EXPM= 0) then 'Decimal' 
		when (M_PREM_EXPM= 1) then '8`' 
		when (M_PREM_EXPM= 2) then '16`' 
		when (M_PREM_EXPM= 3) then '32`' 
		when (M_PREM_EXPM= 4) then '64`' 
		when (M_PREM_EXPM= 5) then '128`' 
		when (M_PREM_EXPM= 6) then 'Variable' 
	end  as PremiumQuotationNotation, 
	M_PREM_FF0 as PremiumFormFactor1, M_PREM_FF1 as PremiumFormFactor2, CAST(M_OPT_CUTOFF AS VARCHAR(14)) as OptionCuttOff,
	case	when (M_SM_ITERM  = 1) then 'Linear' 
		when (M_SM_ITERM  = 2) then 'Spline' 
		when (M_SM_ITERM  = 3) then 'Polynomial' 
		when (M_SM_ITERM  = 4) then 'Inherited' 
		when (M_SM_ITERM  = 5) then 'Smooth' 
                when (M_SM_ITERM  = 6) then 'Constrained polynomial' else ' '
	end as SmileInterpolationMode, 
	case	when (M_SM_EXTRA = 0) then 'Flat curve' 
		when (M_SM_EXTRA = 1) then 'Extrapolate'
		when (M_SM_EXTRA = 4) then 'Inherited' 
	end as SmileInterpolationMethod, 
	M_SIGMA as SigmaSmoothInterpolation, 
	case	when (M_VOL_IMP = 0) then 'Interpolated from OTC'  when (M_VOL_IMP = 1) then 'Listed curve +OTC shift' end as ListedVolatilities, 
	case	when (M_FUT_IMP =0) then  'Interpolated from OTC'  when (M_FUT_IMP = 1) then 'Listed curve +OTC shift' end as FuturePrices
-------
from FX_CNT_DBF 
-------
where M_TYPE='OMFUT'
order by M_LABEL;
quit;
SPOOL OFF;