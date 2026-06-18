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
--rtrim(ind.M_IND_DESC) INDDES,
case ind.M_FUT_CAT
when 0 then 'FWD' 
when 1 then 'OPT' end UNDTYP,
rtrim(und.M_LABEL)    UNDLAB,
rtrim(und.M_DESC)     UNDDES,
rtrim(pub.M_LABEL)    UNDPUB,
rtrim(qot.M_TRAD_SMB) UNDSYM,
rtrim(hsr.M_HSR)      UNDHSR,
rtrim(pub.M_CALENDAR) UNDCAL,
case ind.M_FUT_CAT 
when 0 then rtrim(und.M_LABEL) 
when 1 then rtrim(fcm.M_LABEL) else null end FCMLAB,
case qot.M__TYPE_
when  1 then 'Index'
when  2 then 'Future'
when  4 then 'Dlv.flow'
when  8 then 'Spread'
when  5 then 'Index flow'
when  6 then 'Future flow'
when 14 then 'Spread fut.flow' 
when 16 then 'Opt.Listed' else null end QOTTYP,
rtrim(qot.M_LABEL)    QOTLAB,
-- ind.M_COM_CUR         INDCUR,
rtrim(qot.M_CURR)     CUR,
rtrim(qotuoq.M_LABEL) UOQ, 
rtrim(qotuod.M_LABEL) UOD,
und.M_QTY             LOTSIZ,
-- ROUNDING
'Quoted'      RNDRUL,
qot.M_PRC_DEC RNDDEC,
-- OBSERVATION
coalesce(rtrim(fcmmatset.M_LABEL), rtrim(ofcmatset.M_LABEL)) MATSET,
coalesce(rtrim(fcmmat.M_LABEL), rtrim(ofcmat.M_LABEL))       MATLAB,
coalesce(to_char(fcmmat.M_QT_END,'YYYY-MM-DD'), to_char(ofcmat.M_MATURITY,'YYYY-MM-DD'))   QOTLST,
coalesce(to_char(fcmmat.M_ST_START,'YYYY-MM-DD'), to_char(undmat.M_ST_START,'YYYY-MM-DD')) DLVFST,
coalesce(to_char(fcmmat.M_ST_END,'YYYY-MM-DD'), to_char(undmat.M_ST_END,'YYYY-MM-DD'))     DLVLST,
'H'||rtrim(ind.M_HISFILE)||'_H1S' HISHDR,
'B'||rtrim(ind.M_HISFILE)||'_HBS' HISBDY,
-- UID
ind.M_INDEX     INDNXX,
ind.M_REFERENCE INDUID,
ind.M_COM_FUT   UNDUID,
case ind.M_FUT_CAT 
when 0 then und.M_REFERENCE
when 1 then fcm.M_REFERENCE else null end FCMUID,
qot.M_REFERENCE QOTUID,
ind.M_COM_MAT   MATUID

from RT_INDEX_DBF ind
left join TRN_PC_DBF pc on 1 = 1
left join CM_FUT_DBF   und on ind.M_COM_FUT = und.M_REFERENCE
left join CM_ASSET_DBF ass on und.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_FUT_DBF   fcm on und.M_CM_INSTR = fcm.M_REFERENCE and ind.M_FUT_CAT = 1
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI= pub.M_REFERENCE
left join VIW_ICMPUB_DBF hsr  on pub.M_REFERENCE = hsr.M_PUBUID and hsr.M_HSRDFL = 1
left join CM_UNIT_DBF  qotuoq on qot.M_UNIT = qotuoq.M_REFERENCE
left join CM_UNIT_DBF  qotuod on qot.M_QTY_UNIT = qotuod.M_REFERENCE
left join CM_FMAT1_DBF fcmmat on ind.M_COM_MAT = fcmmat.M_REFERENCE and ind.M_FUT_CAT = 0
left join CM_FMAT_DBF  fcmmatset on fcmmat.M_FMAT_ID = fcmmatset.M_REFERENCE
left join CM_OMAT1_DBF ofcmat on ind.M_COM_MAT = ofcmat.M_REFERENCE and ind.M_FUT_CAT = 1
left join CM_OMAT_DBF  ofcmatset on ofcmat.M_OMAT_ID = ofcmatset.M_REFERENCE
left join CM_FMAT1_DBF undmat on ofcmat.M_UND_REF = undmat.M_REFERENCE

where 1 = 1
and ind.M_CATEGORY = 9
and M_LOG_DELETE_EFFECTIVE > pc.M_DATE

order by FCMLAB, UNDLAB, QOTLST
