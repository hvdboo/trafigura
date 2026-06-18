select 
to_char(pc.M_DATE,'YYYY-MM-DD') REPDAT,
rtrim(ass.M_LABEL)  ASS,
rtrim(typo.M_LABEL) TYPO,
rtrim(pli.M_DSP_LABEL) PLI,
sum(case when trn.M_TRN_STATUS in ('LIVE','MKT_OP') then 1 else 0 end) STAT_LIVE,
sum(case when trn.M_TRN_STATUS in ('DEAD') then 1 else 0 end) STAT_DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF pli on trn.M_INSTRUMENT = pli.M_REFERENCE
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CM_FUT_DBF cmfut on (rtrim(substr(pli.M_LABEL,9,10)) = to_char(cmfut.M_REFERENCE) and pli.M_FAMILY in (32,16384))

where 
trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
-- and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') > '2023-09-30' 
-- and trn.M_TRN_GTYPE in (100, 101, 102, 103)
-- and trn.M_INSTRUMENT in ('1231')

group by
to_char(pc.M_DATE,'YYYY-MM-DD'),
rtrim(ass.M_LABEL),
rtrim(typo.M_LABEL),
rtrim(pli.M_DSP_LABEL)

order by ASS, PLI
