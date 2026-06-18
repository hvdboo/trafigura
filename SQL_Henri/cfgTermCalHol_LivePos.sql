select 
rtrim(cal.M_LABEL) CAL,  rtrim(cal.M_DESC) CALDESC,
to_char(hol.M_DATE,'YYYY-MM-DD') HOLDAT,
rtrim(hol.M_COMMENT) HOLCMT
from CAL_HOL_DBF hol
left join CAL_DEF_DBF cal on hol.M_CAL_LABEL = cal.M_LABEL
left join TRN_PC_DBF pc on 1 = 1
where 
rtrim(M_CAL_LABEL) in
(
select distinct
coalesce(
rtrim(fxcur.M_HOLCLN0),
rtrim(fxcnt.M_CALENDAR0),
rtrim(fxcnt.M_CALENDAR1),
rtrim(cmfpub.M_CALENDAR),
rtrim(cmipub.M_CALENDAR),
rtrim(gen.M_FIX_CLN0)) CAL

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join FX_CURR_DBF fxcur on plin.M_LABEL = fxcur.M_LABEL 
left join FX_CNT_DBF fxcnt on plin.M_LABEL = fxcnt.M_LABEL
left join CM_FUT_DBF cmfut on trim(substr(plin.M_LABEL,9,10)) = to_char(cmfut.M_REFERENCE)
left join CMC_QUOT_DBF cmfqot on cmfut.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI = cmfpub.M_REFERENCE 
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join RT_LNGN_DBF gen on trim(plin.M_LABEL) = to_char(gen.M_GEN_NUM)
where trn.M_TRN_STATUS <> 'DEAD'
)
and hol.M_DATE > pc.M_DATE - to_dsinterval('365 00:00:00')


order by CAL, HOLDAT
