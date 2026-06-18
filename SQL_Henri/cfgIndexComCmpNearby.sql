select
coalesce(rtrim(ast.M_LABEL),' ') ATYP, rtrim(ass.M_LABEL) ASSET,
rtrim(ind.M_IND_LAB) IND_LABEL, rtrim(ind.M_IND_DESC) IND_DESC,
case when ind.M_RESET=6 then
case ind.M_COM_NBY_T
when 0 then 'Future'
when 1 then 'Floating'
when 2 then 'Index' else ' ' end end NBY_TYPE,
case
when ind.M_RESET=0 then rtrim(indcm.M_LABEL) 
when ind.M_RESET=6 and ind.M_COM_NBY_T=0 then rtrim(fut.M_LABEL) 
when ind.M_RESET=6 and ind.M_COM_NBY_T=2 then rtrim(nbyind.M_LABEL)
else rtrim(und.M_IND_LAB) end UND_LABEL, 
case 
when ind.M_RESET=3 then undqot.M_CURR 
when ind.M_RESET=4 then ind.M_CURRENCY else ind.M_COM_CUR end IND_CUR,
case 
when ind.M_RESET=0 then rtrim(indqotunit.M_LABEL)
when ind.M_RESET=3 then rtrim(undqotunit.M_LABEL) 
when ind.M_RESET=4 then rtrim(indunit.M_LABEL)
when ind.M_RESET=6 then rtrim(indqotunit.M_LABEL) end IND_UNITQ,
case ind.M_COM_NBY_T when 0 then
case ind.M_COM_NBY_R
when 0 then 'Quotation end'
when 1 then 'Notification first'
when 2 then 'Notification last' else ' ' end else ' ' end NBY_SHIFT, 
case ind.M_COM_NBY_T when 0 then
case ind.M_COM_NB_MT
when  0 then 'Fixed'
when -1 then 'Floating'
when -9 then 'All' else ' ' end else ' ' end NBY_MATTYP,
case when  ind.M_RESET=6 and ind.M_COM_NBY_T=0 then ind.M_COM_NBY_O else 0 end NBY_ORDER,
ind.M_UECF NBY_SHIFT

from RT_INDEX_DBF ind
left join RT_GROUP_DBF indgrp on ind.M_HISFILE=indgrp.M_HISFILE
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join RT_INDEX_DBF und on ind.M_UNDRL=und.M_INDEX
left join CM_FUT_DBF fut on ind.M_COM_FUT=fut.M_REFERENCE
left join CM_INDEX_DBF indcm on ind.M_COM_IND=indcm.M_REFERENCE
left join CM_INDEX_DBF undcm on und.M_COM_IND=undcm.M_REFERENCE
left join CM_INDEX_DBF nbyind on ind.M_COM_FUT=nbyind.M_REFERENCE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT=indqot.M_REFERENCE
left join CMC_QUOT_DBF undqot on und.M_COM_QUOT=undqot.M_REFERENCE
left join CM_UNIT_DBF indunit on ind.M_UNIT_REF1=indunit.M_REFERENCE
left join CM_UNIT_DBF indqotunit on indqot.M_UNIT=indqotunit.M_REFERENCE
left join CM_UNIT_DBF undqotunit on undqot.M_UNIT=undqotunit.M_REFERENCE
left join CM_MKT_DBF indqotpub on indqot.M_PUBLI=indqotpub.M_REFERENCE
left join CM_PHYS_DBF fys on indcm.M_PHYSICAL=fys.M_REFERENCE
left join CM_LOCAT_DBF loc on indcm.M_LOCATION=loc.M_REFERENCE

where ind.M_CATEGORY=8 and ind.M_RESET=6
order by ast.M_LABEL, ass.M_LABEL, ind.M_IND_LAB
