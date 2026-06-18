select
rtrim(pfl.M_LABEL)  PFL,
rtrim(stg.M_LABEL)  STG,
rtrim(usg.M_LABEL)  USG,
rtrim(typo.M_LABEL) TYPO,
fin.M_FIN_ID        FINKEY

from CLASS_ID_DBF fin
left join TRN_PFLD_DBF pfl on fin.M_PORTFOLIO = pfl.M_REF
left join TRN_STGD_DBF stg on rtrim(fin.M_STRATEGY) = rtrim(stg.M_LABEL)
-- left join TRN_STGD_DBF stg on fin.M_STG_NODE = stg.M_REFERENCE
left join USAGE_DBF usg on fin.M_USAGE = usg.M_REFERENCE
left join TYPOLOGY_DBF typo on fin.M_TYPO = typo.M_REFERENCE

order by PFL, STG, USG, TYPO