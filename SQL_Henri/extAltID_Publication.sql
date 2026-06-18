select 
rtrim(M_OBJ_PS)    PS, 
rtrim(clas.M_NAME) CLASS, 
-- altid.M_OBJ_INST, altid.M_OBJ_ID, altid.M_OBJ_DESC,
rtrim(pub.M_LABEL)      INST,
rtrim(altid.M_OBJ_ASYS) ALT_SYS, 
rtrim(altid.M_OBJ_ATYP) ALT_TYP,
rtrim(altid.M_OBJ_ALBL) ALTLAB,
rtrim(altid.M_OBJ_ALT)  ALT_ID 

from KEYMAP_STC_DBF altid
left join CLASS_MAPPING_DBF clas on altid.M_OBJ_CLASS = clas.M_ID
left join CM_MKT_DBF pub on rtrim(altid.M_OBJ_ID) = rtrim(pub.M_REFERENCE) 

where altid.M_OBJ_CLASS = 'MnVuQ71331'
order by CLASS, INST, ALT_SYS