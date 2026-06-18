select 
rtrim(ass.M_LISTTYPE) SOURCE, 
rtrim(ass.M_DICT) PRODUCT, rtrim(pat.M_REG_DESC) PATTERN,
rtrim(ass.M_GROUP) GRP, rtrim(ass.M_USER) USR, 
rtrim(ass.M_LIST) LIST
from LST_RGTB_DBF ass
left join NPD_PAT_DBF pat on ass.M_PATTERN = pat.M_PAT_ID 
order by SOURCE, PRODUCT, PATTERN, GRP, USR