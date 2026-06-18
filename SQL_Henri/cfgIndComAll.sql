select distinct
rtrim(ast.M_LABEL) ASSTYP,
rtrim(ass.M_LABEL) ASSLAB,
-- INDEX
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then 'SPT'
    when 3 then 'AVG' 
    when 4 then 'BSK'
    when 5 then 'Start-end'
    when 6 then 'NBY' end 
when 9 then 
    case ind.M_FUT_CAT 
    when 0 then 'FWD' 
    when 1 then 'OPT' end
end INDTYP,
bsk.M_ELTOCC BSKELT,
rtrim(ind.M_IND_LAB)  INDLAB,
rtrim(ind.M_IND_DESC) INDDES,
-- QUOTE
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then rtrim(pub.M_LABEL)
    when 3 then rtrim(grp.M_GRP_DESC) 
    when 4 then rtrim(grp.M_GRP_DESC)
    when 6 then rtrim(pub.M_LABEL) end
when 9 then rtrim(pub.M_LABEL) end INDPUB,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then rtrim(pub.M_CALENDAR)
    when 3 then rtrim(grp.M_CALENDAR) 
    when 4 then rtrim(grp.M_CALENDAR)
    when 6 then rtrim(pub.M_CALENDAR) end 
when 9 then rtrim(pub.M_CALENDAR) end INDCAL,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then rtrim(qot.M_TRAD_SMB)
    when 3 then rtrim(undqot.M_TRAD_SMB)
    when 4 then null
    when 6 then null end 
when 9 then rtrim(qot.M_TRAD_SMB) end INDSYM,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then qot.M_CURR
    when 3 then coalesce(rtrim(undqot.M_CURR), rtrim(und.M_CURRENCY))
    when 4 then rtrim(ind.M_CURRENCY)
    when 6 then rtrim(ind.M_COM_CUR) end 
when 9 then rtrim(ind.M_COM_CUR) end INDCUR,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then rtrim(qotuoq.M_LABEL)
    when 3 then coalesce(rtrim(undqotuoq.M_LABEL), rtrim(unduoq.M_LABEL))
    when 4 then rtrim(uoq.M_LABEL)
    when 6 then rtrim(qotuoq.M_LABEL) end 
when 9 then rtrim(qotuoq.M_LABEL) end INDUOQ,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then rtrim(qotuod.M_LABEL)
    when 3 then coalesce(rtrim(undqotuod.M_LABEL), rtrim(unduod.M_LABEL))
    when 4 then rtrim(uod.M_LABEL)
    when 6 then rtrim(qotuod.M_LABEL) end 
when 9 then rtrim(qotuod.M_LABEL) end INDUOD,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_LOTSIZ
    when 3 then null
    when 4 then null
    when 6 then nby.M_LOTSIZ else null end 
when 9 then fwd.M_LOTSIZ end LOTSIZ,
-- UNDERLYING
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_UNDTYP
    when 3 then avr.M_UNDTYP
    when 4 then rtrim(bsk.M_INDTYP1)   
    when 6 then nby.M_UNDTYP else null end 
when 9 then fwd.M_UNDTYP end UNDTYP,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_INDLAB
    when 3 then avr.M_UNDLAB
    when 4 then rtrim(bsk.M_INDLAB1)   
    when 6 then nby.M_UNDLAB else null end 
when 9 then fwd.M_UNDLAB end UNDLAB,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then rtrim(spt.M_INDDES)
    when 3 then rtrim(avr.M_UNDDES)
    when 4 then rtrim(bsk.M_INDDES1)   
    when 6 then nby.M_UNDDES else null end 
when 9 then fwd.M_UNDDES end UNDDES,
--UND.QUOTE
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_QOTLAB
    when 3 then coalesce(rtrim(avr.M_ICMQOT), rtrim(undbsk.M_CUR)||'/'||rtrim(undbsk.M_UOQ))
    when 4 then bsk.M_ICMQOT1
    when 6 then nby.M_QOTLAB else null end 
when 9 then fwd.M_QOTLAB end UNDQOT,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_PUB
    when 3 then avr.M_UNDPUB
    when 4 then bsk.M_INDPUB1
    when 6 then nby.M_PUB else null end 
when 9 then fwd.M_UNDPUB end UNDPUB,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then null
    when 3 then avr.M_UNDHSR
    when 4 then bsk.M_HSR1
    when 6 then null else null end 
