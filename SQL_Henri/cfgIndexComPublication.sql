select 
rtrim(pty.M_DSP_LABEL) PTY,
rtrim(pub.M_LABEL) PUB, 
rtrim(pub.M_DESC) DES, 
rtrim(altmktmic.M_OBJ_ALBL) MIC,
rtrim(pub.M_CALENDAR) CAL, 
rtrim(tmz.M_LABEL) TMZ, 
--rtrim(M_SHIFTER) SHIFT
pub.M_FREQUENCY FRQ, 
M_TIMESTAMPED TMS, 
rtrim(altmktsrd.M_OBJ_ALT) SRDUID,
pub.M_REFERENCE

from CM_MKT_DBF pub
-- left join CM_MKTSR_DBF hsr on pub.M_REFERENCE = hsr.M_REFERENCE
left join TRN_CPDF_DBF  pty on pub.M_PUBLISHER = pty.M_ID
left join DAT_TZONE_DBF tmz on pub.M_TIME_ZONE = tmz.M_REFERENCE
left join FRM_FILE_DBF  frm on pub.M_FORMULA = frm.M_GROUP
left join KEYMAP_STC_DBF altmktmic on pub.M_REFERENCE = altmktmic.M_OBJ_ID and altmktmic.M_OBJ_CLASS = 'MnVuQ71331' and rtrim(substr(altmktmic.M_OBJ_ASYS,1,10)) = 'MIC'
left join KEYMAP_STC_DBF altmktsrd on pub.M_REFERENCE = altmktsrd.M_OBJ_ID and altmktsrd.M_OBJ_CLASS = 'MnVuQ71331' and rtrim(substr(altmktsrd.M_OBJ_ASYS,1,10)) = 'SRD'

where rtrim(pub.M_LABEL) is not null
order by pub.M_LABEL