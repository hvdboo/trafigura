select 
case  ind.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end as M_IND_TYPE,
rtrim(indcm.M_LABEL) as M_IND_LABEL, rtrim(indcm.M_DESC) as M_IND_DESC, rtrim(indqot.M_TRAD_SMB) as M_IND_SYM, rtrim(ind.M_IND_LAB) as M_INDEX_, 
rtrim(indqotpub.M_LABEL) as M_IND_PUB, rtrim(indgrp.M_CALENDAR) as M_PUB_CAL,
indqot.M_CURR as M_IND_CUR, indqotunitq.M_LABEL as M_IND_UNITQ, indcm.M_LOTSIZE as M_IND_LOT,
rtrim(fld0.M_LABEL) as M_PHYTRE0, rtrim(fld1.M_LABEL) as M_PHYTRE1, rtrim(fld2.M_LABEL) as M_PHYTRE2,
rtrim(fys.M_LABEL) as M_PHYSICAL, rtrim(loc.M_LABEL) as M_LOCATION,
rtrim(indast.M_LABEL) as M_IND_AST, rtrim(indass.M_LABEL) as M_IND_ASS,
'Future' as M_FUT,
rtrim(futg.M_LABEL) as M_FUT_LAB, rtrim(futg.M_DESC) as M_FUT_DESC, 
rtrim(futqot.M_TRAD_SMB) as M_FUT_SYM, rtrim(ofutqot.M_TRAD_SMB) as M_OPT_SYM,
rtrim(futqotpub.M_LABEL) as M_FUT_PUB,
futqot.M_CURR as M_FUT_CUR, futqotunitq.M_LABEL as M_FUT_UNITQ, futg.M_QTY as M_FUT_LOT,
rtrim(futast.M_LABEL) as M_FUT_AST, rtrim(futass.M_LABEL) as M_FUT_ASS
from RT_INDEX_DBF ind
left join RT_GROUP_DBF indgrp on ind.M_HISFILE = indgrp.M_HISFILE
left join RT_INDEX_DBF und on ind.M_UNDRL = und.M_INDEX
left join CM_FUT_DBF fut on ind.M_COM_FUT = fut.M_REFERENCE
left join CM_INDEX_DBF indcm on ind.M_COM_IND = indcm.M_REFERENCE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT = indqot.M_REFERENCE
left join CM_ASSET_DBF indass on indcm.M_ASSET = indass.M_REFERENCE
left join CM_ATYPE_DBF indast on indass.M_TYPE = indast.M_REFERENCE
left join CM_UNIT_DBF indqotunitq on indqot.M_UNIT = indqotunitq.M_REFERENCE
left join CM_UNIT_DBF indqotunitd on indqot.M_QTY_UNIT = indqotunitd.M_REFERENCE
left join CM_MKT_DBF indqotpub on indqot.M_PUBLI = indqotpub.M_REFERENCE
left join CM_PHYS_DBF fys on indcm.M_PHYSICAL = fys.M_REFERENCE
left join CM_PTYPE_DBF fystyp on fys.M_TYPE = fystyp.M_REFERENCE
left join CMU_MMST_DBF tr3 on (fys.M_REFERENCE = tr3.M_REF and tr3.M_HEIGHT = 3)
left join CMU_MMST_DBF tr2 on tr3.M_FATHER_R = tr2.M_REF
left join CMU_MMST_DBF tr1 on tr2.M_FATHER_R = tr1.M_REF
left join CMU_MMST_DBF tr0 on tr1.M_FATHER_R = tr0.M_REF
left join ADT_TREEF_DBF fld2 on tr2.M_REF = fld2.M_REFERENCE
left join ADT_TREEF_DBF fld1 on tr1.M_REF = fld1.M_REFERENCE
left join CM_PHYS_DBF fld0 on tr0.M_REF = fld0.M_REFERENCE
left join CM_LOCAT_DBF loc on indcm.M_LOCATION = loc.M_REFERENCE
left join CM_LTYPE_DBF loctyp on loc.M_TYPE = loctyp.M_REFERENCE
left join CMC_MGEN_DBF genf on rtrim(ind.M_INDEX) = rtrim(genf.M_INDEX)
left join CM_FUT_DBF futg on (rtrim(genf.M_REFERENCE) = rtrim(futg.M_CM_INSTR) and futg.M_INS_MODE = 1)
left join CMC_QUOT_DBF futqot on futg.M_QUOT_FWD = futqot.M_REFERENCE
left join CM_MKT_DBF futqotpub on futqot.M_PUBLI = futqotpub.M_REFERENCE
left join CM_UNIT_DBF futqotunitq on futqot.M_UNIT = futqotunitq.M_REFERENCE
left join CM_ASSET_DBF futass on futg.M_ASSET = futass.M_REFERENCE
left join CM_ATYPE_DBF futast on futass.M_TYPE = futast.M_REFERENCE
left join CM_FUT_DBF ofut on (futg.M_REFERENCE = ofut.M_CM_INSTR and ofut.M_LISTED = 64)
left join CMC_QUOT_DBF ofutqot on ofut.M_QUOT_FWD = ofutqot.M_REFERENCE
where ind.M_CATEGORY = 8 and ind.M_RESET = 0 and ind.M_COM_QUOT = indcm.M_QUOT_FWD
order by ind.M_IND_LAB