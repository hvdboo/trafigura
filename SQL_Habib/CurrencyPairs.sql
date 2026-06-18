set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set colsep '#';
set linesize 1910;
set pagesize 2048;
select  CAST(T1.M_LABEL AS VARCHAR2(15)) as CurrencyPair, CAST(T1.M_BASE AS VARCHAR2(5)) as Base, CAST(T1.M_UNDERLNG AS VARCHAR2(11)) as Underlying, CAST(T1.M_QUOTMODE0 AS VARCHAR2(10)) as Quotation, CAST(T1.M_CALENDAR0 AS VARCHAR2(12)) as SpotToDeliv, 
case when T1.M_CRSS_SWP = 0 then 'NO'
	when T1.M_CRSS_SWP = 1 then 'YES: FIXED BASE DISC.'
	when T1.M_CRSS_SWP = 2 then 'YES: FIXED UND. DISC.'
end as CrossSwapMode,
        case when (T1.M_CNT_ACTIVE = 0) then 'NotActive'
	when (T1.M_CNT_ACTIVE = 1) then 'Active'
        end as ActiveContract,
CAST(T1.M_CALENDAR1 AS VARCHAR2(12)) as DateToValue,T1.M_SP_SCHED0 as FwdShift, T1.M_SP_SCHED1 as BwdShift,
case when (T2.M_LABEL is null ) then ' ' else T2.M_LABEL end as Category,
------
T1.M_SPOT_FF0 as SpotF1, T1.M_SPOT_FF1 as SpotF2, T1.M_SWAP_FF0 as SwapF1, T1.M_SWAP_FF1 as SwapF2,
CAST(T1.M_PLQUOT AS VARCHAR2(12)) as PremiumQuot, 
case when T1.M_T_BAS_QUOT = ' ' then '% '||T1.M_BASE else T1.M_T_BAS_QUOT end as BaseTradedQuotation, 
case when T1.M_T_UND_QUOT = ' ' then '% '||T1.M_UNDERLNG else T1.M_T_UND_QUOT end as UnderlyingTradedQuotation, 
------
T1.M_NUM_DEC as Numeraire, T1.M_DEN_DEC as Asset, T1.M_NUMDEN_DEC as NumeraireAsset,T1.M_DENNUM_DEC as AssetNumeraire,					
	T1.M_PREM_FF0 as PremF1, T1.M_PREM_FF1 as PremF2,
	T1.M_SPOT_FT_S0 as FormatSpot1Size, T1.M_SPOT_FT_D0 as FormatSpot1Decimal,
	T1.M_SPOT_FT_S1 as FormatSpot2Size, T1.M_SPOT_FT_D1 as FormatSpot2Decimal,
	T1.M_SWAP_FT_S0 as Swap1Size, T1.M_SWAP_FT_D0 as Swap1Decimal,
	T1.M_SWAP_FT_S1 as Swap2Size, T1.M_SWAP_FT_D1 as Swap2Decimal,
	T1.M_VOL_FT_S as VolatilitySize, T1.M_VOL_FT_D as VolatilityDecimal,	
	case when (T1.M_DELTA_DEC = 0) then 'Decimal'  
	when (T1.M_DELTA_DEC = 1) then '1/2'  
	when (T1.M_DELTA_DEC = 2) then '1/4'  
	end as Delta,
	case when (T1.M_GAMMA_DEC = 0) then 'Decimal'  
	when (T1.M_GAMMA_DEC = 1) then '1/2'  
	when (T1.M_GAMMA_DEC = 2) then '1/4'  
end as Gamma, 
	T1.M_GAMMA_FF as GammaFactor,T1.M_GAMMA_FT_S as GammaSize, T1.M_GAMMA_FT_D as GammaDecimal, 
	case when (T1.M_VEGA_DEC = 0) then 'Decimal'  
	when (T1.M_VEGA_DEC = 1) then '1/2'  
	when (T1.M_VEGA_DEC= 2) then '1/4'  
