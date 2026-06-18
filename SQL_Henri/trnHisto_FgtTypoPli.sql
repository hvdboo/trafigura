select 
trn.M_TRN_GTYPE         FGT,
rtrim(trn.M_TRN_FMLY)   FML,
rtrim(trn.M_TRN_GRP)    GRP,
rtrim(trn.M_TRN_TYPE)   TYP,
typo.M_REFERENCE        TYPOID,
rtrim(typo.M_LABEL)     TYPO,
rtrim(pli.M_FMLY_LBL)   PLIFML,
rtrim(pli.M_LABEL)      PLILAB,
rtrim(pli.M_DSP_LABEL)  PLIDES,
sum(case when trn.M_TRN_STATUS not in ('DEAD') then 1 else null end) LIVE,
sum(case when trn.M_TRN_STATUS in     ('DEAD') then 1 else null end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF pli on trn.M_INSTRUMENT = pli.M_REFERENCE
left join RT_INSGN_DBF gen on (rtrim(pli.M_LABEL) = to_char(gen.M_GEN_NUM) and pli.M_FAMILY in (2,512))

group by
trn.M_TRN_GTYPE,
rtrim(trn.M_TRN_FMLY),
rtrim(trn.M_TRN_GRP),
rtrim(trn.M_TRN_TYPE),
typo.M_REFERENCE,
rtrim(typo.M_LABEL),
rtrim(pli.M_FMLY_LBL),
rtrim(pli.M_LABEL),
rtrim(pli.M_DSP_LABEL)

order by FML, GRP, TYP, TYPO, PLIDES
