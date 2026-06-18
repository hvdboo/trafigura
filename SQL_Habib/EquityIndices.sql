set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 900;
set pagesize 2048;
select	T1.M_SE_D_LABEL as EquityIndices, CAST(T1.M_SE_GROUP AS VARCHAR2(15)) as InstrumentGroup, 
CAST(T1.M_SE_TYPE AS VARCHAR2(15)) as InstrumentType, T1.M_SE_CATE as Category, 
T1.M_SE_CODE as SecurityCode, T1.M_SE_I_CODE as InternalCode, T1.M_SE_F_NAME as FullName, 
case	when (T8.M_DSP_LABEL is null) then ' ' else T8.M_DSP_LABEL  end as Issuer, 
case	when (T9.M_LABEL is null ) then ' ' else T9.M_LABEL end as Seniority, 
T1.M_SE_RTF0 as RealTimeCode, 
case when (T7.M_SE_D_LABEL is null) then ' ' else T7.M_SE_D_LABEL end as UnderlyingBasket, 
CAST(T6.M_EQ_BMARKET AS VARCHAR2(15)) as BasketMarket, 
case	when (T6.M_EQ_D_R_F = 0) then 'Detached' 
	when (T6.M_EQ_D_R_F = 1) then 'Net amount reinvested' 
	When (T6.M_EQ_D_R_F = 2) then 'Gross amount reinvested' 
	else ' ' 
end as  Dividends, T6.M_EQ_IB_PF as Divisor,
T2.M_SE_MARKET as Market, CAST(T2.M_SE_TRDCL AS VARCHAR2(15))  as TradingClauses, 
CAST(T10.M_SE_CUR AS VARCHAR2(20)) as InheritedCurrrency,
case when (T2.M_SE_CUR<>T10.M_SE_CUR) then T2.M_SE_CUR else ' ' end as CustomizedCurrency,
CAST(T10.M_SE_TCQ_L AS VARCHAR2(20)) as InheritedQuotation,
case when (T2.M_SE_TCQ_L<>T10.M_SE_TCQ_L) then T2.M_SE_TCQ_L else ' ' end as CustomizedQuotation,
CAST(T10.M_SE_TCS_L AS VARCHAR2(20)) as InheritedSettlement,
case when (T2.M_SE_TCS_L<>T10.M_SE_TCS_L) then T2.M_SE_TCS_L else ' ' end as CustomizedSettlement,
case when (T11.M_SE_SEC_LS0=0) then 1 else T11.M_SE_SEC_LS0 end as InheritedLotSize, 
case when (T2.M_SE_SEC_LS0=0) then ' ' 
	when (T2.M_SE_SEC_LS0<>T11.M_SE_SEC_LS0) then to_char(T2.M_SE_SEC_LS0) 
	else ' ' 
end as CustomizedLotSize,
case	when (T2.M_SE_FIRSTSD is null) then ' ' else to_char(T2.M_SE_FIRSTSD) end as FirstSettlementDate,
case when T2.M_SE_SEC_LS1 = 0 then T11.M_SE_SEC_LS1 else T2.M_SE_SEC_LS1 end as Nominal ,
T12.M_SE_RND_R_L as RoundRuleLab,
case	when (T12.M_SE_TRND_R = 0) then 'None' 
when (T12.M_SE_TRND_R = 1) then 'Nearest' 
when (T12.M_SE_TRND_R = 2) then 'By default' 
when (T12.M_SE_TRND_R = 3) then 'By excess' 
end as TAmountRoundingRule,T12.M_SE_TRND_D as TAmountDecimals, 
case	when (T12.M_SE_ARND_R = 0) then 'None' 
when (T12.M_SE_ARND_R = 1) then 'Nearest' 
when (T12.M_SE_ARND_R = 2) then 'By default' 
when (T12.M_SE_ARND_R = 3) then 'By excess' 
end as AccAmntRoundRule,T12.M_SE_ARND_D as AccAmntDecimals,	
case	when (T2.M_SE_AMORTT = 0 ) then 'Nominal'
when (T2.M_SE_AMORTT = 1 ) then 'Position'
end as AmortizingType,		
case	when (T2.M_SE_A_IRF = 1) then T2.M_SE_ARCH else ''
end as ArchivingGroup,
T2.M_SE_ATYPE as CutoffType
from	SE_HEAD_DBF T1, SE_ROOT_DBF T2, SE_MKTOP_DBF T5,EQ_SE_DBF T6, SE_HEAD_DBF T7, TRN_CPDF_DBF T8, 
RT_SEN_DBF T9, SE_TRDC_DBF T10 ,  SE_TRDS_DBF T11, SE_SRNDR_DBF T12
where	T1.M_SE_LABEL=T2.M_SE_LABEL 
and	T1.M_SE_GROUP='Equity' 
and	T1.M_SE_TYPE='Index' 
and 	T2.M_SE_LABEL   = T5.M_SE_LABEL
and	T2.M_SE_TRDCL 	= T10.M_SE_TRDCL 
and	T10.M_SE_TCS_L	= T11.M_SE_TCS_L 
and 	T5.M_SE_INUM   = T6.M_EQ_INUM (+) 
and	T6.M_EQ_BASKET = T7.M_SE_LABEL (+) 
and 	T1.M_SE_ISS    = T8.M_LABEL (+) 
and 	T1.M_SE_SEN    = T9.M_REFERENCE (+)
and T2.M_SE_RND_R = T12.M_REFERENCE (+)
-------
order by T1.M_SE_D_LABEL, T2.M_SE_MARKET;
quit;
SPOOL OFF;
/*this link T1.M_SE_D_LABEL *= T3.M_IND_LAB could be written T1.M_SE_LABEL *= T3.M_RT_SELAB */