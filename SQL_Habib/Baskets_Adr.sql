set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1650;
set pagesize 2048;
select	T1.M_SE_D_LABEL as Label,  T1.M_SE_I_CODE as InternalCode, T1.M_SE_CODE as SecurityCode, T1.M_SE_F_NAME as FullName, 
case when (T7.M_DSP_LABEL is null) then ' ' else T7.M_DSP_LABEL end as IssuerName,
case when (T8.M_LABEL is null) then ' ' else T8.M_LABEL end as Seniority, T1.M_SE_L_MAN as LeadManager,
case when (T1.M_SE_ISSD is null) then ' ' else to_char(T1.M_SE_ISSD) end as IssueDate,
T1.M_SE_NISS  as NumberIssued, T1.M_SE_NOUT as NumberOutstanding,
T1.M_SE_COM0 as Comment0, T1.M_SE_COM1 as Comment1, T1.M_SE_COM2 as Comment2, T1.M_SE_COM3 as Comment3, T1.M_SE_RTF0 as RealTimeRIC0,
T1.M_SE_RTF1 as RealTimeRIC1, T1.M_SE_RTF2 as RealTimeRIC2, T1.M_SE_RTF3 as RealTimeRIC3,T1.M_SE_T_SH as TermSheet,
T11.M_SE_D_LABEL as FistSecurity, CAST(T5.M_SE_COM_M0 AS VARCHAR2(20)) as FirstSecurityMarket, T5.M_SE_COM_W0 as WeightK1, 
T5.M_SE_DIV_P as DividendProportionRepaid, 
case when (T5.M_SE_B_P = 0) then 'Continuously'
     when (T5.M_SE_B_P = 1) then 'Other' end as Published,
case when (T5.M_SE_FX_RULE = 0) then 'Standard/Composite'
when (T5.M_SE_FX_RULE = 1) then 'Quanto' end as MultiCurrencyRule,
case when (T5.M_SE_V_TYPE =0) then 'Global'
when (T5.M_SE_V_TYPE =1) then 'By asset'
when (T5.M_SE_V_TYPE =2) then 'By asset and Smile' end as VolatilityType,
T2.M_SE_MARKET as Market, CAST(T2.M_SE_TRDCL AS VARCHAR2(15))  as TradingClauses, 
CAST(T9.M_SE_CUR AS VARCHAR2(20)) as InheritedCurrrency,
case when (T2.M_SE_CUR<>T9.M_SE_CUR) then T2.M_SE_CUR else ' ' end as CustomizedCurrency,
CAST(T9.M_SE_TCQ_L AS VARCHAR2(20)) as InheritedQuotation,
case when (T2.M_SE_TCQ_L<>T9.M_SE_TCQ_L) then T2.M_SE_TCQ_L else ' ' end as CustomizedQuotation,
CAST(T9.M_SE_TCS_L AS VARCHAR2(20)) as InheritedSettlement,
case when (T2.M_SE_TCS_L<>T9.M_SE_TCS_L) then T2.M_SE_TCS_L else ' ' end as CustomizedSettlement,
case when (T10.M_SE_SEC_LS0 =0) then 1 else T10.M_SE_SEC_LS0 end as InheritedLotSize,
case when (T2.M_SE_SEC_LS0=0) then ' ' 
	when (T2.M_SE_SEC_LS0<>T10.M_SE_SEC_LS0) then to_char(T2.M_SE_SEC_LS0) 
	else ' ' 
end as CustomizedLotSize,
case when (T2.M_SE_FIRSTSD is null) then ' ' when T2.M_SE_FIRSTSD = '19000101' then ' ' else CAST(to_char(T2.M_SE_FIRSTSD) AS VARCHAR2(20)) end as FirstSettlementDate,
case when T2.M_SE_SEC_LS1 = 0 then T10.M_SE_SEC_LS1 else T2.M_SE_SEC_LS1 end as Nominal ,															
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
T2.M_SE_ARCHGRP as ArchivingGroup
-------
-------
from  SE_HEAD_DBF  T1
left outer join TRN_CPDF_DBF T7 on T1.M_SE_ISS =T7.M_LABEL
left outer join RT_SEN_DBF T8 on T1.M_SE_SEN=T8.M_REFERENCE,
SE_ROOT_DBF T2
left outer join SE_SRNDR_DBF T12  on T2.M_SE_RND_R = T12.M_REFERENCE,
-------
SE_TRDC_DBF T9, SE_TRDS_DBF  T10,SE_BK_DBF T5 , SE_HEAD_DBF T11, SE_MKTOP_DBF T4
-------
where T1.M_SE_LABEL = T2.M_SE_LABEL
and T1.M_SE_LABEL = T4.M_SE_LABEL 
and T5.M_SE_INUM =T4.M_SE_INUM 
and T5.M_SE_COM_L0 =T11.M_SE_LABEL
and T1.M_SE_GROUP = 'Basket'
and T1.M_SE_TYPE  = 'Adr'
and T2.M_SE_TRDCL = T9.M_SE_TRDCL 
and T9.M_SE_TCS_L = T10.M_SE_TCS_L
and T2.M_SE_DE = ' '
and 	T4.M_IDENTITY IN (select b.M_IDENTITY
                           from SE_MKTOP_DBF b
                            where b.M_SE_GEN = 
                            (select MAX (a.M_SE_GEN)
                                from SE_MKTOP_DBF a
                                where a.M_SE_LABEL = b.M_SE_LABEL)
                                and b.M_SE_LABEL = T1.M_SE_LABEL)
order by  T1.M_SE_D_LABEL;
quit;