when 9 then null end UNDHSR,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_CAL
    when 3 then avr.M_UNDCAL
    when 4 then bsk.M_INDCAL1
    when 6 then nby.M_CAL else null end 
when 9 then fwd.M_UNDCAL end UNDCAL,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_CUR
    when 3 then avr.M_CUR
    when 4 then bsk.M_CUR1
    when 6 then nby.M_CUR else null end 
when 9 then fwd.M_CUR end UNDCUR,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_UOQ
    when 3 then avr.M_UOQ
    when 4 then bsk.M_UOQ1
    when 6 then nby.M_UOQ else null end 
when 9 then fwd.M_CUR end UNDUOQ,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
    when 0 then spt.M_UOD
    when 3 then avr.M_UOD
    when 4 then bsk.M_UOD1
    when 6 then nby.M_UOD else null end 
when 9 then fwd.M_CUR end UNDUOD,
-- OBSERVATION
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_QOTTYP
    when 3 then avr.M_OBSFRM
    when 4 then bsk.M_BSKFRM
    when 6 then nby.M_OBSFRM else null end
when 9 then fwd.M_INDTYP end OBSFRM,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then null
    when 3 then avr.M_OBSFRQ
    when 4 then bsk.M_OBSFRQ
    when 6 then nby.M_OBSFRQ else null end
when 9 then null end OBSFRQ,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_CAL
    when 3 then avr.M_OBSCAL
    when 4 then bsk.M_OBSCAL
    when 6 then nby.M_CAL else null end
when 9 then fwd.M_UNDCAL end OBSCAL,
-- ROUNDING
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_RNDRUL
    when 3 then avr.M_RNDRUL
    when 4 then bsk.M_RNDRUL
    when 6 then nby.M_RNDRUL else null end
when 9 then fwd.M_RNDRUL end RNDRUL,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_RNDDEC
    when 3 then avr.M_RNDDEC
    when 4 then bsk.M_RNDDEC
    when 6 then nby.M_RNDDEC else null end
when 9 then fwd.M_RNDDEC end RNDDEC,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_INDTYP1 else null end BSKINDTYP1,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_INDLAB1 else null end BSKINDLAB1,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_HSR1    else null end BSKINDHSR1,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_RNDRUL1 else null end BSKRNDRUL1,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_RNDDEC1 else null end BSKRNDDEC1,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_INDTYP2 else null end BSKINDTYP2,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_INDLAB2 else null end BSKINDLAB2,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_HSR2    else null end BSKINDHSR2,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_RNDRUL2 else null end BSKRNDRUL2,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then bsk.M_RNDDEC2 else null end BSKRNDDEC2,
-- CURVE
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_UNDLAB
    when 3 then 
        case und.M_RESET
        when 0 then avr.M_ICMLAB
        when 4 then undbsk.M_ICMLAB1
        when 6 then undnby.M_ICMLAB else null end
    when 4 then bsk.M_ICMLAB1
    when 6 then nby.M_ICMLAB else null end 
when 9 then fwd.M_FCMLAB end CRVICM0,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_QOTLAB
    when 3 then 
        case und.M_RESET
        when 0 then avr.M_UNDQOT
        when 4 then undbsk.M_ICMQOT1
        when 6 then undnby.M_ICMQOT else null end
    when 4 then bsk.M_ICMQOT1
    when 6 then nby.M_ICMQOT else null end 
when 9 then fwd.M_QOTLAB end CRVQOT0,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_PUB
    when 3 then coalesce(rtrim(undbsk.M_ICMPUB1), rtrim(avr.M_UNDPUB))
    when 4 then bsk.M_ICMPUB1
    when 6 then nby.M_PUB else null end 
when 9 then fwd.M_UNDPUB end CRVPUB0,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_SYM
    when 3 then 
        case und.M_RESET
        when 0 then avr.M_UNDSYM
        when 4 then undbsk.M_ICMSYM1
        when 6 then undnby.M_ICMSYM else null end
    when 4 then bsk.M_ICMSYM1
    when 6 then nby.M_ICMSYM else null end 
