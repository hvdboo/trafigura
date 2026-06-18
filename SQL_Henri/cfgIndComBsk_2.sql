select
-- ASSET
rtrim(ast.M_LABEL) ASSTYP, 
rtrim(ass.M_LABEL) ASSLAB,
-- INDEX
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then 'Spot'
    when 3 then 'Average' 
    when 4 then 'Basket'
    when 5 then 'Start-end'
    when 6 then 'Nearby' end 
when 9 then 
    case ind.M_FUT_CAT 
    when 0 then 'Forward' 
    when 1 then 'Option' end
end INDTYP,
rtrim(ind.M_IND_LAB)  INDLAB,
rtrim(ind.M_IND_DESC) INDDES,
rtrim(grp.M_GRP_DESC) ARC,
rtrim(ind.M_CURRENCY) CUR, 
rtrim(uoq.M_LABEL)    UOQ,
rtrim(uod.M_LABEL)    UOD,
-- ROUNDING
case
when (ind.M_CRND_RULE = 0) then 'None' 
when (ind.M_CRND_RULE = 1) then 'Nearest'  
when (ind.M_CRND_RULE = 2) then 'By default' 
when (ind.M_CRND_RULE = 3) then 'By excess' 
when (ind.M_ROUND_RUL = 5) then 'Nearest 5th' 
when (ind.M_ROUND_RUL = 6) then 'By excess 5th'
when (ind.M_ROUND_RUL = 7) then 'By default 5th' end RNDRUL,
ind.M_CRND_DEC RNDDEC,
case
when (ind.M_RESET <> 0) and (ind.M_ESTIM_MODE = 0) then 'Current'
when (ind.M_RESET <> 0) and (ind.M_ESTIM_MODE = 1) then 'Underlying' else '' end as BSKESTIM,
case ind.M_BSK_MODE
when 0 then 'Weighted Average' 
when 1 then 'Sum'
when 2 then 'Multiplication'
when 3 then 'Max'
when 4 then 'Min'
when 5 then 'Ratio'
when 6 then 'Inverse' end as BSKFRM,
case ind.M_AVG_UND
when 0 then 'None'
when 3 then 'Average'
when 5 then 'Start-End' else null end OBSFRM,
case ind.M_AVG_UND 
when 3 then rtrim(ind.M_UEI) else null end OBSFRQ,
case sch.M_CALENDAR
when 0 then 'None'
when 1 then 'Week-end'
when 2 then 'External'
when 3 then 'Internal: '||rtrim(sch.M_STRCALEN)
when 4 then 'External+' else null end OBSCAL,
-- ELEMENTS
bskgrp.ELTOCC ELTOCC,
case 
when bskelt0.M_REFERENCE_COMPONENT = 1 then 0
when bskelt1.M_REFERENCE_COMPONENT = 1 then 1
when bskelt2.M_REFERENCE_COMPONENT = 1 then 2
when bskelt3.M_REFERENCE_COMPONENT = 1 then 3
else null end ELTREF,
-- ELT0
bskelt0.M_ORDER ELTORD0,
case bskelt0.M_REFERENCE_COMPONENT when 1 then 'Ref' else null end ELTREF0, 
bskelt0.M_WEIGHT WGT0,
case
when ind0.M_CATEGORY = 4 then 'Forex'
when ind0.M_CATEGORY = 6 then 'Generic'
when ind0.M_CATEGORY = 7 then 'Formula'
when ind0.M_CATEGORY = 8 then
   case ind0.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end 
when ind0.M_CATEGORY = 9 then 'FWD' else null end INDTYP0,
rtrim(ind0.M_IND_LAB)  INDLAB0,
rtrim(ind0.M_IND_DESC) INDDES0,
case
when ind0.M_CATEGORY = 8 then
   case ind0.M_RESET
   when 0 then rtrim(qot0.M_LABEL)
   when 3 then rtrim(undqot0.M_LABEL)
   when 4 then rtrim(bskundqot0.M_LABEL)
   when 6 then coalesce(rtrim(nbyfccqot0.M_LABEL), rtrim(nbyfcsqot0.M_LABEL),rtrim(nbyqot0.M_LABEL)) else null end 
