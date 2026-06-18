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
when bskelt1.M_REFERENCE_COMPONENT = 1 then 1
when bskelt2.M_REFERENCE_COMPONENT = 1 then 2
when bskelt3.M_REFERENCE_COMPONENT = 1 then 3
when bskelt4.M_REFERENCE_COMPONENT = 1 then 4
else null end ELTREF,
-- ELT1
bskelt1.M_ORDER + 1 ELTORD1,
bskelt1.M_REFERENCE_COMPONENT ELTREF1, 
bskelt1.M_WEIGHT WGT1,
bskelt1.M_SPREAD SPR1,
bskelt1.M_POWER  PWR1,
case
when ind1.M_CATEGORY = 4 then 'Forex'
when ind1.M_CATEGORY = 6 then 'Generic'
when ind1.M_CATEGORY = 7 then 'Formula'
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 5 then 'STE'
   when 6 then 'NBY' else null end 
when ind1.M_CATEGORY = 9 then 'FWD+MAT' else null end INDTYP1,
rtrim(ind1.M_IND_LAB)  INDLAB1,
rtrim(ind1.M_IND_DESC) INDDES1,
case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(qot1.M_LABEL)
   when 3 then rtrim(undqot1.M_LABEL)
   when 4 then rtrim(bskqot1.M_LABEL)
   when 6 then rtrim(qot1.M_LABEL) else null end 
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
case ind1.M_RESET
when 0 then qot1.M_CURR
when 3 then coalesce(rtrim(undqot1.M_CURR), rtrim(und1.M_CURRENCY))
when 4 then rtrim(ind1.M_CURRENCY)
when 6 then rtrim(ind1.M_COM_CUR) else null end CUR1, 
case ind1.M_RESET
when 0 then rtrim(qotuoq1.M_LABEL)
when 3 then coalesce(rtrim(undqotuoq1.M_LABEL), rtrim(qotuoq1.M_LABEL))
when 4 then rtrim(uoq1.M_LABEL)
when 6 then rtrim(qotuoq1.M_LABEL) else null end UOQ1,
case ind1.M_RESET
when 0 then rtrim(qotuod1.M_LABEL)
when 3 then coalesce(rtrim(undqotuod1.M_LABEL), rtrim(qotuod1.M_LABEL))
when 4 then rtrim(uod1.M_LABEL)
when 6 then rtrim(qotuod1.M_LABEL) else null end UOD1,
case bskelt1.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end CNVMOD1, 
bskelt1.M_CONVERSION CNVFCT1,
case bskelt1.M_ROUND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' end RNDRUL1, 
bskelt1.M_ROUND_DECIMALS RNDDEC1,
case ind1.M_CATEGORY
when 8 then
   case ind1.M_RESET
   when 0 then 'SPT'
   when 3 then 
      case ind1.M_RESET
      when 0 then 'SPT'
      when 3 then 'AVG'
      when 4 then 'BSK'
      when 5 then 'STE'      
      when 6 then 'NBY' else null end
   when 4 then 
      case bskind1.M_RESET
      when 0 then 'SPT'
      when 3 then 'AVG'
      when 4 then 
         case bskind11.M_RESET
         when 0 then 'SPT'
         when 3 then 'AVG'
         when 4 then 'BSK'
         when 6 then 'NBY' else 'BSK' end      
      when 6 then 'NBY' else null end
   when 6 then 
      case ind1.M_COM_NBY_T 
      when 0 then 'FWD' 
      when 2 then 'SPT' else null end
   else null end    
when 9 then 'FWD' else null end UNDTYP1,
case ind1.M_CATEGORY
when 8 then 
   case ind1.M_RESET
   when 0 then rtrim(ind1.M_IND_LAB)
   when 3 then rtrim(und1.M_IND_LAB)
   when 4 then coalesce(rtrim(bskind11.M_IND_LAB), rtrim(bskund1.M_IND_LAB))
   when 6 then coalesce(rtrim(nbyfcm1.M_LABEL),rtrim(nbyicm1.M_LABEL)) else null end
when 9 then rtrim(fut1.M_LABEL) else null end UNDLAB1,
case ind1.M_CATEGORY
when 8 then
   case ind1.M_RESET
   when 0 then rtrim(icm1.M_LABEL)
   when 3 then coalesce(rtrim(undicm1.M_LABEL), rtrim(undnbyfccicm1.M_LABEL), rtrim(undnbyfcsicm1.M_LABEL))
   when 4 then coalesce(rtrim(nbyfcsicm11.M_LABEL), rtrim(bskicm11.M_LABEL), rtrim(bskicm1.M_LABEL), rtrim(bskundicm1.M_LABEL), rtrim(bskundnbyfccicm1.M_LABEL), rtrim(bskundnbyfcsicm1.M_LABEL))
   when 6 then coalesce(rtrim(nbyfccicm1.M_LABEL), rtrim(nbyfcsicm1.M_LABEL),rtrim(nbyicm1.M_LABEL)) else null end 
when 9 then rtrim(fcsicm1.M_LABEL) else null end ICMLAB1,
case ind1.M_RESET
when 0 then rtrim(qot1.M_LABEL)
when 3 then rtrim(undqot1.M_LABEL)
when 4 then coalesce(rtrim(bskqot11.M_LABEL), rtrim(bskundqot1.M_LABEL))
when 6 then coalesce(rtrim(nbyfccqot1.M_LABEL), rtrim(nbyfcsqot1.M_LABEL),rtrim(nbyqot1.M_LABEL)) else null end ICMQOT1,
case ind1.M_CATEGORY
when 8 then
   case ind1.M_RESET
   when 0 then rtrim(pub1.M_LABEL)
   when 3 then coalesce(rtrim(undpub1.M_LABEL), rtrim(undnbyfccpub1.M_LABEL), rtrim(undnbyfcspub1.M_LABEL))
   when 4 then coalesce(rtrim(nbyfcspub11.M_LABEL), rtrim(bskpub11.M_LABEL), rtrim(bskpub1.M_LABEL), rtrim(bskundpub1.M_LABEL), rtrim(bskundnbyfccpub1.M_LABEL), rtrim(bskundnbyfcspub1.M_LABEL))
   when 6 then coalesce(rtrim(nbyfccpub1.M_LABEL), rtrim(nbyfcspub1.M_LABEL),rtrim(nbypub1.M_LABEL)) else null end 
when 9 then rtrim(fcspub1.M_LABEL) else null end ICMPUB1,
case ind1.M_CATEGORY
when 8 then
   case ind1.M_RESET
   when 0 then rtrim(hsrdfl1.M_HSR)
   when 3 then coalesce(rtrim(undhsrdfl1.M_HSR), rtrim(undnbyfcchsrdfl1.M_HSR), rtrim(undnbyfcshsrdfl1.M_HSR))
   when 4 then coalesce(rtrim(nbyfcshsrdfl11.M_HSR), rtrim(bskhsrdfl11.M_HSR), rtrim(bskhsrdfl1.M_HSR), rtrim(bskundhsrdfl1.M_HSR), rtrim(bskundnbyfcchsrdfl1.M_HSR), rtrim(bskundnbyfcshsrdfl1.M_HSR))
   when 6 then coalesce(rtrim(nbyfcchsrdfl1.M_HSR), rtrim(nbyfcshsrdfl1.M_HSR),rtrim(nbyhsrdfl1.M_HSR)) else null end 