when 9 then fwd.M_UNDSYM end CRVSYM0,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_HSR
    when 3 then 
        case und.M_RESET
        when 0 then coalesce(avr.M_UNDHSR, avr.M_ICMHSR)
        when 4 then coalesce(undbsk.M_HSR1, undbsk.M_ICMHSR1)
        when 6 then undnby.M_HSR else null end
    when 4 then coalesce(bsk.M_HSR1, bsk.M_ICMHSR1)
    when 6 then nby.M_HSR else null end 
when 9 then fwd.M_UNDHSR end CRVHSR0,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_CAL
    when 3 then coalesce(rtrim(undbsk.M_ICMCAL1), rtrim(avr.M_UNDCAL))
    when 4 then bsk.M_ICMCAL1
    when 6 then nby.M_CAL else null end 
when 9 then fwd.M_UNDCAL end CRVCAL0,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 3 then 
        case und.M_RESET
        when 0 then null
        when 4 then undbsk.M_ICMLAB2 
        when 6 then null else null end
    when 4 then bsk.M_ICMLAB2 else null end
when 9 then null end CRVICM1,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 3 then 
        case und.M_RESET
        when 4 then undbsk.M_ICMQOT2 else null end
    when 4 then bsk.M_ICMQOT2 else null end
when 9 then null end CRVQOT1,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then null
    when 3 then 
       case und.M_RESET
       when 4 then undbsk.M_ICMPUB2 else null end
    when 4 then bsk.M_ICMPUB2
    when 6 then null else null end 
when 9 then null end CRVPUB1,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 3 then 
        case und.M_RESET
        when 4 then undbsk.M_ICMSYM2 else null end
    when 4 then bsk.M_ICMSYM2 else null end
when 9 then null end CRVSYM1,

case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 3 then 
       case und.M_RESET
       when 4 then coalesce(undbsk.M_HSR2, undbsk.M_ICMHSR2) else null end
    when 4 then coalesce(bsk.M_HSR2, bsk.M_ICMHSR2) else null end 
when 9 then null end CRVHSR1,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then null
    when 3 then 
       case und.M_RESET
       when 4 then undbsk.M_ICMCAL2 else null end    
    when 4 then bsk.M_ICMCAL2
    when 6 then null else null end 
when 9 then null end CRVCAL1,
-- DELIVERY
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_PHYLAB
    when 3 then 
        case und.M_RESET
        when 0 then undspt.M_PHYLAB
        when 3 then null 
        when 4 then undbsk.M_PHYLAB1
        when 6 then undnby.M_PHYLAB else null end
    when 4 then bsk.M_PHYLAB1
    when 6 then nby.M_PHYLAB else null end
when 9 then null end PHYLAB,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_LOCLAB
    when 3 then 
        case und.M_RESET
        when 0 then undspt.M_LOCLAB
        when 3 then null 
        when 4 then undbsk.M_LOCLAB1
        when 6 then undnby.M_LOCLAB else null end
    when 4 then bsk.M_LOCLAB1
    when 6 then nby.M_LOCLAB else null end
when 9 then null end LOCLAB,
-- HIS
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_HIS
    when 3 then avr.M_HIS
    when 4 then bsk.M_HIS
    when 6 then nby.M_HIS else null end
when 9 then fwd.M_HISBDY end HIS,
-- UID
rtrim(ind.M_INDEX) INDNDX,
ind.M_REFERENCE INDUID,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_QOTUID
    when 3 then avr.M_UNDQOTUID
    when 4 then bsk.M_QOTUID1
    when 6 then nby.M_QOTUID else null end
when 9 then fwd.M_QOTUID end QOTUID,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then rtrim(ind.M_INDEX)
    when 3 then 
        case und.M_RESET
        when 0 then rtrim(undspt.M_INDNDX)
        when 3 then null 
        when 4 then undbsk.M_ICMNDX1
        when 6 then undnby.M_ICMNDX else null end
    when 4 then bsk.M_ICMNDX1
    when 6 then nby.M_ICMNDX else null end
when 9 then null end UNDNDX,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then ind.M_REFERENCE
    when 3 then avr.M_UNDUID
    when 4 then bsk.M_UNDUID1
    when 6 then coalesce(nby.M_FCMUID, nby.M_ICMUID) else null end
when 9 then fwd.M_QOTUID end UNDUID,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_ICMUID
    when 3 then 
        case und.M_RESET
        when 0 then undspt.M_ICMUID
        when 3 then 0 
        when 4 then undbsk.M_ICMUID1
        when 6 then undnby.M_ICMUID else null end    
    when 4 then bsk.M_ICMUID1
    when 6 then nby.M_ICMUID else null end
