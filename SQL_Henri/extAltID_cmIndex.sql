select 
kmp.M_OBJ_CLASS   CLACOD,
rtrim(cla.M_NAME) CLALAB,
ind.M_REFERENCE   INDREF,
ind.M_CATEGORY    INDCAT,
ind.M_RESET       INDNAT,
rtrim(kmp.M_OBJ_ASYS) ALTSYS,
rtrim(kmp.M_OBJ_ATYP) ALTTYP,
rtrim(kmp.M_OBJ_PS)   OBJPUB,
kmp.M_OBJ_ID          OBJUID, 
rtrim(kmp.M_OBJ_DESC) OBJREF,
rtrim(ind.M_IND_LAB)  INDLAB,
rtrim(kmp.M_OBJ_ALBL) ALTLAB,
rtrim(kmp.M_OBJ_ALT)  ALTID

from KEYMAP_STC_DBF kmp
left join CLASS_MAPPING_DBF cla on kmp.M_OBJ_CLASS = cla.M_ID
left join RT_INDEX_DBF ind on rtrim(kmp.M_OBJ_DESC) = rtrim(ind.M_INDEX) and rtrim(kmp.M_OBJ_CLASS) = 'MnXbT37735'

where 1 = 1
and rtrim(kmp.M_OBJ_CLASS) = 'MnXbT37735'
and rtrim(kmp.M_OBJ_ASYS) = 'SRD'

order by INDLAB
