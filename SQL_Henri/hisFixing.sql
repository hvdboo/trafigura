select  
to_char(fxg.M_FIX_DATE,'YYYY-MM-DD') DT_FIX,
trim(src.M_LABEL) SRC,
-- to_char(fxg.M_EFFV_DATE,'YYYY-MM-DD') DT_EFF,
trim(fxg.M_ARCH_LABEL) ARCH,
case fxg.M_IND_CODE
when 0  then 'Standard'
when 2  then 'Compound'
when 3  then 'Mean'
when 10 then 'Interpol' 
when 50 then 'Forex' else null end INDCAT,
case fxg.M_CONF_FLAG
when 0 then 'Published'
when 1 then 'Formula' else null end INDTYP,
trim(ind.M_IND_LAB) IND,
coalesce(trim(hsr.M_LABEL),trim(fxg.M_COL_CODE)) HSR,
to_char(fxg.M_START_DATE,'YYYY-MM-DD') DT_START,
to_char(fxg.M_END_DATE,'YYYY-MM-DD')   DT_END,
case fxg.M_FXNG_CUSTO
when 0 then 'N' 
when 1 then 'Y' else null end CUS,
fxg.M_INDEX_FXNG INDFIX,
fxg.M_FXNG_VALUE TRNFIX,

fxg.M_TRN_NUMBER TRN,
trn.M_TRN_FMLY FML, 
trn.M_TRN_GRP GRP, 
trn.M_TRN_TYPE TYP,
trn.M_TRN_GTYPE GTYP,
fxg.M_EVT_REF, fxg.*

from FXNG_DBF fxg
left join RT_INDEX_DBF ind on fxg.M_IND_LABEL = ind.M_INDEX
left join CM_MKTSR_DBF hsr on trim(substr(fxg.M_COL_CODE,2,10)) = to_char(hsr.M_SERIE)
left join TRN_HDR_DBF trn on fxg.M_TRN_NUMBER = trn.M_NB
left join EVT_EVENT_DBF evt on fxg.M_EVT_REF = evt.M_REFERENCE
left join SRC_MOD_DBF src on evt.M_SRC_MODULE = src.M_REFERENCE

where 
-- to_char(fxg.M_FIX_DATE,'YYYY-MM-DD') > '2018-07-31'
-- and to_char(fxg.M_FIX_DATE,'YYYY-MM-DD') < '2018-09-01'
-- and trim(ind.M_IND_LAB) = 'AL LME 3M_AVG'
-- and trn.M_TRN_GTYPE not in (100)
fxg.M_TRN_NUMBER = 17161548