when 9 then null end ICMUID,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_PHYUID
    when 3 then 
        case und.M_RESET
        when 0 then undspt.M_PHYUID
        when 3 then null 
        when 4 then undbsk.M_PHYUID1
        when 6 then undnby.M_PHYUID else null end
    when 4 then bsk.M_PHYUID1
    when 6 then nby.M_PHYUID else null end
when 9 then null end PHYUID,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then spt.M_LOCUID
    when 3 then 
        case und.M_RESET
        when 0 then undspt.M_LOCUID
        when 3 then null 
        when 4 then undbsk.M_LOCUID1
        when 6 then undnby.M_LOCUID else null end
    when 4 then bsk.M_LOCUID1
    when 6 then nby.M_LOCUID else null end
when 9 then null end LOCUID

from RT_INDEX_DBF ind
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_UNIT_DBF  uod on ind.M_UNIT_REF0 = uod.M_REFERENCE
left join CM_UNIT_DBF  uoq on ind.M_UNIT_REF1 = uoq.M_REFERENCE
left join CM_INDEX_DBF icm on ind.M_COM_IND = icm.M_REFERENCE
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_UNIT_DBF  qotuoq on qot.M_UNIT = qotuoq.M_REFERENCE
left join CM_UNIT_DBF  qotuod on qot.M_QTY_UNIT = qotuod.M_REFERENCE
left join RT_INDEX_DBF und on ind.M_UNDRL = und.M_INDEX
left join RT_GROUP_DBF undgrp on und.M_HISFILE = undgrp.M_HISFILE
left join CM_UNIT_DBF  unduod on und.M_UNIT_REF0 = unduod.M_REFERENCE
left join CM_UNIT_DBF  unduoq on und.M_UNIT_REF1 = unduoq.M_REFERENCE
left join CMC_QUOT_DBF undqot on und.M_COM_QUOT = undqot.M_REFERENCE
left join CM_MKT_DBF   undpub on undqot.M_PUBLI = undpub.M_REFERENCE
left join CM_UNIT_DBF  undqotuoq on undqot.M_UNIT = undqotuoq.M_REFERENCE
left join CM_UNIT_DBF  undqotuod on undqot.M_QTY_UNIT = undqotuod.M_REFERENCE
left join VIW_ICMSPT_DBF spt on ind.M_REFERENCE = spt.M_INDUID and ind.M_CATEGORY = 8 and ind.M_RESET = 0
left join VIW_ICMNBY_DBF nby on ind.M_REFERENCE = nby.M_INDUID and ind.M_CATEGORY = 8 and ind.M_RESET = 6
left join VIW_ICMBSK_DBF bsk on ind.M_REFERENCE = bsk.M_INDUID and ind.M_CATEGORY = 8 and ind.M_RESET = 4
left join VIW_ICMAVG_DBF avr on ind.M_REFERENCE = avr.M_INDUID and ind.M_CATEGORY = 8 and ind.M_RESET = 3
left join VIW_ICMFWD_DBF fwd on ind.M_REFERENCE = fwd.M_INDUID and ind.M_CATEGORY = 9
left join VIW_ICMSPT_DBF undspt on und.M_REFERENCE = undspt.M_INDUID and und.M_CATEGORY = 8 and und.M_RESET = 0
left join VIW_ICMNBY_DBF undnby on und.M_REFERENCE = undnby.M_INDUID and und.M_CATEGORY = 8 and und.M_RESET = 6 
left join VIW_ICMBSK_DBF undbsk on und.M_REFERENCE = undbsk.M_INDUID and und.M_CATEGORY = 8 and und.M_RESET = 4
--left join LST_PREFV_DBF prficm on rtrim(ind.M_IND_LAB) = rtrim(prficm.M_VALUE) and prficm.M_INDEX2 = 204 

where 1 = 1
and ind.M_CREAT_MODE = 0
and ind.M_CATEGORY in (8,9)
and ass.M_LABEL not in ('_ASSET')
and rtrim(ind.M_IND_LAB) not in (select rtrim(M_VALUE) from LST_PREFV_DBF where M_INDEX2 = 204)

order by INDLAB
