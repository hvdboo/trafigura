
select 
rtrim(pfl.M_LABEL) PFLLAB,
rtrim(substr(pfl.M_COMMENT0,10,10)) STA,
rtrim(udfpfl.M_RMDCOD)     ACS,
substr(pfl.M_LABEL,1,2)    LAB12,
rtrim(udfpfl.M_STREAM_C)   PFLSTR,
rtrim(udfacs.M_STR)        ACSSTR,
case when substr(pfl.M_LABEL,1,2)  = rtrim(udfpfl.M_STREAM_C) then 1 else 0 end LABPFL,
case when rtrim(udfpfl.M_STREAM_C) = rtrim(udfacs.M_STR) then 1 else 0 end      PFLACS,
substr(pfl.M_LABEL,3,2)    LAB34,
rtrim(udfpfl.M_STRATEGY_C) STGY,
case when substr(pfl.M_LABEL,3,2) = rtrim(udfpfl.M_STRATEGY_C) then 1 else 0 end DIFFSTG
--substr(pfl.M_LABEL,6,3) LAB678,

from TRN_PFLD_DBF pfl
left join TABLE#DATA#PORTFOLI_DBF udfpfl on rtrim(pfl.M_LABEL) = rtrim(udfpfl.M_LABEL)
left join TRN_ACSC_DBF acs on rtrim(udfpfl.M_RMDCOD) = rtrim(acs.M_LABEL)
left join TABLE#DATA#ACCSECTI_DBF udfacs on rtrim(acs.M_LABEL) = rtrim(udfacs.M_LABEL)

where 1 = 1
and rtrim(pfl.M_COMMENT0) is null
--and substr(pfl.M_LABEL,1,2) = 'NG'

order by PFLLAB

