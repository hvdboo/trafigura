set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 420;
set pagesize 2048;
select distinct T1.M_SE_D_LABEL as Label,
T13.M_SE_D_LABEL as Underlying,	CAST(T6.M_BD_EMARKET AS VARCHAR2(18)) as UnderlyingMarket,
T6.M_BD_R_NOM as ReferenceNominal, T6.M_BD_ARH_GRP as PriceSource, 
case when (T6.M_BD_TR_MODE = 0) then 'No' when (T6.M_BD_TR_MODE = 1) then 'Yes' else ' ' end  as TotalReturn,
case when (T6.M_BD_C_PREF  = 0 ) then 'UNCHECKED' else 'CHECKED' end  as Preferred,
case when (T6.M_BD_C_EX = 1) then 'CHECKED' else 'UNCHECKED' end as Exchangeable,
case when (T6.M_BD_C_EX = 1) then (case when (T6.M_BD_C_EXD = 1) then 'Vulnerable' else 'Covered' end)
else	'Not applicable'
 end as ExchangeableFlag,
case when (T6.M_BD_D_CALL = 0) then 'default call' 
when (T6.M_BD_D_CALL = 1) then 'call off'
 else ' '
  end as PriceWith,
case when (T6.M_BD_C_FLEX = 1) THEN 'CHECKED' else 'UNCHECKED' end as flex,
case when (T6.M_BD_C_CQ = 2) then 'Quanto' else 'Standard/Composite' end as MultiCurrencyRule
from SE_HEAD_DBF  T1 , SE_ROOT_DBF T2   , TRN_CPDF_DBF T3 , SE_MKTOP_DBF T4 ,  RT_SEN_DBF T5   ,  BD_BOND_DBF  T6 ,
BD_TRIG_DBF T7  , RT_LNSEC_DBF T8  , RT_INSGN_DBF T9 , SE_TRDC_DBF T10 ,  SE_TRDS_DBF T11 ,  RT_LNGN_DBF T12, SE_HEAD_DBF  T13
where T1.M_SE_LABEL	= T2.M_SE_LABEL
and T1.M_SE_GROUP	= 'Bond'
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
order by  T1.M_SE_D_LABEL;
quit;
SPOOL OFF;