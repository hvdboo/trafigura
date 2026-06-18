set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2048;
set pagesize 2048;
set feedback off;

select	T1.M_SE_D_LABEL as Label,  T1.M_SE_GROUP as InstrumentGroup, T1.M_SE_TYPE as InstrumentType, T1.M_SE_CATE as Category,
T1.M_SE_CODE as SecurityCode, T1.M_SE_I_CODE as InternalCode, T1.M_SE_F_NAME as FullName,
case when (T3.M_DSP_LABEL is null) then ' ' else T3.M_DSP_LABEL  end as Issuer,
T6.M_SE_D_LABEL as Underlying,	T4.M_EQ_MARKET as UnderlyingMarket,
case when T4.M_EQ_PUTCALL =0 then 'Call' when T4.M_EQ_PUTCALL =1 then 'Put' end  as PutCall,
case when T4.M_EQ_OPT_SE =0 then 'Delivery' when T4.M_EQ_OPT_SE =1 then 'Cash' end as CashDelivery,
case when T4.M_EQ_FWD_S =0 then 'Standard start'
	when T4.M_EQ_FWD_S =1 then 'Forward start'
	when T4.M_EQ_FWD_S =2 then 'Compound'
	when T4.M_EQ_FWD_S =3 then 'Forward/Compound'
	when T4.M_EQ_FWD_S =4 then 'Forward start ratio'
end as StartMode,
case when (T4.M_EQ_FWD_D0 is null) then ' ' else to_char(T4.M_EQ_FWD_D0) end as ForwardDate,
T4.M_EQ_FWD_K as ForwardStrike,
case when T4.M_EQ_FWD_CP =0 then 'Call on option'
when T4.M_EQ_FWD_CP=1 then 'Put on option'
end as Position,
case when (T4.M_EQ_OMAT is null) then ' ' else to_char(T4.M_EQ_OMAT) end as MaturityDate,
T4.M_EQ_STRIKE as Strike,
case when T4.M_EQ_CAP_F=0 then 'No'
	when T4.M_EQ_CAP_F =1 then 'Yes'
	when T4.M_EQ_CAP_F = 2 then 'MCap'
end  as Cap,
T4.M_EQ_CAP as CapValue,T4.M_EQ_DIVI as NominalMode, T4.M_EQ_F_VAL as Denomination, T4.M_EQ_F_FX as FixedFx,
case when T4.M_EQ_FX_RUL=0 then '(S-K) X'
	when T4.M_EQ_FX_RUL=1 then '(SX-K)'
	when T4.M_EQ_FX_RUL= 2 then '(S.1-K)'
end as FxRule,
T4.M_EQ_FX_SPT as Fx,
case when T4.M_EQ_OPT_ST =0 then 'American'
	when T4.M_EQ_OPT_ST  =1 then 'European'
	when T4.M_EQ_OPT_ST  = 2 then 'Deferred American'
end  as OptionStyle,
case when T4.M_EQ_PO =0 then 'Standard'
	when T4.M_EQ_PO=1 then 'Digital'
end  as StdType,
case when T4.M_EQ_EX_CUR =0 then 'in warrant currency'
when T4.M_EQ_EX_CUR=1 then 'in underlying currency'
end  as Exercise,
case when (T4.M_EQ_DA_FE_D is null) then ' ' else to_char(T4.M_EQ_DA_FE_D) end as FirstExercise,
case when T4.M_EQ_R_MOD =0 then 'Default model'
	when T4.M_EQ_R_MOD=1 then 'Specific model'
end as Model,
case when T4.M_EQ_MODEL= 0   then 'Black Fwd'
	when T4.M_EQ_MODEL= 2   then 'Cox Fwd'
	when T4.M_EQ_MODEL= 22  then 'Cox Fwd P'
	when T4.M_EQ_MODEL= 23  then 'Cox Fwd MP'
	when T4.M_EQ_MODEL= -1  then 'User 1'
	when T4.M_EQ_MODEL= -2  then 'User 2'
	when T4.M_EQ_MODEL= -3  then 'User 3'
	when T4.M_EQ_MODEL= -4  then 'User 4'
	when T4.M_EQ_MODEL= -5  then 'User 5'
	when T4.M_EQ_MODEL= -6  then 'User 6'
	when T4.M_EQ_MODEL= -7  then 'User 7'
	when T4.M_EQ_MODEL= -8  then 'User 8'
	when T4.M_EQ_MODEL= -9  then 'User 9'
	when T4.M_EQ_MODEL= -10 then 'User 10'
	when T4.M_EQ_MODEL= -11 then 'User 11'
	when T4.M_EQ_MODEL= -12 then 'User 12'
	when T4.M_EQ_MODEL= -13 then 'User 13'
	when T4.M_EQ_MODEL= -14 then 'User 14'
	when T4.M_EQ_MODEL= -15 then 'User 15'