end as Vega, 
	T1.M_VEGA_FF as VegaFactor, T1.M_VEGA_FT_S as VegaSize, T1.M_VEGA_FT_D as VegaDecimal, 
	case when (T1.M_RHO_DEC = 0) then 'Decimal'  
	when (T1.M_RHO_DEC = 1) then '1/2'  
	when (T1.M_RHO_DEC= 2) then '1/4'  
	end  as Rho,
	T1.M_RHO_FF as RhoFactor, T1.M_RHO_FT_S as RhoSize, T1.M_RHO_FT_D as RhoDecimal, 
	case when (T1.M_THETA_DEC = 0) then 'Decimal'  
	when (T1.M_THETA_DEC = 1) then '1/2'  
	when (T1.M_THETA_DEC= 2) then '1/4'  
	end as Theta,
	T1.M_THETA_FF as ThetaFactor, T1.M_THETA_FT_S as ThetaSize, T1.M_THETA_FT_D as ThetaDecimal, 
	T1.M_STRIKEINCR as StrikeIncrement,
	CAST(T1.M_DELTAQUOT AS VARCHAR2(14)) as DeltaCurrency, CAST(T1.M_GAMMAQUOT AS VARCHAR2(14)) as GammaCurrency, CAST(T1.M_VEGAQUOT AS VARCHAR2(14)) as VegaCurrency, 
	T1.M_PL_QUOT as PL,T1.M_ROLL_DEF_Q as Roll, 
	case when (M_FXD_SETTL = 0) then 'Delivery' 
	when (M_FXD_SETTL = 1) then 'Cash' 
	end as Settlement, 
	case when (M_FXD_SETTL = 0) then ' ' else T1.M_SETTL_CUR end as SettlementCurrency,
	CAST(T1.M_SMILE_QUOT AS VARCHAR2(16)) as SmileForACallOn,
	/*Smile calculations Flag */
case when ((MOD(T1.M_SM_DT_CALC , 1)) < 1 ) and ((MOD(T1.M_SM_DT_CALC , 2)) >= 1 ) then 'Yes'
	else  'No'
	end as QuotPremiumInDelta,
case when ((MOD(T1.M_SM_DT_CALC , 4)) < 4 ) and ((MOD(T1.M_SM_DT_CALC , 8)) >= 4 ) then 'ATM Forward (F=K)'
	else  'ATM Straddle'
	end as CentralPointShortTerm,
case when ((MOD(T1.M_SM_DT_CALC , 128)) < 128 ) and ((MOD(T1.M_SM_DT_CALC , 256)) >= 128 ) then 'ATM Forward (F=K)'
	else  'ATM Straddle'
	end as CentralPointLongTerm,
CAST(T1.M_SMSTCPCONV AS VARCHAR2(22)) as CentralPointLongExpiry,
case when ((MOD(T1.M_SM_DT_CALC , 16)) < 16 ) and ((MOD(T1.M_SM_DT_CALC , 32)) >= 16 ) then 'Yes'
	else  'No'
	end as SpotDeltaShortTerm,
case when ((MOD(T1.M_SM_DT_CALC , 32)) < 32 ) and ((MOD(T1.M_SM_DT_CALC , 64)) >= 32 ) then 'Yes'
	else  'No'
	end as SpotDeltaLongTerm,
CAST(T1.M_SM_ST_CONV AS VARCHAR2(19)) as SpotDeltaLongExpiry,
	T1.M_SM_DT_CALC as SmileCalculations, 
CAST(T1.M_SM_ST_CONV AS VARCHAR2(19)) as SmileLongConvention,
case when ( T1.M_BROKER_STR = 0 ) then 'Smile'  when ( T1.M_BROKER_STR = 1 ) then 'Broker' end as BrokerStrangle, 
case when (T1.M_RR_REVERT = 0) then 'Call'  when (T1.M_RR_REVERT = 1) then 'Put' end as PositiveRRInFavorOf, 
case when T1.M_SM_BA_MODE = 0 then 'Implied premium spreads' 
	when T1.M_SM_BA_MODE = 1 then 'Implied B/A volatilities'
	when T1.M_SM_BA_MODE = 2 then  'Inherited'
