set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1785;
set pagesize 2048;
select distinct T1.M_SE_D_LABEL as Label,
CAST(T1.M_SE_GROUP AS VARCHAR2(15)) as InstrumentGroup,
CAST(T1.M_SE_TYPE AS VARCHAR2(15)) as InstrumentType,
T1.M_SE_CATE as Category, 
T1.M_SE_CODE as SecurityCode,
T1.M_SE_I_CODE as InternalCode,
T1.M_SE_F_NAME as FullName,
case when (T3.M_DSP_LABEL is null) then ' ' else T3.M_DSP_LABEL end as Issuer,
case when (T5.M_LABEL is null ) then ' ' else T5.M_LABEL end as Seniority,
T9.M_INSTR as BondGenerator,
case when (T6.M_BD_F_ACC is null) then ' ' else to_char(T6.M_BD_F_ACC, 'DD MON YY') end as IssueDate,
T6.M_BD_I_PRICE as IssuePrice,
T6.M_BD_O_C as Coupon,
case when (T6.M_BD_MAT is null) then ' ' else to_char(T6.M_BD_MAT,'DD MON YY') end as MaturityDate,
case when (T6.M_BD_SP_ACC is null) then ' ' else T6.M_BD_SP_ACC end as SpecialAccrualConv,
case when (T6.M_BD_SP_ACCD is null) then ' ' else to_char(T6.M_BD_SP_ACCD, 'DD MON YY') end as SpecialAccrualDate, 
T13.M_SE_D_LABEL as Underlying,
CAST(T6.M_BD_EMARKET AS VARCHAR2(18)) as UnderlyingMarket,
T2.M_SE_MARKET as Market,
CAST(T2.M_SE_TRDCL AS VARCHAR2(15)) as TradingClauses,
-------
CAST(T10.M_SE_CUR AS VARCHAR2(20)) as InheritedCurrrency, 
case when (T2.M_SE_CUR<>T10.M_SE_CUR) then T2.M_SE_CUR else ' ' end as CustomizedCurrency,
CAST(T10.M_SE_TCQ_L AS VARCHAR2(20)) as InheritedQuotation,
case when (T2.M_SE_TCQ_L<>T10.M_SE_TCQ_L) then T2.M_SE_TCQ_L else ' ' end as CustomizedQuotation,
CAST( T10.M_SE_TCS_L AS VARCHAR2(20)) as InheritedSettlement,
case when (T2.M_SE_TCS_L<>T10.M_SE_TCS_L) then T2.M_SE_TCS_L else ' ' end as CustomizedSettlement,
case when (T11.M_SE_SEC_LS0=0) then 1 else T11.M_SE_SEC_LS0 end as InheritedLotSize,
case when (T2.M_SE_SEC_LS0=0) then ' ' 
when (T2.M_SE_SEC_LS0 <> T11.M_SE_SEC_LS0)   then to_char(T2.M_SE_SEC_LS0)
else ' ' end as CustomizedLotSize,	
case when (T2.M_SE_FIRSTSD is null) then ' ' else to_char(T2.M_SE_FIRSTSD, 'DD MON YY') end as FirstSettlementDate,
T2.M_SE_SEC_LS1 as Nominal,
T14.M_SE_RND_R_L as RoundRuleLab,
case	when (T14.M_SE_TRND_R = 0) then 'None'
when (T14.M_SE_TRND_R = 1) then 'Nearest'
when (T14.M_SE_TRND_R = 2) then 'By default'
when (T14.M_SE_TRND_R = 3) then 'By excess'
end as TAmountRoundingRule,T14.M_SE_TRND_D as TAmountDecimals,
case	when (T14.M_SE_ARND_R = 0) then 'None'
when (T14.M_SE_ARND_R = 1) then 'Nearest'
when (T14.M_SE_ARND_R = 2) then 'By default'
when (T14.M_SE_ARND_R = 3) then 'By excess'
end as AccAmntRoundRule,
T14.M_SE_ARND_D as AccAmntDecimals,
case when (T2.M_SE_AMORTT = 0 ) then 'Nominal' when (T2.M_SE_AMORTT = 1 ) then 'Position' end as AmortizingType
-------
-------
-------
from SE_HEAD_DBF  T1, SE_ROOT_DBF T2, TRN_CPDF_DBF T3 , SE_MKTOP_DBF T4,  RT_SEN_DBF T5,  BD_BOND_DBF  T6 ,
BD_TRIG_DBF T7  , RT_LNSEC_DBF T8  , RT_INSGN_DBF T9 , SE_TRDC_DBF T10 ,  SE_TRDS_DBF T11,  RT_LNGN_DBF T12, SE_HEAD_DBF  T13, SE_SRNDR_DBF T14
-------
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
and T4.M_SE_INUM   = T7.M_BD_INUM (+)
and T1.M_SE_SEN    = T5.M_REFERENCE (+)
and T2.M_SE_RND_R = T14.M_REFERENCE (+)
order by  T1.M_SE_D_LABEL;
quit; 
SPOOL OFF;

