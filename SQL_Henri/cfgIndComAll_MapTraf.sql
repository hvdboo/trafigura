select distinct
case ind.M_CATEGORY
when 0 then 'Rate'
when 1 then 'Equity'
when 2 then 'Bond'
when 3 then 'Inflation'
when 4 then 'Forex'
when 8 then 'Commodity'
when 9 then 'Com FWD' else null end INDCAT,
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
/*
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
*/
rtrim(altindeai.M_OBJ_ALBL)  EAICOD,
rtrim(altindeai.M_OBJ_ALT)   EAILAB,
rtrim(altindrfp.M_OBJ_ALT)   REFPRC,
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
when 9 then fwd.M_QOTUID end QOTUID

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
left join KEYMAP_STC_DBF altindeai on rtrim(ind.M_INDEX) = rtrim(altindeai.M_OBJ_DESC) and rtrim(altindeai.M_OBJ_CLASS) in ('MnXbT37735', 'MwOJI56899') and rtrim(substr(altindeai.M_OBJ_ASYS,1,3)) = 'EAI'
left join KEYMAP_STC_DBF altindrfp on rtrim(ind.M_INDEX) = rtrim(altindrfp.M_OBJ_DESC) and rtrim(altindrfp.M_OBJ_CLASS) in ('MnXbT37735', 'MwOJI56899') and rtrim(substr(altindrfp.M_OBJ_ASYS,1,3)) = 'CRP'

where 1 = 1
and ind.M_CREAT_MODE = 0
and ind.M_CATEGORY in (8)
and ass.M_LABEL not in ('_ASSET')
and rtrim(ind.M_IND_LAB) not in (select rtrim(M_VALUE) from LST_PREFV_DBF where M_INDEX2 = 204)

order by INDLAB
