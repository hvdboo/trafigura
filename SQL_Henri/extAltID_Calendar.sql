select 
rtrim(M_OBJ_PS) PS, 
rtrim(clas.M_NAME) CLASS, 
-- altid.M_OBJ_INST, 
altid.M_OBJ_ID, 
altid.M_OBJ_DESC,
rtrim(cal.M_LABEL) INSTLAB, 
rtrim(cal.M_DESC) INSTDES,
rtrim(altid.M_OBJ_ASYS) ALT_SYS, 
rtrim(altid.M_OBJ_ATYP) ALT_TYP, 
rtrim(altid.M_OBJ_ALT) ALT_ID 

from KEYMAP_STC_DBF altid
left join CLASS_MAPPING_DBF clas on altid.M_OBJ_CLASS = clas.M_ID
left join CAL_DEF_DBF cal on rtrim(altid.M_OBJ_DESC) = rtrim(cal.M_LABEL) 

where altid.M_OBJ_CLASS = 'MbRYC67318'
order by CLASS, INSTLAB, ALT_SYS