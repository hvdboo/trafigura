
select
rtrim(pfl.M_LABEL)          SRCLAB,
rtrim(pfl.M_COMMENT1)       TGTLAB,
rtrim(udf.M_RMDCOD)         RMD,
rtrim(pfl.M_ACCSECTION)     ACS,
rtrim(udf.M_STREAM)         STREAM,
rtrim(udf.M_STREAM_C)       STR,
substr(pfl.M_COMMENT1,1,2)  STRTGT, 
rtrim(udf.M_STRATEGY)       STRATEGY,
rtrim(udf.M_STRATEGY_C)     STG,
substr(pfl.M_COMMENT1,3,2)  STGTGT,
rtrim(udf.M_MASTRDSK)       MASDSK,
rtrim(udf.M_MASTRDSK_C)     MDK,
substr(pfl.M_COMMENT1,6,3)  MDKTGT,
case 
when substr(pfl.M_LABEL,6,3) in 
(select rtrim(atr.M_CODE) from TABLE#LIST#ATTR_DBF atr where rtrim(atr.M_TYPE) = 'Owner' and substr(atr.M_DESC,1,1) <> '_')
then rtrim(udf.M_OWNER)
else null end               OWNUSR,
case 
when substr(pfl.M_LABEL,6,3) in 
(select rtrim(atr.M_CODE) from TABLE#LIST#ATTR_DBF atr where rtrim(atr.M_TYPE) = 'Owner' and substr(atr.M_DESC,1,1) <> '_')
then null
else rtrim(udf.M_OWNER) end OWNASS,
rtrim(udf.M_OWNER)          OWNER,
rtrim(udf.M_OWNER_C)        OWNC,
substr(pfl.M_COMMENT1,6,3)  OWNTGT,
rtrim(udf.M_PTFTYPE)        CATEGORY,
rtrim(udf.M_PTFCAT)         CAT,
substr(pfl.M_COMMENT1,10,1) CATTGT,
rtrim(cto.M_DSP_LABEL)      LE,
rtrim(pfl.M_DESC)           SRCDES,
pfl.M_REF                   PFLREF

from TRN_PFLD_DBF pfl
left join TRD_SEC_DBF trd on pfl.M_TRDSECTION = trd.M_ID
left join TRN_ACSC_DBF acc on rtrim(pfl.M_ACCSECTION) = rtrim(acc.M_LABEL)
left join TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID
left join TRN_CPDF_DBF cts on pfl.M_SERVICER  = cts.M_ID
left join TRN_CPDF_DBF ctc on rtrim(pfl.M_LABEL) = rtrim(ctc.M_COMMENT0)
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join KEYMAP_STC_DBF alt on (rtrim(pfl.M_LABEL) = rtrim(alt.M_OBJ_DESC) and alt.M_OBJ_CLASS = 'MJkQC54506' and rtrim(alt.M_OBJ_ASYS) = 'SRD')
left join UDTB251_DBF lut on (
rtrim(udf.M_STREAM) = rtrim(lut.M_STREAM) and
rtrim(udf.M_PTFTYPE) = rtrim(lut.M_PTFTYPE) and
rtrim(lut.M_DIVISION) is null and
rtrim(lut.M_MASTRDSK) is null
)
 
where 1 = 1
and rtrim(pfl.M_COMMENT0) is null
--and substr(pfl.M_LABEL,1,2) = 'TF'

order by SRCLAB