when 9 then rtrim(fcshsrdfl1.M_HSR) else null end ICMHSR1,
case ind1.M_CATEGORY
when 8 then
   case ind1.M_RESET
   when 0 then rtrim(pub1.M_CALENDAR)
   when 3 then coalesce(rtrim(undpub1.M_CALENDAR), rtrim(undnbyfccpub1.M_CALENDAR), rtrim(undnbyfcspub1.M_CALENDAR))
   when 4 then coalesce(rtrim(nbyfcspub11.M_CALENDAR), rtrim(bskpub11.M_CALENDAR), rtrim(bskpub1.M_CALENDAR), rtrim(bskundpub1.M_CALENDAR), rtrim(bskundnbyfccpub1.M_CALENDAR), rtrim(bskundnbyfcspub1.M_CALENDAR))
   when 6 then coalesce(rtrim(nbyfccpub1.M_CALENDAR), rtrim(nbyfcspub1.M_CALENDAR),rtrim(nbypub1.M_CALENDAR)) else null end 
when 9 then rtrim(fcspub1.M_CALENDAR) else null end ICMCAL1,
case ind1.M_RESET
when 0 then rtrim(qot1.M_TRAD_SMB)
when 3 then rtrim(undqot1.M_TRAD_SMB)
when 4 then coalesce(rtrim(bskqot11.M_TRAD_SMB), rtrim(bskundqot1.M_TRAD_SMB))
when 6 then coalesce(rtrim(nbyfccqot1.M_TRAD_SMB), rtrim(nbyfcsqot1.M_TRAD_SMB),rtrim(nbyqot1.M_TRAD_SMB)) else null end ICMSYM1,
-- ELT2
bskelt2.M_ORDER + 1 ELTORD2,
bskelt2.M_REFERENCE_COMPONENT ELTREF2, 
bskelt2.M_WEIGHT WGT2,
bskelt2.M_SPREAD SPR2,
bskelt2.M_POWER  PWR2,
case
when ind2.M_CATEGORY = 4 then 'Forex'
when ind2.M_CATEGORY = 6 then 'Generic'
when ind2.M_CATEGORY = 7 then 'Formula'
when ind2.M_CATEGORY = 8 then
   case ind2.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 5 then 'STE'   
   when 6 then 'NBY' else null end
when ind2.M_CATEGORY = 9 then 'FWD'    
else null end          INDTYP2,
rtrim(ind2.M_IND_LAB)  INDLAB2,
rtrim(ind2.M_IND_DESC) INDDES2,
case
when ind2.M_CATEGORY = 8 then
   case ind2.M_RESET
   when 0 then rtrim(qot2.M_LABEL)
   when 3 then rtrim(undqot2.M_LABEL)
   when 4 then coalesce(rtrim(bskundqot2.M_LABEL), rtrim(ind2.M_CURRENCY)||'/'||rtrim(uod2.M_LABEL))
   when 6 then rtrim(qot2.M_LABEL) else null end 
when ind2.M_CATEGORY = 9 then rtrim(qot2.M_LABEL) else null end INDQOT2,
case ind2.M_RESET
when 0 then rtrim(pub2.M_LABEL)
when 3 then rtrim(grp2.M_GRP_DESC) 
when 4 then rtrim(grp2.M_GRP_DESC)
when 6 then rtrim(pub2.M_LABEL) else null end INDPUB2,
case ind2.M_RESET
when 0 then rtrim(pub2.M_CALENDAR)
when 3 then rtrim(grp2.M_CALENDAR) 
when 4 then rtrim(grp2.M_CALENDAR)
when 6 then rtrim(pub2.M_CALENDAR) else null end INDCAL2,
rtrim(hsr2.M_LABEL) HSR2,
case bskelt2.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end as CNVMOD2, 
bskelt2.M_CONVERSION CNVFCT2,
case bskelt2.M_ROUND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' end RNDRUL2, 
bskelt2.M_ROUND_DECIMALS RNDDEC2,
case ind2.M_RESET
when 0 then 'SPT'
when 3 then 
   case ind2.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 5 then 'STE'
   when 6 then 'NBY' else null end
when 4 then 
   case bskind2.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 
      case bskind21.M_RESET
      when 0 then 'SPT'
      when 3 then 'AVG'
      when 4 then 'BSK'
      when 6 then 'NBY' else 'BSK' end
   when 6 then 'NBY' else null end
when 6 then 
   case ind2.M_COM_NBY_T 
   when 0 then 'FWD' 
   when 2 then 'SPT' else null end 
else null end UNDTYP2,
case ind2.M_RESET
when 0 then rtrim(ind2.M_IND_LAB)
when 3 then rtrim(und2.M_IND_LAB)
when 4 then coalesce(rtrim(bskind21.M_IND_LAB), rtrim(bskund2.M_IND_LAB))
when 6 then coalesce(rtrim(nbyfcm2.M_LABEL),rtrim(nbyicm2.M_LABEL))  
else null end UNDLAB2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(icm2.M_LABEL)
   when 3 then coalesce(rtrim(undicm2.M_LABEL), rtrim(undnbyfccicm2.M_LABEL), rtrim(undnbyfcsicm2.M_LABEL))
   when 4 then coalesce(rtrim(nbyfcsicm21.M_LABEL), rtrim(bskicm21.M_LABEL), rtrim(bskicm2.M_LABEL), rtrim(bskundicm2.M_LABEL), rtrim(bskundnbyfccicm2.M_LABEL), rtrim(bskundnbyfcsicm2.M_LABEL))
   when 6 then coalesce(rtrim(nbyfcsundicm2.M_LABEL),rtrim(nbyfccicm2.M_LABEL), rtrim(nbyfcsicm2.M_LABEL),rtrim(nbyicm2.M_LABEL)) else null end 
when 9 then rtrim(fcsicm2.M_LABEL) else null end ICMLAB2,
case ind2.M_RESET
when 0 then rtrim(qot2.M_LABEL)
when 3 then rtrim(undqot2.M_LABEL)
when 4 then coalesce(rtrim(bskqot21.M_LABEL), rtrim(bskundqot2.M_LABEL))
when 6 then coalesce(rtrim(nbyfccqot2.M_LABEL), rtrim(nbyfcsqot2.M_LABEL),rtrim(nbyqot2.M_LABEL)) else null end ICMQOT2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(pub2.M_LABEL)
   when 3 then coalesce(rtrim(undpub2.M_LABEL), rtrim(undnbyfccpub2.M_LABEL), rtrim(undnbyfcspub2.M_LABEL))
   when 4 then coalesce(rtrim(nbyfcspub21.M_LABEL), rtrim(bskpub21.M_LABEL), rtrim(bskpub2.M_LABEL), rtrim(bskundpub2.M_LABEL), rtrim(bskundnbyfccpub2.M_LABEL), rtrim(bskundnbyfcspub2.M_LABEL))
   when 6 then coalesce(rtrim(nbyfccpub2.M_LABEL), rtrim(nbyfcspub2.M_LABEL),rtrim(nbypub2.M_LABEL)) else null end 
when 9 then rtrim(fcspub2.M_LABEL) else null end ICMPUB2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(hsrdfl2.M_HSR)
   when 3 then coalesce(rtrim(undhsrdfl2.M_HSR), rtrim(undnbyfcchsrdfl2.M_HSR), rtrim(undnbyfcshsrdfl2.M_HSR))
   when 4 then coalesce(rtrim(nbyfcshsrdfl21.M_HSR), rtrim(bskhsrdfl21.M_HSR), rtrim(bskhsrdfl2.M_HSR), rtrim(bskundhsrdfl2.M_HSR), rtrim(bskundnbyfcchsrdfl2.M_HSR), rtrim(bskundnbyfcshsrdfl2.M_HSR))
   when 6 then coalesce(rtrim(nbyfcchsrdfl2.M_HSR), rtrim(nbyfcshsrdfl2.M_HSR),rtrim(nbyhsrdfl2.M_HSR)) else null end 
