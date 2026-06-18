select 
-- ASSET
rtrim(ast.M_LABEL) ASSTYP, 
rtrim(ass.M_LABEL) ASSLAB,
-- INDEX
case ind.M_CATEGORY
when 0 then 'Rate'
when 1 then 'Equity'
when 2 then 'Bond'
when 3 then 'Inflation'
when 4 then 'Forex'
when 8 then 'Commodity'
when 9 then 'Com FWD' else null end INDCAT,
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
when bskelt01.M_REFERENCE_COMPONENT = 1 then 1
when bskelt02.M_REFERENCE_COMPONENT = 1 then 2
when bskelt03.M_REFERENCE_COMPONENT = 1 then 3
when bskelt04.M_REFERENCE_COMPONENT = 1 then 4
else null end ELTREF,
-- ELT1
bskelt01.M_ORDER + 1 ELTORD1,
bskelt01.M_REFERENCE_COMPONENT ELTREF1, 
bskelt01.M_WEIGHT WGT1,
bskelt01.M_SPREAD SPR1,
bskelt01.M_POWER  PWR1,
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
case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(icmviw1.M_PUB)
   when 3 then rtrim(grp1.M_GRP_DESC) 
   when 4 then rtrim(grp1.M_GRP_DESC)
   when 6 then coalesce(rtrim(nbyfccicmviw1.M_PUB), rtrim(nbyfcsicmviw1.M_PUB), rtrim(nbyicmviw1.M_PUB)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsicmviw1.M_PUB) else null end INDPUB1,
case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(icmviw1.M_CAL)
   when 3 then rtrim(grp1.M_CALENDAR) 
   when 4 then rtrim(grp1.M_CALENDAR)
   when 6 then coalesce(rtrim(nbyfccicmviw1.M_CAL), rtrim(nbyfcsicmviw1.M_CAL), rtrim(nbyicmviw1.M_CAL)) else null end
when ind1.M_CATEGORY = 9 then rtrim(fcsicmviw1.M_CAL) else null end INDCAL1,
rtrim(hsr1.M_LABEL) HSR1,
case ind1.M_RESET
when 0 then qot1.M_CURR
when 3 then coalesce(rtrim(undqot1.M_CURR), rtrim(und1.M_CURRENCY))
when 4 then rtrim(ind1.M_CURRENCY)
when 6 then rtrim(ind1.M_COM_CUR) else null end CUR1, 
case ind1.M_RESET
when 0 then rtrim(qotuoq1.M_LABEL)
when 3 then coalesce(rtrim(undicmviw1.M_UOQ), rtrim(qotuoq1.M_LABEL))
when 4 then rtrim(uoq1.M_LABEL)
when 6 then rtrim(qotuoq1.M_LABEL) else null end UOQ1,
case ind1.M_RESET
when 0 then rtrim(qotuod1.M_LABEL)
when 3 then coalesce(rtrim(undicmviw1.M_UOD), rtrim(qotuod1.M_LABEL))
when 4 then rtrim(uod1.M_LABEL)
when 6 then rtrim(qotuod1.M_LABEL) else null end UOD1,
case bskelt01.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end CNVMOD1, 
bskelt01.M_CONVERSION CNVFCT1,
case bskelt01.M_ROUND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' end RNDRUL1, 
bskelt01.M_ROUND_DECIMALS   RNDDEC1,
case 
when ind1.M_CATEGORY = 8 then
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
when ind1.M_CATEGORY = 9 then 'FWD' else null end UNDTYP1,
case 
when ind1.M_CATEGORY = 8 then 
   case ind1.M_RESET
   when 0 then rtrim(ind1.M_IND_LAB)
   when 3 then rtrim(und1.M_IND_LAB)
   when 4 then coalesce(rtrim(bskind11.M_IND_LAB), rtrim(bskund1.M_IND_LAB), rtrim(bskind1.M_IND_LAB))
   when 6 then coalesce(rtrim(nbyfcm1.M_LABEL),rtrim(nbyicm1.M_LABEL)) else null end
when ind1.M_CATEGORY = 9 then rtrim(fut1.M_LABEL) else null end UNDLAB1,
case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(icm1.M_LABEL)
   when 3 then coalesce(rtrim(undicm1.M_LABEL), rtrim(undnbyfccicm1.M_LABEL), rtrim(undnbyfcsicm1.M_LABEL))
   when 4 then coalesce(rtrim(nbyfcsicm11.M_LABEL), rtrim(bskicm11.M_LABEL), rtrim(bskicm1.M_LABEL), rtrim(bskundicm1.M_LABEL), rtrim(bskindnbyfcsicm1.M_LABEL),rtrim(bskundnbyfccicm1.M_LABEL), rtrim(bskundnbyfcsicm1.M_LABEL))
   when 6 then coalesce(rtrim(nbyfccicm1.M_LABEL), rtrim(nbyfcsicm1.M_LABEL),rtrim(nbyicm1.M_LABEL)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsicm1.M_LABEL) else null end ICMLAB1,
case 
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(qot1.M_LABEL)
   when 3 then rtrim(undqot1.M_LABEL)
   when 4 then coalesce(rtrim(bskqot11.M_LABEL), rtrim(bskundqot1.M_LABEL))
   when 6 then coalesce(rtrim(nbyfccqot1.M_LABEL), rtrim(nbyfcsqot1.M_LABEL),rtrim(nbyqot1.M_LABEL)) else null end
when ind1.M_CATEGORY = 9 then rtrim(fcsqot1.M_LABEL) else null end ICMQOT1,
case 
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(icmviw1.M_PUB)
   when 3 then coalesce(rtrim(undicmviw1.M_PUB), rtrim(undnbyfccicmviw1.M_PUB), rtrim(undnbyfcsicmviw1.M_PUB))
   when 4 then coalesce(rtrim(nbyfcsicmviw11.M_PUB), rtrim(bskicmviw11.M_PUB), rtrim(bskicmviw1.M_PUB), rtrim(bskundicmviw1.M_PUB), rtrim(bskundnbyfccicmviw1.M_PUB), rtrim(bskundnbyfcsicmviw1.M_PUB))
   when 6 then coalesce(rtrim(nbyfccicmviw1.M_PUB), rtrim(nbyfcsicmviw1.M_PUB),rtrim(nbyicmviw1.M_PUB)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsicmviw1.M_PUB) else null end ICMPUB1,
