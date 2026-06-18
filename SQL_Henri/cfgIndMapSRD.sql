select distinct
rtrim(ast.M_LABEL) AST,
rtrim(ass.M_LABEL) ASS,
case ind.M_RESET
when 0 then 'Spot' 
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end TYP,
rtrim(cmi.M_LABEL) LAB,
rtrim(cmi.M_DESC) DES,
rtrim(pub.M_LABEL) PUB,
rtrim(qot.M_TRAD_SMB) SYM,
rtrim(qot.M_LABEL) QOT,
rtrim(aid.M_OBJ_ALBL) EAICOD,
to_number(rtrim(aid.M_OBJ_ALBL)) EAIUID,
rtrim(aid.M_OBJ_ALT) EAILAB,
rtrim(cal.M_LABEL) CALLAB,
rtrim(cal.M_DESC) CALDES,
case 
when coalesce(rtrim(crv.M_KEY),'Z') = 'Z' then ' ' 
else concat(rtrim(cmi.M_LABEL),substr(crv.M_KEY,21,5)) end CRV,
case grpi.M_GEN_MODE
when 0 then 
   case grpi.M_FUTURE
   when 0 then   
      case ins.M_INSTR_TYPE
      when  3 then 'IR Loan'
      when 13 then 'Index' 
      when 21 then 'Repo' else null end
   else 'Future' end
when 1 then 'Index' 
when 2 then 
      case grpi.M_VAL_TYPE
      when 0 then 'Lease Metal Rate'
      when 2 then 'Lease Cash Rate'
      when 4 then 'Forward Price'
      when 5 then 'Forward Rate' else null end                                                                        
end CRVUND,
case grpi.M_GEN_MODE
when 0 then 'Custom'
when 1 then 'Simple' end CRVMOD,
case grpi.M_GEN_MODE
when 0 then
   case when ins.M_INSTR_TYPE = 13 then rtrim(ins.M_INSTR) else rtrim(fut.M_LABEL) end
when 1 then rtrim(genind.M_IND_LAB) 
when 2 then rtrim(gencmi.M_LABEL) else null end CRVINS,
rtrim(grp.M_LABEL) SWPGRP,
case grpi.M_GEN_MODE
when 0 then rtrim(fut237.M_DGMODEL)
when 1 then rtrim(swp237.M_DGMODEL)
else null end DGFWD

-- rtrim(hisgrp.M_GRP_DESC) GRP,
-- rtrim(hisgrp.M_CALENDAR) ARCCAL,

from RT_INDEX_DBF ind
left join CM_INDEX_DBF cmi on ind.M_COM_IND = cmi.M_REFERENCE
left join CM_ASSET_DBF ass on cmi.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI = pub.M_REFERENCE
left join CAL_DEF_DBF  cal on pub.M_CALENDAR = cal.M_LABEL
left join KEYMAP_STC_DBF aid on rtrim(ind.M_INDEX) = rtrim(aid.M_OBJ_DESC) and aid.M_OBJ_CLASS in ('MnXbT37735') and rtrim(aid.M_OBJ_ASYS) = 'EAI'
left join TRN_PC_DBF pc on  1 = 1
left join CMK_SCCF_DBF crv on cmi.M_REFERENCE = to_number(substr(crv.M_KEY,1,10)) and crv.M__DATE_ = pc.M_DATE and crv.M__ALIAS_ = 'RT'
left join CMG_GRPI_DBF grpi on (crv.M__DATE_ = grpi.M__DATE_ and crv.M__ALIAS_ = grpi.M__ALIAS_ and crv.M_OBJ_PIL = grpi.M_GROUP and grpi.M_GTYPE = 512) 
left join CMC_MGEN_DBF mgen on grpi.M_INSTR_GEN = mgen.M_REFERENCE and grpi.M_GEN_MODE = 1
left join RT_INDEX_DBF genind on mgen.M_INDEX = genind.M_INDEX
left join CM_INDEX_DBF gencmi on grpi.M_INSTR_GEN = gencmi.M_REFERENCE and grpi.M_GEN_MODE = 2
left join RT_INSGN_DBF ins on grpi.M_INSTR_GEN = ins.M_GEN_NUM
left join CM_FUT_DBF fut on grpi.M_FUTURE = fut.M_REFERENCE
left join CMC_MGEN_DBF mgngrp on ind.M_INDEX = mgngrp.M_INDEX
left join CMG_GRPI_DBF grps on (grps.M__DATE_ = pc.M_DATE and grps.M__ALIAS_ = 'RT' and grps.M_GTYPE = 256 and mgngrp.M_REFERENCE = grps.M_INSTR_GEN) 
left join CMG_GRP_DBF grp on (grps.M__DATE_ = grp.M__DATE_ and grps.M__ALIAS_ = grp.M__ALIAS_ and grps.M_GROUP = grp.M_REFERENCE and grps.M_GTYPE = grp.M_GTYPE)
left join UDTB237_DBF swp237 on rtrim(genind.M_IND_LAB) = rtrim(swp237.M_DGGENERAT) and rtrim(swp237.M_DGPTYPE) = 'COM_SWAP' 
left join UDTB237_DBF fut237 on rtrim(fut.M_LABEL) = rtrim(fut237.M_DGMXLABEL) and rtrim(fut237.M_DGPTYPE) = 'COM_FUT' 
left join RT_GROUP_DBF hisgrp on ind.M_HISFILE = hisgrp.M_HISFILE

where 1 = 1
and ind.M_CATEGORY = 8 
and ind.M_RESET in (0, 4, 6)
and ind.M_COM_QUOT = cmi.M_QUOT_FWD
and cmi.M_COMMENT4 not in ('OOS')

order by AST, ASS, LAB