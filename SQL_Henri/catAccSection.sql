select 
rtrim(udf.M_SEQ)    SEQ,
rtrim(udf.M_DIVLAB) DIV,
rtrim(udf.M_STRLAB) STR,
rtrim(acs.M_DESC)   MDK,
rtrim(acs.M_LABEL)  ORA,
rtrim(udf.M_BZLLAB) BZL,
rtrim(div.M_GUID)    DIVGUID,
rtrim(str.M_GUID)    STRGUID,
rtrim(alt.M_OBJ_ALT) MDKGUID,
rtrim(bzl.M_GUID)    BZLGUID

from TRN_ACSC_DBF acs
left join TABLE#DATA#ACCSECTI_DBF udf on rtrim(acs.M_LABEL) = rtrim(udf.M_LABEL)
left join TABLE#LIST#SRD_DBF div on rtrim(udf.M_DIV) = rtrim(div.M_COD) and rtrim(div.M_OBJ) = 'DIV'
left join TABLE#LIST#SRD_DBF str on rtrim(udf.M_STR) = rtrim(str.M_COD) and rtrim(str.M_OBJ) = 'STR'
left join TABLE#LIST#SRD_DBF bzl on rtrim(udf.M_BZL) = rtrim(bzl.M_COD) and rtrim(bzl.M_OBJ) = 'BZL'
left join KEYMAP_STC_DBF alt on acs.M_REFERENCE = alt.M_OBJ_ID and alt.M_OBJ_CLASS = 'MDkZb35207' and rtrim(alt.M_OBJ_ASYS) = 'SRD'


order by udf.M_SEQ, acs.M_LABEL


