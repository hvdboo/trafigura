set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1414;
set pagesize 2048;
select T1.M_SE_D_LABEL as Label,
case when (T7.M_BD_TG_MT = 0 ) then 'Conversion' else 'None' end as ClausesType,
case when (T6.M_BD_TGS_FS  = 0) then 'UNCHECKED' else 'CHECKED' end as CRatioFunctionSpot,
case when (T6.M_BD_TGS_FT  = 0) then 'UNCHECKED' else 'CHECKED' end as CRatioFunctionTime,
case when (T6.M_BD_TGS_MWC = 0) then 'UNCHECKED' else 'CHECKED' end as MakeWholeConversion,
case when (T6.M_BD_TGS_CPC = 0) then 'UNCHECKED' else 'CHECKED' end as CashPaidConversion,
case when (T6.M_BD_TGS_CNO = 0) then 'New Shares' else 'Outstanding shares' end as ConvertibleTo,
case when (T6.M_BD_P_TYPE  = 0) then 'Conversion ratio' else 'Conversion price' end as ConversionGivenAs,
case when (T6.M_BD_P_TYPE  = 1) then to_char(T6.M_BD_I_FX) else 'Not applicable' end as InitialFx,
case when (T6.M_BD_TGS_DM  = 0) then 'Business' else 'Calendar' end as DateMode,
case when (T6.M_BD_TGS_CGT = 0) then 'No' else 'Yes' end as Contingent,
case when (T7.M_BD_TG_CPD = 0)  then (case when (T7.M_BD_TG_BD  is null)  then ' ' else to_char(T7.M_BD_TG_BD,'DD MON YY' ) end)
	else 'Conversion Period: Relative'
end as ConversionStart,
case when (T7.M_BD_TG_CPD = 0)  then (case when (T7.M_BD_TG_ED  is null)  then ' ' else to_char(T7.M_BD_TG_ED,'DD MON YY' ) end)
	else 'Conversion Period: Relative'
end as ConversionEnd,
case when (T7.M_BD_TG_MT = 0 ) then (case when (T7.M_BD_TG_CC = 0) then 'No' when (T7.M_BD_TG_CC = 1) then 'Yes' end)
	else 'Not applicable' 
end as Mandatory,
case when (T6.M_BD_TGS_CNO = 0) then to_char(T7.M_BD_TG_FPA0) else to_char(T7.M_BD_TG_FPA1) end as ConvPriceRatioS1T1,
case when (T6.M_BD_TGS_FS  = 1) then (case when (T6.M_BD_TGS_CNO = 0) then to_char(T7.M_BD_TG_SPA0) else to_char(T7.M_BD_TG_SPA1) end)
	else 'CRatio is not a function of spot' 
end as ConvPriceRatioS2T1,
case when (T6.M_BD_TGS_FT  = 1) then (case when (T6.M_BD_TGS_CNO = 0) then to_char(T7.M_BD_TG_TPA0) else to_char(T7.M_BD_TG_TPA1) end)
	else 'CRatio is not a function of time' 
end as ConvPriceRatioS1T2,
case when (T6.M_BD_TGS_FS  = 1) then to_char(T7.M_BD_TG_BLE) else 'CRatio is not a function of spot' end as Spot1, 
case when (T6.M_BD_TGS_FS  = 1) then to_char(T7.M_BD_TG_ELE) else 'CRatio is not a function of spot' end as Spot2,
case when (T7.M_BD_TG_AP = 0) then 'No' else 'Yes' end as AccrualsPaid,
case when (T7.M_BD_TG_CF = 0) then 'No' else	'Yes' end as CouponForfeit,
case when (T6.M_BD_TGS_CGT = 1) then (case when (T7.M_BD_TG_MOD = 1) then 'No' when (T7.M_BD_TG_MOD = 0) then 'Yes' end)
	else 'Not contingent' 
end as ContingentMode,
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then (case when (T7.M_BD_TG_CPD = 0) then 'Absolute' when (T7.M_BD_TG_CPD = 1) then 'Relative' end)
	else 'Not contingent' 
end  as ConversionPeriod,
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then (case	when (T7.M_BD_TG_LT =0 ) then 'None' 
	when (T7.M_BD_TG_LT =1 ) then 'Call'
	when (T7.M_BD_TG_LT =2 ) then 'Rating Below'
	when (T7.M_BD_TG_LT =3 ) then 'Stock price above % C price'
	when (T7.M_BD_TG_LT =4 ) then 'CB price less than %S*parity'
	when (T7.M_BD_TG_LT =5 ) then 'S above % accreted CP' end)
	else 'Not contingent' 
