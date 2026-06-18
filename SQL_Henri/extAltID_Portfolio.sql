select 
rtrim(M_OBJ_PS) PS, 
rtrim(clas.M_NAME) CLASS, 
-- altid.M_OBJ_INST, altid.M_OBJ_ID, altid.M_OBJ_DESC,
rtrim(pfl.M_LABEL) INST,
rtrim(altid.M_OBJ_ASYS) ALT_SYS, 
rtrim(altid.M_OBJ_ATYP) ALT_TYP, 
rtrim(altid.M_OBJ_ALT) ALT_ID 

from KEYMAP_STC_DBF altid
left join CLASS_MAPPING_DBF clas on altid.M_OBJ_CLASS = clas.M_ID
left join TRN_PFLD_DBF pfl on rtrim(altid.M_OBJ_DESC) = rtrim(pfl.M_LABEL) 

where altid.M_OBJ_CLASS = 'MJkQC54506'
order by CLASS, INST, ALT_SYS