select
case ind.M_CATEGORY
when 0 THEN 'Rate'
when 1 THEN 'Equity' 
when 2 THEN 'Bond'
when 3 THEN 'Inflation' 
when 4 THEN 'FX Spot'
when 5 then 'Mortgage'
when 6 then 'Generic'
when 7 then 'Formula' 
when 8 THEN 'Com SPT' 
when 9 THEN 'Com FWD' else null end CAT,
case  ind.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end IND_TYPE,
case  ind.M_RESET
when 0 then rtrim(asts.M_LABEL)
else rtrim(asti.M_LABEL) end ATYPE,
case  ind.M_RESET
when 0 then rtrim(asss.M_LABEL)
else rtrim(assi.M_LABEL) end ASSET,
rtrim(indcm.M_LABEL) IND_LABEL, 
case  ind.M_RESET
when 0 then rtrim(indcm.M_DESC) else rtrim(ind.M_IND_DESC) end IND_DESC, 
rtrim(ind.M_IND_LAB) INDEX_, 
rtrim(ind.M_IND_CODE) IND_CODE, rtrim(indqot.M_TRAD_SMB) QOT_SYMBOL,
coalesce(indcm.M_LOTSIZE, undcm.M_LOTSIZE) LOTSIZ,
case
when indgrp.M_GRP_DESC='Commodity publication' then'Publication' else 'Archiving' end ARC_TYP,
case when ind.M_RESET=0 then rtrim(indqotpub.M_LABEL) else rtrim(indgrp.M_GRP_DESC) end ARC_SRC ,
case when ind.M_RESET=0 then rtrim(indqotpub.M_CALENDAR) else rtrim(indgrp.M_CALENDAR) end ARC_CAL,  
indqotpub.M_FREQUENCY ARC_FRQ,
('B'||rtrim(indgrp.M_HISFILE)||'_HBS') HIS,
case indcm.M_DEL_MECHAN
when 0 then 'Stock'
when 1 then 'Flow' else null end DLV, 
indcm.M_QUOT_SET QOTSET, indqot.M_REFERENCE QOTREF,
case
when ind.M_RESET=0 then rtrim(indqot.M_LABEL) 
when ind.M_RESET=3 then rtrim(undqot.M_LABEL) end IND_QUOT,
case undqot.M__TYPE_
when  1 then 'Index'
when  2 then 'Future'
when  4 then 'Dlv.flow'
when  8 then 'Spread'
when  5 then 'Index flow'
when  6 then 'Future flow'
when 14 then 'Spread fut.flow' 
when 16 then 'Listed option' else null end QUOT_TYP,
indqot.M_REFERENCE,
indqot.M__TYPE_,
case 
when ind.M_RESET=3 then undqot.M_CURR 
when ind.M_RESET=4 then ind.M_CURRENCY else ind.M_COM_CUR end IND_CUR,
case 
when ind.M_RESET=0 then rtrim(indqotunitq.M_LABEL)
when ind.M_RESET=3 then rtrim(undqotunitq.M_LABEL) 
when ind.M_RESET=4 then rtrim(indunitq.M_LABEL) 
when ind.M_RESET=6 then rtrim(indqotunitq.M_LABEL) end IND_UNITQ,
case 
when ind.M_RESET=0 then rtrim(indqotunitd.M_LABEL)
when ind.M_RESET=3 then rtrim(undqotunitd.M_LABEL) 
when ind.M_RESET=4 then rtrim(indunitd.M_LABEL) 
when ind.M_RESET=6 then rtrim(indqotunitd.M_LABEL) end IND_UNITD,
/*
case
when (ind.M_CRND_RULE=0) then 'None' 
when (ind.M_CRND_RULE=1) then 'Nearest'  
when (ind.M_CRND_RULE=2) then 'By default' 
when (ind.M_CRND_RULE=3) then 'By excess' 
when (ind.M_ROUND_RUL = 5) then 'Nearest 5th' 
when (ind.M_ROUND_RUL = 6) then 'By excess 5th'
when (ind.M_ROUND_RUL = 7) then 'By default 5th' end ROUND_RULE,
*/
ind.M_CRND_DEC ROUND_DECIM,
indqot.M_PRC_FACT DISP_CURPF, 
indqot.M_PRC_WIDTH DISP_PRCSIZE, indqot.M_PRC_DEC DISP_PRCDEC,
indqot.M_VOL_WIDTH DISP_VOLSIZE, indqot.M_VOL_DEC DISP_VOLDEC,
rtrim(fystyp.M_LABEL) FYS_TYP, rtrim(fys.M_LABEL) PHYSICAL, 
case when fys.M_CNV_VW=1 then fys.M_CNV_VWF1 else null end CNV_VW_FCT,  
cnv_vw_v.M_LABEL CNV_VW_V,  cnv_vw_w.M_LABEL CNV_VW_W,  
rtrim(loctyp.M_LABEL) LOC_TYP, rtrim(loc.M_LABEL) LOCATION,
ind.M_INDEX, ind.M_REFERENCE

