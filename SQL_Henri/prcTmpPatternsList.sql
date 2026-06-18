select distinct 
rtrim(cla.M_NAME) CLASS,
rtrim(pat.M_REG_DESC) REGISTRY, 
rtrim(objPat.M_LABEL) PATTERN, 
rtrim(objLay.M_LABEL) LAYOUT,
--reg.CLASS_ID CLA, 
--reg.CLASS_INST REG, 
pat.M_PAT_ID PAT, 
pat.M_PRF_ID LAY

from NPD_PAT_DBF pat
left join DCF_OBJ_DBF objPat on (pat.M_PAT_ID = objPat.M_ITEM_ID and pat.M_PAT_TYPE = 0)
left join DCF_GRPB_DBF tmp on objPat.M_OBJ_ID = tmp.M_OBJ_ID
left join DCF_GRPH_DBF tmpl on tmp.M_GRP_ID = tmpl.M_GRP_ID
left join CLASS_MAPPING_DBF cla on pat.M_REG_LBL = cla.M_ID
left join NPD_PAT_DBF patLay on pat.M_PRF_ID = patLay.M_PRF_ID and patLay.M_PAT_TYPE = 1
left join DCF_OBJ_DBF objLay on patLay.M_PAT_ID = objLay.M_ITEM_ID
left join NPD_PAT_DBF patDvl on pat.M_TMP_ID = patDvl.M_TMP_ID and patDvl.M_PAT_TYPE = 2
left join DCF_OBJ_DBF objDvl on patDvl.M_PAT_ID = objDvl.M_ITEM_ID
left join NPD_PAT_DBF patOpt on pat.M_OPT_ID = patOpt.M_OPT_ID and patOpt.M_PAT_TYPE = 3
left join DCF_OBJ_DBF objOpt on patOpt.M_PAT_ID = objOpt.M_ITEM_ID
left join NPD_PAT_DBF patIni on pat.M_INIT_ID = patIni.M_INIT_ID and patIni.M_PAT_TYPE = 5
left join DCF_OBJ_DBF objIni on patIni.M_PAT_ID = objIni.M_ITEM_ID
left join TYPOLOGY_DBF typo on (pat.M_TYPO_REF = typo.M_REFERENCE)
left join TABLE#LIST#REGISTRY_DBF reg on rtrim(pat.M_REG_DESC) = rtrim(reg.M_LAB)
where 
tmpl.M_LABEL  = 'PT_TRAF_ALL' and (
pat.M_REG_LBL='1.238' 
or pat.M_REG_LBL='1.394' 
or pat.M_REG_LBL='1.526' 
)  
and pat.M_PAT_TYPE = 0 
and objPat.M_CATEG = 1
/*
and reg.CLASS_INST in (
100, 101, 102, 103, 113, 130, 131, 136, 154, 77, 0, 87, 92, 76, 1, 2, 49, 50, 
2661,
2666,
2670,
2711,
2724,
2728,
2732,
2744,
2833
)
*/
order by CLASS, REGISTRY, PATTERN