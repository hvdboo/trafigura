set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1400;
set pagesize 2048;
select	T1.M_SE_D_LABEL as EquityFutures,  T1.M_SE_GROUP as Grp, T1.M_SE_TYPE as Type, T1.M_SE_CATE  as Category,T1.M_SE_I_CODE as InternalCode,
        T1.M_SE_CODE as SecurityCode, T1.M_SE_F_NAME as FullName, T1.M_SE_NISS as NumberIssued, T1.M_SE_NOUT as NumberOutstanding,
case when (T6.M_DSP_LABEL is null) then ' ' else T6.M_DSP_LABEL end as IssuerName, 
case when (T7.M_LABEL is null) then ' ' else T7.M_LABEL end as Seniority, T1.M_SE_L_MAN as LeadManager, 
case when (T1.M_SE_ISSD is null) then ' ' else to_char(T1.M_SE_ISSD) end as IssueDate, 
        T1.M_SE_COM0 as Comment0,
        T1.M_SE_COM1 as Comment1, T1.M_SE_COM2 as Comment2, T1.M_SE_COM3 as Comment3, T1.M_SE_RTF0 as RealTimeRIC0, 
T1.M_SE_RTF1 as RealTimeRIC1,
T1.M_SE_RTF2 as RealTimeRIC2, T1.M_SE_RTF3 as RealTimeRIC3,T1.M_SE_T_SH as TermSheet,
-------
        CAST(T2.M_SE_CUR AS VARCHAR2(10)) as Currency, T5.M_SE_D_LABEL as UnderlyingIndex, CAST(T4.M_FU_MARKET AS VARCHAR2(18)) as UnderlyingMarket, T2.M_SE_MARKET as Market, T2.M_SE_TCQ_L as Quotation, 
         T2.M_SE_SEC_LS0 as LotSize, CAST(T2.M_SE_MAT_SET AS VARCHAR2(15)) as MaturitySet,
-------
case when (T4.M_FU_MARG = 0) then 'No' 
     when (T4.M_FU_MARG = 1) then 'Yes' end as Margining,
case when (T4.M_FU_CLEAR is null) then ' ' else T4.M_FU_CLEAR end as ClearingCenter,
-------
case when (T4.M_FU_MARG_FQ = 0) then 'Daily'
     when (T4.M_FU_MARG_FQ = 3) then 'Fist Margin Call Date Shifted' 
      else ' ' end as MarginingFrequency,
-------
T4.M_FU_MSH as MarginShifter,
case when (T4.M_FU_MARG_F = 0) then 'Fut Currency'
     when (T4.M_FU_MARG_F = 5) then 'Other Currency' end as MarginBasedOn,
case when (T4.M_FU_VBYMAT = 0) then 'No'
     when (T4.M_FU_VBYMAT = 1) then 'Yes' end as VolatilityByMaturity,
case when (T4.M_FU_FX_RUL = 0) then 'Basic'
     when (T4.M_FU_FX_RUL = 1) then 'Composite'
     when (T4.M_FU_FX_RUL = 2) then 'Quanto' end as MultiCurrency,
case when (T4.M_FU_DIV = 0) then 'No'
     when (T4.M_FU_DIV = 1) then 'Yes' end as DividendFuture  
-------
from SE_HEAD_DBF T1, SE_ROOT_DBF T2, SE_MKTOP_DBF T3, FU_FUT_DBF T4, SE_HEAD_DBF T5, TRN_CPDF_DBF T6, RT_SEN_DBF T7
where  T1.M_SE_LABEL=T2.M_SE_LABEL
and T1.M_SE_GROUP='Future' 
and T1.M_SE_TYPE= 'Plain'
and T1.M_SE_CATE='Equity'
and T1.M_SE_LABEL=T3.M_SE_LABEL
and T3.M_SE_INUM=T4.M_FU_INUM
and T4.M_FU_UNDERL=T5.M_SE_LABEL
and T1.M_SE_ISS = T6.M_LABEL (+)
and T1.M_SE_SEN = T7.M_REFERENCE (+)
order by T1.M_SE_D_LABEL;
quit;
SPOOL OFF;