from RT_INDEX_DBF ind
left join RT_GROUP_DBF indgrp on ind.M_HISFILE=indgrp.M_HISFILE
left outer join RT_INDEX_DBF und on ind.M_UNDRL=und.M_INDEX
left join CM_FUT_DBF fut on ind.M_COM_FUT=fut.M_REFERENCE
left join CM_INDEX_DBF indcm on ind.M_COM_IND=indcm.M_REFERENCE
left join CM_INDEX_DBF undcm on und.M_COM_IND=undcm.M_REFERENCE
left join CM_INDEX_DBF nbyind on ind.M_COM_FUT=nbyind.M_REFERENCE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT=indqot.M_REFERENCE
left join CMC_QUOT_DBF undqot on und.M_COM_QUOT=undqot.M_REFERENCE
left join CM_UNIT_DBF indunitq on ind.M_UNIT_REF1=indunitq.M_REFERENCE
left join CM_UNIT_DBF indunitd on ind.M_UNIT_REF0=indunitd.M_REFERENCE
left join CM_UNIT_DBF indqotunitq on indqot.M_UNIT=indqotunitq.M_REFERENCE
left join CM_UNIT_DBF indqotunitd on indqot.M_QTY_UNIT=indqotunitd.M_REFERENCE
left join CM_UNIT_DBF undqotunitq on undqot.M_UNIT=undqotunitq.M_REFERENCE
left join CM_UNIT_DBF undqotunitd on undqot.M_QTY_UNIT=undqotunitd.M_REFERENCE
left join CM_MKT_DBF indqotpub on indqot.M_PUBLI=indqotpub.M_REFERENCE
left join CM_PHYS_DBF fys on indcm.M_PHYSICAL=fys.M_REFERENCE
left join CM_PTYPE_DBF fystyp on fys.M_TYPE = fystyp.M_REFERENCE
left join CM_UNIT_DBF cnv_ew_e  on fys.M_CNV_EWU0 = cnv_ew_e.M_REFERENCE  
left join CM_UNIT_DBF cnv_ew_w on fys.M_CNV_EWU1 = cnv_ew_w.M_REFERENCE  
left join CM_UNIT_DBF cnv_vw_v on fys.M_CNV_VWU0 = cnv_vw_v.M_REFERENCE  
left join CM_UNIT_DBF cnv_vw_w on fys.M_CNV_VWU1 = cnv_vw_w.M_REFERENCE
left join CM_LOCAT_DBF loc on indcm.M_LOCATION=loc.M_REFERENCE
left join CM_LTYPE_DBF loctyp on loc.M_TYPE = loctyp.M_REFERENCE
left join CM_ASSET_DBF assi on ltrim(ind.M_RT_SELAB)= to_char(assi.M_REFERENCE)
left join CM_ATYPE_DBF asti on assi.M_TYPE = asti.M_REFERENCE
left join CM_ASSET_DBF asss on indcm.M_ASSET = asss.M_REFERENCE
left join CM_ATYPE_DBF asts on asss.M_TYPE = asts.M_REFERENCE

where 1 = 1
and ind.M_CATEGORY = 8 and ind.M_RESET = 0
-- and indqot.M_REFERENCE is null
-- and indcm.M_REFERENCE = 1221

order by ind.M_RESET, ind.M_IND_LAB