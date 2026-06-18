select 
rtrim(M_OBJ_PS) PS, rtrim(clas.M_NAME) CLASS, 
-- altid.M_OBJ_INST, altid.M_OBJ_ID, altid.M_OBJ_DESC,
rtrim(cmfut.M_LABEL)    PLI,
rtrim(altid.M_OBJ_ASYS) ALT_SYS, 
rtrim(altid.M_OBJ_ATYP) ALT_TYP,
rtrim(altid.M_OBJ_ALBL) ALT_LAB,
rtrim(altid.M_OBJ_ALT)  ALT_ID 

from KEYMAP_STC_DBF altid
left join CLASS_MAPPING_DBF clas on altid.M_OBJ_CLASS = clas.M_ID
left join CM_FUT_DBF cmfut on altid.M_OBJ_ID = cmfut.M_REFERENCE

where altid.M_OBJ_CLASS = 'MfHrf56898'

order by CLASS, PLI, 
case 
when substr(ALT_SYS,1,3)='COM' then 1
when substr(ALT_SYS,1,3)='MAR' then 2
when substr(ALT_SYS,1,3)='INS' then 3
when substr(ALT_SYS,1,3)='TIT' then 4
when substr(ALT_SYS,1,3)='PLU' then 5
when substr(ALT_SYS,5,3)='URL' then 6
when substr(ALT_SYS,1,3)='ETD' then 7
when substr(ALT_SYS,1,3)='DG_' then 8
else 9 end
