select distinct
altid.M_OBJ_CLASS, rtrim(clas.M_NAME) CLASS,
rtrim(altid.M_OBJ_ASYS) ALT_SYS
from KEYMAP_STC_DBF altid
left join CLASS_MAPPING_DBF clas on altid.M_OBJ_CLASS = clas.M_ID