end as SmileBidAskMode,
case when (T1.M_CORRVOL_M= 0) then 'Off' 
		when (T1.M_CORRVOL_M = 1) then 'Implied correlation'
		when (T1.M_CORRVOL_M = 2) then 'Implied volatility'  
	end as CorrelAndVolLink, 
	case when (T1.M_CORRVOL_M= 0) then ' ' else T1.M_CORRVOL_C end as CorrelationCurrency,
case when ( T1.M_VOL_CONV = 0 ) then 'Volatility on calendar days' 
		when ( T1.M_VOL_CONV = 1 ) then 'Volatility on business days'
	end as VolatilityConvention,      
case when (T1.M_SHIFT_MODE in (-1,1) ) then 'Inherited'  
	when (T1.M_SHIFT_MODE in ( 0,1) ) then 'Roll pillar dates and roll vol curve till' 
	end as VolatilityShiftMode,
case when (T1.M_SHIFT_MODE in (-1,1) ) then ' '
	else T1.M_SHIFT_DATE 
end as ShiftDate,
case when (T1.M_SM_INTERP in (0,4)) then 'Inherited'  
	when (T1.M_SM_INTERP = 5) then 'Log-moneyness'
	when (T1.M_SM_INTERP = 1) then 'Delta' 
		when (T1.M_SM_INTERP = 2) then 'Strike'
end  as SmileInterIndex,
case when ((MOD(T1.M_SM_DT_CALC , 64)) < 64 ) and ((MOD(T1.M_SM_DT_CALC , 128)) >= 64 ) then 'Yes'
	else  'No'
end as SmileInterPremDelta,
case when ((MOD(T1.M_SM_DT_CALC , 8)) < 8 ) and ((MOD(T1.M_SM_DT_CALC , 16)) >= 8 ) then 'Put'
	else 'Moneyness'
end as SmileInterScale,
case  when ((MOD(T1.M_SM_DT_CALC , 2)) < 2 ) and ((MOD(T1.M_SM_DT_CALC , 4)) >= 2 ) then 'Yes'
	else 'No'
end as SmileInterSpotDeltaForInter,
case when (T1.M_SM_ITERM  = 1) then 'Linear' 
		when (T1.M_SM_ITERM  = 2) then 'Spline'
		when (T1.M_SM_ITERM  = 3) then 'Polynomial'
	when (T1.M_SM_ITERM  in (0,4)) then 'Inherited' 
		when (T1.M_SM_ITERM  = 5) then 'Smooth'
		when (T1.M_SM_ITERM  = 6) then 'Constrained polynomial'
	end as SmileInterpolationMode,
	T1.M_SIGMA as SigmaForSmoothInterpolation,
	case when (T1.M_SM_EXTRA  = 0) then 'Flat curve'
	when (T1.M_SM_EXTRA = 1) then 'Extrapolate'
	when (T1.M_SM_EXTRA = 4) then 'Inherited'
	end as SmileInterpAtBounds,
case	when (T1.M_SMCOMP = 0)  then 'PL and greeks'
	when (T1.M_SMCOMP = 1)  then 'PL only'
	when (T1.M_SMCOMP = 2)  then 'PL + adapted delta'
	when (T1.M_SMCOMP = 3)  then 'PL + adapted greeks'
	when (T1.M_SMCOMP = -1) then 'Inherited'
	end as UseSmileFor
------
from FX_CNT_DBF T1
left outer join  FXCAT_CNT_DBF T2 on T1.M_CATEGORY = T2.M_REFERENCE
where T1.M_TYPE='OTC'
order by T1.M_LABEL;
quit; 
SPOOL OFF;
/* SMILE_CALCULATIONS (column called T1.M_SM_DT_CALC in FX_CNT_DBF table) encompasses the following fields : 
