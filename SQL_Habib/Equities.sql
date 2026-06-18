set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 750;
set pagesize 2048;
select  T1.M_SE_D_LABEL as Equities,T1.M_SE_F_NAME as FullName, T1.M_SE_I_CODE as InternalCode, T1.M_SE_CODE as SecurityCode,
case when (T1.M_SE_ISS =' ' ) then ' ' else T3.M_DSP_LABEL end as Issuer,T1.M_SE_RTF0 as RealTimeCode,
T2.M_SE_MARKET as Market, CAST(T2.M_SE_TRDCL AS VARCHAR2(15))  as TradingClauses, 
CAST(T6.M_SE_CUR AS VARCHAR2(20)) as InheritedCurrrency,
case when (T2.M_SE_CUR<>T6.M_SE_CUR) then T2.M_SE_CUR else ' ' end as CustomizedCurrency,
CAST(T6.M_SE_TCQ_L AS VARCHAR2(20)) as InheritedQuotation,
case when (T2.M_SE_TCQ_L<>T6.M_SE_TCQ_L) then T2.M_SE_TCQ_L else ' ' end as CustomizedQuotation,
CAST(T6.M_SE_TCS_L AS VARCHAR2(20)) as InheritedSettlement,
case when (T2.M_SE_TCS_L<>T6.M_SE_TCS_L) then T2.M_SE_TCS_L else ' ' end as CustomizedSettlement,
case when (T7.M_SE_SEC_LS0=0) then 1 else T7.M_SE_SEC_LS0 end as InheritedLotSize,
case when (T2.M_SE_SEC_LS0=0) then ' ' 
	when (T2.M_SE_SEC_LS0<>T7.M_SE_SEC_LS0) then to_char(T2.M_SE_SEC_LS0) 
	else  ' ' 
end as CustomizedLotSize,
case when (T2.M_SE_FIRSTSD is null) then ' ' else to_char(T2.M_SE_FIRSTSD) end as FirstSettlementDate,
case when T2.M_SE_SEC_LS1 = 0 then T7.M_SE_SEC_LS1 else T2.M_SE_SEC_LS1 end as Nominal ,														
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
-------
case	when (T2.M_SE_AMORTT = 0 ) then 'Nominal'
when (T2.M_SE_AMORTT = 1 ) then 'Position'
end as AmortizingType, 
case when T2.M_SE_A_IRF = 0 then 'Inherited'
	when T2.M_SE_A_IRF = 1 then 'Redefined'
end as CutOffSetting,
case when T2.M_SE_A_IRF = 1 and T2.M_SE_ARCH is not null then T2.M_SE_ARCH
	else ' '
end as CutOffArchingGroup,
case when T2.M_SE_A_IRF = 1 and T2.M_SE_ATYPE is not null then T2.M_SE_ATYPE
	else ' '
end as CutOffSeries
-------
from  SE_ROOT_DBF T2, SE_TRDC_DBF T6,  SE_TRDS_DBF T7 , SE_HEAD_DBF  T1, TRN_CPDF_DBF T3, SE_SRNDR_DBF T12	
-------
where	T1.M_SE_LABEL = T2.M_SE_LABEL 
and 	T1.M_SE_TYPE  = 'Simple'
and	T1.M_SE_GROUP = 'Equity' 
and	T2.M_SE_TRDCL 	= T6.M_SE_TRDCL 
and	T6.M_SE_TCS_L	= T7.M_SE_TCS_L	
and T1.M_SE_ISS = T3.M_LABEL (+)
and T2.M_SE_RND_R = T12.M_REFERENCE (+)	
-------
order by T1.M_SE_D_LABEL, T2.M_SE_MARKET;
quit;
SPOOL OFF;	
/*  We can replace the	left outer join RT_INDEX_DBF T4  on  T1.M_SE_LABEL =T4.M_RT_SELAB 
	by 		left outer join RT_INDEX_DBF T4  on  T1.M_SE_D_LABEL =T4.M_IND_LAB
 */	