select 
rtrim(pub.M_LABEL)       PUBLAB, 
rtrim(pub.M_DESC)        PUBDES, 
rtrim(pub.M_CALENDAR)    CAL, 
rtrim(hsr.M_LABEL)       HSR,
rtrim(altcut.M_OBJ_ALBL) CUTOFF,
rtrim(tmz.M_LABEL)       TMZ, 
rtrim(altcut.M_OBJ_ALT)  DES,
hsr.M_SERIE,
pub.M_REFERENCE

from CM_MKTSR_DBF hsr
left join CM_MKT_DBF pub on hsr.M_REFERENCE = pub.M_REFERENCE
left join DAT_TZONE_DBF tmz on pub.M_TIME_ZONE = tmz.M_REFERENCE
left join KEYMAP_STC_DBF altmic on pub.M_REFERENCE = altmic.M_OBJ_ID and rtrim(altmic.M_OBJ_CLASS) = 'MnVuQ71331' and substr(altmic.M_OBJ_ASYS,1,3) = 'MIC'
left join KEYMAP_STC_DBF altcut on hsr.M_SERIE     = altcut.M_OBJ_ID and rtrim(altcut.M_OBJ_CLASS) = 'MJeEP71331' and substr(altcut.M_OBJ_ASYS,1,6) = 'CUTOFF'

where 1 = 1
and rtrim(pub.M_LABEL) is not null
and rtrim(altcut.M_OBJ_ALBL) is not null

order by TMZ, PUBLAB, CUTOFF