case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(icmviw1.M_HSR)
   when 3 then coalesce(rtrim(undicmviw1.M_HSR), rtrim(undnbyfccicmviw1.M_HSR), rtrim(undnbyfcsicmviw1.M_HSR))
   when 4 then coalesce(rtrim(nbyfcsicmviw11.M_HSR), rtrim(bskicmviw11.M_HSR), rtrim(bskicmviw1.M_HSR), rtrim(bskundicmviw1.M_HSR), rtrim(bskundnbyfccicmviw1.M_HSR), rtrim(bskundnbyfcsicmviw1.M_HSR))
   when 6 then coalesce(rtrim(nbyfccicmviw1.M_HSR), rtrim(nbyfcsicmviw1.M_HSR),rtrim(nbyicmviw1.M_HSR)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsicmviw1.M_HSR) else null end ICMHSR1,
case 
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(icmviw1.M_CAL)
   when 3 then coalesce(rtrim(undicmviw1.M_CAL), rtrim(undnbyfccicmviw1.M_CAL), rtrim(undnbyfcsicmviw1.M_CAL))
   when 4 then coalesce(rtrim(nbyfcsicmviw11.M_CAL), rtrim(bskicmviw11.M_CAL), rtrim(bskicmviw1.M_CAL), rtrim(bskundicmviw1.M_CAL), rtrim(bskundnbyfccicmviw1.M_CAL), rtrim(bskundnbyfcsicmviw1.M_CAL))
   when 6 then coalesce(rtrim(nbyfccicmviw1.M_CAL), rtrim(nbyfcsicmviw1.M_CAL),rtrim(nbyicmviw1.M_CAL)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsicmviw1.M_CAL) else null end ICMCAL1,
case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then rtrim(qot1.M_TRAD_SMB)
   when 3 then rtrim(undqot1.M_TRAD_SMB)
   when 4 then coalesce(rtrim(bskqot11.M_TRAD_SMB), rtrim(bskundqot1.M_TRAD_SMB))
   when 6 then coalesce(rtrim(nbyfccqot1.M_TRAD_SMB), rtrim(nbyfcsqot1.M_TRAD_SMB),rtrim(nbyqot1.M_TRAD_SMB)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsqot1.M_TRAD_SMB) else null end ICMSYM1,
-- ELT2
bskelt02.M_ORDER + 1 ELTORD2,
bskelt02.M_REFERENCE_COMPONENT ELTREF2, 
bskelt02.M_WEIGHT WGT2,
bskelt02.M_SPREAD SPR2,
bskelt02.M_POWER  PWR2,
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
when 0 then rtrim(icmviw2.M_PUB)
when 3 then rtrim(grp2.M_GRP_DESC) 
when 4 then rtrim(grp2.M_GRP_DESC)
when 6 then coalesce(rtrim(nbyfccicmviw2.M_PUB), rtrim(nbyfcsicmviw2.M_PUB), rtrim(nbyfcsundicmviw2.M_PUB), rtrim(nbyicmviw2.M_PUB)) else null end INDPUB2,
case ind2.M_RESET
when 0 then rtrim(icmviw2.M_CAL)
when 3 then rtrim(grp2.M_CALENDAR) 
when 4 then rtrim(grp2.M_CALENDAR)
when 6 then coalesce(rtrim(nbyfccicmviw2.M_CAL), rtrim(nbyfcsicmviw2.M_CAL), rtrim(nbyfcsundicmviw2.M_CAL), rtrim(nbyicmviw2.M_CAL)) else null end INDCAL2,
rtrim(hsr2.M_LABEL) HSR2,
case bskelt02.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end as CNVMOD2, 
bskelt02.M_CONVERSION CNVFCT2,
case bskelt02.M_ROUND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' end RNDRUL2, 
bskelt02.M_ROUND_DECIMALS   RNDDEC2,
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
when 4 then coalesce(rtrim(bskind21.M_IND_LAB), rtrim(bskund2.M_IND_LAB), rtrim(bskind2.M_IND_LAB))
when 6 then coalesce(rtrim(nbyfcm2.M_LABEL),rtrim(nbyicm2.M_LABEL))  
else null end UNDLAB2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(icm2.M_LABEL)
   when 3 then coalesce(rtrim(undicm2.M_LABEL), rtrim(undnbyfccicm2.M_LABEL), rtrim(undnbyfcsicm2.M_LABEL))
   when 4 then coalesce(rtrim(nbyfcsicm21.M_LABEL), rtrim(bskicm21.M_LABEL), rtrim(bskicm2.M_LABEL), rtrim(bskundicm2.M_LABEL), rtrim(bskindnbyfcsicm2.M_LABEL), rtrim(bskundnbyfccicm2.M_LABEL), rtrim(bskundnbyfcsicm2.M_LABEL))
   when 6 then coalesce(rtrim(nbyfcsundicm2.M_LABEL), rtrim(nbyfccicm2.M_LABEL), rtrim(nbyfcsicm2.M_LABEL), rtrim(nbyicm2.M_LABEL)) else null end 
when 9 then rtrim(fcsicm2.M_LABEL) else null end ICMLAB2,
case ind2.M_RESET
when 0 then rtrim(qot2.M_LABEL)
when 3 then rtrim(undqot2.M_LABEL)
when 4 then coalesce(rtrim(bskqot21.M_LABEL), rtrim(bskqot2.M_LABEL), rtrim(bskundqot2.M_LABEL), rtrim(bskindnbyfcsqot2.M_LABEL))
when 6 then coalesce(rtrim(nbyfccqot2.M_LABEL), rtrim(nbyfcsqot2.M_LABEL), rtrim(nbyqot2.M_LABEL)) else null end ICMQOT2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(icmviw2.M_PUB)
   when 3 then coalesce(rtrim(undicmviw2.M_PUB), rtrim(undnbyfccicmviw2.M_PUB), rtrim(undnbyfcsicmviw2.M_PUB))
   when 4 then coalesce(rtrim(nbyfcsicmviw21.M_PUB), rtrim(bskicmviw21.M_PUB), rtrim(bskicmviw2.M_PUB), rtrim(bskundicmviw2.M_PUB), rtrim(bskindnbyfcsicmviw2.M_PUB), rtrim(bskundnbyfccicmviw2.M_PUB), rtrim(bskundnbyfcsicmviw2.M_PUB))
   when 6 then coalesce(rtrim(nbyfcsundicmviw2.M_PUB), rtrim(nbyfccicmviw2.M_PUB), rtrim(nbyfcsicmviw2.M_PUB), rtrim(nbyicmviw2.M_PUB)) else null end