when ind0.M_CATEGORY = 9 then rtrim(qot0.M_LABEL) else null end INDQOT0,
case ind0.M_RESET
when 0 then rtrim(pub0.M_LABEL)
when 3 then rtrim(grp0.M_GRP_DESC) 
when 4 then rtrim(grp0.M_GRP_DESC)
when 6 then rtrim(pub0.M_LABEL) else null end INDPUB0,
case ind0.M_RESET
when 0 then rtrim(pub0.M_CALENDAR)
when 3 then rtrim(grp0.M_CALENDAR) 
when 4 then rtrim(grp0.M_CALENDAR)
when 6 then rtrim(pub0.M_CALENDAR) else null end INDCAL0,
rtrim(hsr0.M_LABEL) HSR0,
/*
case ind0.M_RESET
when 0 then qot0.M_CURR
when 3 then coalesce(rtrim(undqot0.M_CURR), rtrim(und0.M_CURRENCY))
when 4 then rtrim(ind0.M_CURRENCY)
when 6 then rtrim(ind0.M_COM_CUR) else null end CUR0, 
case ind0.M_RESET
when 0 then rtrim(qotuoq0.M_LABEL)
when 3 then coalesce(rtrim(undqotuoq0.M_LABEL), rtrim(qotuoq0.M_LABEL))
when 4 then rtrim(uoq0.M_LABEL)
when 6 then rtrim(qotuoq0.M_LABEL) else null end UOQ0,
case ind0.M_RESET
when 0 then rtrim(qotuod0.M_LABEL)
when 3 then coalesce(rtrim(undqotuod0.M_LABEL), rtrim(qotuod0.M_LABEL))
when 4 then rtrim(uod0.M_LABEL)
when 6 then rtrim(qotuod0.M_LABEL) else null end UOD0,
*/
case bskelt0.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end CNVMOD0, 
bskelt0.M_CONVERSION CNVFCT0,
bskelt0.M_SPREAD     SPR0,
bskelt0.M_POWER      PWR0,
case ind0.M_RESET
when 0 then 'SPT'
when 3 then 
   case ind0.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end
when 4 then 
   case bskund0.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end
when 6 then 
   case ind0.M_COM_NBY_T 
   when 0 then 'FWD' 
   when 2 then 'SPT' else null end 
else null end UNDTYP0,
case ind0.M_RESET
when 0 then rtrim(ind0.M_IND_LAB)
when 3 then rtrim(und0.M_IND_LAB)
when 4 then rtrim(bskund0.M_IND_LAB)
when 6 then coalesce(rtrim(nbyfcm0.M_LABEL),rtrim(nbyicm0.M_LABEL))  
else null end UNDLAB0,
case ind0.M_RESET
when 0 then rtrim(icm0.M_LABEL)
when 3 then rtrim(undicm0.M_LABEL)
when 4 then rtrim(bskundicm0.M_LABEL)
when 6 then coalesce(rtrim(nbyfccicm0.M_LABEL), rtrim(nbyfcsicm0.M_LABEL),rtrim(nbyicm0.M_LABEL)) else null end ICMLAB0,
case ind0.M_RESET
when 0 then rtrim(qot0.M_LABEL)
when 3 then rtrim(undqot0.M_LABEL)
when 4 then rtrim(bskundqot0.M_LABEL)
when 6 then coalesce(rtrim(nbyfccqot0.M_LABEL), rtrim(nbyfcsqot0.M_LABEL),rtrim(nbyqot0.M_LABEL)) else null end UNDQOT0,


