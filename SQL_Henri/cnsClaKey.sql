select
rtrim(pfl.M_LABEL)   PFL,
rtrim(stg.M_LABEL)   STG,
rtrim(usg.M_LABEL)   USG,
rtrim(typo.M_LABEL)  TYPO,
fin.M_FIN_ID         FINKEY,
cla.M_TRN_GTYPE      FGT,
rtrim(reg.M_REG_FML) FML,
rtrim(reg.M_REG_GRP) GRP,
rtrim(reg.M_REG_TYP) TYP,
rtrim(pli.M_DSP_LABEL) PLI,
cla.M_POSFINID       POSKEY,
cla.M_CLASKEYID      CLAKEY

from CLASSIFICATION_KEYS_P_DBF cla
left join CLASS_ID_DBF fin on cla.M_CLASSID = fin.M_FIN_ID
left join TRN_PFLD_DBF pfl on fin.M_PORTFOLIO = pfl.M_REF
left join TRN_STGD_DBF stg on rtrim(fin.M_STRATEGY) = rtrim(stg.M_LABEL)
-- left join TRN_STGD_DBF stg on fin.M_STG_NODE = stg.M_REFERENCE
left join USAGE_DBF usg on fin.M_USAGE = usg.M_REFERENCE
left join TYPOLOGY_DBF typo on fin.M_TYPO = typo.M_REFERENCE
left join UDTB279_DBF reg on cla.M_TRN_GTYPE = reg.M_REG_FGT
left join TRN_PLIN_DBF pli on cla.M_INSTRUMENT = pli.M_ID

where cla.M_CLASKEYID in
(
595980,
596744
)

order by PFL, STG, USG, FML, TYPO, PLI, POSKEY