when 9 then rtrim(fcshsrdfl2.M_HSR) else null end ICMHSR2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(pub2.M_CALENDAR)
   when 3 then coalesce(rtrim(undpub2.M_CALENDAR), rtrim(undnbyfccpub2.M_CALENDAR), rtrim(undnbyfcspub2.M_CALENDAR))
   when 4 then coalesce(rtrim(nbyfcspub21.M_CALENDAR), rtrim(bskpub21.M_CALENDAR), rtrim(bskpub2.M_CALENDAR), rtrim(bskundpub2.M_CALENDAR), rtrim(bskundnbyfccpub2.M_CALENDAR), rtrim(bskundnbyfcspub2.M_CALENDAR))
   when 6 then coalesce(rtrim(nbyfccpub2.M_CALENDAR), rtrim(nbyfcspub2.M_CALENDAR),rtrim(nbypub2.M_CALENDAR)) else null end 
when 9 then rtrim(fcspub2.M_CALENDAR) else null end ICMCAL2,
case ind2.M_RESET
when 0 then rtrim(qot2.M_TRAD_SMB)
when 3 then rtrim(undqot2.M_TRAD_SMB)
when 4 then coalesce(rtrim(bskqot21.M_TRAD_SMB), rtrim(bskundqot2.M_TRAD_SMB))
when 6 then coalesce(rtrim(nbyfccqot2.M_TRAD_SMB), rtrim(nbyfcsqot2.M_TRAD_SMB),rtrim(nbyqot2.M_TRAD_SMB)) else null end ICMSYM2,
-- ELT3
bskelt3.M_ORDER + 1 ELTORD3,
bskelt3.M_REFERENCE_COMPONENT ELTREF3, 
bskelt3.M_WEIGHT WGT3,
bskelt3.M_SPREAD SPR3,
bskelt3.M_POWER  PWR3,
case
when ind3.M_CATEGORY = 4 then 'Forex'
when ind3.M_CATEGORY = 6 then 'Generic'
when ind3.M_CATEGORY = 7 then 'Formula'
when ind3.M_CATEGORY = 8 then
   case ind3.M_RESET
   when 0 then 'SPT'
   when 3 then 'AVG'
   when 4 then 'BSK'
   when 6 then 'NBY' else null end 
when ind3.M_CATEGORY = 9 then 'FWD'
else null end         INDTYP3,
rtrim(ind3.M_IND_LAB) INDLAB3,
rtrim(hsr3.M_LABEL)   HSR3,
case bskelt3.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end as CNVMOD3, 
bskelt3.M_CONVERSION CNVFCT3,
case bskelt3.M_ROUND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' end RNDRUL3, 
bskelt2.M_ROUND_DECIMALS RNDDEC3,
rtrim(icm3.M_LABEL)  ICMLAB3,
-- DELIVERY
case ind1.M_RESET
when 0 then rtrim(icmphy1.M_LABEL)
when 3 then coalesce(rtrim(undicmphy1.M_LABEL), rtrim(ind1.M_IND_CODE))
when 4 then rtrim(ind1.M_IND_CODE)
when 6 then coalesce(rtrim(nbyfccgnlphy1.M_LABEL), rtrim(nbyfcsicmphy1.M_LABEL), rtrim(nbyicmphy1.M_LABEL)) else null end PHYLAB1,
case ind1.M_RESET
when 0 then rtrim(icmloc1.M_LABEL)
when 3 then rtrim(undicmloc1.M_LABEL)
when 4 then null
when 6 then coalesce(rtrim(nbyfccgnlloc1.M_LABEL), rtrim(nbyfcsicmloc1.M_LABEL), rtrim(nbyicmloc1.M_LABEL)) else null end LOCLAB1,
rtrim(grp.M_HISFILE) HIS,
-- UID
ind.M_REFERENCE  INDUID,
ind1.M_REFERENCE INDUID1,
case ind1.M_RESET
when 0 then ind1.M_REFERENCE
when 3 then und1.M_REFERENCE
when 4 then bskund1.M_REFERENCE
when 6 then coalesce(nbyfcm1.M_REFERENCE, nbyicm1.M_REFERENCE) else null end UNDUID1,
case ind1.M_RESET
when 0 then qot1.M_REFERENCE
when 3 then undqot1.M_REFERENCE
when 4 then bskundqot1.M_REFERENCE
when 6 then nbyqot1.M_REFERENCE else null end QOTUID1,
case ind1.M_RESET
when 0 then ind1.M_INDEX
when 3 then und1.M_INDEX
when 4 then bskund1.M_INDEX
when 6 then coalesce(nbyfccind1.M_INDEX, nbyfcsind1.M_INDEX, concat(lpad(nbyicm1.M_REFERENCE,7),lpad(nbyqot1.M_REFERENCE,8))) else null end ICMNDX1,
case ind1.M_RESET
when 0 then icm1.M_REFERENCE
when 3 then undicm1.M_REFERENCE
when 4 then bskicm1.M_REFERENCE
when 6 then coalesce(nbyfccicm1.M_REFERENCE, nbyfcsicm1.M_REFERENCE, nbyicm1.M_REFERENCE) else null end ICMUID1,
ind2.M_REFERENCE INDUID2,
case ind2.M_RESET
when 0 then ind2.M_REFERENCE
when 3 then und2.M_REFERENCE
when 4 then bskund2.M_REFERENCE
when 6 then coalesce(nbyfcm2.M_REFERENCE, nbyicm2.M_REFERENCE) else null end UNDUID2,
case ind2.M_RESET
when 0 then qot2.M_REFERENCE
when 3 then undqot2.M_REFERENCE
when 4 then bskundqot2.M_REFERENCE
when 6 then nbyqot2.M_REFERENCE else null end QOTUID2,
case ind2.M_RESET
when 0 then icm2.M_REFERENCE
when 3 then undicm2.M_REFERENCE
when 4 then bskicm2.M_REFERENCE
when 6 then coalesce(nbyfccicm2.M_REFERENCE, nbyfcsicm2.M_REFERENCE, nbyicm2.M_REFERENCE) else null end ICMUID2,
ind3.M_REFERENCE INDUID3,
icm3.M_REFERENCE ICMUID3,
case ind1.M_RESET
when 0 then icmphy1.M_REFERENCE
when 3 then undicmphy1.M_REFERENCE
when 4 then 
   case
   when rtrim(ind1.M_IND_LAB) = 'C3 MBT_OPIS MT'         then 25
   when rtrim(ind1.M_IND_LAB) = 'F35 RTM FB_PLA BBL'     then 82
   when rtrim(ind1.M_IND_LAB) = 'GI EBOX ARA FB_ARG BBL' then 39
   when rtrim(ind1.M_IND_LAB) = 'GI RBOB 1LE BBL'        then 39
   when rtrim(ind1.M_IND_LAB) = 'GO ICE 1LP BBL'         then 73 
   when substr(ind1.M_IND_LAB,1,3) = 'CPO'               then 103
   when substr(ind1.M_IND_LAB,1,3) = 'FRT'               then 184 else null end 
