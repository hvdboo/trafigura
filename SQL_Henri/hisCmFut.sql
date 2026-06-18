select 
to_char(hisbdy.M_INS_DATE,'YYYY-MM-DD') INS_DAT,
to_char(hisbdy.M_DATE,'YYYY-MM-DD') FIX_DAT,
rtrim(fut.M_LABEL) FUT,
rtrim(mat.M_LABEL) MAT,
to_char(mat.M_QT_END,'YYYY-MM-DD') QTL,
-- rtrim(ind.M_IND_LAB) IND, 
rtrim(hsr.M_LABEL) HSR, 
to_char(hisbdy.M_P87,'99,999.9999') VAL

from B318123_HBS hisbdy
left join TRN_PC_DBF bo on 1 = 1
left join H318123_H1S hishdr on hisbdy.M_KEYID = hishdr.M_KEYID
left join CM_FMAT1_DBF mat on hishdr.M_KEY0 = mat.M_REFERENCE
left join RT_GROUP_DBF grp on grp.M_HISFILE = '318123'
left join CM_FUT_DBF fut on to_number(trim(substr(grp.M_GRP_DESC,1,10))) = fut.M_REFERENCE
left join CM_MKTSR_DBF hsr on hsr.M_SERIE = 87

where 1 = 1
and hisbdy.M_DATE = bo.M_DATE
-- and to_char(his.M_DATE,'YYYY-MM-DD') > '2021-10-31'

order by FIX_DAT, QTL
