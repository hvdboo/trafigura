set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1644;
set pagesize 2048;
select	T1.M_SE_D_LABEL as Label ,  CAST(T1.M_SE_GROUP AS VARCHAR2(16)) as InstrumentGroup, CAST(T1.M_SE_TYPE AS VARCHAR2(15)) as InstrumentType, T1.M_SE_CATE as Category,	
T1.M_SE_CODE as SecurityCode, T1.M_SE_I_CODE as InternalCode, T1.M_SE_F_NAME as FullName,
case when (T3.M_DSP_LABEL is null) then ' ' else T3.M_DSP_LABEL  end as Issuer,
case when (T7.M_LABEL is null) then ' ' else T7.M_LABEL end as Seniority,
T13.M_INSTR as BondGenerator,
case	when (T8.M_BD_F_ACC is null) then ' ' else to_char(T8.M_BD_F_ACC) end as IssueDate,
T8.M_BD_I_PRICE as IssuePrice, T8.M_BD_O_C as Coupon,
case	when (T8.M_BD_MAT is null) then ' ' else to_char(T8.M_BD_MAT) end as MaturityDate,
CAST(T8.M_BD_SP_ACC AS VARCHAR2(19)) as SpecialAccrualConv,
case	when (T8.M_BD_SP_ACCD is null) then ' ' else to_char(T8.M_BD_SP_ACCD) end  as SpecialAccrualDate,
T6.M_SE_D_LABEL as Underlying, CAST(T4.M_EQ_MARKET AS VARCHAR2(17)) as UnderlyingMarket,
T4.M_EQ_PUTCALL as  PutCall, T4.M_EQ_STRIKE as Strike,
T4.M_EQ_CAP_F as Cap, T4.M_EQ_CAP as CapValue,	T4.M_EQ_MULT as Participation, CAST(T4.M_EQ_OSTYPE AS VARCHAR2(11)) as OptionType,
T11.M_PRIVATE as  FixingType, T11.M_GENERATOR as FixingGenerator,
case when (T11.M_VALUE1 is null) then ' ' else to_char(T11.M_VALUE1) end  as FixingFrom,
case when (T11.M_VALUE2 is null) then ' ' else to_char(T11.M_VALUE2) end  as FixingTo,
T11.M_COMMENT as Comments,
case when (T11.M_PAYMENT =0 ) then 'Maturity' else 'Knock time' end as Payment,
case when (T12.M_DATES  is null) then ' ' else to_char(T12.M_DATES) end as FixingDate, T12.M_WEIGHT as FixingValue,
case when (T9.M_BD_TG_MT = 0 ) then 'Conversion'
	when (T9.M_BD_TG_MT = 1 ) then 'Call'
	when (T9.M_BD_TG_MT = 2 ) then 'Put'
	when (T9.M_BD_TG_MT = 3 ) then 'Reset'
	else 'None'
end as ClausesType,
case when ((T9.M_BD_TG_MT = 1 ) and (T8.M_BD_TGS_CMW = 0)) then 'UNCHECKED'
	when ((T9.M_BD_TG_MT = 1 ) and (T8.M_BD_TGS_CMW = 1)) then 'CHECKED'
	else ' '
end  as MakeWholeConversion,
case when (T9.M_BD_TG_MT = 1 ) then (case when (T8.M_BD_TGS_CDM = 0) then 'Business' else 'Calendar' end)
	when (T9.M_BD_TG_MT = 2 ) then (case when (T8.M_BD_TGS_PDM = 0) then 'Business' else 'Calendar' end)
	else ' ' end as DateMode,
case when (T9.M_BD_TG_BD  is null) then ' ' else  to_char(T9.M_BD_TG_BD) end as StartDate,
case when (T9.M_BD_TG_ED  is null) then ' '  else to_char(T9.M_BD_TG_ED) end as EndDate,
case when (T9.M_BD_TG_TY = 0) then 'Price'
	when (T9.M_BD_TG_TY = 1) then 'Yield'
	else ' ' 
end as RepaymentType,
T9.M_BD_TG_FPA0 as Repayment, 
case when (T9.M_BD_TG_MOD = 0) then 'No'
	when (T9.M_BD_TG_MOD = 1) then 'Yes'
	else ' ' 
end as TriggerMode,
case when (T9.M_BD_TG_LT =0 ) then 'Abs'
	when (T9.M_BD_TG_LT =1 ) then '%Re'
	when (T9.M_BD_TG_LT =2 ) then '% of initial CP'
	when (T9.M_BD_TG_LT =3 ) then '% of current CP'
	else ' '
end as TriggerExpression,
T9.M_BD_TG_LE as TriggerValue,
case when (T9.M_BD_TG_OT = 0) then 'Hard'
when (T9.M_BD_TG_OT = 1) then 'Consecutive'
when (T9.M_BD_TG_OT = 2) then 'Any'
else ' ' end as ObservationType,
T9.M_BD_TG_NOD as NumberOfDays,
case when (T9.M_BD_TG_MAT = 0) then 'UNCHECKED' 
	when (T9.M_BD_TG_MAT= 1) then 'CHECKED' 
