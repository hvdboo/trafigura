select 
rtrim(ast.M_LABEL) ATYPE, rtrim(ass.M_LABEL) ASSET,
rtrim(ind.M_IND_LAB) IND_LABEL, rtrim(ind.M_IND_DESC) IND_DESC, 
case
when ind.M_RESET=0 then rtrim(indqotpub.M_LABEL) else rtrim(indgrp.M_GRP_DESC) end ARC_SRC ,
rtrim(indgrp.M_CALENDAR) ARC_CAL,  
case 
when ind.M_RESET=3 then undqot.M_CURR 
when ind.M_RESET=4 then ind.M_CURRENCY else ind.M_COM_CUR end IND_CUR,
case 
when ind.M_RESET=0 then rtrim(indqotunit.M_LABEL)
when ind.M_RESET=3 then rtrim(undqotunit.M_LABEL) 
when ind.M_RESET=4 then rtrim(indunit.M_LABEL) 
when ind.M_RESET=6 then rtrim(indqotunit.M_LABEL) end IND_UNITQ,
case
when ind.M_RESET=0 then 'Spot' 
when ind.M_RESET=3 then 
case  und.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end 
when ind.M_RESET=4 then 'Basket' 
when ind.M_RESET=6 then 'Future' end UND_TYP, 
case
when ind.M_RESET=0 then rtrim(indcm.M_LABEL) 
when ind.M_RESET=6 and ind.M_COM_NBY_T=0 then rtrim(fut.M_LABEL) 
when ind.M_RESET=6 and ind.M_COM_NBY_T=2 then rtrim(nbyind.M_LABEL) 
else rtrim(und.M_IND_LAB) end UND_LABEL, 
rtrim(hsr.M_LABEL) UND_HSR,
case
when (ind.M_RESET <> 0) and (ind.M_ESTIM_MODE=0) then 'Current'
when (ind.M_RESET <> 0) and (ind.M_ESTIM_MODE=1) then 'Underlying' else '' end IND_ESTIM, 
case
when ind.M_MEAN_TYPE=0 then 'Simple' end MEAN,         
rtrim(ind.M_UEI) AVG_FIXING, 
case when ind.M_F_SHIFT = 1 then
case ind.M_U_LSHIFT
when 0  then 'first' 
when 1  then 'last'  end else '' end AVG_SHIFDAT1,
rtrim(ind.M_F_SHIFTER) AVG_SHIFSHIFT1,
case when ind.M_L_SHIFT = 1 then
case ind.M_U_FSHIFT
when 0 then 'first' 
when 1 then 'last'  end else '' end AVG_SHIFDAT2,
rtrim(ind.M_L_SHIFTER) AVG_SHIFSHIFT2,
case 
when (ind.M_FIRST_EXCL=0) then 'Included' 
when (ind.M_FIRST_EXCL=1) then 'Excluded'  end AVG_EXCLF,
case 	
when (ind.M_LAST_EXCL=0) then 'Included' 
when (ind.M_LAST_EXCL=1) then 'Excluded'  end AVG_EXCLL, 
case
when (ind.M_EXCLUDE=0) then 'No' 
when (ind.M_EXCLUDE=1) then 'Yes'  end AVG_EXCL,
case
when (ind.M_BROKEN=0) then 'Up front' 
when (ind.M_BROKEN=1) then 'In arrears' else '' end AVG_STUB,
case
when (ind.M_CRND_RULE=0) then 'None' 
when (ind.M_CRND_RULE=1) then 'Nearest'  
when (ind.M_CRND_RULE=2) then 'By default' 
when (ind.M_CRND_RULE=3) then 'By excess' 
when (ind.M_ROUND_RUL = 5) then 'Nearest 5th' 
when (ind.M_ROUND_RUL = 6) then 'By excess 5th'
when (ind.M_ROUND_RUL = 7) then 'By default 5th' end ROUND_RULE,
ind.M_CRND_DEC ROUND_DECIM,
ind.M_REFERENCE INDUID

from RT_INDEX_DBF ind
left join RT_GROUP_DBF indgrp on ind.M_HISFILE=indgrp.M_HISFILE
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB)) = ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left outer join RT_INDEX_DBF und on ind.M_UNDRL = und.M_INDEX
left join CM_FUT_DBF fut on ind.M_COM_FUT = fut.M_REFERENCE
left join CM_INDEX_DBF indcm on ind.M_COM_IND = indcm.M_REFERENCE
left join CM_INDEX_DBF undcm on und.M_COM_IND = undcm.M_REFERENCE
left join CM_INDEX_DBF nbyind on ind.M_COM_FUT = nbyind.M_REFERENCE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT = indqot.M_REFERENCE
left join CMC_QUOT_DBF undqot on und.M_COM_QUOT = undqot.M_REFERENCE
left join CM_UNIT_DBF indunit on ind.M_UNIT_REF1 = indunit.M_REFERENCE
left join CM_UNIT_DBF indqotunit on indqot.M_UNIT = indqotunit.M_REFERENCE
left join CM_UNIT_DBF undqotunit on undqot.M_UNIT = undqotunit.M_REFERENCE
left join CM_MKT_DBF indqotpub on indqot.M_PUBLI = indqotpub.M_REFERENCE
left join CM_MKTSR_DBF hsr on rtrim(substr(ind.M_UNDRL_FORMULA,2,8)) = to_char(hsr.M_SERIE)
left join CM_PHYS_DBF fys on indcm.M_PHYSICAL=fys.M_REFERENCE
left join CM_LOCAT_DBF loc on indcm.M_LOCATION=loc.M_REFERENCE

where ind.M_CATEGORY=8 and ind.M_RESET=3 and ind.M_CREAT_MODE = 0 and ass.M_LABEL not in ('_ASSET')
order by ind.M_RESET, ast.M_LABEL, ass.M_LABEL, ind.M_IND_LAB