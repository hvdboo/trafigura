select
rtrim(arcgrp.M_DESC) PUB,
rtrim(hdr.M_KEY0) PAIR,
to_char(bdy.M_DATE,'YYYY-MM-DD') VALDAT,
rtrim(arccol.M_COLUMN) HSR,
round(bdy.M_COL0,6) VAL

from BG000050_HBS bdy
left join HG000050_H1S hdr on bdy.M_KEYID = hdr.M_KEYID
left join FX_ARCGR_DBF arcgrp on rtrim(arcgrp.M_HIS_FILE) = 'HG000050'
left join FX_ARCCL_DBF arccol on arcgrp.M_COL_LINK = arccol.M_LINK
left join FX_CNT_DBF cnt on rtrim(hdr.M_KEY0) = rtrim(cnt.M_LABEL)
left join RT_INDEX_DBF ind on rtrim(arcgrp.M_DESC) = rtrim(ind.M_FX_GROUP) and cnt.M_BASE = rtrim(ind.M_CURR1) and cnt.M_UNDERLNG  = rtrim(ind.M_CURR2)

where to_char(bdy.M_DATE,'YYYY-MM-DD') = '2020-09-28'