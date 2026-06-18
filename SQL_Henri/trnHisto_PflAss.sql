select distinct
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
rtrim(trn.M_TRN_FMLY) FINASS,
rtrim(atp.M_LABEL) ASSTYP,
rtrim(ass.M_LABEL) ASSLAB,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE

where 1 = 1 
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
-- and trn.M_TRN_STATUS <> 'DEAD'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') >= '2023-10-01'

group by 
pc.M_DATE, 
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
trn.M_TRN_FMLY, atp.M_LABEL, ass.M_LABEL

order by PFL, ASSTYP, ASSLAB desc