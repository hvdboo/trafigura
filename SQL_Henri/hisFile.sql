select 
rtrim(grp.M_GRP_DESC) GRP,
to_char(his.M_FIX_DATE,'YYYY-MM-DD') FIX_DAT,
rtrim(ind.M_IND_LAB) IND, rtrim(hsr.M_LABEL) HSR, 
to_char(his.M_VALUE,'99,999.99') VAL
from HS790525_DBF his
left join RT_GROUP_DBF grp on 'HS790525.DBF' = grp.M_HISFILE  
left join RT_INDEX_DBF ind on his.M_INDEX = ind.M_INDEX
left join CM_MKTSR_DBF hsr on to_number(trim(substr(his.M_FORMULA,2,10))) = hsr.M_SERIE
where his.M_FIX_DATE = ?
order by FIX_DAT, IND, HSR
