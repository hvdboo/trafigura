select 
tbl.M_EAI_CODE        EAICode,
rtrim(tbl.M_EAI_NAME) EAIName,
'>'                   TGT, 
rtrim(ind.M_IND_LAB)  MXLabel,
rtrim(tbl.M_EAI_MX)   MXUID

from UDTB322_DBF tbl
left join RT_INDEX_DBF ind on tbl.M_EAI_MX = ind.M_REFERENCE

order by EAICode