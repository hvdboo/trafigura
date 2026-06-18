select 
trn.M_TRN_FMLY FML,
trn.M_TRN_GRP  GRP,
trn.M_TRN_TYPE TYP,
trn.M_TRN_GTYPE GTYP,
rtrim(trn.M_INSTRUMENT) INS,
rtrim(plin.M_DSP_LABEL) INS_LAB, 
trn.M_PL_INSCUR CUR,
rtrim(trn.M_MKT_INDEX) MKI,
rtrim(ind.M_IND_LAB) MKI_LAB,
case ind.M_CATEGORY
when 9 then (pub.M_LABEL)
when 8 then 
case ind.M_RESET
when 0 then (pub.M_LABEL)
when 3 then rtrim(grp.M_GRP_DESC) 
when 6 then rtrim(grp.M_GRP_DESC) else null end end ARC,
count(case when trn.M_TRN_STATUS in ('LIVE','MKT_OP') then 1 else null end) LIVE, 
count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join RT_INSGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_INDEX_DBF gin on (plin.M_LABEL = gin.M_INDEX and plin.M_FAMILY = 256)
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join RT_INDEX_DBF ind on trn.M_MKT_INDEX = ind.M_INDEX
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_INDEX_DBF cmi on ind.M_COM_FUT = cmi.M_REFERENCE
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = qot.M_REFERENCE

-- where trn.M_TRN_FMLY = 'COM' and trn.M_TRN_FMLY <> 'FUT'
where trn.M_TRN_FMLY <> 'SCF'

group by
trn.M_TRN_FMLY,
trn.M_TRN_GRP,
trn.M_TRN_TYPE,
trn.M_TRN_GTYPE,
rtrim(trn.M_INSTRUMENT),
rtrim(plin.M_DSP_LABEL),
trn.M_PL_INSCUR,
rtrim(trn.M_MKT_INDEX),
case ind.M_CATEGORY
when 9 then (pub.M_LABEL)
when 8 then 
case ind.M_RESET
when 0 then (pub.M_LABEL)
when 3 then rtrim(grp.M_GRP_DESC) 
when 6 then rtrim(grp.M_GRP_DESC) else null end end,
rtrim(ind.M_IND_LAB),
rtrim(grp.M_GRP_DESC)

order by FML, GRP, TYP, GTYP, INS_LAB, MKI_LAB
