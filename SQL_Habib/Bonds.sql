set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1740;
set pagesize 2048;
select T1.M_SE_D_LABEL as Label,
 case  
when T17.M_NODE_REF = 48 then 'ShortPapers'
when T17.M_NODE_REF = 49 then 'Bonds'
end as Classification,
T1.M_SE_CODE as SecurityCode, T1.M_SE_I_CODE as InternalCode, T1.M_SE_F_NAME as FullName,
case when (T3.M_DSP_LABEL is null) then ' ' else T3.M_DSP_LABEL  end as Issuer,
case when (T7.M_LABEL is null ) then ' ' else T7.M_LABEL end as Seniority,
case when (T11.M_LABEL is null ) then ' ' else T11.M_LABEL end as RankingSource,
T1.M_SE_COUP as Coupon, CAST(to_char(T4.M_BD_F_ACC,'DD MON YY') AS VARCHAR2(15)) as FirstAcDate, to_char(T1.M_SE_MAT,'DD MON YY') as Maturity,
T6.M_INSTR as Generator, T2.M_SE_MARKET as Market,
case when (T2.M_SE_DE = 'Y') then 'Yes' else 'No' end as MarketLogDeleted,
CAST(T2.M_SE_TRDCL AS VARCHAR2(15))  as TradingClauses,CAST(T8.M_SE_CUR AS VARCHAR2(20)) as InheritedCurrrency,
-------
case when (T2.M_SE_CUR<>T8.M_SE_CUR) then T2.M_SE_CUR else ' ' end as CustomizedCurrency,
CAST(T8.M_SE_TCQ_L AS VARCHAR2(20)) as InheritedQuotation,
case when (T2.M_SE_TCQ_L<>T8.M_SE_TCQ_L) then T2.M_SE_TCQ_L else ' ' end as CustomizedQuotation,
CAST(T8.M_SE_TCS_L AS VARCHAR2(20)) as InheritedSettlement,
case when (T2.M_SE_TCS_L<>T8.M_SE_TCS_L) then T2.M_SE_TCS_L else ' ' end as CustomizedSettlement,
case when (T9.M_SE_SEC_LS0=0) then 1 else T9.M_SE_SEC_LS0 end as InheritedLotSize,
-------
case when (T2.M_SE_SEC_LS0=0) then ' ' 
when (T2.M_SE_SEC_LS0 <> T9.M_SE_SEC_LS0)   then to_char(T2.M_SE_SEC_LS0)
else ' ' end as CustomizedLotSize,
case when (T4.M_BD_RT_STOR=0) then 'No'
when (T4.M_BD_RT_STOR=1) then 'Yes' 
end as Customized,
case when (T4.M_PR_CM_MD=0) then 'Standard'
when (T4.M_PR_CM_MD=1) then 'Inclusive'
end as PriceMode,


case	when (T2.M_SE_A_IRF = 1) then T2.M_SE_ARCH else ''
end as ArchivingGroup,

T2.M_SE_ATYPE as CutoffType,
-------
case when (T16.M_CREAT_MODE in (0,1))  and (T16.M_BROKEN in (0,1)) then ' ' 
	 when T10.M_ROLL_DATE0 is not null then to_char(T10.M_ROLL_DATE0,'DD MON YY') 
       when T10.M_ROLL_DATE0 is null and T6.M_BROKEN =3 then to_char(T1.M_SE_MAT,'DD MON YY')
       when T10.M_ROLL_DATE0 is null and T6.M_BROKEN =5 then to_char(T4.M_BD_F_ACC,'DD MON YY')
      when T10.M_ROLL_DATE0  is null and T6.M_BROKEN in (0,1) then ' '
end as RollDate,
case when (T10.M_NPAR_REP0 = 1)  then to_char(T10.M_REP_FACT0) else ' ' end as Repayment,
-------
	case when (T2.M_SE_FIRSTSD is null) then ' ' else to_char(T2.M_SE_FIRSTSD) end as FirstSettlementDate,	
-------
-------
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
end as AccAmntRoundRule,
T12.M_SE_ARND_D as AccAmntDecimals,	
case when (T2.M_SE_AMORTT = 0 ) then 'Nominal'
when (T2.M_SE_AMORTT = 1 ) then 'Position'
end as AmortizingType
-------
-------
from  SE_ROOT_DBF T2,  BD_BOND_DBF T4 , SE_MKTOP_DBF T5, RT_INSGN_DBF T6, SE_TRDC_DBF T8, SE_TRDS_DBF T9, SE_HEAD_DBF  T1, RT_SEN_DBF T7, TRN_CPDF_DBF T3, 
RT_LNSEC_DBF T10 , RNK_SRC_DBF T11, SE_SRNDR_DBF T12,RT_INSGN_DBF T16,CSF_CLASSIFICATION_DBF  T17,CSF_JOIN_DBF T18
-------
where T1.M_SE_LABEL = T2.M_SE_LABEL
and T4.M_BD_INUM  = T5.M_SE_INUM
and T1.M_SE_LABEL = T5.M_SE_LABEL
and T4.M_BD_GEN = T6.M_GEN_NUM
and T2.M_SE_TRDCL = T8.M_SE_TRDCL
and T8.M_SE_TCS_L = T9.M_SE_TCS_L
and T1.M_SE_GROUP ='Bond'
and T1.M_SE_TYPE='Coupon'
and T1.M_SE_SEN = T7.M_REFERENCE(+)
and T1.M_SE_ISS = T3.M_LABEL(+)
and T4.M_BD_INUM = T10.M_NB(+)
and  T1.M_SE_LABEL=T17.M_OBJ_LABEL(+)
and T17.M_JOIN=T18.M_REFERENCE(+)
and T1.M_RANK_SRC = T11.M_REFERENCE(+) 
and T2.M_SE_RND_R = T12.M_REFERENCE(+)
and T10.M_GEN_NUM = T16.M_GEN_NUM (+)
-------
and case when T10.M_IDENTITY is null then 0 else T10.M_IDENTITY end in
(select min(M_IDENTITY) from RT_LNSEC_DBF group by M_NB UNION select 0 from DUAL)
and  T18.M_LABEL='SecurityJoin'
-------
order by T1.M_SE_D_LABEL;
quit;
SPOOL OFF;
