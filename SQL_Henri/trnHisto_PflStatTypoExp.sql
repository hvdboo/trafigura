select 
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
trn.M_TRN_FMLY FML,
trn.M_TRN_GRP  GRP,
trn.M_TRN_TYPE TYP,
-- trn.M_TRN_GTYPE GTYP,
rtrim(typo.M_LABEL) TYPO,
trn.M_TRN_STATUS STAT,
-- trn.M_INSTRUMENT INS_REF,
rtrim(plin.M_DSP_LABEL) INS, 
-- rtrim(plin.M_DESC) INS_DES,
-- rtrim(trn.M_MKT_INDEX) MKTNDX, 
-- rtrim(indmkt.M_IND_LAB) MKT_INDLAB,
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP,
count(*) OCC

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join RT_INDEX_DBF indmkt on trn.M_MKT_INDEX = indmkt.M_INDEX

group by
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
trn.M_TRN_FMLY,
trn.M_TRN_GRP,
trn.M_TRN_TYPE,
rtrim(typo.M_LABEL),
trn.M_TRN_STATUS,
rtrim(plin.M_DSP_LABEL),
trn.M_TRN_EXP

order by PFL, FML, GRP, TYP, TYPO, STAT, INS, EXP
