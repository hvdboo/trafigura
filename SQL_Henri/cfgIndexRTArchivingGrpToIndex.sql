select 
rtrim(ind.M_IND_LAB) IND, 
case ind.M_CATEGORY
when 9 then 'Fut.ind'
when 8 then
case  ind.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end end IND_TYPE,
rtrim(indgrp.M_GRP_DESC) GRPDES,
rtrim(indpub.M_LABEL) PUB,
indgrp.M_HISFILE GRPHIS, 
ind.M_HISFILE INDHIS

from RT_GROUP_DBF indgrp 
left join RT_INDEX_DBF ind on indgrp.M_HISFILE = ind.M_HISFILE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT = indqot.M_REFERENCE

left join CM_MKT_DBF indpub on indqot.M_PUBLI = indpub.M_REFERENCE

where ind.M_CATEGORY in (8)
order by IND