select 
rtrim(udf.M_DIVLAB) DIVISION,
rtrim(udf.M_DIV)    DIVCOD,
rtrim(udf.M_STRLAB) STREAM,
rtrim(udf.M_STR)    STRCOD,
rtrim(acs.M_DESC)   MSTDSK,
rtrim(udf.M_MDK)    MDKCOD1,
rtrim(srdmdk.M_COD) MDKCOD,
rtrim(acs.M_LABEL)  ORACLE,
rtrim(udf.M_BZLLAB) BUZLINZ,
rtrim(udf.M_BZL)    BZLCOD,
udf.M_SEQ           SEQ,
srddiv.M_GUID       DIVGUID,
srdstr.M_GUID       STRGUID,
srdmdk.M_GUID       MDKGUID,
srdbzl.M_GUID       BZLGUID

from TRN_ACSC_DBF acs
left join TABLE#DATA#ACCSECTI_DBF udf on rtrim(acs.M_LABEL) = rtrim(udf.M_LABEL)
left join TABLE#LIST#SRD_DBF srddiv on rtrim(udf.M_DIV) = rtrim(srddiv.M_COD) and rtrim(srddiv.M_OBJ) = 'DIV'
left join TABLE#LIST#SRD_DBF srdstr on rtrim(udf.M_STR) = rtrim(srdstr.M_COD) and rtrim(srdstr.M_OBJ) = 'STR'
left join TABLE#LIST#SRD_DBF srdmdk on rtrim(udf.M_MDK) = rtrim(srdmdk.M_COD) and rtrim(srdmdk.M_OBJ) = 'MDK'
left join TABLE#LIST#SRD_DBF srdbzl on rtrim(udf.M_BZL) = rtrim(srdbzl.M_COD) and rtrim(srdbzl.M_OBJ) = 'BZL'

order by udf.M_SEQ
