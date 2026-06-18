select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
rtrim(src.M_LABEL) SRC,
trn.M_TRN_FMLY FML,
trn.M_TRN_GRP  GRP,
trn.M_TRN_TYPE TYP,
trn.M_TRN_GTYPE GTYP,
count(case when trn.M_TRN_STATUS = 'LIVE' then 1 else null end) LIVE, 
count(case when trn.M_TRN_STATUS = 'MKT_OP' then 1 else null end) MKT_OP,
count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE

-- where and trn.M_TRN_GTYPE not in (49, 76, 100, 101, 136, 146)

group by 
to_char(pc.M_DATE,'YYYY-MM-DD'),
rtrim(src.M_LABEL),
trn.M_TRN_FMLY,
trn.M_TRN_GRP,
trn.M_TRN_TYPE,
trn.M_TRN_GTYPE

order by SRC, FML, GRP, TYP