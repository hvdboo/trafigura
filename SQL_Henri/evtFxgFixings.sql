select
fxg.M_INB,
to_char(evt.M_LOGIN_DATE,'YYYY-MM-DD') EVT_DEXE,
rtrim(evt.M_USER) USR,
rtrim(substr(cla.M_NAME,17,20)) CLASS,
rtrim(src.M_LABEL) EVT,
to_char(evt.M_DATE,'YYYY-MM-DD') EVT_DEVT,
rtrim(fxg.M_ARCH_LABEL) ARC,
fxg.M_IND_CODE,
fxg.M_IND_LABEL,
case fxg.M_IND_CODE
when 50 then rtrim(fxg.M_IND_LABEL)
else rtrim(ind.M_IND_LAB) end INDLAB,
case fxg.M_IND_CODE
when  0 then 'Published'
when  3 then 'Calculated'
when  4 then 'Basket'
when 10 then 'Interpolated'
when 50 then 'FX Published' else null end INDTYP,
rtrim(und.M_IND_LAB) UNDLAB,
rtrim(pub.M_LABEL) PUB,
case fxg.M_IND_CODE
when 50 then rtrim(fxg.M_COL_CODE)
else rtrim(hsr.M_LABEL) end HSR,
to_char(fxg.M_START_DATE,'YYYY-MM-DD') DFST,
to_char(fxg.M_END_DATE,'YYYY-MM-DD')   DLST,
to_char(fxg.M_FIX_DATE,'YYYY-MM-DD')   DFIX,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD')    DEXP,
fxg.M_FXNG_VALUE VAL,
fxg.M_FIRST_FXNG FIX,
rtrim(typo.M_LABEL) TYPO,
trn.M_NB TRN,
cnt.M_REFERENCE CNT,
rtrim(evt.M_COMMENT) CMT

from FXNG_DBF fxg
left join EVT_EVENT_DBF evt on fxg.M_EVT_REF = evt.M_REFERENCE
left join SRC_MOD_DBF src on evt.M_SRC_MODULE = src.M_REFERENCE
left join CLASS_MAPPING_DBF cla on evt.M__INTID_ = cla.M_ID
left join RT_INDEX_DBF ind on fxg.M_IND_LABEL = ind.M_INDEX
left join RT_INDEX_DBF und on ind.M_UNDRL = und.M_INDEX
left join CM_MKTSR_DBF hsr on rtrim(substr(fxg.M_COL_CODE,2,10)) = to_char(hsr.M_SERIE)
left join CM_MKT_DBF pub on hsr.M_REFERENCE = pub.M_REFERENCE
left join TRN_HDR_DBF trn on fxg.M_TRN_NUMBER = trn.M_NB
left join RT_LOAN_DBF loan on fxg.M_TRN_NUMBER = loan.M_NB
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE

where
--fxg.M_TRN_NUMBER in (14992659)
-- fxg.M_IND_LABEL = '8778'
to_char(fxg.M_FIX_DATE,'YYYYMMDD') = ?
and fxg.M_IND_CODE = 3
--and fxg.M_START_DATE > ?
--and fxg.M_END_DATE < ?
and fxg.M_FIRST_FXNG = 0

/*
where fxg.M_TRN_NUMBER in 
(
select M_NB
from TRN_HDR_DBF
where M_NB in 
(
11773472,
11773474,
11806223,
11806225,
)

)
*/

order by ARC, INDLAB, UNDLAB, DFIX, TRN