end as ModelType,
T4.M_EQ_IT0 as ModelValue1,T4.M_EQ_IT1 as ModelValue2,
case when T4.M_EQ_ECONVF =0 then 'Inherited'
	when T4.M_EQ_ECONVF=1 then 'Redefined'
end  as UnderlyingConventionFlag,
T4.M_EQ_ECONV as UnderlyingConvention,
case when (T4.M_EQ_ECONVP is null) then ' ' else to_char(T4.M_EQ_ECONVP) end as PaymentDate,
case when (T4.M_EQ_ECONVC is null) then ' ' else to_char(T4.M_EQ_ECONVC) end as CouponDate,
case when T4.M_EQ_CCONVF=0 then 'Inherited'
	when T4.M_EQ_CCONVF=1 then 'Redefined'
end as FinalPaymentFlag,
T4.M_EQ_CCONV as FinalPaymentShifter,
case when (T4.M_EQ_CCONVP is null) then ' ' else to_char(T4.M_EQ_CCONVP) end as PremiumDate,
case when 	T4.M_EQ_PROP_F=0 then 'Parity'
	when T4.M_EQ_PROP_F =1 then 'Ratio'
end as RatioParity,
T4.M_EQ_MULT as Numerator,T2.M_SE_MARKET as Market, T2.M_SE_TRDCL  as TradingClauses,
T8.M_SE_CUR as InheritedCurrrency, case when T8.M_SE_CUR <> T2.M_SE_CUR then T2.M_SE_CUR else ' ' end as CustomizedCurrency,
T8.M_SE_TCQ_L as InheritedQuotation, case when T8.M_SE_TCQ_L <> T2.M_SE_TCQ_L then T2.M_SE_TCQ_L else ' ' end  as CustomizedQuotation,
T8.M_SE_TCS_L as InheritedSettlement, case when T8.M_SE_TCS_L <> T2.M_SE_TCS_L then T2.M_SE_TCS_L else ' ' end  as CustomizedSettlement,
T9.M_SE_SEC_LS0 as InheritedLotSize, case when T9.M_SE_SEC_LS0 <> T2.M_SE_SEC_LS0 then T2.M_SE_SEC_LS0 else 0 end  as CustomizedLotSize,
case	when (T2.M_SE_FIRSTSD is null) then ' ' else to_char(T2.M_SE_FIRSTSD) end as FirstSettlementDate,
case when T2.M_SE_SEC_LS1 = 0 then T9.M_SE_SEC_LS1 else T2.M_SE_SEC_LS1 end as Nominal ,
------
T10.M_SE_RND_R_L as RoundRuleLab,
case	when (T10.M_SE_TRND_R = 0) then 'None'
when (T10.M_SE_TRND_R = 1) then 'Nearest'		
when (T10.M_SE_TRND_R = 2) then 'By default'
when (T10.M_SE_TRND_R = 3) then 'By excess'					
end as TAmountRoundingRule,T10.M_SE_TRND_D as TAmountDecimals,
case	when (T10.M_SE_ARND_R = 0) then 'None'
when (T10.M_SE_ARND_R = 1) then 'Nearest'		
when (T10.M_SE_ARND_R = 2) then 'By default'
when (T10.M_SE_ARND_R = 3) then 'By excess'	
end as AccAmntRoundRule,T10.M_SE_ARND_D as AccAmntDecimals,	
------
case when T2.M_SE_AMORTT =0 then 'Nominal'
	when T2.M_SE_AMORTT =1 then 'Position'
end as AmortizingType 
from SE_HEAD_DBF T1 , SE_ROOT_DBF T2 , TRN_CPDF_DBF T3 , OP_SOW_DBF  T4, SE_MKTOP_DBF T5, SE_HEAD_DBF T6, RT_SEN_DBF T7,
SE_TRDC_DBF T8, SE_TRDS_DBF T9, SE_SRNDR_DBF T10
where T1.M_SE_LABEL = T2.M_SE_LABEL
and	T1.M_SE_LABEL = T5.M_SE_LABEL
and T4.M_EQ_INUM  = T5.M_SE_INUM
and	T2.M_SE_TRDCL = T8.M_SE_TRDCL
and T8.M_SE_TCS_L = T9.M_SE_TCS_L
and T1.M_SE_GROUP = 'Warrant'
and T4.M_EQ_RTYPE = 'INSTR'
and	T4.M_EQ_UNDERL = T6.M_SE_LABEL (+)
and	T1.M_SE_SEN  = T7.M_REFERENCE (+)
and	T1.M_SE_ISS = T3.M_LABEL (+)
and T2.M_SE_RND_R = T10.M_REFERENCE (+)
------
and T4.M_EQ_OMAT >= '19000101' 
order by T1.M_SE_D_LABEL;
quit;
SPOOL OFF;