when 9 then rtrim(fcsicmviw2.M_PUB) else null end ICMPUB2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(icmviw2.M_HSR)
   when 3 then coalesce(rtrim(undicmviw2.M_HSR), rtrim(undnbyfccicmviw2.M_HSR), rtrim(undnbyfcsicmviw2.M_HSR))
   when 4 then coalesce(rtrim(nbyfcsicmviw21.M_HSR), rtrim(bskicmviw21.M_HSR), rtrim(bskicmviw2.M_HSR), rtrim(bskundicmviw2.M_HSR), rtrim(bskindnbyfcsicmviw2.M_HSR), rtrim(bskundnbyfccicmviw2.M_HSR), rtrim(bskundnbyfcsicmviw2.M_HSR))
   when 6 then coalesce(rtrim(nbyfccicmviw2.M_HSR), rtrim(nbyfcsicmviw2.M_HSR),rtrim(nbyicmviw2.M_HSR)) else null end 
when 9 then rtrim(fcsicmviw2.M_HSR) else null end ICMHSR2,
case ind2.M_CATEGORY
when 8 then
   case ind2.M_RESET
   when 0 then rtrim(icmviw2.M_CAL)
   when 3 then coalesce(rtrim(undicmviw2.M_CAL), rtrim(undnbyfccicmviw2.M_CAL), rtrim(undnbyfcsicmviw2.M_CAL))
   when 4 then coalesce(rtrim(nbyfcsicmviw21.M_CAL), rtrim(bskicmviw21.M_CAL), rtrim(bskicmviw2.M_CAL), rtrim(bskundicmviw2.M_CAL), rtrim(bskindnbyfcsicmviw2.M_CAL), rtrim(bskundnbyfccicmviw2.M_CAL), rtrim(bskundnbyfcsicmviw2.M_CAL))
   when 6 then coalesce(rtrim(nbyfccicmviw2.M_CAL), rtrim(nbyfcsicmviw2.M_CAL),rtrim(nbyicmviw2.M_CAL)) else null end 
when 9 then rtrim(fcsicmviw2.M_CAL) else null end ICMCAL2,
case ind2.M_RESET
when 0 then rtrim(qot2.M_TRAD_SMB)
when 3 then rtrim(undqot2.M_TRAD_SMB)
when 4 then coalesce(rtrim(bskqot21.M_TRAD_SMB), rtrim(bskqot2.M_TRAD_SMB), rtrim(bskundqot2.M_TRAD_SMB), rtrim(bskindnbyfcsqot2.M_TRAD_SMB))
when 6 then coalesce(rtrim(nbyfccqot2.M_TRAD_SMB), rtrim(nbyfcsqot2.M_TRAD_SMB),rtrim(nbyqot2.M_TRAD_SMB)) else null end ICMSYM2,
-- ELT3
bskelt03.M_ORDER + 1 ELTORD3,
bskelt03.M_REFERENCE_COMPONENT ELTREF3, 
bskelt03.M_WEIGHT WGT3,
bskelt03.M_SPREAD SPR3,
bskelt03.M_POWER  PWR3,
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
case bskelt03.M_CUSTOMIZED_CONVERSION
when 0 then 'Inherited' 
when 1 then 'Customized' end as CNVMOD3, 
bskelt03.M_CONVERSION CNVFCT3,
case bskelt03.M_ROUND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' end RNDRUL3, 
bskelt03.M_ROUND_DECIMALS   RNDDEC3,
rtrim(icm3.M_LABEL)  ICMLAB3,
-- DELIVERY
case 
when ind1.M_CATEGORY = 8 then 
   case ind1.M_RESET
   when 0 then rtrim(icmviw1.M_PHYLAB)
   when 3 then coalesce(rtrim(undicmviw1.M_PHYLAB), rtrim(ind1.M_IND_CODE))
   when 4 then coalesce(rtrim(bskicmviw1.M_PHYLAB), rtrim(bskundicmviw1.M_PHYLAB), rtrim(bskicmviw11.M_PHYLAB), rtrim(nbyfcsicmviw11.M_PHYLAB))
   when 6 then coalesce(rtrim(nbyfccicmviw1.M_PHYLAB), rtrim(nbyfcsicmviw1.M_PHYLAB), rtrim(nbyicmviw1.M_PHYLAB)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsicmviw1.M_PHYLAB) else null end PHYLAB1,
case 
when ind1.M_CATEGORY = 8 then 
   case ind1.M_RESET
   when 0 then rtrim(icmviw1.M_LOCLAB)
   when 3 then rtrim(undicmviw1.M_LOCLAB)
   when 4 then coalesce(rtrim(bskicmviw1.M_LOCLAB), rtrim(bskundicmviw1.M_LOCLAB), rtrim(bskicmviw11.M_LOCLAB), rtrim(nbyfcsicmviw11.M_LOCLAB))
   when 6 then coalesce(rtrim(nbyfccicmviw1.M_LOCLAB), rtrim(nbyfcsicmviw1.M_LOCLAB), rtrim(nbyicmviw1.M_LOCLAB)) else null end 
when ind1.M_CATEGORY = 9 then rtrim(fcsicmviw1.M_LOCLAB) else null end LOCLAB1,
rtrim(grp.M_HISFILE) HIS,
-- UID
ind.M_REFERENCE  INDUID,
ind1.M_REFERENCE INDUID1,
case 
when ind1.M_CATEGORY = 8 then 
   case ind1.M_RESET
   when 0 then ind1.M_REFERENCE
   when 3 then und1.M_REFERENCE
   when 4 then coalesce(bskind11.M_REFERENCE, bskund1.M_REFERENCE, bskind1.M_REFERENCE)
   when 6 then coalesce(nbyfcm1.M_REFERENCE, nbyicm1.M_REFERENCE) else null end 
when ind1.M_CATEGORY = 9 then ind1.M_COM_FUT else null end UNDUID1,
case 
when ind1.M_CATEGORY = 8 then 
   case ind1.M_RESET
   when 0 then qot1.M_REFERENCE
   when 3 then undqot1.M_REFERENCE
   when 4 then coalesce(bskundqot1.M_REFERENCE, bskqot1.M_REFERENCE)
   when 6 then coalesce(nbyqot1.M_REFERENCE, qot1.M_REFERENCE) else null end 
when ind1.M_CATEGORY = 9 then ind1.M_COM_QUOT else null end QOTUID1,
case 
when ind1.M_CATEGORY = 8 then 
   case ind1.M_RESET
   when 0 then ind1.M_INDEX
   when 3 then und1.M_INDEX
   when 4 then bskund1.M_INDEX
   when 6 then coalesce(nbyfccind1.M_INDEX, nbyfcsind1.M_INDEX, concat(lpad(nbyicm1.M_REFERENCE,7),lpad(nbyqot1.M_REFERENCE,8))) else null end
