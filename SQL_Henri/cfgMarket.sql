select
rtrim(mkt.M_SE_MARKET) MKTLAB,
rtrim(udf.M_MIC) MIC,
rtrim(cou.M_COUNTRY) COUCOD,
rtrim(cou.M_DESC) COUDES,
rtrim(mkt.M_SE_CALEND) CALLAB,
rtrim(cal.M_DESC) CALDES,
rtrim(mkt.M_SE_CUR) CUR,
rtrim(mkt.M_SE_ARCH) ARCGRP,
rtrim(grp.M_HISFILE) ARCHIS,
rtrim(mkt.M_SE_ATYPE) ARCHSR

from SE_MKT1_DBF mkt
left join CR_CTRY_DBF cou on mkt.M_SE_CRY_REF = cou.M_REFERENCE
left join CAL_DEF_DBF cal on rtrim(mkt.M_SE_CALEND) = rtrim(cal.M_LABEL)
left join RT_GROUP_DBF grp on rtrim(mkt.M_SE_MARKET) = rtrim(grp.M_GRP_DESC)
left join TABLE#DATA#MARKET_DBF udf on rtrim(mkt.M_SE_MARKET) = rtrim(udf.M_SE_MARKET)
order by MKTLAB
