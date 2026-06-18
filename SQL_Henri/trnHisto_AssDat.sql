select
rtrim(trn.M_TRN_FMLY) FML,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
to_char(trn.M_TRN_DATE,'YYYY') TRNYEAR,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE

where 1 = 1 
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') > '2017-12-31'

group by 
rtrim(trn.M_TRN_FMLY),
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end),
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end,
to_char(trn.M_TRN_DATE,'YYYY'),
to_char(trn.M_TRN_DATE,'YYYY-MM-DD')