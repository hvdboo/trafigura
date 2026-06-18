
select distinct
rtrim(pfl.M_LABEL)      PFL,
rtrim(udf.M_RMDCOD)     RMD,
rtrim(srd.M_BZL)        BZLSRD,
rtrim(udf.M_PTFCAT)     CAT,
rtrim(udf.M_STRATEGY_C) STG,
rtrim(ext.M_PTF_STREAM) BZLSTL,
case when substr(srd.M_BZL,1,3) = rtrim(ext.M_PTF_STREAM) then 1 else 0 end COMP1,
case 
when rtrim(udf.M_PTFCAT) in ('F','S') then
   case
   when rtrim(pfl.M_LABEL) in
(
'BKEX IMA PTED'
) 
   then 'BLK'   
   when rtrim(pfl.M_LABEL) in 
(
'DFOP MSI TMPI',
'DFOT MSI TMPI',
'DFOT SFR TMPI',
'DFTS MSI TMPI'
)
   then 'CHN'

   else 'DRN' end
else substr(srd.M_BZL,1,3) end BZLSQL

from DLV_CASH_DBF csh
left join DLV_CASHE_DBF ext on csh.M_REFERENCE = ext.M_REFERENCE
left join TRN_PFLD_DBF  pfl on csh.M_PORTFOLIO = pfl.M_REF
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join VIW_SRD_DBF srd on rtrim(udf.M_RMDCOD) = srd.M_ORA

where 1 = 1
and csh.M_STP_STATUS = 'Netted'
and to_char(csh.M_VAL_DATE,'YYYY-MM-DD') > '2024-09-30'

order by PFL
