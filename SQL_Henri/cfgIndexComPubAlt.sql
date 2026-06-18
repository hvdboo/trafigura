select 
case altmap.M_OBJ_CLASS
when 'MnVuQ71331' then 'PUB'
when 'MJeEP71331' then 'HSR' else null end OBJ,
case altmap.M_OBJ_CLASS
when 'MnVuQ71331' then rtrim(pub.M_LABEL)
when 'MJeEP71331' then rtrim(hsrpub.M_LABEL) else null end PUB,
rtrim(hsr.M_LABEL) HSR,
rtrim(altmap.M_OBJ_ATYP) ALTTYP,
rtrim(altmap.M_OBJ_ASYS) ALTSYS,
rtrim(altmap.M_OBJ_ALBL) ALTLAB,
rtrim(altmap.M_OBJ_ALT) ALTUID
from KEYMAP_STC_DBF altmap
left join CM_MKT_DBF pub on (altmap.M_OBJ_ID = pub.M_REFERENCE and altmap.M_OBJ_CLASS = 'MnVuQ71331')
left join CM_MKTSR_DBF hsr on (altmap.M_OBJ_ID = hsr.M_SERIE and altmap.M_OBJ_CLASS = 'MJeEP71331')
left join CM_MKT_DBF hsrpub on hsr.M_REFERENCE = hsrpub.M_REFERENCE

where altmap.M_OBJ_CLASS in ('MnVuQ71331','MJeEP71331')

order by OBJ, PUB, HSR, ALTSYS, ALTLAB