end as Maturity, T9.M_BD_TG_CD as NoticePeriod,
case when (T9.M_BD_TG_LND  is null) then ' ' else to_char(T9.M_BD_TG_LND) end as LastNoticeDate,
case when (T9.M_BD_TG_AP = 0) then 'No'
	when (T9.M_BD_TG_AP = 1) then 'Yes'
	else ' '
end as AccrualsPaid,
case when (T9.M_BD_TG_CF = 0) then 'No'
	when (T9.M_BD_TG_CF = 1) then 'Yes'
	else ' ' 
end as CouponForfeit,
T2.M_SE_MARKET as Market, CAST(T2.M_SE_TRDCL AS VARCHAR2(15)) as TradingClauses,
CAST(T14.M_SE_CUR AS VARCHAR2(19)) as InheritedCurrrency, CAST(T2.M_SE_CUR AS VARCHAR2(19)) as CustomizedCurrency,
CAST(T14.M_SE_TCQ_L AS VARCHAR2(19)) as InheritedQuotation, CAST(T2.M_SE_TCQ_L AS VARCHAR2(20)) as CustomizedQuotation,
CAST(T14.M_SE_TCS_L AS VARCHAR2(20)) as InheritedSettlement, CAST(T2.M_SE_TCS_L AS VARCHAR2(21)) as CustomizedSettlement,
T15.M_SE_SEC_LS0 as InheritedLotSize, T2.M_SE_SEC_LS0 as CustomizedLotSize,	
case when (T2.M_SE_FIRSTSD is null) then ' ' else to_char(T2.M_SE_FIRSTSD) end as FirstSettlementDate,
T2.M_SE_SEC_LS1 as Nominal,
-------
T16.M_SE_RND_R_L as RoundRuleLab,
case	when (T16.M_SE_TRND_R = 0) then 'None' 	
when (T16.M_SE_TRND_R = 1) then 'Nearest' 
when (T16.M_SE_TRND_R = 2) then 'By default' 
when (T16.M_SE_TRND_R = 3) then 'By excess'	
end as TAmountRoundingRule,T16.M_SE_TRND_D as TAmountDecimals, 
case	when (T16.M_SE_ARND_R = 0) then 'None' 	
when (T16.M_SE_ARND_R = 1) then 'Nearest' 
when (T16.M_SE_ARND_R = 2) then 'By default' 
when (T16.M_SE_ARND_R = 3) then 'By excess'	
end as AccAmntRoundRule,T16.M_SE_ARND_D as AccAmntDecimals,
	-------
case when (T2.M_SE_AMORTT = 0 ) then 'Nominal'
	when (T2.M_SE_AMORTT = 1 ) then 'Position'
end as AmortizingType
from SE_HEAD_DBF  T1, SE_ROOT_DBF T2, TRN_CPDF_DBF T3, OP_SOW_DBF T4 , SE_MKTOP_DBF T5 , SE_HEAD_DBF T6, RT_SEN_DBF T7, BD_BOND_DBF T8, 
BD_TRIG_DBF T9 , RT_LNSEC_DBF  T10  , FIXSD_HD_DBF T11, FIXSD_DT_DBF T12, RT_INSGN_DBF T13,	SE_TRDC_DBF T14 ,  SE_TRDS_DBF T15, SE_SRNDR_DBF T16
where T1.M_SE_LABEL   = T2.M_SE_LABEL	
and T1.M_SE_GROUP   = 'Bond'
and T1.M_SE_TYPE    = 'S.Indexed' 
and T1.M_SE_LABEL   = T5.M_SE_LABEL 
and T8.M_BD_INUM    = T5.M_SE_INUM 
and T13.M_GEN_NUM   = T8.M_BD_GEN 
and T2.M_SE_TRDCL   = T14.M_SE_TRDCL 
and T14.M_SE_TCS_L  = T15.M_SE_TCS_L 
and T5.M_SE_INUM   = T4.M_EQ_INUM (+)
and T1.M_SE_ISS    = T3.M_LABEL (+)
and T5.M_SE_INUM   = T10.M_NB (+)
and T5.M_SE_INUM   = T9.M_BD_INUM (+)
and T4.M_EQ_UNDERL = T6.M_SE_LABEL (+)
and T1.M_SE_SEN    = T7.M_REFERENCE	 (+)
and T5.M_SE_INUM   = T11.M_INT_NB (+)
and T11.M_LINK     = T12.M_LINK (+)
and T2.M_SE_RND_R = T16.M_REFERENCE (+)
order by  T1.M_SE_D_LABEL;
quit;
SPOOL OFF;