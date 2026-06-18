select
rtrim(ast.M_LABEL) ATYPE, 
rtrim(ass.M_LABEL) ASSET,
rtrim(cmp.M_IND_LAB)  LABEL, 
rtrim(cmp.M_IND_DESC) DESCRIPTION,
rtrim(grp.M_GRP_DESC) ARCHIVING,
rtrim(grp.M_HISFILE)  HIS, 
rtrim(cmp.M_CURRENCY) CUR, 
rtrim(uoq.M_LABEL) UOQ, 
rtrim(uod.M_LABEL) UOD,
case cmp.M_CRND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' 
when 5 then 'Nearest 5th' 
when 6 then 'By excess 5th'
when 7 then 'By default 5th' end BASK_RNDRUL,
cmp.M_CRND_DEC BSK_RNDDEC,
--udf.M_LOT BSKLOT,
ind.M_LOTSIZE ELTLOT,
-- cmp.M_REFERENCE,
case cmp.M_BSK_MODE
when 0 then 'Weighted Average' 
when 1 then 'Sum'
when 2 then 'Multiplication'
when 3 then 'Max'
when 4 then 'Min'
when 5 then 'Ratio'
when 6 then 'Inverse' end as BSKTYP,
case
when (cmp.M_RESET <> 0) and (cmp.M_ESTIM_MODE=0) then 'Current Index'
when (cmp.M_RESET <> 0) and (cmp.M_ESTIM_MODE=1) then 'Underlying Indices' else '' end as ESTIM,
case cmp.M_AVG_UND
when 0 then 'None'
when 3 then 'Average'
when 5 then 'Start-End' else null end UNDFRM,
case cmp.M_AVG_UND 
when 3 then rtrim(cmp.M_UEI) else null end UNDFRQ,
bsk.M_ORDER + 1 ELT_ORDER,
case bsk.M_REFERENCE_COMPONENT
when 1 then 'Ref' else null end ELT_REF, 
case
when elt.M_CATEGORY = 4 then 'FX Index'
when elt.M_CATEGORY = 6 then 'Generic'
when elt.M_CATEGORY = 7 then 'Formula'
when elt.M_CATEGORY = 9 then 'Fut.index'
when elt.M_CATEGORY = 8 then
case elt.M_RESET
when 0 then 'CM Spot'
when 3 then 'CM Average'
when 4 then 'CM Basket'
when 6 then 'CM Nearby' end end ELT_TYPE,
rtrim(elt.M_IND_LAB) ELT_LABEL, 
-- elt.M_REFERENCE,
rtrim(hsr.M_LABEL) ELT_SERIE,
/*
case
when elt.M_CATEGORY = 8 then
case elt.M_RESET
when 0 then ind.M_LABEL end end IND,
case
when elt.M_CATEGORY = 8 then
case elt.M_RESET
when 0 then ind.M_COMMENT0 end end CMT,*/
bsk.M_WEIGHT ELT_WEIGHT,
bsk.M_SPREAD ELT_SPREAD,
bsk.M_POWER  ELT_POWER,
case
when bsk.M_CUSTOMIZED_CONVERSION = 0 then 'Inherited' 
when bsk.M_CUSTOMIZED_CONVERSION = 1 then 'Customized' end as ELT_CNVMOD, 
bsk.M_CONVERSION ELT_CNVFCT,
case bsk.M_ROUND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' 
when 5 then 'Nearest 5th' 
when 6 then 'By excess 5th'
when 7 then 'By default 5th' end ELT_RNDRUL,
bsk.M_ROUND_DECIMALS ELT_RNDDEC

from RT_INDEX_DBF cmp
left join RT_GROUP_DBF grp on cmp.M_HISFILE = grp.M_HISFILE
left join CM_UNIT_DBF uod on cmp.M_UNIT_REF0 = uod.M_REFERENCE
left join CM_UNIT_DBF uoq on cmp.M_UNIT_REF1 = uoq.M_REFERENCE
left outer join RT_INDBK_COMPONENT_DBF bsk on cmp.M_REFERENCE = bsk.M_BASKET_REFERENCE 
left outer join RT_INDEX_DBF elt on bsk.M_INDEX = elt.M_INDEX 
left outer join CM_MKTSR_DBF hsr on trim(substr(bsk.M_FORMULA,2,10)) = to_char(hsr.M_SERIE)
left join CM_INDEX_DBF ind on elt.M_COM_IND = ind.M_REFERENCE
left join CM_ASSET_DBF ass on to_number(ltrim(cmp.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
--left join TABLE#DATA#INDEXES_DBF udf on rtrim(cmp.M_INDEX) = rtrim(udf.M_INDEX)

where 1 = 1 
and cmp.M_CATEGORY = 8 and cmp.M_RESET = 4 and cmp.m_CREAT_MODE = 0

-- and ass.M_LABEL <> 'FRT'

order by ast.M_LABEL, ass.M_LABEL, cmp.M_IND_LAB, bsk.M_ORDER
