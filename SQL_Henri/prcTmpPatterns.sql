select distinct 
rtrim(tmpl.M_LABEL) TEMPLATE, 
rtrim(substr(pat.M_CLASS_PATH,1,50)) CLASSIFICATION,
case pat.M_PAT_TYPE
when 0 then 'Pattern'
when 1 then 'Layout'
when 2 then 'Def.values'
when 3 then 'Options'
when 4 then 'Pool'
when 5 then 'Init map'
when 6 then 'Solver'
when 7 then 'Order mapping' 
when 8 then 'Form' end TYP,
rtrim(cla.M_NAME) CLASS,
pat.M_PRF_ID PATID,
rtrim(pat.M_REG_DESC) REGISTRY, 
rtrim(objPat.M_LABEL) PATTERN, 
rtrim(objLay.M_LABEL) LAYOUT,
--rtrim(objDvl.M_LABEL) DEFVAL, 
--rtrim(objOpt.M_LABEL) OPTIONS, 
--rtrim(objIni.M_LABEL) INIT_MAP,
rtrim(typo.M_LABEL) TYPOLOGY
--reg.CLASS_INST REG, pat.M_PAT_ID PAT, pat.M_PRF_ID LAY
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
left join TRAF_REG reg on rtrim(pat.M_REG_DESC) = rtrim(reg.LAB)
where 
tmpl.M_LABEL  = 'PT_TRAF_ALL' and (
pat.M_REG_LBL='1.238' or
pat.M_REG_LBL='1.394' or
pat.M_REG_LBL='1.526' or
pat.M_REG_LBL='MSqHl39229')  
and pat.M_PAT_TYPE=0 
--and pat.M_CLASS_PATH in ('Commodities', 'Commodities@5. Structured','Commodities@5. Structured@Accumulators' )
--order by TEMPLATE, CLASSIFICATION, CLASS, REGISTRY, PATTERN
order by TEMPLATE, CLASSIFICATION, PATTERN