end as TriggerExpression,
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then to_char(T7.M_BD_TG_TV) else 'Not contingent' end as TriggerValue,
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then to_char(T7.M_BD_TG_TS) else 'Not contingent' end as TriggerStart, 
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0) and (T7.M_BD_TG_CPD = 1)) then (case when (T7.M_BD_TG_SS is null) then ' ' else T7.M_BD_TG_SS end)
	when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0) and (T7.M_BD_TG_CPD = 0)) then 'Conversion Period: Absolute' 
	else 'Not contingent' 
end as StartShifter,
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then to_char(T7.M_BD_TG_TE) else 'Not contingent' end as TriggerEnd,
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0) and (T7.M_BD_TG_CPD = 1)) then (case when (T7.M_BD_TG_ES is null) then ' ' else T7.M_BD_TG_ES end)
	when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0) and (T7.M_BD_TG_CPD = 0)) then 'Conversion Period: Absolute'
	else 'Not contingent' 
end as EndShifter,
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then (case when (T7.M_BD_TG_OT = 0) then 'Hard' when (T7.M_BD_TG_OT = 1) then 'Consecutive' when (T7.M_BD_TG_OT = 2) then 'Any' end) 
	else 'Not contingent' 
end as ObservationType, 
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then (case when (T7.M_BD_TG_OT in (1,2)) then to_char(T7.M_BD_TG_NOD) else 'Observation Type: Hard' end)	
else 'Not contingent' end as NumberOfDays,	
case when ((T6.M_BD_TGS_CGT = 1) and (T7.M_BD_TG_MOD = 0)) then (case when (T7.M_BD_TG_OT = 2) then to_char(T7.M_BD_TG_OOF) else 'Observation Type != Any' end)
	else 'Not contingent' 
end as OutOf,
case when (T6.M_BD_TGS_CPC = 1) then (case when (T7.M_BD_TG_SE = 0) then 'Bond+Cash1' when (T7.M_BD_TG_SE = 1) then 'Cash2' when (T7.M_BD_TG_SE = 2) then 'Max(Bond+Cash1,Cash2)' end)
	else 'Cash is not paid on conversion' 
end as Settlement,
case when (T6.M_BD_TGS_CPC = 1) then to_char(T7.M_BD_TG_FCS) else 'Cash is not paid on conversion' end as Cash1, 
case when (T6.M_BD_TGS_CPC = 1) then to_char(T7.M_BD_TG_SCS) else 'Cash is not paid on conversion' end as Cash2,
case when (T6.M_BD_TGS_MWC = 1 ) then to_char(T7.M_BD_TG_MP) else 'Makewhole is not on conversion' end as MakewholePremium, 
case when (T6.M_BD_TGS_MWC = 1 ) then to_char(T7.M_BD_TG_MF) else 'Makewhole is not on conversion' end as MakewholeFloor
from  SE_HEAD_DBF  T1 , SE_ROOT_DBF T2   , TRN_CPDF_DBF T3 , SE_MKTOP_DBF T4 ,  RT_SEN_DBF T5   ,  BD_BOND_DBF  T6 , 
BD_TRIG_DBF T7  , RT_LNSEC_DBF T8  , RT_INSGN_DBF T9 , SE_TRDC_DBF T10 ,  SE_TRDS_DBF T11 ,  RT_LNGN_DBF T12, SE_HEAD_DBF  T13
where T1.M_SE_LABEL	= T2.M_SE_LABEL
and	T1.M_SE_GROUP	= 'Bond'
and T1.M_SE_TYPE	= 'Convert' 
and	T1.M_SE_LABEL	= T4.M_SE_LABEL 
and	T6.M_BD_INUM	= T4.M_SE_INUM 
and T9.M_GEN_NUM 	= T6.M_BD_GEN
and	T2.M_SE_TRDCL 	= T10.M_SE_TRDCL
and	T10.M_SE_TCS_L	= T11.M_SE_TCS_L
and	T9.M_GEN_NUM    = T12.M_GEN_NUM	
and	T13.M_SE_LABEL  = T6.M_BD_EQUITY 
and T1.M_SE_ISS    = T3.M_LABEL (+)
and T4.M_SE_INUM   = T8.M_NB (+)
and T4.M_SE_INUM   = T7.M_BD_INUM 
and T1.M_SE_SEN    = T5.M_REFERENCE (+)
and	T7.M_BD_TG_MT	= 0
order by  T1.M_SE_D_LABEL;
quit;
SPOOL OFF;