when ind1.M_CATEGORY = 9 then fcsind1.M_INDEX else null end ICMNDX1,
case 
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then icm1.M_REFERENCE
   when 3 then coalesce(undicm1.M_REFERENCE, undnbyfccicm1.M_REFERENCE, undnbyfcsicm1.M_REFERENCE)
   when 4 then coalesce(nbyfcsicm11.M_REFERENCE, bskicm11.M_REFERENCE, bskicm1.M_REFERENCE, bskundicm1.M_REFERENCE, bskindnbyfcsicm1.M_REFERENCE, bskundnbyfccicm1.M_REFERENCE, bskundnbyfcsicm1.M_REFERENCE)
   when 6 then coalesce(nbyfccicm1.M_REFERENCE, nbyfcsicm1.M_REFERENCE, nbyicm1.M_REFERENCE) else null end 
when ind1.M_CATEGORY = 9 then fcsicm1.M_REFERENCE else null end ICMUID1,
ind2.M_REFERENCE INDUID2,
case ind2.M_RESET
when 0 then ind2.M_REFERENCE
when 3 then und2.M_REFERENCE
when 4 then coalesce(bskind21.M_REFERENCE, bskund2.M_REFERENCE, bskind2.M_REFERENCE)
when 6 then coalesce(nbyfcm2.M_REFERENCE, nbyicm2.M_REFERENCE) else null end UNDUID2,
case ind2.M_RESET
when 0 then qot2.M_REFERENCE
when 3 then undqot2.M_REFERENCE
when 4 then coalesce(bskqot21.M_REFERENCE, bskqot2.M_REFERENCE, bskundqot2.M_REFERENCE, bskindnbyfcsqot2.M_REFERENCE)
when 6 then nbyqot2.M_REFERENCE else null end QOTUID2,
case ind2.M_RESET
when 0 then icm2.M_REFERENCE
when 3 then coalesce(undicm2.M_REFERENCE, undnbyfccicm2.M_REFERENCE, undnbyfcsicm2.M_REFERENCE)
when 4 then coalesce(nbyfcsicm21.M_REFERENCE, bskicm21.M_REFERENCE, bskicm2.M_REFERENCE, bskundicm2.M_REFERENCE, bskindnbyfcsicm2.M_REFERENCE, bskundnbyfccicm2.M_REFERENCE, bskundnbyfcsicm2.M_REFERENCE)
when 6 then coalesce(nbyfcsundicm2.M_REFERENCE, nbyfccicm2.M_REFERENCE, nbyfcsicm2.M_REFERENCE, nbyicm2.M_REFERENCE) else null end ICMUID2,
ind3.M_REFERENCE INDUID3,
icm3.M_REFERENCE ICMUID3,
case 
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then icmviw1.M_PHYUID
   when 3 then undicmviw1.M_PHYUID
   when 4 then coalesce(bskicmviw1.M_PHYUID, bskundicmviw1.M_PHYUID, bskicmviw11.M_PHYUID, nbyfcsicmviw11.M_PHYUID)
   when 6 then coalesce(nbyfccicmviw1.M_PHYUID, nbyfcsicmviw1.M_PHYUID, nbyicmviw1.M_PHYUID) else null end
when ind1.M_CATEGORY = 9 then fcsicmviw1.M_PHYUID else null end PHYUID1,
case
when ind1.M_CATEGORY = 8 then
   case ind1.M_RESET
   when 0 then icmviw1.M_LOCUID
   when 3 then undicmviw1.M_LOCUID
   when 4 then coalesce(bskicmviw1.M_LOCUID, bskundicmviw1.M_LOCUID, bskicmviw11.M_LOCUID, nbyfcsicmviw11.M_LOCUID)
   when 6 then coalesce(nbyfccicmviw1.M_LOCUID, nbyfcsicmviw1.M_LOCUID, nbyicmviw1.M_LOCUID) else null end
when ind1.M_CATEGORY = 9 then fcsicmviw1.M_LOCUID else null end LOCUID1