when 6 then coalesce(nbyfccgnlphy1.M_REFERENCE, nbyfcsicmphy1.M_REFERENCE, nbyicmphy1.M_REFERENCE) else null end PHYUID1,
case ind1.M_RESET
when 0 then icmloc1.M_REFERENCE
when 3 then undicmloc1.M_REFERENCE
when 4 then null
when 6 then coalesce(nbyfccgnlloc1.M_REFERENCE, nbyfcsicmloc1.M_REFERENCE, nbyicmloc1.M_REFERENCE) else null end LOCUID1

from RT_INDEX_DBF ind
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_UNIT_DBF  uod on ind.M_UNIT_REF0 = uod.M_REFERENCE
left join CM_UNIT_DBF  uoq on ind.M_UNIT_REF1 = uoq.M_REFERENCE
left join DAT_ECH_DBF  sch on rtrim(ind.M_UEI) = rtrim(sch.M_LABEL)
left join RT_INDBK_COMPONENT_DBF bskeltr on (ind.M_REFERENCE = bskeltr.M_BASKET_REFERENCE and bskeltr.M_REFERENCE_COMPONENT = 1)
left join RT_INDBK_COMPONENT_DBF bskelt1 on (ind.M_REFERENCE = bskelt1.M_BASKET_REFERENCE and bskelt1.M_ORDER = 0)
left join RT_INDBK_COMPONENT_DBF bskelt2 on (ind.M_REFERENCE = bskelt2.M_BASKET_REFERENCE and bskelt2.M_ORDER = 1)
left join RT_INDBK_COMPONENT_DBF bskelt3 on (ind.M_REFERENCE = bskelt3.M_BASKET_REFERENCE and bskelt3.M_ORDER = 2)
left join RT_INDBK_COMPONENT_DBF bskelt4 on (ind.M_REFERENCE = bskelt4.M_BASKET_REFERENCE and bskelt4.M_ORDER = 3)
-- ELT1
left join RT_INDEX_DBF ind1 on bskelt1.M_INDEX = ind1.M_INDEX
left join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join RT_GROUP_DBF grp1 on ind1.M_HISFILE = grp1.M_HISFILE
left join CM_UNIT_DBF  uod1 on ind1.M_UNIT_REF0 = uod1.M_REFERENCE
left join CM_UNIT_DBF  uoq1 on ind1.M_UNIT_REF1 = uoq1.M_REFERENCE
left join CM_FUT_DBF fut1 on ind1.M_COM_FUT = fut1.M_REFERENCE and ind1.M_CATEGORY = 9
-- Spot 1
left join CM_INDEX_DBF icm1 on ind1.M_COM_IND = icm1.M_REFERENCE and ind1.M_RESET = 0
left join CM_PHYS_DBF  icmphy1 on icm1.M_PHYSICAL = icmphy1.M_REFERENCE
left join CM_LOCAT_DBF icmloc1 on icm1.M_LOCATION = icmloc1.M_REFERENCE
left join CMC_QUOT_DBF qot1 on ind1.M_COM_QUOT = qot1.M_REFERENCE
left join CM_MKT_DBF   pub1 on qot1.M_PUBLI = pub1.M_REFERENCE
left join VIW_ICMPUB_DBF hsrdfl1 on pub1.M_REFERENCE = hsrdfl1.M_PUBUID and hsrdfl1.M_HSRDFL = 1
left join CM_UNIT_DBF  qotuoq1 on qot1.M_UNIT = qotuoq1.M_REFERENCE
left join CM_UNIT_DBF  qotuod1 on qot1.M_QTY_UNIT = qotuod1.M_REFERENCE
left join CM_MKTSR_DBF hsr1 on trim(substr(bskelt1.M_FORMULA,2,10)) = to_char(hsr1.M_SERIE)
-- Avg 1
left join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join CM_INDEX_DBF undicm1 on und1.M_COM_IND  = undicm1.M_REFERENCE
left join CM_PHYS_DBF  undicmphy1 on undicm1.M_PHYSICAL = undicmphy1.M_REFERENCE
left join CM_LOCAT_DBF undicmloc1 on undicm1.M_LOCATION = undicmloc1.M_REFERENCE
left join CMC_QUOT_DBF undqot1 on und1.M_COM_QUOT = undqot1.M_REFERENCE
left join CM_MKT_DBF   undpub1 on undqot1.M_PUBLI = undpub1.M_REFERENCE
left join VIW_ICMPUB_DBF undhsrdfl1 on undpub1.M_REFERENCE = undhsrdfl1.M_PUBUID and undhsrdfl1.M_HSRDFL = 1
left join CM_UNIT_DBF  undqotuoq1 on undqot1.M_UNIT = undqotuoq1.M_REFERENCE
left join CM_UNIT_DBF  undqotuod1 on undqot1.M_QTY_UNIT = undqotuod1.M_REFERENCE
left join CM_FUT_DBF   undnbyfcm1 on (und1.M_COM_FUT = undnbyfcm1.M_REFERENCE and und1.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  undnbyfccgnl1 on (undnbyfcm1.M_CM_INSTR = undnbyfccgnl1.M_GEN_NUM and undnbyfcm1.M_INS_MODE = 0 and undnbyfcm1.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF undnbyfccind1 on undnbyfccgnl1.M_INDEX0 = undnbyfccind1.M_INDEX
left join CM_INDEX_DBF undnbyfccicm1 on (undnbyfccind1.M_COM_IND = undnbyfccicm1.M_REFERENCE and undnbyfccind1.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfccqot1 on undnbyfccind1.M_COM_QUOT = undnbyfccqot1.M_REFERENCE
left join CM_MKT_DBF   undnbyfccpub1 on undnbyfccqot1.M_PUBLI = undnbyfccpub1.M_REFERENCE
left join VIW_ICMPUB_DBF undnbyfcchsrdfl1 on undnbyfccpub1.M_REFERENCE = undnbyfcchsrdfl1.M_PUBUID and undnbyfcchsrdfl1.M_HSRDFL = 1
left join CMC_MGEN_DBF undnbyfcsgnm1 on (undnbyfcm1.M_CM_INSTR = undnbyfcsgnm1.M_REFERENCE and undnbyfcm1.M_INS_MODE = 1 and undnbyfcm1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF undnbyfcsind1 on undnbyfcsgnm1.M_INDEX = undnbyfcsind1.M_INDEX
left join CM_INDEX_DBF undnbyfcsicm1 on (undnbyfcsind1.M_COM_IND = undnbyfcsicm1.M_REFERENCE and undnbyfcsind1.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfcsqot1 on undnbyfcsind1.M_COM_QUOT = undnbyfcsqot1.M_REFERENCE
left join CM_MKT_DBF   undnbyfcspub1 on undnbyfcsqot1.M_PUBLI = undnbyfcspub1.M_REFERENCE
left join VIW_ICMPUB_DBF undnbyfcshsrdfl1 on undnbyfcspub1.M_REFERENCE = undnbyfcshsrdfl1.M_PUBUID and undnbyfcshsrdfl1.M_HSRDFL = 1
-- Nearby 1
left join CM_FUT_DBF   nbyfcm1 on (ind1.M_COM_FUT = nbyfcm1.M_REFERENCE and ind1.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  nbyfccgnl1 on (nbyfcm1.M_CM_INSTR = nbyfccgnl1.M_GEN_NUM and nbyfcm1.M_INS_MODE = 0 and nbyfcm1.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF nbyfccind1 on nbyfccgnl1.M_INDEX0 = nbyfccind1.M_INDEX
left join CM_INDEX_DBF nbyfccicm1 on (nbyfccind1.M_COM_IND = nbyfccicm1.M_REFERENCE and nbyfccind1.M_RESET = 0)
left join CM_PHYS_DBF  nbyfccgnlphy1 on nbyfccgnl1.M_DEL_FYS0 = nbyfccgnlphy1.M_REFERENCE
left join CM_LOCAT_DBF nbyfccgnlloc1 on nbyfccgnl1.M_DEL_LOC0 = nbyfccgnlloc1.M_REFERENCE
left join CMC_QUOT_DBF nbyfccqot1 on (nbyfccind1.M_COM_QUOT = nbyfccqot1.M_REFERENCE and nbyfccind1.M_RESET = 0)
left join CM_MKT_DBF   nbyfccpub1 on nbyfccqot1.M_PUBLI = nbyfccpub1.M_REFERENCE
left join VIW_ICMPUB_DBF nbyfcchsrdfl1 on nbyfccpub1.M_REFERENCE = nbyfcchsrdfl1.M_PUBUID and nbyfcchsrdfl1.M_HSRDFL = 1
left join CMC_MGEN_DBF nbyfcsgnm1 on (nbyfcm1.M_CM_INSTR = nbyfcsgnm1.M_REFERENCE and nbyfcm1.M_INS_MODE = 1 and nbyfcm1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind1 on nbyfcsgnm1.M_INDEX = nbyfcsind1.M_INDEX
left join CM_INDEX_DBF nbyfcsicm1 on (nbyfcsind1.M_COM_IND = nbyfcsicm1.M_REFERENCE and nbyfcsind1.M_RESET = 0)
left join CM_PHYS_DBF  nbyfcsicmphy1 on nbyfcsicm1.M_PHYSICAL = nbyfcsicmphy1.M_REFERENCE
left join CM_LOCAT_DBF nbyfcsicmloc1 on nbyfcsicm1.M_LOCATION = nbyfcsicmloc1.M_REFERENCE
left join CMC_QUOT_DBF nbyfcsqot1 on (nbyfcsind1.M_COM_QUOT = nbyfcsqot1.M_REFERENCE and nbyfcsind1.M_RESET = 0)
left join CM_MKT_DBF   nbyfcspub1 on nbyfcsqot1.M_PUBLI = nbyfcspub1.M_REFERENCE
left join VIW_ICMPUB_DBF nbyfcshsrdfl1 on nbyfcspub1.M_REFERENCE = nbyfcshsrdfl1.M_PUBUID and nbyfcshsrdfl1.M_HSRDFL = 1
left join CM_INDEX_DBF nbyicm1 on (ind1.M_COM_FUT = nbyicm1.M_REFERENCE and ind1.M_COM_NBY_T = 2)
left join CM_PHYS_DBF  nbyicmphy1 on nbyicm1.M_PHYSICAL = nbyicmphy1.M_REFERENCE
left join CM_LOCAT_DBF nbyicmloc1 on nbyicm1.M_LOCATION = nbyicmloc1.M_REFERENCE
left join CMC_QUOT_DBF nbyqot1 on ind1.M_COM_QUOT = nbyqot1.M_REFERENCE and ind1.M_RESET = 6
left join CM_MKT_DBF   nbypub1 on nbyqot1.M_PUBLI = nbypub1.M_REFERENCE
left join VIW_ICMPUB_DBF nbyhsrdfl1 on nbypub1.M_REFERENCE = nbyhsrdfl1.M_PUBUID and nbyhsrdfl1.M_HSRDFL = 1
-- Basket 1
left join RT_INDBK_COMPONENT_DBF bskelt1 on (ind1.M_REFERENCE = bskelt1.M_BASKET_REFERENCE and bskelt1.M_ORDER = 0)
left join RT_INDEX_DBF bskind1 on bskelt1.M_INDEX = bskind1.M_INDEX
left join CM_INDEX_DBF bskicm1 on bskind1.M_COM_IND  = bskicm1.M_REFERENCE
left join CMC_QUOT_DBF bskqot1 on bskind1.M_COM_QUOT = bskqot1.M_REFERENCE
left join CM_MKT_DBF   bskpub1 on bskqot1.M_PUBLI = bskpub1.M_REFERENCE
left join VIW_ICMPUB_DBF bskhsrdfl1 on bskpub1.M_REFERENCE = bskhsrdfl1.M_PUBUID and bskhsrdfl1.M_HSRDFL = 1
left join RT_INDEX_DBF bskund1 on bskind1.M_UNDRL = bskund1.M_INDEX
left join CM_INDEX_DBF bskundicm1 on (bskund1.M_COM_IND = bskundicm1.M_REFERENCE and bskund1.M_RESET = 0)
left join CMC_QUOT_DBF bskundqot1 on bskund1.M_COM_QUOT = bskundqot1.M_REFERENCE
left join CM_MKT_DBF   bskundpub1 on bskundqot1.M_PUBLI = bskundpub1.M_REFERENCE
left join VIW_ICMPUB_DBF bskundhsrdfl1 on bskundpub1.M_REFERENCE = bskundhsrdfl1.M_PUBUID and bskundhsrdfl1.M_HSRDFL = 1
left join CM_FUT_DBF   bskundnbyfcm1 on (bskund1.M_COM_FUT = bskundnbyfcm1.M_REFERENCE and bskund1.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  bskundnbyfccgnl1 on (bskundnbyfcm1.M_CM_INSTR = bskundnbyfccgnl1.M_GEN_NUM and bskundnbyfcm1.M_INS_MODE = 0 and undnbyfcm1.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF bskundnbyfccind1 on bskundnbyfccgnl1.M_INDEX0 = bskundnbyfccind1.M_INDEX
left join CM_INDEX_DBF bskundnbyfccicm1 on (bskundnbyfccind1.M_COM_IND = bskundnbyfccicm1.M_REFERENCE and bskundnbyfccind1.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfccqot1 on bskundnbyfccind1.M_COM_QUOT = bskundnbyfccqot1.M_REFERENCE
left join CM_MKT_DBF   bskundnbyfccpub1 on bskundnbyfccqot1.M_PUBLI = bskundnbyfccpub1.M_REFERENCE
left join VIW_ICMPUB_DBF bskundnbyfcchsrdfl1 on bskundnbyfccpub1.M_REFERENCE = bskundnbyfcchsrdfl1.M_PUBUID and bskundnbyfcchsrdfl1.M_HSRDFL = 1
left join CMC_MGEN_DBF bskundnbyfcsgnm1 on (bskundnbyfcm1.M_CM_INSTR = bskundnbyfcsgnm1.M_REFERENCE and bskundnbyfcm1.M_INS_MODE = 1 and undnbyfcm1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF bskundnbyfcsind1 on bskundnbyfcsgnm1.M_INDEX = bskundnbyfcsind1.M_INDEX
left join CM_INDEX_DBF bskundnbyfcsicm1 on (bskundnbyfcsind1.M_COM_IND = bskundnbyfcsicm1.M_REFERENCE and bskundnbyfcsind1.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfcsqot1 on bskundnbyfcsind1.M_COM_QUOT = bskundnbyfcsqot1.M_REFERENCE
left join CM_MKT_DBF   bskundnbyfcspub1 on bskundnbyfcsqot1.M_PUBLI = bskundnbyfcspub1.M_REFERENCE
left join VIW_ICMPUB_DBF bskundnbyfcshsrdfl1 on bskundnbyfcspub1.M_REFERENCE = bskundnbyfcshsrdfl1.M_PUBUID and bskundnbyfcshsrdfl1.M_HSRDFL = 1
left join RT_INDBK_COMPONENT_DBF bskelt11 on (bskind1.M_REFERENCE = bskelt11.M_BASKET_REFERENCE and bskelt11.M_ORDER = 0)
left join RT_INDEX_DBF bskind11 on bskelt11.M_INDEX = bskind11.M_INDEX
left join CM_INDEX_DBF bskicm11 on bskind11.M_COM_IND  = bskicm11.M_REFERENCE
left join CMC_QUOT_DBF bskqot11 on bskind11.M_COM_QUOT = bskqot11.M_REFERENCE
left join CM_MKT_DBF   bskpub11 on bskqot11.M_PUBLI = bskpub11.M_REFERENCE
left join VIW_ICMPUB_DBF bskhsrdfl11 on bskpub11.M_REFERENCE = bskhsrdfl11.M_PUBUID and bskhsrdfl11.M_HSRDFL = 1
left join CM_FUT_DBF   nbyfcm11 on (bskind11.M_COM_FUT = nbyfcm11.M_REFERENCE and bskind11.M_COM_NBY_T = 0)
left join CMC_MGEN_DBF nbyfcsgnm11 on (nbyfcm11.M_CM_INSTR = nbyfcsgnm11.M_REFERENCE and nbyfcm11.M_INS_MODE = 1 and nbyfcm11.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind11 on nbyfcsgnm11.M_INDEX = nbyfcsind11.M_INDEX
left join CM_INDEX_DBF nbyfcsicm11 on (nbyfcsind11.M_COM_IND = nbyfcsicm11.M_REFERENCE and nbyfcsind11.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsqot11 on nbyfcsind11.M_COM_QUOT = nbyfcsqot11.M_REFERENCE
left join CM_MKT_DBF   nbyfcspub11 on nbyfcsqot11.M_PUBLI = nbyfcspub11.M_REFERENCE
left join VIW_ICMPUB_DBF nbyfcshsrdfl11 on nbyfcspub11.M_REFERENCE = nbyfcshsrdfl11.M_PUBUID and nbyfcshsrdfl11.M_HSRDFL = 1
-- Forward 1
left join CMC_MGEN_DBF fcsgnm1 on (fut1.M_CM_INSTR = fcsgnm1.M_REFERENCE and fut1.M_INS_MODE = 1 and fut1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF fcsind1 on fcsgnm1.M_INDEX = fcsind1.M_INDEX
left join CM_INDEX_DBF fcsicm1 on (fcsind1.M_COM_IND = fcsicm1.M_REFERENCE and fcsind1.M_RESET = 0)
left join CM_PHYS_DBF  fcsicmphy1 on fcsicm1.M_PHYSICAL = fcsicmphy1.M_REFERENCE
left join CM_LOCAT_DBF fcsicmloc1 on fcsicm1.M_LOCATION = fcsicmloc1.M_REFERENCE
left join CMC_QUOT_DBF fcsqot1 on (fcsind1.M_COM_QUOT = fcsqot1.M_REFERENCE and fcsind1.M_RESET = 0)
left join CM_MKT_DBF   fcspub1 on fcsqot1.M_PUBLI = fcspub1.M_REFERENCE
left join VIW_ICMPUB_DBF fcshsrdfl1 on fcspub1.M_REFERENCE = fcshsrdfl1.M_PUBUID and fcshsrdfl1.M_HSRDFL = 1
-- ELT2
left join RT_INDEX_DBF ind2 on bskelt2.M_INDEX = ind2.M_INDEX
left join RT_INDEX_DBF und2 on ind2.M_UNDRL = und2.M_INDEX
left join RT_GROUP_DBF grp2 on ind2.M_HISFILE = grp2.M_HISFILE
left join CM_UNIT_DBF  uod2 on ind2.M_UNIT_REF0 = uod2.M_REFERENCE
left join CM_UNIT_DBF  uoq2 on ind2.M_UNIT_REF1 = uoq2.M_REFERENCE
left join CM_FUT_DBF fut2 on ind2.M_COM_FUT = fut2.M_REFERENCE and ind2.M_CATEGORY = 9
-- Spot 2
left join CM_INDEX_DBF icm2 on ind2.M_COM_IND = icm2.M_REFERENCE and ind2.M_RESET = 0
left join CM_PHYS_DBF  icmphy2 on icm2.M_PHYSICAL = icmphy2.M_REFERENCE
left join CM_LOCAT_DBF icmloc2 on icm2.M_LOCATION = icmloc2.M_REFERENCE
left join CMC_QUOT_DBF qot2 on ind2.M_COM_QUOT = qot2.M_REFERENCE
left join CM_MKT_DBF   pub2 on qot2.M_PUBLI = pub2.M_REFERENCE
left join VIW_ICMPUB_DBF hsrdfl2 on pub2.M_REFERENCE = hsrdfl2.M_PUBUID and hsrdfl2.M_HSRDFL = 1
left join CM_UNIT_DBF  qotuoq2 on qot2.M_UNIT = qotuoq2.M_REFERENCE
left join CM_UNIT_DBF  qotuod2 on qot2.M_QTY_UNIT = qotuod2.M_REFERENCE
left join CM_MKTSR_DBF hsr2 on trim(substr(bskelt2.M_FORMULA,2,10)) = to_char(hsr2.M_SERIE)
-- Avg 2
left join RT_INDEX_DBF und2 on ind2.M_UNDRL = und2.M_INDEX
left join CM_INDEX_DBF undicm2 on und2.M_COM_IND  = undicm2.M_REFERENCE
left join CM_PHYS_DBF  undicmphy2 on undicm2.M_PHYSICAL = undicmphy2.M_REFERENCE
left join CM_LOCAT_DBF undicmloc2 on undicm2.M_LOCATION = undicmloc2.M_REFERENCE
left join CMC_QUOT_DBF undqot2 on und2.M_COM_QUOT = undqot2.M_REFERENCE
left join CM_MKT_DBF   undpub2 on undqot2.M_PUBLI = undpub2.M_REFERENCE
left join VIW_ICMPUB_DBF undhsrdfl2 on undpub2.M_REFERENCE = undhsrdfl2.M_PUBUID and undhsrdfl2.M_HSRDFL = 1
left join CM_UNIT_DBF  undqotuoq2 on undqot2.M_UNIT = undqotuoq2.M_REFERENCE
left join CM_UNIT_DBF  undqotuod2 on undqot2.M_QTY_UNIT = undqotuod2.M_REFERENCE
left join CM_FUT_DBF   undnbyfcm2 on (und2.M_COM_FUT = undnbyfcm2.M_REFERENCE and und2.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  undnbyfccgnl2 on (undnbyfcm2.M_CM_INSTR = undnbyfccgnl2.M_GEN_NUM and undnbyfcm2.M_INS_MODE = 0 and undnbyfcm2.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF undnbyfccind2 on undnbyfccgnl2.M_INDEX0 = undnbyfccind2.M_INDEX
left join CM_INDEX_DBF undnbyfccicm2 on (undnbyfccind2.M_COM_IND = undnbyfccicm2.M_REFERENCE and undnbyfccind2.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfccqot2 on undnbyfccind2.M_COM_QUOT = undnbyfccqot2.M_REFERENCE
left join CM_MKT_DBF   undnbyfccpub2 on undnbyfccqot2.M_PUBLI = undnbyfccpub2.M_REFERENCE
left join VIW_ICMPUB_DBF undnbyfcchsrdfl2 on undnbyfccpub2.M_REFERENCE = undnbyfcchsrdfl2.M_PUBUID and undnbyfcchsrdfl2.M_HSRDFL = 1
left join CMC_MGEN_DBF undnbyfcsgnm2 on (undnbyfcm2.M_CM_INSTR = undnbyfcsgnm2.M_REFERENCE and undnbyfcm2.M_INS_MODE = 1 and undnbyfcm2.M_LISTED in (1,2,16))
left join RT_INDEX_DBF undnbyfcsind2 on undnbyfcsgnm2.M_INDEX = undnbyfcsind2.M_INDEX
left join CM_INDEX_DBF undnbyfcsicm2 on (undnbyfcsind2.M_COM_IND = undnbyfcsicm2.M_REFERENCE and undnbyfcsind2.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfcsqot2 on undnbyfcsind2.M_COM_QUOT = undnbyfcsqot2.M_REFERENCE
left join CM_MKT_DBF   undnbyfcspub2 on undnbyfcsqot2.M_PUBLI = undnbyfcspub2.M_REFERENCE
left join VIW_ICMPUB_DBF undnbyfcshsrdfl2 on undnbyfcspub2.M_REFERENCE = undnbyfcshsrdfl2.M_PUBUID and undnbyfcshsrdfl2.M_HSRDFL = 1
-- Nearby 2
left join CM_FUT_DBF   nbyfcm2 on (ind2.M_COM_FUT = nbyfcm2.M_REFERENCE and ind2.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  nbyfccgnl2 on (nbyfcm2.M_CM_INSTR = nbyfccgnl2.M_GEN_NUM and nbyfcm2.M_INS_MODE = 0 and nbyfcm2.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF nbyfccind2 on nbyfccgnl2.M_INDEX0 = nbyfccind2.M_INDEX
left join CM_INDEX_DBF nbyfccicm2 on (nbyfccind2.M_COM_IND = nbyfccicm2.M_REFERENCE and nbyfccind2.M_RESET = 0)
left join CM_PHYS_DBF  nbyfccgnlphy2 on nbyfccgnl2.M_DEL_FYS0 = nbyfccgnlphy2.M_REFERENCE
left join CM_LOCAT_DBF nbyfccgnlloc2 on nbyfccgnl2.M_DEL_LOC0 = nbyfccgnlloc2.M_REFERENCE
left join CMC_QUOT_DBF nbyfccqot2 on (nbyfccind2.M_COM_QUOT = nbyfccqot2.M_REFERENCE and nbyfccind2.M_RESET = 0)
left join CM_MKT_DBF   nbyfccpub2 on nbyfccqot2.M_PUBLI = nbyfccpub2.M_REFERENCE
left join VIW_ICMPUB_DBF nbyfcchsrdfl2 on nbyfccpub2.M_REFERENCE = nbyfcchsrdfl2.M_PUBUID and nbyfcchsrdfl2.M_HSRDFL = 1
left join CMC_MGEN_DBF nbyfcsgnm2 on (nbyfcm2.M_CM_INSTR = nbyfcsgnm2.M_REFERENCE and nbyfcm2.M_INS_MODE = 1 and nbyfcm2.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind2 on nbyfcsgnm2.M_INDEX = nbyfcsind2.M_INDEX
left join CM_INDEX_DBF nbyfcsicm2 on (nbyfcsind2.M_COM_IND = nbyfcsicm2.M_REFERENCE and nbyfcsind2.M_RESET = 0)
left join CM_PHYS_DBF  nbyfcsicmphy2 on nbyfcsicm2.M_PHYSICAL = nbyfcsicmphy2.M_REFERENCE
left join CM_LOCAT_DBF nbyfcsicmloc2 on nbyfcsicm2.M_LOCATION = nbyfcsicmloc2.M_REFERENCE
left join CMC_QUOT_DBF nbyfcsqot2 on (nbyfcsind2.M_COM_QUOT = nbyfcsqot2.M_REFERENCE and nbyfcsind2.M_RESET = 0)
left join CM_MKT_DBF   nbyfcspub2 on nbyfcsqot2.M_PUBLI = nbyfcspub2.M_REFERENCE
left join VIW_ICMPUB_DBF nbyfcshsrdfl2 on nbyfcspub2.M_REFERENCE = nbyfcshsrdfl2.M_PUBUID and nbyfcshsrdfl2.M_HSRDFL = 1
left join RT_INDEX_DBF nbyfcsund2 on nbyfcsind2.M_UNDRL = nbyfcsund2.M_INDEX
left join CM_FUT_DBF   nbyfcsundfcm2 on (nbyfcsund2.M_COM_FUT = nbyfcsundfcm2.M_REFERENCE and nbyfcsund2.M_COM_NBY_T = 0)
left join CMC_MGEN_DBF nbyfcsundgnm2 on (nbyfcsundfcm2.M_CM_INSTR = nbyfcsundgnm2.M_REFERENCE and nbyfcsundfcm2.M_INS_MODE = 1 and nbyfcsundfcm2.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsundind2 on nbyfcsundgnm2.M_INDEX = nbyfcsundind2.M_INDEX
left join CM_INDEX_DBF nbyfcsundicm2 on (nbyfcsundind2.M_COM_IND = nbyfcsundicm2.M_REFERENCE and nbyfcsundind2.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsundqot2 on (nbyfcsundind2.M_COM_QUOT = nbyfcsundqot2.M_REFERENCE and nbyfcsundind2.M_RESET = 0)
left join CM_MKT_DBF   nbyfcsundpub2 on nbyfcsundqot2.M_PUBLI = nbyfcsundpub2.M_REFERENCE
left join CM_INDEX_DBF nbyicm2 on (ind2.M_COM_FUT = nbyicm2.M_REFERENCE and ind2.M_COM_NBY_T = 2)
left join CM_PHYS_DBF  nbyicmphy2 on nbyicm2.M_PHYSICAL = nbyicmphy2.M_REFERENCE
left join CM_LOCAT_DBF nbyicmloc2 on nbyicm2.M_LOCATION = nbyicmloc2.M_REFERENCE
left join CMC_QUOT_DBF nbyqot2 on ind2.M_COM_QUOT = nbyqot2.M_REFERENCE and ind2.M_RESET = 6
left join CM_MKT_DBF   nbypub2 on nbyqot2.M_PUBLI = nbypub2.M_REFERENCE
left join VIW_ICMPUB_DBF nbyhsrdfl2 on nbypub2.M_REFERENCE = nbyhsrdfl2.M_PUBUID and nbyhsrdfl2.M_HSRDFL = 1
-- Basket 2
left join RT_INDBK_COMPONENT_DBF bskelt2 on (ind2.M_REFERENCE = bskelt2.M_BASKET_REFERENCE and bskelt2.M_ORDER = 1)
left join RT_INDEX_DBF bskind2 on bskelt2.M_INDEX = bskind2.M_INDEX
left join CM_INDEX_DBF bskicm2 on bskind2.M_COM_IND  = bskicm2.M_REFERENCE
left join CMC_QUOT_DBF bskqot2 on bskind2.M_COM_QUOT = bskqot2.M_REFERENCE
left join CM_MKT_DBF   bskpub2 on bskqot2.M_PUBLI = bskpub2.M_REFERENCE
left join VIW_ICMPUB_DBF bskhsrdfl2 on bskpub2.M_REFERENCE = bskhsrdfl2.M_PUBUID and bskhsrdfl2.M_HSRDFL = 1
left join RT_INDEX_DBF bskund2 on bskind2.M_UNDRL = bskund2.M_INDEX
left join CM_INDEX_DBF bskundicm2 on (bskund2.M_COM_IND = bskundicm2.M_REFERENCE and bskund2.M_RESET = 0)
left join CMC_QUOT_DBF bskundqot2 on bskund2.M_COM_QUOT = bskundqot2.M_REFERENCE
left join CM_MKT_DBF   bskundpub2 on bskundqot2.M_PUBLI = bskundpub2.M_REFERENCE
left join VIW_ICMPUB_DBF bskundhsrdfl2 on bskundpub2.M_REFERENCE = bskundhsrdfl2.M_PUBUID and bskundhsrdfl2.M_HSRDFL = 1
left join CM_FUT_DBF   bskundnbyfcm2 on (bskund2.M_COM_FUT = bskundnbyfcm2.M_REFERENCE and bskund2.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  bskundnbyfccgnl2 on (bskundnbyfcm2.M_CM_INSTR = bskundnbyfccgnl2.M_GEN_NUM and bskundnbyfcm2.M_INS_MODE = 0 and undnbyfcm2.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF bskundnbyfccind2 on bskundnbyfccgnl2.M_INDEX0 = bskundnbyfccind2.M_INDEX
left join CM_INDEX_DBF bskundnbyfccicm2 on (bskundnbyfccind2.M_COM_IND = bskundnbyfccicm2.M_REFERENCE and bskundnbyfccind2.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfccqot2 on bskundnbyfccind2.M_COM_QUOT = bskundnbyfccqot2.M_REFERENCE
left join CM_MKT_DBF   bskundnbyfccpub2 on bskundnbyfccqot2.M_PUBLI = bskundnbyfccpub2.M_REFERENCE
left join VIW_ICMPUB_DBF bskundnbyfcchsrdfl2 on bskundnbyfccpub2.M_REFERENCE = bskundnbyfcchsrdfl2.M_PUBUID and bskundnbyfcchsrdfl2.M_HSRDFL = 1
left join CMC_MGEN_DBF bskundnbyfcsgnm2 on (bskundnbyfcm2.M_CM_INSTR = bskundnbyfcsgnm2.M_REFERENCE and bskundnbyfcm2.M_INS_MODE = 1 and undnbyfcm2.M_LISTED in (1,2,16))
left join RT_INDEX_DBF bskundnbyfcsind2 on bskundnbyfcsgnm2.M_INDEX = bskundnbyfcsind2.M_INDEX
left join CM_INDEX_DBF bskundnbyfcsicm2 on (bskundnbyfcsind2.M_COM_IND = bskundnbyfcsicm2.M_REFERENCE and bskundnbyfcsind2.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfcsqot2 on bskundnbyfcsind2.M_COM_QUOT = bskundnbyfcsqot2.M_REFERENCE
left join CM_MKT_DBF   bskundnbyfcspub2 on bskundnbyfcsqot2.M_PUBLI = bskundnbyfcspub2.M_REFERENCE
left join VIW_ICMPUB_DBF bskundnbyfcshsrdfl2 on bskundnbyfcspub2.M_REFERENCE = bskundnbyfcshsrdfl2.M_PUBUID and bskundnbyfcshsrdfl2.M_HSRDFL = 1
left join RT_INDBK_COMPONENT_DBF bskelt21 on (bskind2.M_REFERENCE = bskelt21.M_BASKET_REFERENCE and bskelt21.M_ORDER = 0)
left join RT_INDEX_DBF bskind21 on bskelt21.M_INDEX = bskind21.M_INDEX
left join CM_INDEX_DBF bskicm21 on bskind21.M_COM_IND  = bskicm21.M_REFERENCE
left join CMC_QUOT_DBF bskqot21 on bskind21.M_COM_QUOT = bskqot21.M_REFERENCE
left join CM_MKT_DBF   bskpub21 on bskqot21.M_PUBLI = bskpub21.M_REFERENCE
left join VIW_ICMPUB_DBF bskhsrdfl21 on bskpub21.M_REFERENCE = bskhsrdfl21.M_PUBUID and bskhsrdfl21.M_HSRDFL = 1
left join CM_FUT_DBF   nbyfcm21 on (bskind21.M_COM_FUT = nbyfcm21.M_REFERENCE and bskind21.M_COM_NBY_T = 0)
left join CMC_MGEN_DBF nbyfcsgnm21 on (nbyfcm21.M_CM_INSTR = nbyfcsgnm21.M_REFERENCE and nbyfcm21.M_INS_MODE = 1 and nbyfcm21.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind21 on rtrim(nbyfcsgnm21.M_INDEX) = rtrim(nbyfcsind21.M_INDEX)
left join CM_INDEX_DBF nbyfcsicm21 on (nbyfcsind21.M_COM_IND = nbyfcsicm21.M_REFERENCE and nbyfcsind21.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsqot21 on nbyfcsind21.M_COM_QUOT = nbyfcsqot21.M_REFERENCE
left join CM_MKT_DBF   nbyfcspub21 on nbyfcsqot21.M_PUBLI = nbyfcspub21.M_REFERENCE
left join VIW_ICMPUB_DBF nbyfcshsrdfl21 on nbyfcspub21.M_REFERENCE = nbyfcshsrdfl21.M_PUBUID and nbyfcshsrdfl21.M_HSRDFL = 1
-- Forward 2
left join CMC_MGEN_DBF fcsgnm2 on (fut2.M_CM_INSTR = fcsgnm2.M_REFERENCE and fut2.M_INS_MODE = 1 and fut2.M_LISTED in (1,2,16))
left join RT_INDEX_DBF fcsind2 on fcsgnm2.M_INDEX = fcsind2.M_INDEX
left join CM_INDEX_DBF fcsicm2 on (fcsind2.M_COM_IND = fcsicm2.M_REFERENCE and fcsind2.M_RESET = 0)
left join CM_PHYS_DBF  fcsicmphy2 on fcsicm2.M_PHYSICAL = fcsicmphy2.M_REFERENCE
left join CM_LOCAT_DBF fcsicmloc2 on fcsicm2.M_LOCATION = fcsicmloc2.M_REFERENCE
left join CMC_QUOT_DBF fcsqot2 on (fcsind2.M_COM_QUOT = fcsqot2.M_REFERENCE and fcsind2.M_RESET = 0)
left join CM_MKT_DBF   fcspub2 on fcsqot2.M_PUBLI = fcspub2.M_REFERENCE
left join VIW_ICMPUB_DBF fcshsrdfl2 on fcspub2.M_REFERENCE = fcshsrdfl2.M_PUBUID and fcshsrdfl2.M_HSRDFL = 1
-- ELT3
left join RT_INDEX_DBF ind3 on bskelt3.M_INDEX = ind3.M_INDEX 
left join CM_INDEX_DBF icm3 on ind3.M_COM_IND = icm3.M_REFERENCE
left join CM_MKTSR_DBF hsr3 on trim(substr(bskelt3.M_FORMULA,2,10)) = to_char(hsr3.M_SERIE)
-- ELT4
left join RT_INDEX_DBF ind4 on bskelt4.M_INDEX = ind4.M_INDEX 
left join CM_INDEX_DBF icm4 on ind4.M_COM_IND = icm4.M_REFERENCE
left join CM_MKTSR_DBF hsr4 on trim(substr(bskelt4.M_FORMULA,2,10)) = to_char(hsr4.M_SERIE)
-- ELTOCC
left join (select M_BASKET_REFERENCE ,count(*) ELTOCC from RT_INDBK_COMPONENT_DBF group by M_BASKET_REFERENCE) bskgrp on ind.M_REFERENCE = bskgrp.M_BASKET_REFERENCE

where 1 = 1 
and ind.M_CREAT_MODE = 0
and ind.M_CATEGORY = 8 
and ind.M_RESET = 4 

order by INDLAB

