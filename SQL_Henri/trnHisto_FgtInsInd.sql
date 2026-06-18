select 
trn.M_TRN_FMLY FML,
trn.M_TRN_GRP  GRP,
trn.M_TRN_TYPE TYP,
trn.M_TRN_GTYPE GTYP,
trn.M_INSTRUMENT INS_REF,
rtrim(plin.M_DSP_LABEL) INS_LAB, -- rtrim(plin.M_DESC) INS_DES,
rtrim(trn.M_MKT_INDEX) MKTNDX, rtrim(indmkt.M_IND_LAB) MKT_INDLAB,

count(case when trn.M_TRN_STATUS in ('LIVE','MKT_OP') then 1 else null end) LIVE, 
count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join RT_INDEX_DBF indmkt on trn.M_MKT_INDEX = indmkt.M_INDEX

where trn.M_TRN_FMLY = 'COM' and trn.M_TRN_GRP <> 'FUT'

group by
trn.M_TRN_FMLY,
trn.M_TRN_GRP,
trn.M_TRN_TYPE,
trn.M_TRN_GTYPE,
trn.M_INSTRUMENT,
rtrim(plin.M_DSP_LABEL), rtrim(plin.M_DESC),
rtrim(trn.M_MKT_INDEX), rtrim(indmkt.M_IND_LAB)

order by FML, GRP, TYP, INS_LAB, MKT_INDLAB
