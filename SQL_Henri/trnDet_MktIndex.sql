select distinct 
trn.M_NB TRN,
trn.M_CONTRACT CNT,
trn.M_MKT_INDEX M_MKTNDX, 
trn.M_BRW_FV1||trn.M_BRW_FV2 M_NAT,
trn.M_MKT_INDEX MKI,
rtrim(ind0.M_IND_LAB) M_IND0,
rtrim(fut0.M_LABEL) M_FUT0,
case fut0.M_LISTED
when  1 then rtrim(fmat0.M_LABEL)
when 64 then rtrim(omat0.M_LABEL) end M_MAT0,
rtrim(und0.M_IND_LAB) M_UND0,
rtrim(ind1.M_IND_LAB) M_IND1,
rtrim(und1.M_IND_LAB) M_UND1
from TRN_HDR_DBF trn
left join RT_INDEX_DBF ind0 on trim(substr(trn.M_MKT_INDEX, 1,15)) = trim(ind0.M_INDEX)
left join RT_INDEX_DBF ind1 on trim(substr(trn.M_MKT_INDEX,18,15)) = trim(ind1.M_INDEX)
left join CM_FUT_DBF fut0 on (ind0.M_COM_FUT = fut0.M_REFERENCE and ind0.M_CATEGORY = 9)
left join CM_FUT_DBF fut1 on (ind1.M_COM_FUT = fut1.M_REFERENCE and ind1.M_CATEGORY = 9)
left join CM_FMAT1_DBF fmat0 on (ind0.M_COM_MAT = fmat0.M_REFERENCE and ind0.M_CATEGORY = 9)
left join CM_FMAT1_DBF fmat1 on (ind1.M_COM_MAT = fmat1.M_REFERENCE and ind0.M_CATEGORY = 9)
left join CM_OMAT1_DBF omat0 on (ind0.M_COM_MAT = omat0.M_REFERENCE and ind0.M_CATEGORY = 9)
left join CM_OMAT1_DBF omat1 on (ind1.M_COM_MAT = omat0.M_REFERENCE and ind0.M_CATEGORY = 9)
left join RT_INDEX_DBF und0 on rtrim(ind0.M_UNDRL) = rtrim(und0.M_INDEX)
left join RT_INDEX_DBF und1 on rtrim(ind1.M_UNDRL) = rtrim(und1.M_INDEX)
where trn.M_NB in
(
9834687
)