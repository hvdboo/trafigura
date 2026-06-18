select distinct
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
rtrim(trn.M_TRN_FMLY) FINASS,
rtrim(src.M_LABEL)    SRCLAB,
rtrim(src.M_DESC)     SRCDES,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE 

where 1 = 1 
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
-- and trn.M_TRN_STATUS <> 'DEAD'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') >= '2023-10-01'

group by pc.M_DATE, src.M_LABEL, src.M_DESC, trn.M_TRN_FMLY

order by FINASS, OCC desc