-- ELT1
bskelt1.M_ORDER ELTORD1,
case bskelt1.M_REFERENCE_COMPONENT when 1 then 'Ref' else null end ELTREF1, 
bskelt1.M_WEIGHT WGT1,
case
when ind1.M_CATEGORY = 4 then 'Forex'
when ind1.M_CATEGORY = 6 then 'Generic'
when ind1.M_CATEGORY = 7 then 'Formula'
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end
when ind0.M_CATEGORY = 9 then 'FWD'
else null end         INDTYP1,
rtrim(ind1.M_IND_LAB) INDLAB1,

case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(qot1.M_LABEL)
   when 3 then rtrim(undqot1.M_LABEL)
   when 4 then rtrim(bskundqot1.M_LABEL)
   when 6 then coalesce(rtrim(nbyfccqot1.M_LABEL), rtrim(nbyfcsqot1.M_LABEL),rtrim(nbyqot1.M_LABEL)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(qot1.M_LABEL) else null end INDQOT1,
case ind1.M_RESET
when 0 then rtrim(pub1.M_LABEL)
when 3 then rtrim(grp1.M_GRP_DESC) 
when 4 then rtrim(grp1.M_GRP_DESC)
when 6 then rtrim(pub1.M_LABEL) else null end INDPUB1,
case ind1.M_RESET
when 0 then rtrim(pub1.M_CALENDAR)
when 3 then rtrim(grp1.M_CALENDAR) 
when 4 then rtrim(grp1.M_CALENDAR)
when 6 then rtrim(pub1.M_CALENDAR) else null end INDCAL1,
rtrim(hsr1.M_LABEL) HSR1,
case bskelt1.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end as CNVMOD1, 
bskelt1.M_CONVERSION CNVFCT1,
bskelt1.M_SPREAD SPR1,
bskelt1.M_POWER  PWR1,
case ind1.M_RESET
when 0 then 'SPT'
when 3 then 
   case ind1.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end
when 4 then 
   case bskund1.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end
when 6 then 
   case ind1.M_COM_NBY_T 
   when 0 then 'FWD' 
   when 2 then 'SPT' else null end 
else null end UNDTYP1,
case ind1.M_RESET
when 0 then rtrim(ind1.M_IND_LAB)
when 3 then rtrim(und1.M_IND_LAB)
when 4 then rtrim(bskund1.M_IND_LAB)
when 6 then coalesce(rtrim(nbyfcm1.M_LABEL),rtrim(nbyicm1.M_LABEL))  
else null end UNDLAB1,
case ind1.M_RESET
when 0 then rtrim(icm1.M_LABEL)
when 3 then rtrim(undicm1.M_LABEL)
when 4 then rtrim(icm1.M_LABEL)
when 6 then coalesce(rtrim(nbyfccicm1.M_LABEL), rtrim(nbyfcsicm1.M_LABEL),rtrim(nbyicm1.M_LABEL)) else null end ICMLAB1,
-- ELT2
bskelt2.M_ORDER ELTORD2,
case bskelt2.M_REFERENCE_COMPONENT when 1 then 'Ref' else null end ELTREF2, 
bskelt2.M_WEIGHT WGT2,
case
when ind2.M_CATEGORY = 4 then 'Forex'
when ind2.M_CATEGORY = 6 then 'Generic'
when ind2.M_CATEGORY = 7 then 'Formula'
when ind2.M_CATEGORY = 8 then
   case ind2.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end 
when ind0.M_CATEGORY = 9 then 'FWD'
else null end            INDTYP2,
rtrim(ind2.M_IND_LAB) INDLAB2,
rtrim(hsr2.M_LABEL)   HSR2,
case bskelt2.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end as CNVMOD2, 
bskelt2.M_CONVERSION CNVFCT2,
bskelt2.M_SPREAD SPR2,
bskelt2.M_POWER  PWR2,
rtrim(icm2.M_LABEL) ICMLAB2,
-- DELIVERY
case ind0.M_RESET
when 0 then rtrim(icmphy0.M_LABEL)
when 3 then coalesce(rtrim(undicmphy0.M_LABEL), rtrim(ind0.M_IND_CODE))
when 4 then rtrim(ind0.M_IND_CODE)
when 6 then coalesce(rtrim(nbyfccgnlphy0.M_LABEL), rtrim(nbyfcsicmphy0.M_LABEL), rtrim(nbyicmphy0.M_LABEL)) else null end PHYLAB0,
case ind0.M_RESET
when 0 then rtrim(icmloc0.M_LABEL)
when 3 then rtrim(undicmloc0.M_LABEL)
when 4 then null
when 6 then coalesce(rtrim(nbyfccgnlloc0.M_LABEL), rtrim(nbyfcsicmloc0.M_LABEL), rtrim(nbyicmloc0.M_LABEL)) else null end LOCLAB0,
rtrim(grp.M_HISFILE) HIS,
-- UID
ind.M_REFERENCE  INDUID,
ind0.M_REFERENCE INDUID0,
case ind0.M_RESET
when 0 then ind0.M_REFERENCE
when 3 then und0.M_REFERENCE
when 4 then bskund0.M_REFERENCE
when 6 then coalesce(nbyfcm0.M_REFERENCE, nbyicm0.M_REFERENCE) else null end UNDUID0,
case ind0.M_RESET
when 0 then qot0.M_REFERENCE
when 3 then undqot0.M_REFERENCE
when 4 then bskundqot0.M_REFERENCE
when 6 then nbyqot0.M_REFERENCE else null end QOTUID0,
case ind0.M_RESET
when 0 then ind0.M_INDEX
when 3 then und0.M_INDEX
when 4 then bskund0.M_INDEX
when 6 then coalesce(nbyfccind0.M_INDEX, nbyfcsind0.M_INDEX, concat(lpad(nbyicm0.M_REFERENCE,7),lpad(nbyqot0.M_REFERENCE,8))) else null end ICMNDX0,
case ind0.M_RESET
when 0 then icm0.M_REFERENCE
when 3 then undicm0.M_REFERENCE
when 4 then bskundicm0.M_REFERENCE
when 6 then coalesce(nbyfccicm0.M_REFERENCE, nbyfcsicm0.M_REFERENCE, nbyicm0.M_REFERENCE) else null end ICMUID0,
ind1.M_REFERENCE INDUID1,
case ind1.M_RESET
when 0 then icm1.M_REFERENCE
when 3 then undicm1.M_REFERENCE
when 4 then icm1.M_REFERENCE
when 6 then coalesce(nbyfccicm1.M_REFERENCE, nbyfcsicm1.M_REFERENCE, nbyicm1.M_REFERENCE) else null end ICMUID1,
ind2.M_REFERENCE INDUID2,
icm2.M_REFERENCE ICMUID2,
case ind0.M_RESET
when 0 then icmphy0.M_REFERENCE
when 3 then undicmphy0.M_REFERENCE
when 4 then 
   case
   when rtrim(ind0.M_IND_LAB) = 'C3 MBT_OPIS MT'         then 25
   when rtrim(ind0.M_IND_LAB) = 'F35 RTM FB_PLA BBL'     then 82
   when rtrim(ind0.M_IND_LAB) = 'GI EBOX ARA FB_ARG BBL' then 39
   when rtrim(ind0.M_IND_LAB) = 'GI RBOB 1LE BBL'        then 39
   when rtrim(ind0.M_IND_LAB) = 'GO ICE 1LP BBL'         then 73 
   when substr(ind0.M_IND_LAB,1,3) = 'CPO'               then 103
   when substr(ind0.M_IND_LAB,1,3) = 'FRT'               then 184 else null end 
when 6 then coalesce(nbyfccgnlphy0.M_REFERENCE, nbyfcsicmphy0.M_REFERENCE, nbyicmphy0.M_REFERENCE) else null end PHYUID0,
case ind0.M_RESET
when 0 then icmloc0.M_REFERENCE
when 3 then undicmloc0.M_REFERENCE
when 4 then null
when 6 then coalesce(nbyfccgnlloc0.M_REFERENCE, nbyfcsicmloc0.M_REFERENCE, nbyicmloc0.M_REFERENCE) else null end LOCUID0

from RT_INDEX_DBF ind
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_UNIT_DBF  uod on ind.M_UNIT_REF0 = uod.M_REFERENCE
left join CM_UNIT_DBF  uoq on ind.M_UNIT_REF1 = uoq.M_REFERENCE
left join DAT_ECH_DBF  sch on rtrim(ind.M_UEI) = rtrim(sch.M_LABEL)
left join RT_INDBK_COMPONENT_DBF bskeltr on (ind.M_REFERENCE = bskeltr.M_BASKET_REFERENCE and bskeltr.M_REFERENCE_COMPONENT = 1)
left join RT_INDBK_COMPONENT_DBF bskelt0 on (ind.M_REFERENCE = bskelt0.M_BASKET_REFERENCE and bskelt0.M_ORDER = 0)
left join RT_INDBK_COMPONENT_DBF bskelt1 on (ind.M_REFERENCE = bskelt1.M_BASKET_REFERENCE and bskelt1.M_ORDER = 1)
left join RT_INDBK_COMPONENT_DBF bskelt2 on (ind.M_REFERENCE = bskelt2.M_BASKET_REFERENCE and bskelt2.M_ORDER = 2)
left join RT_INDBK_COMPONENT_DBF bskelt3 on (ind.M_REFERENCE = bskelt3.M_BASKET_REFERENCE and bskelt3.M_ORDER = 3)
-- ELT0
left join RT_INDEX_DBF ind0 on bskelt0.M_INDEX = ind0.M_INDEX
left join RT_GROUP_DBF grp0 on ind0.M_HISFILE = grp0.M_HISFILE
left join CM_UNIT_DBF  uod0 on ind0.M_UNIT_REF0 = uod0.M_REFERENCE
left join CM_UNIT_DBF  uoq0 on ind0.M_UNIT_REF1 = uoq0.M_REFERENCE
-- Spot 0
left join CM_INDEX_DBF icm0 on ind0.M_COM_IND = icm0.M_REFERENCE and ind0.M_RESET = 0
left join CMC_QUOT_DBF qot0 on ind0.M_COM_QUOT = qot0.M_REFERENCE
left join CM_MKT_DBF   pub0 on qot0.M_PUBLI = pub0.M_REFERENCE
left join CM_UNIT_DBF  qotuoq0 on qot0.M_UNIT = qotuoq0.M_REFERENCE
left join CM_UNIT_DBF  qotuod0 on qot0.M_QTY_UNIT = qotuod0.M_REFERENCE
left join CM_MKTSR_DBF hsr0 on trim(substr(bskelt0.M_FORMULA,2,10)) = to_char(hsr0.M_SERIE)
left join CM_PHYS_DBF  icmphy0 on icm0.M_PHYSICAL = icmphy0.M_REFERENCE
left join CM_LOCAT_DBF icmloc0 on icm0.M_LOCATION = icmloc0.M_REFERENCE
-- Avg 0
left join RT_INDEX_DBF und0 on ind0.M_UNDRL = und0.M_INDEX
left join CM_INDEX_DBF undicm0 on und0.M_COM_IND  = undicm0.M_REFERENCE
left join CMC_QUOT_DBF undqot0 on und0.M_COM_QUOT = undqot0.M_REFERENCE
left join CM_MKT_DBF   undpub0 on undqot0.M_PUBLI = undpub0.M_REFERENCE
left join CM_UNIT_DBF  undqotuoq0 on undqot0.M_UNIT = undqotuoq0.M_REFERENCE
left join CM_UNIT_DBF  undqotuod0 on undqot0.M_QTY_UNIT = undqotuod0.M_REFERENCE
left join CM_PHYS_DBF  undicmphy0 on undicm0.M_PHYSICAL = undicmphy0.M_REFERENCE
left join CM_LOCAT_DBF undicmloc0 on undicm0.M_LOCATION = undicmloc0.M_REFERENCE
-- Nearby 0
left join CM_FUT_DBF   nbyfcm0 on (ind0.M_COM_FUT = nbyfcm0.M_REFERENCE and ind0.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  nbyfccgnl0 on (nbyfcm0.M_CM_INSTR = nbyfccgnl0.M_GEN_NUM and nbyfcm0.M_INS_MODE = 0 and nbyfcm0.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF nbyfccind0 on nbyfccgnl0.M_INDEX0 = nbyfccind0.M_INDEX
left join CM_INDEX_DBF nbyfccicm0 on (nbyfccind0.M_COM_IND  = nbyfccicm0.M_REFERENCE and nbyfccind0.M_RESET = 0)
left join CMC_QUOT_DBF nbyfccqot0 on (nbyfccind0.M_COM_QUOT = nbyfccqot0.M_REFERENCE and nbyfccind0.M_RESET = 0)
left join CM_PHYS_DBF  nbyfccgnlphy0 on nbyfccgnl0.M_DEL_FYS0 = nbyfccgnlphy0.M_REFERENCE
left join CM_LOCAT_DBF nbyfccgnlloc0 on nbyfccgnl0.M_DEL_LOC0 = nbyfccgnlloc0.M_REFERENCE
left join CMC_MGEN_DBF nbyfcsgnm0 on (nbyfcm0.M_CM_INSTR = nbyfcsgnm0.M_REFERENCE and nbyfcm0.M_INS_MODE = 1 and nbyfcm0.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind0 on nbyfcsgnm0.M_INDEX = nbyfcsind0.M_INDEX
left join CM_INDEX_DBF nbyfcsicm0 on (nbyfcsind0.M_COM_IND  = nbyfcsicm0.M_REFERENCE and nbyfcsind0.M_RESET = 0)
left join CM_PHYS_DBF  nbyfcsicmphy0 on nbyfcsicm0.M_PHYSICAL = nbyfcsicmphy0.M_REFERENCE
left join CM_LOCAT_DBF nbyfcsicmloc0 on nbyfcsicm0.M_LOCATION = nbyfcsicmloc0.M_REFERENCE
left join CMC_QUOT_DBF nbyfcsqot0 on (nbyfcsind0.M_COM_QUOT = nbyfcsqot0.M_REFERENCE and nbyfcsind0.M_RESET = 0)
left join CM_INDEX_DBF nbyicm0 on (ind0.M_COM_FUT  = nbyicm0.M_REFERENCE and ind0.M_COM_NBY_T = 2)
left join CMC_QUOT_DBF nbyqot0 on (ind0.M_COM_QUOT = nbyqot0.M_REFERENCE and ind0.M_COM_NBY_T = 2) and ind0.M_RESET = 6
left join CM_PHYS_DBF  nbyicmphy0 on nbyicm0.M_PHYSICAL = nbyicmphy0.M_REFERENCE
left join CM_LOCAT_DBF nbyicmloc0 on nbyicm0.M_LOCATION = nbyicmloc0.M_REFERENCE
-- Basket 0
left join RT_INDBK_COMPONENT_DBF bskeltund0 on (ind0.M_REFERENCE = bskeltund0.M_BASKET_REFERENCE and bskeltund0.M_ORDER = 0)
left join RT_INDEX_DBF bskund0 on bskeltund0.M_INDEX = bskund0.M_INDEX
left join CMC_QUOT_DBF bskundqot0 on bskund0.M_COM_QUOT = bskundqot0.M_REFERENCE
left join CM_INDEX_DBF bskundicm0 on bskund0.M_COM_IND  = bskundicm0.M_REFERENCE
left join CM_FUT_DBF   bskundnbyfcm0 on (bskund0.M_COM_FUT = bskundnbyfcm0.M_REFERENCE and bskund0.M_COM_NBY_T = 0)
-- ELT1
left join RT_INDEX_DBF ind1 on bskelt1.M_INDEX = ind1.M_INDEX 
left join RT_GROUP_DBF grp1 on ind1.M_HISFILE = grp1.M_HISFILE
left join CM_UNIT_DBF  uod1 on ind1.M_UNIT_REF0 = uod1.M_REFERENCE
left join CM_UNIT_DBF  uoq1 on ind1.M_UNIT_REF1 = uoq1.M_REFERENCE
-- Spot 1
left join CM_INDEX_DBF icm1 on ind1.M_COM_IND = icm1.M_REFERENCE and ind1.M_RESET = 0
left join CMC_QUOT_DBF qot1 on ind1.M_COM_QUOT = qot1.M_REFERENCE
left join CM_MKT_DBF   pub1 on qot1.M_PUBLI = pub1.M_REFERENCE
left join CM_UNIT_DBF  qotuoq1 on qot1.M_UNIT = qotuoq1.M_REFERENCE
left join CM_UNIT_DBF  qotuod1 on qot1.M_QTY_UNIT = qotuod1.M_REFERENCE
left join CM_MKTSR_DBF hsr1 on trim(substr(bskelt1.M_FORMULA,2,10)) = to_char(hsr1.M_SERIE)
left join CM_PHYS_DBF  icmphy1 on icm1.M_PHYSICAL = icmphy1.M_REFERENCE
left join CM_LOCAT_DBF icmloc1 on icm1.M_LOCATION = icmloc1.M_REFERENCE
-- Avg 1
left join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join CM_INDEX_DBF undicm1 on und1.M_COM_IND  = undicm1.M_REFERENCE
left join CMC_QUOT_DBF undqot1 on und1.M_COM_QUOT = undqot1.M_REFERENCE
left join CM_MKT_DBF   undpub1 on undqot1.M_PUBLI = undpub1.M_REFERENCE
left join CM_UNIT_DBF  undqotuoq1 on undqot1.M_UNIT = undqotuoq1.M_REFERENCE
left join CM_UNIT_DBF  undqotuod1 on undqot1.M_QTY_UNIT = undqotuod1.M_REFERENCE
left join CM_PHYS_DBF  undicmphy1 on undicm1.M_PHYSICAL = undicmphy1.M_REFERENCE
left join CM_LOCAT_DBF undicmloc1 on undicm1.M_LOCATION = undicmloc1.M_REFERENCE
-- Nearby 1
left join CM_FUT_DBF   nbyfcm1 on (ind1.M_COM_FUT = nbyfcm1.M_REFERENCE and ind1.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  nbyfccgnl1 on (nbyfcm1.M_CM_INSTR = nbyfccgnl1.M_GEN_NUM and nbyfcm1.M_INS_MODE = 0 and nbyfcm1.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF nbyfccind1 on nbyfccgnl1.M_INDEX0 = nbyfccind1.M_INDEX
left join CM_INDEX_DBF nbyfccicm1 on (nbyfccind1.M_COM_IND = nbyfccicm1.M_REFERENCE and nbyfccind1.M_RESET = 0)
left join CMC_QUOT_DBF nbyfccqot1 on (nbyfccind1.M_COM_QUOT = nbyfccqot1.M_REFERENCE and nbyfccind1.M_RESET = 0)
left join CM_PHYS_DBF  nbyfccgnlphy1 on nbyfccgnl1.M_DEL_FYS0 = nbyfccgnlphy1.M_REFERENCE
left join CM_LOCAT_DBF nbyfccgnlloc1 on nbyfccgnl1.M_DEL_LOC0 = nbyfccgnlloc1.M_REFERENCE
left join CMC_MGEN_DBF nbyfcsgnm1 on (nbyfcm1.M_CM_INSTR = nbyfcsgnm1.M_REFERENCE and nbyfcm1.M_INS_MODE = 1 and nbyfcm1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind1 on nbyfcsgnm1.M_INDEX = nbyfcsind1.M_INDEX
left join CM_INDEX_DBF nbyfcsicm1 on (nbyfcsind1.M_COM_IND = nbyfcsicm1.M_REFERENCE and nbyfcsind1.M_RESET = 0)
left join CM_PHYS_DBF  nbyfcsicmphy1 on nbyfcsicm1.M_PHYSICAL = nbyfcsicmphy1.M_REFERENCE
left join CM_LOCAT_DBF nbyfcsicmloc1 on nbyfcsicm1.M_LOCATION = nbyfcsicmloc1.M_REFERENCE
left join CMC_QUOT_DBF nbyfcsqot1 on (nbyfcsind1.M_COM_QUOT = nbyfcsqot1.M_REFERENCE and nbyfcsind1.M_RESET = 0)
left join CM_INDEX_DBF nbyicm1 on (ind1.M_COM_FUT = nbyicm1.M_REFERENCE and ind1.M_COM_NBY_T = 2)
left join CM_PHYS_DBF  nbyicmphy1 on nbyicm1.M_PHYSICAL = nbyicmphy1.M_REFERENCE
left join CM_LOCAT_DBF nbyicmloc1 on nbyicm1.M_LOCATION = nbyicmloc1.M_REFERENCE
left join CMC_QUOT_DBF nbyqot1 on ind1.M_COM_QUOT = nbyqot1.M_REFERENCE and ind1.M_RESET = 6
-- Basket 1
left join RT_INDBK_COMPONENT_DBF bskeltund1 on (ind1.M_REFERENCE = bskeltund1.M_BASKET_REFERENCE and bskeltund1.M_ORDER = 0)
left join RT_INDEX_DBF bskund1 on bskeltund1.M_INDEX = bskund1.M_INDEX
left join CMC_QUOT_DBF bskundqot1 on bskund1.M_COM_QUOT = bskundqot1.M_REFERENCE
left join CM_INDEX_DBF bskundicm1 on bskund1.M_COM_IND  = bskundicm1.M_REFERENCE
left join CM_FUT_DBF   bskundnbyfcm1 on (bskund1.M_COM_FUT = bskundnbyfcm1.M_REFERENCE and bskund1.M_COM_NBY_T = 0)
-- ELT2
left join RT_INDEX_DBF ind2 on bskelt2.M_INDEX = ind2.M_INDEX 
left join CM_INDEX_DBF icm2 on ind2.M_COM_IND = icm2.M_REFERENCE
left join CM_MKTSR_DBF hsr2 on trim(substr(bskelt2.M_FORMULA,2,10)) = to_char(hsr2.M_SERIE)
-- ELT3
left join RT_INDEX_DBF ind3 on bskelt3.M_INDEX = ind3.M_INDEX 
left join CM_INDEX_DBF icm3 on ind3.M_COM_IND = icm3.M_REFERENCE
left join CM_MKTSR_DBF hsr3 on trim(substr(bskelt3.M_FORMULA,2,10)) = to_char(hsr3.M_SERIE)

left join (select M_BASKET_REFERENCE ,count(*) ELTOCC from RT_INDBK_COMPONENT_DBF group by M_BASKET_REFERENCE) bskgrp on ind.M_REFERENCE = bskgrp.M_BASKET_REFERENCE

where 1 = 1 
and ind.M_CREAT_MODE = 0
and ind.M_CATEGORY = 8 
and ind.M_RESET = 4 