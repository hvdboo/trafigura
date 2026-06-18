select  
--rtrim(tmpl.M_LABEL) TEMPLATE, 
--rtrim(substr(pat.M_CLASS_PATH,1,50)) CLASSIFICATION,
--rtrim(cla.M_NAME) CLASS,
rtrim(pat.M_REG_DESC) REGISTRY, 
rtrim(objPat.M_LABEL) PATTERN, 
rtrim(regl.LAB) LEG_REG,
rtrim(legObjPat.M_LABEL) LEG_PAT, 
rtrim(legObjLay.M_LABEL) LEG_LAYOUT
--reg.CLASS_INST REG, pat.M_PAT_ID PAT, pat.M_PRF_ID LAY, 
--npd.M_LEG_ID L_ID, npd.M_REG_ID L_REG, npd.M_PAT_ID L_PAT, legPat.M_PRF_ID L_LAY
from NPD_PAT_DBF pat
left join DCF_OBJ_DBF objPat on (pat.M_PAT_ID = objPat.M_ITEM_ID and pat.M_PAT_TYPE = 0)
left join DCF_GRPB_DBF tmp on objPat.M_OBJ_ID = tmp.M_OBJ_ID
left join DCF_GRPH_DBF tmpl on tmp.M_GRP_ID = tmpl.M_GRP_ID
left join CLASS_MAPPING_DBF cla on pat.M_REG_LBL = cla.M_ID
left join NPD_PAT_DBF patLay on pat.M_PRF_ID = patLay.M_PRF_ID and patLay.M_PAT_TYPE = 1
left join DCF_OBJ_DBF objLay on patLay.M_PAT_ID = objLay.M_ITEM_ID
left join TRAF_REG reg on rtrim(pat.M_REG_DESC) = rtrim(reg.LAB)
left join NPD_BDY_DBF npd on reg.CLASS_INST = npd.M_ROOT_ID
left join TRAF_REG regl on npd.M_REG_ID = regl.CLASS_INST
left join NPD_PAT_DBF legPat on (npd.M_PAT_ID = legPat.M_PAT_ID and legPat.M_PAT_TYPE = 0)
left join DCF_OBJ_DBF legObjPat on (legPat.M_PAT_ID = legObjPat.M_ITEM_ID and legPat.M_PAT_TYPE = 0)
left join NPD_PAT_DBF legPatLay on (legPat.M_PRF_ID = legPatLay.M_PRF_ID and legPatLay.M_PAT_TYPE = 1)
left join DCF_OBJ_DBF legObjLay on legPatLay.M_PAT_ID = legObjLay.M_ITEM_ID
where 
tmpl.M_LABEL  = 'PT_TRAF_ALL' and (
pat.M_REG_LBL='1.238' or
pat.M_REG_LBL='1.394' or
pat.M_REG_LBL='1.526' or
pat.M_REG_LBL='MSqHl39229')  
and pat.M_PAT_TYPE=0 
--and pat.M_CLASS_PATH in ('Commodities@5. Structured', 'Commodities@5. Structured@Accumulators')
order by rtrim(tmpl.M_LABEL), rtrim(substr(pat.M_CLASS_PATH,1,50)), rtrim(objPat.M_LABEL), npd.M_FID, npd.M_LEG_ID