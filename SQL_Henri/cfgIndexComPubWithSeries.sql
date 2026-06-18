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
rtrim(hsr.M_LABEL) HSR, 
hsr.M_SERIE,
-- rtrim(frm.M_BUFFER) FRM, 
pub.M_REFERENCE

from CM_MKTSR_DBF hsr
left join CM_MKT_DBF pub on hsr.M_REFERENCE = pub.M_REFERENCE
left join TRN_CPDF_DBF pty on pub.M_PUBLISHER = pty.M_ID
left join CM_TZONH_DBF tmz on pub.M_TIME_ZONE = tmz.M_REFERENCE
left join FRM_FILE_DBF frm on pub.M_FORMULA = frm.M_GROUP
left join KEYMAP_STC_DBF altmktmic on pub.M_REFERENCE = altmktmic.M_OBJ_ID and altmktmic.M_OBJ_CLASS in ('MnVuQ71331') and rtrim(substr(altmktmic.M_OBJ_ASYS,1,10)) = 'MIC'

where rtrim(pub.M_LABEL) is not null
order by pub.M_LABEL, hsr.M_LABEL