from RT_INDEX_DBF ind
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_UNIT_DBF  uod on ind.M_UNIT_REF0 = uod.M_REFERENCE
left join CM_UNIT_DBF  uoq on ind.M_UNIT_REF1 = uoq.M_REFERENCE
left join DAT_ECH_DBF  sch on rtrim(ind.M_UEI) = rtrim(sch.M_LABEL)
left join RT_INDBK_COMPONENT_DBF bskeltr on (ind.M_REFERENCE = bskeltr.M_BASKET_REFERENCE and bskeltr.M_REFERENCE_COMPONENT = 1)
left join RT_INDBK_COMPONENT_DBF bskelt01 on (ind.M_REFERENCE = bskelt01.M_BASKET_REFERENCE and bskelt01.M_ORDER = 0)
left join RT_INDBK_COMPONENT_DBF bskelt02 on (ind.M_REFERENCE = bskelt02.M_BASKET_REFERENCE and bskelt02.M_ORDER = 1)
left join RT_INDBK_COMPONENT_DBF bskelt03 on (ind.M_REFERENCE = bskelt03.M_BASKET_REFERENCE and bskelt03.M_ORDER = 2)
left join RT_INDBK_COMPONENT_DBF bskelt04 on (ind.M_REFERENCE = bskelt04.M_BASKET_REFERENCE and bskelt04.M_ORDER = 3)
-- ELT1
left join RT_INDEX_DBF ind1 on bskelt01.M_INDEX = ind1.M_INDEX
left join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join RT_GROUP_DBF grp1 on ind1.M_HISFILE = grp1.M_HISFILE
left join CM_UNIT_DBF  uod1 on ind1.M_UNIT_REF0 = uod1.M_REFERENCE
left join CM_UNIT_DBF  uoq1 on ind1.M_UNIT_REF1 = uoq1.M_REFERENCE
-- Spot 1
left join CM_INDEX_DBF icm1 on ind1.M_COM_IND = icm1.M_REFERENCE and ind1.M_RESET = 0
left join CMC_QUOT_DBF qot1 on ind1.M_COM_QUOT = qot1.M_REFERENCE
left join CM_UNIT_DBF  qotuoq1 on qot1.M_UNIT = qotuoq1.M_REFERENCE
left join CM_UNIT_DBF  qotuod1 on qot1.M_QTY_UNIT = qotuod1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) icmviw1 on icm1.M_REFERENCE = icmviw1.M_ICMUID
left join CM_MKTSR_DBF hsr1 on trim(substr(bskelt01.M_FORMULA,2,10)) = to_char(hsr1.M_SERIE)
-- Avg 1
left join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join CM_INDEX_DBF undicm1 on und1.M_COM_IND  = undicm1.M_REFERENCE
left join CMC_QUOT_DBF undqot1 on und1.M_COM_QUOT = undqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undicmviw1 on undicm1.M_REFERENCE = undicmviw1.M_ICMUID
left join CM_FUT_DBF   undnbyfcm1 on (und1.M_COM_FUT = undnbyfcm1.M_REFERENCE and und1.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  undnbyfccgnl1 on (undnbyfcm1.M_CM_INSTR = undnbyfccgnl1.M_GEN_NUM and undnbyfcm1.M_INS_MODE = 0 and undnbyfcm1.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF undnbyfccind1 on undnbyfccgnl1.M_INDEX0 = undnbyfccind1.M_INDEX
left join CM_INDEX_DBF undnbyfccicm1 on (undnbyfccind1.M_COM_IND = undnbyfccicm1.M_REFERENCE and undnbyfccind1.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfccqot1 on undnbyfccind1.M_COM_QUOT = undnbyfccqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undnbyfccicmviw1 on undnbyfccicm1.M_REFERENCE = undnbyfccicmviw1.M_ICMUID
left join CMC_MGEN_DBF undnbyfcsgnm1 on (undnbyfcm1.M_CM_INSTR = undnbyfcsgnm1.M_REFERENCE and undnbyfcm1.M_INS_MODE = 1 and undnbyfcm1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF undnbyfcsind1 on undnbyfcsgnm1.M_INDEX = undnbyfcsind1.M_INDEX
left join CM_INDEX_DBF undnbyfcsicm1 on (undnbyfcsind1.M_COM_IND = undnbyfcsicm1.M_REFERENCE and undnbyfcsind1.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfcsqot1 on undnbyfcsind1.M_COM_QUOT = undnbyfcsqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undnbyfcsicmviw1 on undnbyfcsicm1.M_REFERENCE = undnbyfcsicmviw1.M_ICMUID
-- Nearby 1
left join CM_FUT_DBF   nbyfcm1 on (ind1.M_COM_FUT = nbyfcm1.M_REFERENCE and ind1.M_RESET = 6 and ind1.M_COM_NBY_T = 0)
left join RT_LNGN_DBF  nbyfccgnl1 on (nbyfcm1.M_CM_INSTR = nbyfccgnl1.M_GEN_NUM and nbyfcm1.M_INS_MODE = 0 and nbyfcm1.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF nbyfccind1 on nbyfccgnl1.M_INDEX0 = nbyfccind1.M_INDEX
left join CM_INDEX_DBF nbyfccicm1 on (nbyfccind1.M_COM_IND = nbyfccicm1.M_REFERENCE and nbyfccind1.M_RESET = 0)
left join CMC_QUOT_DBF nbyfccqot1 on (nbyfccind1.M_COM_QUOT = nbyfccqot1.M_REFERENCE and nbyfccind1.M_RESET = 0)
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfccicmviw1 on nbyfccicm1.M_REFERENCE = nbyfccicmviw1.M_ICMUID
left join CMC_MGEN_DBF nbyfcsgnm1 on (nbyfcm1.M_CM_INSTR = nbyfcsgnm1.M_REFERENCE and nbyfcm1.M_INS_MODE = 1 and nbyfcm1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind1 on nbyfcsgnm1.M_INDEX = nbyfcsind1.M_INDEX
left join CM_INDEX_DBF nbyfcsicm1 on (nbyfcsind1.M_COM_IND = nbyfcsicm1.M_REFERENCE and nbyfcsind1.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsqot1 on (nbyfcsind1.M_COM_QUOT = nbyfcsqot1.M_REFERENCE and nbyfcsind1.M_RESET = 0)
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsicmviw1 on nbyfcsicm1.M_REFERENCE = nbyfcsicmviw1.M_ICMUID
left join CM_INDEX_DBF nbyicm1 on (ind1.M_COM_FUT = nbyicm1.M_REFERENCE and ind1.M_COM_NBY_T = 2)
left join CMC_QUOT_DBF nbyqot1 on ind1.M_COM_QUOT = nbyqot1.M_REFERENCE and ind1.M_RESET = 6
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyicmviw1 on nbyicm1.M_REFERENCE = nbyicmviw1.M_ICMUID
-- Basket 1
left join RT_INDBK_COMPONENT_DBF bskelt1 on (ind1.M_REFERENCE = bskelt1.M_BASKET_REFERENCE and bskelt1.M_ORDER = 0)
left join RT_INDEX_DBF bskind1 on bskelt1.M_INDEX = bskind1.M_INDEX
left join CM_INDEX_DBF bskicm1 on bskind1.M_COM_IND  = bskicm1.M_REFERENCE
left join CMC_QUOT_DBF bskqot1 on bskind1.M_COM_QUOT = bskqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskicmviw1 on bskicm1.M_REFERENCE = bskicmviw1.M_ICMUID
left join CM_FUT_DBF   bskindnbyfcm1 on (bskind1.M_COM_FUT = bskindnbyfcm1.M_REFERENCE and bskind1.M_COM_NBY_T = 0 and bskindnbyfcm1.M_LISTED in (1,2,16))
left join CMC_MGEN_DBF bskindnbyfcsgnm1 on (bskindnbyfcm1.M_CM_INSTR = bskindnbyfcsgnm1.M_REFERENCE and bskindnbyfcm1.M_INS_MODE = 1)
left join RT_INDEX_DBF bskindnbyfcsind1 on bskindnbyfcsgnm1.M_INDEX = bskindnbyfcsind1.M_INDEX
left join CM_INDEX_DBF bskindnbyfcsicm1 on (bskindnbyfcsind1.M_COM_IND = bskindnbyfcsicm1.M_REFERENCE and bskindnbyfcsind1.M_RESET = 0)
left join CMC_QUOT_DBF bskindnbyfcsqot1 on bskindnbyfcsind1.M_COM_QUOT = bskindnbyfcsqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskindnbyfcsicmviw1 on bskindnbyfcsicm1.M_REFERENCE = bskindnbyfcsicmviw1.M_ICMUID
left join RT_INDEX_DBF bskund1 on bskind1.M_UNDRL = bskund1.M_INDEX
left join CM_INDEX_DBF bskundicm1 on (bskund1.M_COM_IND = bskundicm1.M_REFERENCE and bskund1.M_RESET = 0)
left join CMC_QUOT_DBF bskundqot1 on bskund1.M_COM_QUOT = bskundqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskundicmviw1 on bskundicm1.M_REFERENCE = bskundicmviw1.M_ICMUID
left join CM_FUT_DBF   bskundnbyfcm1 on (bskund1.M_COM_FUT = bskundnbyfcm1.M_REFERENCE and bskund1.M_COM_NBY_T = 0 and bskundnbyfcm1.M_LISTED in (1,2,16,32))
left join RT_LNGN_DBF  bskundnbyfccgnl1 on (bskundnbyfcm1.M_CM_INSTR = bskundnbyfccgnl1.M_GEN_NUM and bskundnbyfcm1.M_INS_MODE = 0) 
left join RT_INDEX_DBF bskundnbyfccind1 on bskundnbyfccgnl1.M_INDEX0 = bskundnbyfccind1.M_INDEX
left join CM_INDEX_DBF bskundnbyfccicm1 on (bskundnbyfccind1.M_COM_IND = bskundnbyfccicm1.M_REFERENCE and bskundnbyfccind1.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfccqot1 on bskundnbyfccind1.M_COM_QUOT = bskundnbyfccqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskundnbyfccicmviw1 on bskundnbyfccicm1.M_REFERENCE = bskundnbyfccicmviw1.M_ICMUID
left join CMC_MGEN_DBF bskundnbyfcsgnm1 on (bskundnbyfcm1.M_CM_INSTR = bskundnbyfcsgnm1.M_REFERENCE and bskundnbyfcm1.M_INS_MODE = 1)
left join RT_INDEX_DBF bskundnbyfcsind1 on bskundnbyfcsgnm1.M_INDEX = bskundnbyfcsind1.M_INDEX
left join CM_INDEX_DBF bskundnbyfcsicm1 on (bskundnbyfcsind1.M_COM_IND = bskundnbyfcsicm1.M_REFERENCE and bskundnbyfcsind1.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfcsqot1 on bskundnbyfcsind1.M_COM_QUOT = bskundnbyfcsqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskundnbyfcsicmviw1 on bskundnbyfcsicm1.M_REFERENCE = bskundnbyfcsicmviw1.M_ICMUID
left join RT_INDBK_COMPONENT_DBF bskelt11 on (bskind1.M_REFERENCE = bskelt11.M_BASKET_REFERENCE and bskelt11.M_ORDER = 0)
left join RT_INDEX_DBF bskind11 on bskelt11.M_INDEX = bskind11.M_INDEX
left join CM_INDEX_DBF bskicm11 on bskind11.M_COM_IND  = bskicm11.M_REFERENCE
left join CMC_QUOT_DBF bskqot11 on bskind11.M_COM_QUOT = bskqot11.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskicmviw11 on bskicm11.M_REFERENCE = bskicmviw11.M_ICMUID
left join CM_FUT_DBF   nbyfcm11 on (bskind11.M_COM_FUT = nbyfcm11.M_REFERENCE and bskind11.M_COM_NBY_T = 0)
left join CMC_MGEN_DBF nbyfcsgnm11 on (nbyfcm11.M_CM_INSTR = nbyfcsgnm11.M_REFERENCE and nbyfcm11.M_INS_MODE = 1 and nbyfcm11.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind11 on nbyfcsgnm11.M_INDEX = nbyfcsind11.M_INDEX
left join CM_INDEX_DBF nbyfcsicm11 on (nbyfcsind11.M_COM_IND = nbyfcsicm11.M_REFERENCE and nbyfcsind11.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsqot11 on nbyfcsind11.M_COM_QUOT = nbyfcsqot11.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsicmviw11 on nbyfcsicm11.M_REFERENCE = nbyfcsicmviw11.M_ICMUID
-- Forward 1
left join CM_FUT_DBF   fut1 on ind1.M_COM_FUT = fut1.M_REFERENCE and ind1.M_CATEGORY = 9
left join CMC_MGEN_DBF fcsgnm1 on (fut1.M_CM_INSTR = fcsgnm1.M_REFERENCE and fut1.M_INS_MODE = 1 and fut1.M_LISTED in (1,2,16))
left join RT_INDEX_DBF fcsind1 on fcsgnm1.M_INDEX = fcsind1.M_INDEX
left join CM_INDEX_DBF fcsicm1 on fcsind1.M_COM_IND = fcsicm1.M_REFERENCE
left join CMC_QUOT_DBF fcsqot1 on fcsind1.M_COM_QUOT = fcsqot1.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) fcsicmviw1 on fcsicm1.M_REFERENCE = fcsicmviw1.M_ICMUID
-- ELT2
left join RT_INDEX_DBF ind2 on bskelt02.M_INDEX = ind2.M_INDEX
left join RT_INDEX_DBF und2 on ind2.M_UNDRL = und2.M_INDEX
left join RT_GROUP_DBF grp2 on ind2.M_HISFILE = grp2.M_HISFILE
left join CM_UNIT_DBF  uod2 on ind2.M_UNIT_REF0 = uod2.M_REFERENCE
left join CM_UNIT_DBF  uoq2 on ind2.M_UNIT_REF1 = uoq2.M_REFERENCE
-- Spot 2
left join CM_INDEX_DBF icm2 on ind2.M_COM_IND = icm2.M_REFERENCE and ind2.M_RESET = 0
left join CMC_QUOT_DBF qot2 on ind2.M_COM_QUOT = qot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) icmviw2 on icm2.M_REFERENCE = icmviw2.M_ICMUID
left join CM_UNIT_DBF  qotuoq2 on qot2.M_UNIT = qotuoq2.M_REFERENCE
left join CM_UNIT_DBF  qotuod2 on qot2.M_QTY_UNIT = qotuod2.M_REFERENCE
left join CM_MKTSR_DBF hsr2 on trim(substr(bskelt02.M_FORMULA,2,10)) = to_char(hsr2.M_SERIE)
-- Avg 2
left join RT_INDEX_DBF und2 on ind2.M_UNDRL = und2.M_INDEX
left join CM_INDEX_DBF undicm2 on und2.M_COM_IND  = undicm2.M_REFERENCE
left join CMC_QUOT_DBF undqot2 on und2.M_COM_QUOT = undqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undicmviw2 on undicm2.M_REFERENCE = undicmviw2.M_ICMUID
left join CM_FUT_DBF   undnbyfcm2    on (und2.M_COM_FUT = undnbyfcm2.M_REFERENCE and und2.M_COM_NBY_T = 0 and undnbyfcm2.M_LISTED in (1,2,16))
left join RT_LNGN_DBF  undnbyfccgnl2 on (undnbyfcm2.M_CM_INSTR = undnbyfccgnl2.M_GEN_NUM and undnbyfcm2.M_INS_MODE = 0 and undnbyfcm2.M_LISTED in (1,2,16,32))
left join RT_INDEX_DBF undnbyfccind2 on undnbyfccgnl2.M_INDEX0 = undnbyfccind2.M_INDEX
left join CM_INDEX_DBF undnbyfccicm2 on (undnbyfccind2.M_COM_IND = undnbyfccicm2.M_REFERENCE and undnbyfccind2.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfccqot2 on undnbyfccind2.M_COM_QUOT = undnbyfccqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undnbyfccicmviw2 on undnbyfccicm2.M_REFERENCE = undnbyfccicmviw2.M_ICMUID
left join CMC_MGEN_DBF undnbyfcsgnm2 on (undnbyfcm2.M_CM_INSTR = undnbyfcsgnm2.M_REFERENCE and undnbyfcm2.M_INS_MODE = 1)
left join RT_INDEX_DBF undnbyfcsind2 on undnbyfcsgnm2.M_INDEX = undnbyfcsind2.M_INDEX
left join CM_INDEX_DBF undnbyfcsicm2 on (undnbyfcsind2.M_COM_IND = undnbyfcsicm2.M_REFERENCE and undnbyfcsind2.M_RESET = 0)
left join CMC_QUOT_DBF undnbyfcsqot2 on undnbyfcsind2.M_COM_QUOT = undnbyfcsqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undnbyfcsicmviw2 on undnbyfcsicm2.M_REFERENCE = undnbyfcsicmviw2.M_ICMUID
-- Nearby 2
left join CM_FUT_DBF   nbyfcm2    on (ind2.M_COM_FUT = nbyfcm2.M_REFERENCE and ind2.M_COM_NBY_T = 0 and nbyfcm2.M_LISTED in (1,2,16,32))
left join RT_LNGN_DBF  nbyfccgnl2 on (nbyfcm2.M_CM_INSTR = nbyfccgnl2.M_GEN_NUM and nbyfcm2.M_INS_MODE = 0)
left join RT_INDEX_DBF nbyfccind2 on nbyfccgnl2.M_INDEX0 = nbyfccind2.M_INDEX
left join CM_INDEX_DBF nbyfccicm2 on (nbyfccind2.M_COM_IND  = nbyfccicm2.M_REFERENCE and nbyfccind2.M_RESET = 0)
left join CMC_QUOT_DBF nbyfccqot2 on (nbyfccind2.M_COM_QUOT = nbyfccqot2.M_REFERENCE and nbyfccind2.M_RESET = 0)
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfccicmviw2 on nbyfccicm2.M_REFERENCE = nbyfccicmviw2.M_ICMUID
left join CMC_MGEN_DBF nbyfcsgnm2 on (nbyfcm2.M_CM_INSTR = nbyfcsgnm2.M_REFERENCE and nbyfcm2.M_INS_MODE = 1)
left join RT_INDEX_DBF nbyfcsind2 on nbyfcsgnm2.M_INDEX = nbyfcsind2.M_INDEX
left join CM_INDEX_DBF nbyfcsicm2 on (nbyfcsind2.M_COM_IND  = nbyfcsicm2.M_REFERENCE and nbyfcsind2.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsqot2 on (nbyfcsind2.M_COM_QUOT = nbyfcsqot2.M_REFERENCE and nbyfcsind2.M_RESET = 0)
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsicmviw2 on nbyfcsicm2.M_REFERENCE = nbyfcsicmviw2.M_ICMUID
left join RT_INDEX_DBF nbyfcsund2 on nbyfcsind2.M_UNDRL = nbyfcsund2.M_INDEX
left join CM_FUT_DBF   nbyfcsundfcm2 on (nbyfcsund2.M_COM_FUT = nbyfcsundfcm2.M_REFERENCE and nbyfcsund2.M_COM_NBY_T = 0 and nbyfcsundfcm2.M_LISTED in (1,2,16))
left join CMC_MGEN_DBF nbyfcsundgnm2 on (nbyfcsundfcm2.M_CM_INSTR = nbyfcsundgnm2.M_REFERENCE and nbyfcsundfcm2.M_INS_MODE = 1)
left join RT_INDEX_DBF nbyfcsundind2 on nbyfcsundgnm2.M_INDEX = nbyfcsundind2.M_INDEX
left join CM_INDEX_DBF nbyfcsundicm2 on (nbyfcsundind2.M_COM_IND  = nbyfcsundicm2.M_REFERENCE and nbyfcsundind2.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsundqot2 on (nbyfcsundind2.M_COM_QUOT = nbyfcsundqot2.M_REFERENCE and nbyfcsundind2.M_RESET = 0)
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsundicmviw2 on nbyfcsundicm2.M_REFERENCE = nbyfcsundicmviw2.M_ICMUID
left join CM_INDEX_DBF nbyicm2 on (ind2.M_COM_FUT = nbyicm2.M_REFERENCE and ind2.M_COM_NBY_T = 2)
left join CMC_QUOT_DBF nbyqot2 on ind2.M_COM_QUOT = nbyqot2.M_REFERENCE and ind2.M_RESET = 6
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyicmviw2 on nbyicm2.M_REFERENCE = nbyicmviw2.M_ICMUID
-- Basket 2
left join RT_INDBK_COMPONENT_DBF bskelt2 on (ind2.M_REFERENCE = bskelt2.M_BASKET_REFERENCE and bskelt2.M_ORDER = 0)
left join RT_INDEX_DBF bskind2 on bskelt2.M_INDEX = bskind2.M_INDEX
left join CM_INDEX_DBF bskicm2 on bskind2.M_COM_IND  = bskicm2.M_REFERENCE
left join CMC_QUOT_DBF bskqot2 on bskind2.M_COM_QUOT = bskqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskicmviw2 on bskicm2.M_REFERENCE = bskicmviw2.M_ICMUID
left join CM_FUT_DBF   bskindnbyfcm2 on (bskind2.M_COM_FUT = bskindnbyfcm2.M_REFERENCE and bskind2.M_COM_NBY_T = 0 and bskindnbyfcm2.M_LISTED in (1,2,16))
left join CMC_MGEN_DBF bskindnbyfcsgnm2 on (bskindnbyfcm2.M_CM_INSTR = bskindnbyfcsgnm2.M_REFERENCE and bskindnbyfcm2.M_INS_MODE = 1)
left join RT_INDEX_DBF bskindnbyfcsind2 on bskindnbyfcsgnm2.M_INDEX = bskindnbyfcsind2.M_INDEX
left join CM_INDEX_DBF bskindnbyfcsicm2 on (bskindnbyfcsind2.M_COM_IND = bskindnbyfcsicm2.M_REFERENCE and bskindnbyfcsind2.M_RESET = 0)
left join CMC_QUOT_DBF bskindnbyfcsqot2 on bskindnbyfcsind2.M_COM_QUOT = bskindnbyfcsqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskindnbyfcsicmviw2 on bskindnbyfcsicm2.M_REFERENCE = bskindnbyfcsicmviw2.M_ICMUID
left join RT_INDEX_DBF bskund2 on bskind2.M_UNDRL = bskund2.M_INDEX
left join CM_INDEX_DBF bskundicm2 on (bskund2.M_COM_IND = bskundicm2.M_REFERENCE and bskund2.M_RESET = 0)
left join CMC_QUOT_DBF bskundqot2 on bskund2.M_COM_QUOT = bskundqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskundicmviw2 on bskundicm2.M_REFERENCE = bskundicmviw2.M_ICMUID
left join CM_FUT_DBF   bskundnbyfcm2 on (bskund2.M_COM_FUT = bskundnbyfcm2.M_REFERENCE and bskund2.M_COM_NBY_T = 0 and undnbyfcm2.M_LISTED in (1,2,16,32))
left join RT_LNGN_DBF  bskundnbyfccgnl2 on (bskundnbyfcm2.M_CM_INSTR = bskundnbyfccgnl2.M_GEN_NUM and bskundnbyfcm2.M_INS_MODE = 0)
left join RT_INDEX_DBF bskundnbyfccind2 on bskundnbyfccgnl2.M_INDEX0 = bskundnbyfccind2.M_INDEX
left join CM_INDEX_DBF bskundnbyfccicm2 on (bskundnbyfccind2.M_COM_IND = bskundnbyfccicm2.M_REFERENCE and bskundnbyfccind2.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfccqot2 on bskundnbyfccind2.M_COM_QUOT = bskundnbyfccqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskundnbyfccicmviw2 on bskundnbyfccicm2.M_REFERENCE = bskundnbyfccicmviw2.M_ICMUID
left join CMC_MGEN_DBF bskundnbyfcsgnm2 on (bskundnbyfcm2.M_CM_INSTR = bskundnbyfcsgnm2.M_REFERENCE and bskundnbyfcm2.M_INS_MODE = 1)
left join RT_INDEX_DBF bskundnbyfcsind2 on bskundnbyfcsgnm2.M_INDEX = bskundnbyfcsind2.M_INDEX
left join CM_INDEX_DBF bskundnbyfcsicm2 on (bskundnbyfcsind2.M_COM_IND = bskundnbyfcsicm2.M_REFERENCE and bskundnbyfcsind2.M_RESET = 0)
left join CMC_QUOT_DBF bskundnbyfcsqot2 on bskundnbyfcsind2.M_COM_QUOT = bskundnbyfcsqot2.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskundnbyfcsicmviw2 on bskundnbyfcsicm2.M_REFERENCE = bskundnbyfcsicmviw2.M_ICMUID
left join RT_INDBK_COMPONENT_DBF bskelt21 on (bskind2.M_REFERENCE = bskelt21.M_BASKET_REFERENCE and bskelt21.M_ORDER = 0)
left join RT_INDEX_DBF bskind21 on bskelt21.M_INDEX = bskind21.M_INDEX
left join CM_INDEX_DBF bskicm21 on bskind21.M_COM_IND  = bskicm21.M_REFERENCE
left join CMC_QUOT_DBF bskqot21 on bskind21.M_COM_QUOT = bskqot21.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) bskicmviw21 on bskicm21.M_REFERENCE = bskicmviw21.M_ICMUID
left join CM_FUT_DBF   nbyfcm21 on (bskind21.M_COM_FUT = nbyfcm21.M_REFERENCE and bskind21.M_COM_NBY_T = 0)
left join CMC_MGEN_DBF nbyfcsgnm21 on (nbyfcm21.M_CM_INSTR = nbyfcsgnm21.M_REFERENCE and nbyfcm21.M_INS_MODE = 1 and nbyfcm21.M_LISTED in (1,2,16))
left join RT_INDEX_DBF nbyfcsind21 on rtrim(nbyfcsgnm21.M_INDEX) = rtrim(nbyfcsind21.M_INDEX)
left join CM_INDEX_DBF nbyfcsicm21 on (nbyfcsind21.M_COM_IND = nbyfcsicm21.M_REFERENCE and nbyfcsind21.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsqot21 on nbyfcsind21.M_COM_QUOT = nbyfcsqot21.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsicmviw21 on nbyfcsicm21.M_REFERENCE = nbyfcsicmviw21.M_ICMUID
-- Forward 2
left join CM_FUT_DBF   fut2 on ind2.M_COM_FUT = fut2.M_REFERENCE and ind2.M_CATEGORY = 9 and fut2.M_LISTED in (1,2,16)
left join CMC_MGEN_DBF fcsgnm2 on (fut2.M_CM_INSTR = fcsgnm2.M_REFERENCE and fut2.M_INS_MODE = 1)
left join RT_INDEX_DBF fcsind2 on fcsgnm2.M_INDEX = fcsind2.M_INDEX
left join CM_INDEX_DBF fcsicm2 on (fcsind2.M_COM_IND = fcsicm2.M_REFERENCE and fcsind2.M_RESET = 0)
left join CMC_QUOT_DBF fcsqot2 on (fcsind2.M_COM_QUOT = fcsqot2.M_REFERENCE and fcsind2.M_RESET = 0)
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) fcsicmviw2 on fcsicm2.M_REFERENCE = fcsicmviw2.M_ICMUID
-- ELT3
left join RT_INDEX_DBF ind3 on bskelt03.M_INDEX = ind3.M_INDEX 
left join CM_INDEX_DBF icm3 on ind3.M_COM_IND = icm3.M_REFERENCE
left join CM_MKTSR_DBF hsr3 on trim(substr(bskelt03.M_FORMULA,2,10)) = to_char(hsr3.M_SERIE)
-- ELT4
left join RT_INDEX_DBF ind4 on bskelt04.M_INDEX = ind4.M_INDEX 
left join CM_INDEX_DBF icm4 on ind4.M_COM_IND = icm4.M_REFERENCE
left join CM_MKTSR_DBF hsr4 on trim(substr(bskelt04.M_FORMULA,2,10)) = to_char(hsr4.M_SERIE)
-- ELTOCC
left join (select M_BASKET_REFERENCE ,count(*) ELTOCC from RT_INDBK_COMPONENT_DBF group by M_BASKET_REFERENCE) bskgrp on ind.M_REFERENCE = bskgrp.M_BASKET_REFERENCE

where 1 = 1 
and ind.M_CREAT_MODE = 0
and ind.M_CATEGORY = 8 
and ind.M_RESET = 4 

order by INDLAB

