select 
trn.M_TRN_GTYPE FGT,
trn.M_TRN_FMLY  FML, 
trn.M_TRN_GRP   GRP, 
trn.M_TRN_TYPE  TYP,
rtrim(usg.M_LABEL) USG,
count(*)

from TRN_HDR_DBF trn
left join USAGE_DBF usg on trn.M_USAGE = usg.M_REFERENCE

where rtrim(usg.M_LABEL) is not null

group by 
trn.M_TRN_GTYPE, trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE,
trn.M_USAGE, usg.M_LABEL

order by trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE, usg.M_LABEL